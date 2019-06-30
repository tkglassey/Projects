#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
int main(){
//	pid_t pid = fork();
//	if(pid==0){
//		for(int i = 0;i<20;i++){
//			printf("I am the child\n");
//			for(int i = 0;i<300000000;i++){}
//		}
//	exit(0);
//	}
//	wait(NULL);
//	return 0;
	int fd = open("dat", O_CREAT | O_TRUNC | O_RDWR, S_IWUSR | S_IRUSR);
	dup2(fd, 1);
	dup2(fd, 2);
	close(fd);
	execlp("wc", "wc","/etc/passwd", NULL);
}

