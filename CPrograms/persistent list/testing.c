#include <stdio.h>

int main(int argc, char **argv) {
  void *boo, *foo;
  int x = 7;
  boo = 10;
  foo = boo;
  boo = 20;
  printf("boo = %d, foo = %d", boo, foo);
}
