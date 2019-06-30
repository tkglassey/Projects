#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <string.h>


#include "memdb.h"
// NOTES
// 14 + str length is the entry size
// ENTRY REPLACEMENT: Entries are not split up once established. IE if an entry is deleted,
// then replaced by a smaller entry, it maintains it's size
// STRATEGY: First fit

int main(int argc, char **argv) {
  if (argc != 2 && argc != 3) {
    printf("USAGE: %s dbfile\n", argv[0]);
    return 1;
  }
  const char *dbfile = argv[1];

  int fd = open(argv[1], O_CREAT |  O_RDWR, S_IWUSR | S_IRUSR);
  if(fd == -1)
  {
    perror(dbfile);
    return 2;
  }

  struct stat s;
  if (fstat(fd, &s) == -1)
  {
    perror(dbfile);
    return 3;
  }

  size_t size = INIT_SIZE;
  int setUp = 0;
  if(s.st_size == 0) {
    size = INIT_SIZE;
    setUp = 1;
    ftruncate(fd, INIT_SIZE);
  }
  else {size = s.st_size;}
  int flag = MAP_SHARED;
  if(argc == 3 && strcmp(argv[2], "-t") == 0)
  {
    flag = MAP_PRIVATE;
  }
  struct fhdr_s *fhdr = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
  if (fhdr == (void *) -1)
  {
    perror(dbfile);
    return 4;
  }

  if(setUp == 1)
  {
    fhdr -> magic = FILE_MAGIC;
    fhdr -> free_start = 20;
    fhdr -> data_start = 0;
    struct entry_s *initEntry = (struct entry_s *) ((char *) fhdr + sizeof(*fhdr));
    initEntry -> magic = ENTRY_MAGIC_FREE;
    initEntry -> next = 0;
    initEntry -> len = size - (sizeof(*fhdr) + sizeof(*initEntry));
    msync(fhdr, size, MS_SYNC);
  }

  char *input = NULL;
  char *cmd;
  size_t len = 0;
  ssize_t read;
  int compRet;

  while(read = getline(&input, &len, stdin) != -1)
  {
    struct entry_s *entry;
    if(input[0] == 'a' && input[1] == ' ')
    {
      struct entry_s *prevFree;
      entry = (struct entry_s *) ((char *) fhdr + fhdr -> free_start);
      int adjustFree = 1;
      while(entry -> next != 0 && entry -> len < strlen(input + 2))
      {
        adjustFree = 0;
        prevFree = entry;
        entry = (struct entry_s *) ((char *) fhdr + entry -> next);
      }

      // Finally established where entry will be placed. Now to deal with variables.
      // Can't do len and next until later
      int entryLen = strlen(input + 2);
      entry -> magic = ENTRY_MAGIC_DATA;
      strncpy(entry -> str, input+2, entryLen);
      entry -> str[entryLen-1] = '\0';
      struct entry_s *otherEntry;
      // Deal with free section length assuming it took from main.
      if(entry -> next == 0)
      {
        otherEntry = (struct entry_s *) (entry -> str + entryLen);
        otherEntry -> magic = ENTRY_MAGIC_FREE;
        otherEntry -> next = 0;
        otherEntry -> len = (entry -> len - (14 + entryLen));
        // Now replace the len. We do it here so we don't replace the length of a space in the middle
        entry -> len = entryLen;
      }
      // Adjust start location of free space
      if(adjustFree == 1)
      {
        if(entry -> next == 0)
        {
          fhdr -> free_start = (moffset_t) otherEntry - (moffset_t) fhdr;
        }
        else
        {
          fhdr -> free_start = entry -> next;
        }
        adjustFree = 0;
      }
      else
      {
        prevFree -> next = entry -> next;
      }

      // Dealing with next
      if(fhdr -> data_start == 0)
      {
        fhdr -> data_start = (moffset_t) entry - (moffset_t) fhdr;
        entry -> next = 0;
      }
      else
      {
        int cmpRes;
        struct entry_s *prevEntry;
        otherEntry = (struct entry_s *) ((char*) fhdr + fhdr -> data_start);
        // Special condition for entry being new head
        cmpRes = strcmp(entry -> str, otherEntry -> str);
        if(cmpRes < 0)
        {
          entry -> next = fhdr -> data_start;
          fhdr -> data_start = (moffset_t) entry - (moffset_t) fhdr;
        }
        else
        {
          while(otherEntry -> next !=0 && (cmpRes > 0))
          {
            prevEntry = otherEntry;
            otherEntry = (struct entry_s *) ((char *) fhdr + otherEntry -> next);
            cmpRes = strcmp(entry -> str, otherEntry -> str);
          }
          // Special condition for entry being new tail
          if(cmpRes > 0)
          {
            otherEntry -> next = (moffset_t) entry - (moffset_t) fhdr;
            entry -> next = 0;
          }
          else // Insert into middle
          {
            entry -> next = (moffset_t) otherEntry - (moffset_t) fhdr;
            prevEntry -> next = (moffset_t) entry - (moffset_t) fhdr;
          }
        }
      }
      if(entry -> next == ((moffset_t) entry - (moffset_t) fhdr))
      {printf("ERROR: entry %s points to itself, %lld", entry -> str, entry -> next);}
    }
    else if(input[0] == 'd' && input[1] == ' ')
    {
      struct entry_s *prevEntry;
      char *tbDel;
      tbDel = input+2;
      tbDel[strlen(tbDel) - 1] = '\0';
      entry = (struct entry_s *) ((char*) fhdr + fhdr -> data_start);
      int cmpRes = strcmp(entry -> str, tbDel);

      // Special Case: Deleting head
      if(cmpRes == 0)
      {
        fhdr -> data_start = entry -> next;
      }
      while(entry -> next !=0 && (cmpRes != 0))
      {
        prevEntry = entry;
        entry = (struct entry_s *) ((char *) fhdr + entry -> next);
        cmpRes = strcmp(entry -> str, tbDel);
      }
      if(cmpRes != 0)
      {
        printf("%s not found\n", tbDel);
      }
      else
      {
	if(fhdr -> data_start != entry -> next)
	{
          prevEntry -> next = entry -> next;
        }
	entry -> magic = ENTRY_MAGIC_FREE;
        entry -> next = 0;
        prevEntry = NULL;

        // Determining next, and adding to the free list.
        moffset_t entryOffset = (moffset_t) entry - (moffset_t) fhdr;
        struct entry_s *emptyEntry = (struct entry_s *) ((char *) fhdr + fhdr -> free_start);
        moffset_t freeOffset = (moffset_t) emptyEntry - (moffset_t) fhdr;
        moffset_t prevOffset = 0;
        while(freeOffset < entryOffset)
        {
          prevEntry = emptyEntry;
          emptyEntry = (struct entry_s *) ((char *) fhdr + emptyEntry -> next);
          prevOffset = freeOffset;
          freeOffset = (moffset_t) emptyEntry - (moffset_t) fhdr;
        }
        if(prevOffset != 0 && ((prevOffset + prevEntry -> len + 14) == entryOffset))
        {
          prevEntry -> len = prevEntry -> len + entry -> len + 14;
          entry = prevEntry;
          entryOffset = prevOffset;
          prevOffset = 0;
        }
        if((entryOffset + 14 + entry -> len) == freeOffset)
        {
          entry -> next = emptyEntry -> next;
          entry -> len = entry -> len + emptyEntry -> len + 14;
        }
        else
        {
          entry -> next = freeOffset;
        }
        if(prevOffset != 0)
        {
          prevEntry -> next = entryOffset;
        }
        else if (fhdr -> free_start == freeOffset)
        {
          fhdr -> free_start = entryOffset;
        }
      }
      if(entry -> next == ((moffset_t) entry - (moffset_t) fhdr))
      {
        printf("ERROR: Entry: %lld, leads to itself", entry -> next);
      }
    }
    else if(compRet = strcmp(input,"l\n") == 0)
    {
      if(fhdr -> data_start != 0)
      {
        entry = (struct entry_s *) ((char *) fhdr + fhdr -> data_start);
        printf("%s\n", entry -> str);
        while(entry -> next != 0)
        {
          entry = (struct entry_s *) ((char *) fhdr + entry -> next);
          printf("%s\n", entry -> str);
        }
      }
    }
    else
    {
      printf("command must be one of:\n a string_to_add\n d string_to_del\n l\n");
    }
  }
}
