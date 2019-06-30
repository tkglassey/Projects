#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int arc, char **argv)
{
	printf("hi\n");
	pid_t pid = fork();
	if(pid>0){
		printf("I'm the parent of %d\n", pid);
		pid_t finished_child = wait(NULL);
		printf("child = %d\n", finished_child);
	}else if (pid==0){
		for (int i = 0; i<5;i++){
			printf("I'm the child\n");
			sleep(1);
		}
		printf("bye\n");
	}
}
