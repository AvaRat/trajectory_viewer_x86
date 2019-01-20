# ifndef F_H
#define F_H

void f( char* )
#endif //F_H

#include <stdio.h>
#include "f.h"		

int main( int argc, char **argv)
{
	if (argc < 2)
	{
		printf("Arg.missing /n");
		return -1;
	}
	f(argv[1])
	{
		printf(argv[1]);
		printf("/n");
		return 0;
	}
}

