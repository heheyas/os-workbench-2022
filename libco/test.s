	.file	"test.c"
	.text
	.globl	global_cnt
	.bss
	.align 4
	.type	global_cnt, @object
	.size	global_cnt, 4
global_cnt:
	.zero	4
	.section	.rodata
.LC0:
	.string	"%d %s with i=%d\n"
.LC1:
	.string	"%s returned\n"
	.text
	.globl	entry
	.type	entry, @function
entry:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L2
.L3:
	movl	global_cnt(%rip), %eax
	movl	-8(%rbp), %ecx
	movq	-24(%rbp), %rdx
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	global_cnt(%rip), %eax
	addl	$1, %eax
	movl	%eax, global_cnt(%rip)
	movl	$0, %eax
	call	co_yield@PLT
	addl	$1, -8(%rbp)
.L2:
	cmpl	$9, -8(%rbp)
	jle	.L3
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	entry, .-entry
	.globl	do_nothing
	.type	do_nothing, @function
do_nothing:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	do_nothing, .-do_nothing
	.section	.rodata
.LC2:
	.string	"a"
.LC3:
	.string	"co1"
.LC4:
	.string	"b"
.LC5:
	.string	"co2"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	leaq	.LC2(%rip), %rdx
	leaq	entry(%rip), %rsi
	leaq	.LC3(%rip), %rdi
	call	co_start@PLT
	movq	%rax, -16(%rbp)
	leaq	.LC4(%rip), %rdx
	leaq	entry(%rip), %rsi
	leaq	.LC5(%rip), %rdi
	call	co_start@PLT
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	co_wait@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	co_wait@PLT
	movl	$0, %eax
	call	co_yield@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
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
