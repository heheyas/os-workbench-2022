#include <stdio.h>
#include "co.h"

#define debug(...) printf(__VA_ARGS__)

int global_cnt = 0;

void entry(void *arg)
{
    int x = 0;
    for (int i = 0; i < 10; ++i)
    {
        printf("%d %s with i=%d\n", global_cnt, (const char *)arg, i);
        global_cnt++;
        co_yield();
    }
    debug("%s returned\n", (const char *)arg); // print returned when i == 10
}

int main(int argc, char *argv[])
{
    struct co *co1 = co_start("co1", entry, "a");
    struct co *co2 = co_start("co2", entry, "b");
    co_wait(co1); // never returns
    co_wait(co2);
    co_yield();
}
