#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

double square_root(double);
long long int strtoll();
long long int main(int argc, char **argv) // argument accepts
{
	char *endptr, *lineptr;
	size_t n = 0;
	size_t s = 0;
	long long int num;
	long long int factors[100];
	int ifactor = 0;
	pid_t pid = 0;
	if(argc == 1)
	{
		while(s = getline(&lineptr, &n, stdin) > 0 && pid == 0)
		{
			pid = fork();
		}
		if(s = 0){exit(0);}
	}
//	printf("%d \n", argc);
//	int ifactor = 0;
	int fds[2];
	pipe(fds);
	int argInd = argc;
//	printf("starting \n");
//	printf("this worked \n");
	while(pid==0 && argInd>=1)
	{
		argInd = argInd - 1;
		lineptr = argv[argInd];
		pid = fork();
//		if(pid>0){}
	}
	if(argInd > 0)
	{
		wait(NULL);
//		printf("%d \n", argInd);
		num  = strtoll(lineptr, &endptr, 10);
		double tempSqrt = square_root((double)num);
		long long int i = 1;
		long long int sqrt = (long long int)tempSqrt;
//		printf("%lld ", sqrt);
		printf("%lld: ", num);
		while(i<=sqrt)
		{
			if(num % i == 0)
			{
				printf("%lld ", i);
				factors[ifactor] = num/i;
				ifactor = ifactor + 1;
			}
			i = i + 1;
		}
		while(ifactor>0)
		{
			printf("%lld ", factors[ifactor-1]);
			ifactor = ifactor - 1;
		}
		printf("\n");
	}
	else{exit(0);}






	// Failed pipeline code. would not read properly.
/*	if(pid == 0) //child
	{
		long long int  num =  strtoll(argv[1], &endptr, 10);
		long long int i = 1;
		//long long int test = 234121324120;
		//write(fds[1], &i, 64);
		//printf("%lld: ", num);
		while(i<=num)
		{
			if(num % i == 0)
			{
				//write(fds[1], &i, 64);
				//printf("%lld ", i);
//				printf("science \n");
				factors[ifactor] = i;
				ifactor = ifactor + 1;
			}
			i = i + 1;
		}
		int j;
		for(j = 0; j < ifactor; ++j)
		{
//			printf("science2 \n");
			write(fds[1], &factors[j], 64);
		}
	}
	else
	{
		long long factor = 0;
		long long firstNum;
//		printf("science3\n");
		firstNum = strtoll(argv[1], &endptr, 10);
		printf("%lld: ", firstNum);
		while(factor != firstNum)
		{
//			printf("science4\n");
			read(fds[0], &factor, 64);
			printf("%lld ", factor);
		}
		printf("\n");
	}
*/
}

// Babylonian Method
// Taken from geeksforgeeks.org
// Subject: square root of a perfect square
// Used because I wasn't sure if we were allowed to load in math.h
double square_root(double n)
{
	double x = n;
	double y = 1;
	double a = 0.000001;
	while((x-y) > a)
	{
		x = (x+y)/2;
		y = n/x;
	}
	return x;
}
