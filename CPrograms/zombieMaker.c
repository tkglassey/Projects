#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
int main(){
	pid_t pid = fork();
	if(pid == 0){
		sleep(10);
		printf("terminating child\n");
		exit(0);
	}
	printf("child id %d\n", pid);
	sleep(20);
	wait(NULL);
	sleep(20);
}
