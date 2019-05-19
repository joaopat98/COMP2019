	.text
	.file	"out.txt"
	.globl	print_int               # -- Begin function print_int
	.p2align	4, 0x90
	.type	print_int,@function
print_int:                              # @print_int
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%edi, %esi
	movl	$.L.int_format, %edi
	xorl	%eax, %eax
	callq	printf
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	print_int, .Lfunc_end0-print_int
	.cfi_endproc
                                        # -- End function
	.globl	print_float             # -- Begin function print_float
	.p2align	4, 0x90
	.type	print_float,@function
print_float:                            # @print_float
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$.L.float_format, %edi
	movb	$1, %al
	callq	printf
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	print_float, .Lfunc_end1-print_float
	.cfi_endproc
                                        # -- End function
	.globl	print_string            # -- Begin function print_string
	.p2align	4, 0x90
	.type	print_string,@function
print_string:                           # @print_string
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	callq	printf
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	print_string, .Lfunc_end2-print_string
	.cfi_endproc
                                        # -- End function
	.globl	print_bool              # -- Begin function print_bool
	.p2align	4, 0x90
	.type	print_bool,@function
print_bool:                             # @print_bool
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	testb	$1, %dil
	je	.LBB3_2
# %bb.1:                                # %true
	movl	$.L.bool_true, %edi
	xorl	%eax, %eax
	callq	printf
.LBB3_2:                                # %end
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	print_bool, .Lfunc_end3-print_bool
	.cfi_endproc
                                        # -- End function
	.globl	factorial               # -- Begin function factorial
	.p2align	4, 0x90
	.type	factorial,@function
factorial:                              # @factorial
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -16
	movl	%edi, 12(%rsp)
	testl	%edi, %edi
	jne	.LBB4_3
# %bb.1:                                # %l_0
	movl	$1, %eax
	jmp	.LBB4_2
.LBB4_3:                                # %l_1
	movl	12(%rsp), %ebx
	leal	-1(%rbx), %edi
	callq	factorial
	imull	%ebx, %eax
.LBB4_2:                                # %l_0
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	factorial, .Lfunc_end4-factorial
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, 16(%rsp)
	movq	8(%rsi), %rdi
	callq	atoi
	movl	%eax, 12(%rsp)
	movl	%eax, %edi
	callq	factorial
	movl	%eax, %edi
	callq	print_int
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
	.cfi_endproc
                                        # -- End function
	.type	.L.int_format,@object   # @.int_format
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.int_format:
	.asciz	"%d\n"
	.size	.L.int_format, 4

	.type	.L.float_format,@object # @.float_format
.L.float_format:
	.asciz	"%.08f\n"
	.size	.L.float_format, 7

	.type	.L.bool_true,@object    # @.bool_true
.L.bool_true:
	.asciz	"true\n"
	.size	.L.bool_true, 6

	.type	.L.bool_false,@object   # @.bool_false
.L.bool_false:
	.asciz	"false\n"
	.size	.L.bool_false, 7


	.section	".note.GNU-stack","",@progbits
