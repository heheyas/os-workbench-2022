#include "co.h"
#include <stdlib.h>
#include <malloc.h>
#include <setjmp.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define STACK_SIZE 64000
#define COR_SIZE 128

static inline void stack_switch_call(void *sp, void *entry, uintptr_t arg)
{
  asm volatile(
#if __x86_64__
      "movq %0, %%rsp; movq %2, %%rdi; jmp *%1"
      :
      : "b"((uintptr_t)sp), "d"(entry), "a"(arg)
      : "memory"
#else
      "movl %0, %%esp; movl %2, 4(%0); jmp *%1"
      :
      : "b"((uintptr_t)sp - 8), "d"(entry), "a"(arg)
      : "memory"
#endif
  );
}

enum co_status
{
  CO_NEW = 1,
  CO_RUNNING,
  CO_WAITING,
  CO_DEAD,
};

struct co
{
  char *name;
  void (*func)(void *);
  void *arg;
  int cid;

  enum co_status status;
  struct co *waiter;
  jmp_buf context;
  uint8_t stack[STACK_SIZE];
};

struct co *current;

bool occupied[COR_SIZE];
struct co *co_table[COR_SIZE];

int find_available_cid()
{
  for (int i = 0; i < COR_SIZE; ++i)
  {
    if (!occupied[i])
    {
      occupied[i] = true;
      return i;
    }
  }
  return -1;
}

inline int count_num_alive_co()
{
  int sum = 0;
  for (int i = 0; i < COR_SIZE; ++i)
  {
    sum += occupied[i];
  }
  return sum;
}

int random_select_co()
{
  int num_co = count_num_alive_co();
  int rand_number = rand() % num_co + 1;
  int idx = 0, acc = 0;
  for (; idx < COR_SIZE; ++idx)
  {
    acc += occupied[idx];
    if (acc == rand_number)
      break;
  }
  return idx;
}

void co_resume()
{
  if (current->status == CO_NEW)
  {
    current->status = CO_RUNNING;
    stack_switch_call(current->stack, current->func, (uintptr_t*)current->arg);
  }
  else if (current->status == CO_WAITING)
  {
    longjmp(current->context, 1);
  }
}

struct co *co_start(const char *name, void (*func)(void *), void *arg)
{
  struct co *new_co = (struct co *)malloc(sizeof(struct co));
  strcpy(new_co->name, name);
  new_co->func = func;
  new_co->arg = arg;
  new_co->cid = find_available_cid();
  return new_co;
}


void co_wait(struct co *co)
{
  current->status = CO_WAITING;
  if (co->status == CO_DEAD)
  {
    co_table[co->cid] = NULL;
    occupied[co->cid] = false;
    free(co);
    current->status = CO_RUNNING;
  }
  else
  {
    co_yield();
    co_wait(co);
  }
}

void choose_a_coroutine_to_resume()
{
  int cid = random_select_co();
  current = co_table[cid];
  co_resume();
}

void co_yield()
{
  int val = setjmp(current->context);
  if (val == 0)
  {
    choose_a_coroutine_to_resume();
  }
  else
  {
    return;
  }
}
