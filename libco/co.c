#include "co.h"
#include <stdlib.h>
#include <malloc.h>
#include <setjmp.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>

#define K 1024
#define STACK_SIZE (64 * K)
#define COR_SIZE 128

#ifdef LOCAL_MACHINE
#define debug(...) printf(__VA_ARGS__)
#else
#endif

static int num_call_stack_switch = 1;

static void fake_func()
{
  return;
}

static inline void stack_switch_call(void *sp, void *entry, uintptr_t arg) {
  asm volatile (
#if __x86_64__
    "movq %0, %%rsp; movq %2, %%rdi; jmp *%1"
      : : "b"((uintptr_t)sp), "d"(entry), "a"(arg) : "memory"
#else
    "movl %0, %%esp; movl %2, 4(%0); jmp *%1"
      : : "b"((uintptr_t)sp - 8), "d"(entry), "a"(arg) : "memory"
#endif
  );
}

/** static inline void stack_switch_call(void *sp, void *entry, uintptr_t arg) */
/** { */
/**   debug("%d time(s) call stack switch\n", num_call_stack_switch++); */
/**   [> if (num_call_stack_switch >= 4) <] */
/**   [>   return; <] */
/**   register long rsp asm("rsp"); */
/**   volatile long saved_rsp = rsp; */
/**   fake_func(); */
/**   asm volatile( */
/** #if __x86_64__ */
/**       "movq %0, %%rsp; movq %3, 16(%%rsp); movq %2, %%rdi; call *%1" */
/**       : */
/**       : "b"((uintptr_t)sp - 32), "d"((uintptr_t)entry), "a"((uintptr_t)arg), "r"(saved_rsp) */
/**       : "memory", "rcx" */
/** #else */
/**       "movl %0, %%esp; movl %2, 4(%0); jmp *%1" */
/**       : */
/**       : "b"((uintptr_t)sp - 8), "d"(entry), "a"(arg) */
/**       : "memory" */
/** #endif */
/**   ); */
/**   asm volatile( */
/** #if __x86_64__ */
/**       "movq 32(%%rsp), %%rcx; movq 16(%%rsp), %0; movq %0, %%rsp" */
/** #else */
/**       "movl %0, %%esp; movl %1, %%ebp" */
/** #endif */
/**       : */
/**       : "r"(saved_rsp) */
/**       : "rcx"); */
/**   return; */
/** } */

enum co_status
{
  CO_NEW = 1, // 新创建，还未执行过
  CO_RUNNING, // 已经执行过
  CO_WAITING, // 在 co_wait 上等待
  CO_DEAD,    // 已经结束，但还未释放资源
};

typedef struct co
{
  const char *name;
  void (*func)(void *);
  void *arg;

  uint8_t stack[STACK_SIZE];
  enum co_status status;
  struct co *waiter;
  jmp_buf context;
} co;

typedef struct coNode
{
  struct co *coroutine;
  struct coNode *prev, *next;
} coNode;

coNode *current = NULL;

static void insert_coroutine(co *new_co)
{
  coNode *new_co_node = (coNode *)malloc(sizeof(coNode));
  new_co_node->coroutine = new_co;
  if (current == NULL)
  {
    new_co_node->prev = new_co_node;
    new_co_node->next = new_co_node;
    current = new_co_node;
  }
  else
  {
    new_co_node->prev = current->prev;
    new_co_node->next = current;
    current->prev->next = new_co_node;
    current->prev = new_co_node;
  }
}

static coNode *find_then_remove(co *del_co)
{
  // debug("Here in the find_then_remove_func\n");
  // print_coroutine_list();
  if (del_co != current->coroutine)
  {
    if (del_co == NULL)
      return NULL;
    coNode *cp = current;
    while (cp->coroutine != del_co)
      cp = cp->next;
    assert(cp->coroutine == del_co);
    cp->prev->next = cp->next;
    cp->next->prev = cp->prev;
    cp->next = cp;
    cp->prev = cp;
    debug("after removal\n");
    // print_coroutine_list();
    return cp;
  }
  else
  {
    if (current->next == current)
    {
      coNode *only_one = current;
      current = NULL;
      return only_one;
    }
    else
    {
      coNode *old_current = current;
      current->prev->next = current->next;
      current->next->prev = current->prev;
      current = current->next;
      old_current->next = old_current->prev = old_current;
      return old_current;
    }
  }
}

// static void remove_coroutine(co *)

struct co *co_start(const char *name, void (*func)(void *), void *arg)
{
  co *new_co = (co *)malloc(sizeof(co));
  assert(new_co);

  new_co->name = name;
  new_co->func = func;
  new_co->arg = arg;
  new_co->status = CO_NEW;
  new_co->waiter = NULL;
  insert_coroutine(new_co);

  return new_co;
}

void find_next_coroutine()
{
  // srand(time(0));
  int rand_num = rand() % COR_SIZE + 1;
  // debug("random number: %d\n", rand_num);
  int cnt = 0;
  coNode *next_cur = current;
  while (cnt < rand_num)
  {
    if (next_cur->coroutine->status == CO_NEW || next_cur->coroutine->status == CO_RUNNING)
    {
      cnt++;
    }
    next_cur = next_cur->next;
  }
  current = next_cur->prev;
}

void co_yield ()
{
  int val = setjmp(current->coroutine->context);
  if (!val)
  {
    find_next_coroutine();
    assert(current && (current->coroutine->status == CO_NEW || current->coroutine->status == CO_RUNNING));
    if (current->coroutine->status == CO_RUNNING)
    {
      longjmp(current->coroutine->context, 1);
    }
    else
    {
      ((coNode volatile *)current)->coroutine->status = CO_RUNNING;
      stack_switch_call(current->coroutine->stack + STACK_SIZE, current->coroutine->func, current->coroutine->arg);
      debug("should right after the returned statement\n");
      current->coroutine->status = CO_DEAD;
      if (current->coroutine->waiter)
        current->coroutine->waiter->status = CO_RUNNING;
      co_yield();
    }
  }
}

void co_wait(co *waited_co)
{
  assert(waited_co);
  if (waited_co->status != CO_DEAD)
  {
    waited_co->waiter = current->coroutine;
    current->coroutine->status = CO_WAITING;
    co_yield();
  }
  assert(waited_co->status == CO_DEAD);
  coNode *deleted = find_then_remove(waited_co);
  free(waited_co);
  free(deleted);
}

void test_print_current_coroutine_name()
{
  find_next_coroutine();
  printf("current coroutine name is: %s\n", current->coroutine->name);
}

static __attribute__((constructor)) void global_init()
{
  srand(time(0));
  co_start("main", NULL, NULL);
  assert(current);
  current->coroutine->status = CO_RUNNING;
}

static __attribute__((destructor)) void global_resign()
{
  // debug("resign\n");
  if (current)
  {
    while (current)
    {
      free(current->coroutine);
      free(find_then_remove(current->coroutine));
      if (current == NULL)
        break;
      current = current->next;
    }
  }
}

void print_coroutine_list()
{
  coNode *cur = current;
  printf("%s", cur->coroutine->name);
  cur = cur->next;
  while (cur != current)
  {
    printf("->%s", cur->coroutine->name);
    cur = cur->next;
  }
  printf("\n");
}
