	.file	"co.c"
	.text
	.data
	.align 4
	.type	num_call_stack_switch, @object
	.size	num_call_stack_switch, 4
num_call_stack_switch:
	.long	1
	.text
	.type	fake_func, @function
fake_func:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	fake_func, .-fake_func
	.section	.rodata
.LC0:
	.string	"%d time(s) call stack switch\n"
	.text
	.type	stack_switch_call, @function
stack_switch_call:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	num_call_stack_switch(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, num_call_stack_switch(%rip)
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	debug@PLT
	movl	num_call_stack_switch(%rip), %eax
	cmpl	$3, %eax
	jg	.L6
	movq	%rsp, %rax
	movq	%rax, -24(%rbp)
	movl	$0, %eax
	call	fake_func
	movq	-40(%rbp), %rax
	leaq	-32(%rax), %rdi
	movq	-48(%rbp), %rdx
	movq	-24(%rbp), %rsi
	movq	-56(%rbp), %rax
	movq	%rdi, %rbx
#APP
# 47 "co.c" 1
	movq %rbx, %rsp; movq %rsi, 16(%rsp); movq %rax, %rdi; call *%rdx
# 0 "" 2
#NO_APP
	movq	-24(%rbp), %rax
#APP
# 60 "co.c" 1
	movq 32(%rsp), %rcx; movq 16(%rsp), %rax; movq %rax, %rsp
# 0 "" 2
#NO_APP
	jmp	.L3
.L6:
	nop
.L3:
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	stack_switch_call, .-stack_switch_call
	.globl	current
	.bss
	.align 8
	.type	current, @object
	.size	current, 8
current:
	.zero	8
	.text
	.type	insert_coroutine, @function
insert_coroutine:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$24, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	current(%rip), %rax
	testq	%rax, %rax
	jne	.L8
	movq	-8(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-8(%rbp), %rax
	movq	%rax, current(%rip)
	jmp	.L10
.L8:
	movq	current(%rip), %rax
	movq	8(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	current(%rip), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	current(%rip), %rax
	movq	8(%rax), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	current(%rip), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 8(%rax)
.L10:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	insert_coroutine, .-insert_coroutine
	.section	.rodata
.LC1:
	.string	"co.c"
.LC2:
	.string	"cp->coroutine == del_co"
.LC3:
	.string	"after removal\n"
	.text
	.type	find_then_remove, @function
find_then_remove:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	current(%rip), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	je	.L12
	cmpq	$0, -40(%rbp)
	jne	.L13
	movl	$0, %eax
	jmp	.L14
.L13:
	movq	current(%rip), %rax
	movq	%rax, -24(%rbp)
	jmp	.L15
.L16:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -24(%rbp)
.L15:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	jne	.L16
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	je	.L17
	leaq	__PRETTY_FUNCTION__.3304(%rip), %rcx
	movl	$130, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC2(%rip), %rdi
	call	__assert_fail@PLT
.L17:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	-24(%rbp), %rdx
	movq	16(%rdx), %rdx
	movq	%rdx, 16(%rax)
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	movq	-24(%rbp), %rdx
	movq	8(%rdx), %rdx
	movq	%rdx, 8(%rax)
	movq	-24(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-24(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, 8(%rax)
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	debug@PLT
	movq	-24(%rbp), %rax
	jmp	.L14
.L12:
	movq	current(%rip), %rax
	movq	16(%rax), %rdx
	movq	current(%rip), %rax
	cmpq	%rax, %rdx
	jne	.L18
	movq	current(%rip), %rax
	movq	%rax, -8(%rbp)
	movq	$0, current(%rip)
	movq	-8(%rbp), %rax
	jmp	.L14
.L18:
	movq	current(%rip), %rax
	movq	%rax, -16(%rbp)
	movq	current(%rip), %rdx
	movq	current(%rip), %rax
	movq	8(%rax), %rax
	movq	16(%rdx), %rdx
	movq	%rdx, 16(%rax)
	movq	current(%rip), %rdx
	movq	current(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rdx), %rdx
	movq	%rdx, 8(%rax)
	movq	current(%rip), %rax
	movq	16(%rax), %rax
	movq	%rax, current(%rip)
	movq	-16(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-16(%rbp), %rax
.L14:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	find_then_remove, .-find_then_remove
	.section	.rodata
.LC4:
	.string	"new_co"
	.text
	.globl	co_start
	.type	co_start, @function
co_start:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$65776, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L20
	leaq	__PRETTY_FUNCTION__.3315(%rip), %rcx
	movl	$164, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC4(%rip), %rdi
	call	__assert_fail@PLT
.L20:
	movq	-8(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-8(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-8(%rbp), %rax
	movl	$1, 65560(%rax)
	movq	-8(%rbp), %rax
	movq	$0, 65568(%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	insert_coroutine
	movq	-8(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	co_start, .-co_start
	.globl	find_next_coroutine
	.type	find_next_coroutine, @function
find_next_coroutine:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	call	rand@PLT
	cltd
	shrl	$25, %edx
	addl	%edx, %eax
	andl	$127, %eax
	subl	%edx, %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	movl	$0, -16(%rbp)
	movq	current(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L23
.L26:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movl	65560(%rax), %eax
	cmpl	$1, %eax
	je	.L24
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movl	65560(%rax), %eax
	cmpl	$2, %eax
	jne	.L25
.L24:
	addl	$1, -16(%rbp)
.L25:
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -8(%rbp)
.L23:
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L26
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, current(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	find_next_coroutine, .-find_next_coroutine
	.section	.rodata
	.align 8
.LC5:
	.string	"current && (current->coroutine->status == CO_NEW || current->coroutine->status == CO_RUNNING)"
	.align 8
.LC6:
	.string	"should right after the returned statement\n"
	.text
	.globl	co_yield
	.type	co_yield, @function
co_yield:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	current(%rip), %rax
	movq	(%rax), %rax
	addq	$65576, %rax
	movq	%rax, %rdi
	call	_setjmp@PLT
	endbr64
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jne	.L35
	movl	$0, %eax
	call	find_next_coroutine
	movq	current(%rip), %rax
	testq	%rax, %rax
	je	.L30
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	65560(%rax), %eax
	cmpl	$1, %eax
	je	.L36
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	65560(%rax), %eax
	cmpl	$2, %eax
	je	.L36
.L30:
	leaq	__PRETTY_FUNCTION__.3327(%rip), %rcx
	movl	$200, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC5(%rip), %rdi
	call	__assert_fail@PLT
.L36:
	nop
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	65560(%rax), %eax
	cmpl	$2, %eax
	jne	.L33
	movq	current(%rip), %rax
	movq	(%rax), %rax
	addq	$65576, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	longjmp@PLT
.L33:
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	$2, 65560(%rax)
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	16(%rax), %rax
	movq	%rax, %rsi
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	8(%rax), %rax
	movq	current(%rip), %rdx
	movq	(%rdx), %rdx
	addq	$24, %rdx
	leaq	65536(%rdx), %rcx
	movq	%rsi, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	stack_switch_call
	leaq	.LC6(%rip), %rdi
	movl	$0, %eax
	call	debug@PLT
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	$4, 65560(%rax)
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	65568(%rax), %rax
	testq	%rax, %rax
	je	.L34
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	65568(%rax), %rax
	movl	$2, 65560(%rax)
.L34:
	movl	$0, %eax
	call	co_yield
.L35:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	co_yield, .-co_yield
	.section	.rodata
.LC7:
	.string	"waited_co"
.LC8:
	.string	"waited_co->status == CO_DEAD"
	.text
	.globl	co_wait
	.type	co_wait, @function
co_wait:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L38
	leaq	__PRETTY_FUNCTION__.3332(%rip), %rcx
	movl	$220, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC7(%rip), %rdi
	call	__assert_fail@PLT
.L38:
	movq	-24(%rbp), %rax
	movl	65560(%rax), %eax
	cmpl	$4, %eax
	je	.L39
	movq	current(%rip), %rax
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 65568(%rax)
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	$3, 65560(%rax)
	movl	$0, %eax
	call	co_yield
.L39:
	movq	-24(%rbp), %rax
	movl	65560(%rax), %eax
	cmpl	$4, %eax
	je	.L40
	leaq	__PRETTY_FUNCTION__.3332(%rip), %rcx
	movl	$227, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC8(%rip), %rdi
	call	__assert_fail@PLT
.L40:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	find_then_remove
	movq	%rax, -8(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	co_wait, .-co_wait
	.section	.rodata
	.align 8
.LC9:
	.string	"current coroutine name is: %s\n"
	.text
	.globl	test_print_current_coroutine_name
	.type	test_print_current_coroutine_name, @function
test_print_current_coroutine_name:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %eax
	call	find_next_coroutine
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	test_print_current_coroutine_name, .-test_print_current_coroutine_name
	.section	.rodata
.LC10:
	.string	"main"
.LC11:
	.string	"current"
	.text
	.type	global_init, @function
global_init:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %edi
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	movl	$0, %edx
	movl	$0, %esi
	leaq	.LC10(%rip), %rdi
	call	co_start
	movq	current(%rip), %rax
	testq	%rax, %rax
	jne	.L43
	leaq	__PRETTY_FUNCTION__.3338(%rip), %rcx
	movl	$243, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC11(%rip), %rdi
	call	__assert_fail@PLT
.L43:
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movl	$2, 65560(%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	global_init, .-global_init
	.section	.init_array,"aw"
	.align 8
	.quad	global_init
	.text
	.type	global_resign, @function
global_resign:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	current(%rip), %rax
	testq	%rax, %rax
	je	.L50
	jmp	.L46
.L48:
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	current(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	find_then_remove
	movq	%rax, %rdi
	call	free@PLT
	movq	current(%rip), %rax
	testq	%rax, %rax
	je	.L51
	movq	current(%rip), %rax
	movq	16(%rax), %rax
	movq	%rax, current(%rip)
.L46:
	movq	current(%rip), %rax
	testq	%rax, %rax
	jne	.L48
	jmp	.L50
.L51:
	nop
.L50:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	global_resign, .-global_resign
	.section	.fini_array,"aw"
	.align 8
	.quad	global_resign
	.section	.rodata
.LC12:
	.string	"%s"
.LC13:
	.string	"->%s"
	.text
	.globl	print_coroutine_list
	.type	print_coroutine_list, @function
print_coroutine_list:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	current(%rip), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC12(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -8(%rbp)
	jmp	.L53
.L54:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC13(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -8(%rbp)
.L53:
	movq	current(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L54
	movl	$10, %edi
	call	putchar@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	print_coroutine_list, .-print_coroutine_list
	.section	.rodata
	.align 16
	.type	__PRETTY_FUNCTION__.3304, @object
	.size	__PRETTY_FUNCTION__.3304, 17
__PRETTY_FUNCTION__.3304:
	.string	"find_then_remove"
	.align 8
	.type	__PRETTY_FUNCTION__.3315, @object
	.size	__PRETTY_FUNCTION__.3315, 9
__PRETTY_FUNCTION__.3315:
	.string	"co_start"
	.align 8
	.type	__PRETTY_FUNCTION__.3327, @object
	.size	__PRETTY_FUNCTION__.3327, 9
__PRETTY_FUNCTION__.3327:
	.string	"co_yield"
	.align 8
	.type	__PRETTY_FUNCTION__.3332, @object
	.size	__PRETTY_FUNCTION__.3332, 8
__PRETTY_FUNCTION__.3332:
	.string	"co_wait"
	.align 8
	.type	__PRETTY_FUNCTION__.3338, @object
	.size	__PRETTY_FUNCTION__.3338, 12
__PRETTY_FUNCTION__.3338:
	.string	"global_init"
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
