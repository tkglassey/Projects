#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <memory.h>
#include "prodcon.h"
#include <pthread.h>
#include <string.h>

/**
 * Based on prodcon.c provided by Professor Ben Reed.
 * Original code was single threaded, changed to be multithreaded.
 * Must be compiled using -ldl -lpthread
 */

struct llist_node {
    struct llist_node *next;
    char *str;
};

/*
struct prod_info {
    int id;
    int count;
    produce_f produce;
    int argc;
    char **argv;
};

struct cons_info {
    int id;
    consume_f consume;
    int argc;
    char **argv;
};*/

struct info {
    int id;
    int argc;
    char **argv;
};

/**
 * pop a node off the start of the list.
 *
 * @param phead the head of the list. this will be modified by the call unless the list is empty
 * (*phead == NULL).
 * @return NULL if list is empty or a pointer to the string at the top of the list. the caller is
 * incharge of calling free() on the pointer when finished with the string.
 */
char *pop(struct llist_node **phead)
{
    if (*phead == NULL) {
        return NULL;
    }
    char *s = (*phead)->str;
    struct llist_node *next = (*phead)->next;
    free(*phead);
    *phead = next;
    return s;
}

/**
 * push a node onto the start of the list. a copy of the string will be made.
 * @param phead the head of the list. this will be modified by this call to point to the new node
 * being added for the string.
 * @param s the string to add. a copy of the string will be made and placed at the beginning of
 * the list.
 */
void push(struct llist_node **phead, const char *s)
{
    struct llist_node *new_node = malloc(sizeof(*new_node));
    new_node->next = *phead;
    new_node->str = strdup(s);
    *phead = new_node;
}

// the array of list heads. the size should be equal to the number of consumers
static struct llist_node **heads;

static assign_consumer_f assign_consumer;
static run_producer_f run_producer;
static run_consumer_f run_consumer;
static int producer_count;
static int consumer_count;
int sentinelCount = 0;
int placedSentinel = 0;
char * sentinel = "COMPLETE";

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

_Thread_local int my_consumer_number = -1;

void queue(int consumer, const char *str)
{
    push(&heads[consumer], str);
}

void produce(const char *buffer)
{
    pthread_mutex_lock(&lock);
    int hash = assign_consumer(consumer_count, buffer);
    queue(hash, buffer);
    /*if(strcmp(buffer, sentinel) == 0)
    {
        printf("Placed Sentinels: %d, Placed in %d\n", placedSentinel, hash);
    }*/
    pthread_cond_broadcast(&cond);
    pthread_mutex_unlock(&lock);
}

char *consume() {
    pthread_mutex_lock(&lock);
    char *str = pop(&heads[my_consumer_number]);
    /*if(str != NULL && strcmp(str, sentinel) == 0)
        {
            sentinelCount++;
            printf("Sentinel Count : %d\n", sentinelCount);
            _Bool x = sentinelCount < producer_count;
            printf("%s", x ? "true" : "false\n");
        }*/
    while(str == NULL || strcmp(str, sentinel) == 0)
    {
        if(str == NULL && sentinelCount >= producer_count)
        {
            pthread_cond_broadcast(&cond);
            pthread_mutex_unlock(&lock);
            return NULL;
        }
        if(str != NULL && strcmp(str, sentinel) == 0)
        {
            sentinelCount++;
            //printf("Sentinel Count : %d, found within %d\n", sentinelCount, my_consumer_number);
            pthread_cond_signal(&cond);
        } else if (str == NULL)
        {
            //printf("spinning wheels\n");
            //printf("producer_count = %d, sentinel count = %d, consumer %d stopped\n", producer_count, sentinelCount, my_consumer_number);
            pthread_cond_wait(&cond, &lock);
            //printf("consumer %d started again", my_consumer_number);
        }
        str = pop(&heads[my_consumer_number]);
    }
    pthread_mutex_unlock(&lock);
    return str;
}

void do_usage(char *prog)
{
    printf("USAGE: %s shared_lib consumer_count producer_count ....\n", prog);
    exit(1);
}

void *start_prod(void *v)
{
    struct 
    info *x = v;
    //printf("Started prod thread, id:%d, count:%d, argc:%d\n", x->id, x->count, x->argc);
    run_producer(x->id, producer_count, produce, x->argc, x->argv);
    produce(sentinel);
    placedSentinel++;
    
}

void *start_cons(void *v)
{
    struct info *x = v;
    //printf("Started cons thread, id:%d, argc:%d\n", x->id,  x->argc);
    my_consumer_number = x->id;
    run_consumer(x->id, consume, x->argc, x->argv);
}

/*void *threadTest(void *v)
{
    
    printf("Working\n");
}*/

int main(int argc, char **argv)
{
    if (argc < 4) {
        do_usage(argv[0]);
    }

    char *shared_lib = argv[1];
    producer_count = strtol(argv[2], NULL, 10);
    consumer_count = strtol(argv[3], NULL, 10);

    char **new_argv = &argv[4];
    int new_argc = argc - 4;
    setlinebuf(stdout);

    if (consumer_count <= 0 || producer_count <= 0) {
        do_usage(argv[0]);
    }

    void *dh = dlopen(shared_lib, RTLD_LAZY);

    // load the producer, consumer, and assignment functions from the library
    run_producer = dlsym(dh, "run_producer");
    run_consumer = dlsym(dh, "run_consumer");
    assign_consumer = dlsym(dh, "assign_consumer");
    if (run_producer == NULL || run_consumer == NULL || assign_consumer == NULL) {
        printf("Error loading functions: prod %p cons %p assign %p\n", run_producer,
                run_consumer, assign_consumer);
        exit(2);
    }

    heads = calloc(consumer_count, sizeof(*heads));

    struct info pInfo[producer_count];
    pthread_t prod_threads[producer_count];
//    printf("Theoretically started\n");
    for (int i = 0; i < producer_count; i++) {
        //run_producer(i, producer_count, produce, new_argc, new_argv);
        /*void * blank;
        if(pthread_create(&prod_threads[i], NULL, threadTest, blank))
        {
            fprintf(stderr, "Error creating thread\n");
        }*/
        
        pInfo[i].id = i;
        //pInfo[i].count = producer_count;
        //pInfo[i].produce = produce;
        pInfo[i].argc = new_argc;
        pInfo[i].argv = new_argv;
        pthread_create(&prod_threads[i], NULL, start_prod, (void*) &pInfo[i]);
        /*if(pthread_join(prod_threads[i], NULL)) {
            fprintf(stderr, "Error joining thread\n");
            return 2;
        }*/
    }

    struct info cInfo[consumer_count];
    pthread_t cons_threads[consumer_count];
    for (int i = 0; i < consumer_count; i++) {
        //my_consumer_number = i;
        //run_consumer(i, consume, new_argc, new_argv);
        cInfo[i].id = i;
        //cInfo[i].consume = consume;
        cInfo[i].argc = new_argc;
        cInfo[i].argv = new_argv;
        pthread_create(&cons_threads[i], NULL, start_cons, (void*) &cInfo[i]);
        
    }
    for (int i = 0; i < consumer_count; i++) {
        if(pthread_join(cons_threads[i], NULL)) {
            fprintf(stderr, "Error joining thread\n");
            return 2;
        }
    }

    return 0;
}
