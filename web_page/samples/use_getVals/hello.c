#include <stdio.h>

int
main (int argc, char *argv[])
{
#if DEBUG
  printf( "DEBUG FLAG ON\n" );
#endif
  printf( "Hello, world!\n" );
  return 0;
 }
