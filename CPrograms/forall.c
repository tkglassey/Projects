#include <sys/types.h>
#include <signal.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

pid_t pid = 1;

void ctrlCHandler (int signum){
	if(pid == 0)
	{
//		printf("Child was slain\n");
		exit(2);
	}
	else
	{
//		printf("ctrl+c cannot kill the parent!\n");
		kill(pid, SIGINT);
		printf("^CSignaling %d\n", pid);
	}
}

void quitHandler(int signum){
	if(pid == 0)
	{
//		printf("A child was slain!\n");
		exit(2);
	}
	else
	{
		kill(pid, SIGINT);
		printf("^\Signaling %d\n", pid);
		printf("Exiting due to quit signal\n");
		exit(2);
	}
}

int main(int argc, char **argv)
{
	signal(SIGINT, ctrlCHandler);
	signal(SIGQUIT, quitHandler);
	int i = 2;
	int fd = 0;
	int fd2 = 0;
	char filename[64];
	while(i < argc && pid > 0)
	{
		sprintf(filename, "%d.out", i-1);
		fd = open(filename, O_CREAT | O_TRUNC |  O_RDWR, S_IWUSR | S_IRUSR);
		pid = fork();
		if(pid > 0)
		{
			int cstatus;
			pid_t wpid;
			dprintf(fd, "Executing %s %s\n", argv[1], argv[i]);
			do {
				wpid = wait(&cstatus);
			} while (wpid == -1);
//			printf("child %d exited with %d sig %d\n", wpid, WEXITSTATUS(cstatus), WTERMSIG(cstatus));
			if(WTERMSIG(cstatus) == 0)
			{
				dprintf(fd, "Finished executing %s %s exit code = %d\n", argv[1], argv[i], WEXITSTATUS(cstatus));
			}else
			{
				dprintf(fd, "Stopped executing %s %s signal = %d\n", argv[1], argv[i], WTERMSIG(cstatus));
			}
			i = i + 1;
		}
		//else{printf("I was successfully created \n");}
	}
	if(pid == 0)
	{
//		printf("Child %d activated\n", i-1);
		fd2 = dup(fd);
		dup2(fd2, 1);
		dup2(fd2, 2);
		close(fd2);
		execlp(argv[1], argv[1], argv[i], NULL);
//		printf("Child %d executing %s with %s as the parameter\n", i-1, argv[1], argv[i]);
	}
	else
	{
		printf("I am parent and I am finished running\n");
	}
	exit(0);
}
