#include <stdio.h>
#include <stdlib.h>

struct jmp_buf
{
	unsigned long rsp;
	unsigned long rbp;
	unsigned long rip;
	unsigned long r12;
	unsigned long r13;
	unsigned long r14;
	unsigned long r15;
};
