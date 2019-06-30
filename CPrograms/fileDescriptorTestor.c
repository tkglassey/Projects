#include <fcntl.h>

main()
{
	int fd = open("dat", O_CREAT | O_TRUNC | O_RDWR | S_IWUSR | S_IRUSR);
	int fd2 = dup(fd);
	printf("%d %d\n", fd, fd2);
}
