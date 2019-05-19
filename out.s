	.text
	.file	"out.ll"
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
	.globl	fca                     # -- Begin function fca
	.p2align	4, 0x90
	.type	fca,@function
fca:                                    # @fca
	.cfi_startproc
# %bb.0:
	xorl	%eax, %eax
	retq
.Lfunc_end4:
	.size	fca, .Lfunc_end4-fca
	.cfi_endproc
                                        # -- End function
	.globl	fcb                     # -- Begin function fcb
	.p2align	4, 0x90
	.type	fcb,@function
fcb:                                    # @fcb
	.cfi_startproc
# %bb.0:
	movl	$132, -4(%rsp)
	movl	$132, %eax
	retq
.Lfunc_end5:
	.size	fcb, .Lfunc_end5-fcb
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function fcd
.LCPI6_0:
	.quad	4607213943997409001     # double 1.0069999999999999
	.text
	.globl	fcd
	.p2align	4, 0x90
	.type	fcd,@function
fcd:                                    # @fcd
	.cfi_startproc
# %bb.0:
	movsd	.LCPI6_0(%rip), %xmm0   # xmm0 = mem[0],zero
	retq
.Lfunc_end6:
	.size	fcd, .Lfunc_end6-fcd
	.cfi_endproc
                                        # -- End function
	.globl	fce                     # -- Begin function fce
	.p2align	4, 0x90
	.type	fce,@function
fce:                                    # @fce
	.cfi_startproc
# %bb.0:
	movq	-8(%rsp), %rax
	retq
.Lfunc_end7:
	.size	fce, .Lfunc_end7-fce
	.cfi_endproc
                                        # -- End function
	.globl	fcf                     # -- Begin function fcf
	.p2align	4, 0x90
	.type	fcf,@function
fcf:                                    # @fcf
	.cfi_startproc
# %bb.0:
	movb	-1(%rsp), %al
	retq
.Lfunc_end8:
	.size	fcf, .Lfunc_end8-fcf
	.cfi_endproc
                                        # -- End function
	.globl	fcg                     # -- Begin function fcg
	.p2align	4, 0x90
	.type	fcg,@function
fcg:                                    # @fcg
	.cfi_startproc
# %bb.0:
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%edi, 12(%rsp)
	movsd	%xmm0, 16(%rsp)
	callq	fcd
	ucomisd	16(%rsp), %xmm0
	jbe	.LBB9_2
# %bb.1:                                # %l_0
	callq	fca
	movl	12(%rsp), %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB9_2:                                # %l_1
	.cfi_def_cfa_offset 32
	callq	fcb
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end9:
	.size	fcg, .Lfunc_end9-fcg
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function fch
.LCPI10_0:
	.quad	4576918229304087675     # double 0.01
	.text
	.globl	fch
	.p2align	4, 0x90
	.type	fch,@function
fch:                                    # @fch
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -16
	movl	%edi, 12(%rsp)
	movsd	%xmm0, 24(%rsp)
	movq	%rsi, 16(%rsp)
	callq	fcb
	movl	%eax, %ebx
	callq	fcd
	movl	%ebx, %edi
	callq	fcg
	movq	16(%rsp), %rdi
	callq	print_string
	cmpb	$1, bb(%rip)
	jne	.LBB10_2
# %bb.1:                                # %l_3
	movl	ia(%rip), %eax
	addl	ib(%rip), %eax
	movl	%eax, 12(%rsp)
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	movsd	%xmm0, 24(%rsp)
	movsd	%xmm0, fb(%rip)
	movl	%eax, id(%rip)
.LBB10_2:                               # %l_5
	movsd	.LCPI10_0(%rip), %xmm0  # xmm0 = mem[0],zero
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end10:
	.size	fch, .Lfunc_end10-fch
	.cfi_endproc
                                        # -- End function
	.globl	fci                     # -- Begin function fci
	.p2align	4, 0x90
	.type	fci,@function
fci:                                    # @fci
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$48, %rsp
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -16
	movl	%edi, 20(%rsp)
	movl	%esi, 16(%rsp)
	movsd	%xmm0, 40(%rsp)
	movsd	%xmm1, 32(%rsp)
	movq	%rdx, 24(%rsp)
	callq	fcb
	movl	%eax, %ebx
	callq	fcd
	movl	%ebx, %edi
	callq	fcg
	movl	%eax, %ebx
	callq	fcd
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	callq	fce
	movl	%ebx, %edi
	movsd	8(%rsp), %xmm0          # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movq	%rax, %rsi
	callq	fch
	movl	16(%rsp), %ebx
	addl	ic(%rip), %ebx
	callq	fcb
                                        # kill: def $eax killed $eax def $rax
	leal	12(%rax,%rbx), %eax
	movl	%eax, 20(%rsp)
	callq	fcf
	testb	$1, %al
	je	.LBB11_3
# %bb.1:                                # %l_6
	movq	24(%rsp), %rdi
	callq	print_string
	movl	ia(%rip), %edi
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	movq	sa(%rip), %rsi
	callq	fch
	jmp	.LBB11_2
.LBB11_3:                               # %l_7
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	mulsd	32(%rsp), %xmm0
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	callq	fcd
	addsd	8(%rsp), %xmm0          # 8-byte Folded Reload
	movsd	%xmm0, 40(%rsp)
	callq	fcd
.LBB11_2:                               # %l_6
	addq	$48, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end11:
	.size	fci, .Lfunc_end11-fci
	.cfi_endproc
                                        # -- End function
	.globl	fcj                     # -- Begin function fcj
	.p2align	4, 0x90
	.type	fcj,@function
fcj:                                    # @fcj
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$48, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %rbp, -16
	movl	%edi, 28(%rsp)
	movl	%esi, 24(%rsp)
	movsd	%xmm0, 40(%rsp)
	movsd	%xmm1, 32(%rsp)
	andl	$1, %edx
	movb	%dl, 15(%rsp)
	movl	ia(%rip), %ebx
	addl	ib(%rip), %ebx
	movl	ic(%rip), %eax
	imull	id(%rip), %eax
	cltd
	idivl	ie(%rip)
	subl	%edx, %ebx
	movl	%ebx, 20(%rsp)
	callq	fcb
	movl	%eax, %ebp
	movl	16(%rsp), %r14d
	callq	fcb
	movsd	fb(%rip), %xmm0         # xmm0 = mem[0],zero
	movq	sa(%rip), %rsi
	movl	%eax, %edi
	callq	fch
	movsd	fd(%rip), %xmm1         # xmm1 = mem[0],zero
	movq	sb(%rip), %rdx
	movl	%ebp, %edi
	movl	%r14d, %esi
	callq	fci
	movl	%ebx, %edi
	callq	fcg
	cmpl	%eax, %ebx
	jle	.LBB12_3
# %bb.1:                                # %l_9
	cmpb	$1, ba(%rip)
	jne	.LBB12_6
# %bb.2:                                # %l_12
	movabsq	$4576918229304087675, %rax # imm = 0x3F847AE147AE147B
	movq	%rax, fc(%rip)
	jmp	.LBB12_3
.LBB12_6:                               # %l_13
	movsd	fc(%rip), %xmm0         # xmm0 = mem[0],zero
	addsd	fe(%rip), %xmm0
	movsd	%xmm0, fc(%rip)
	cmpb	$1, 15(%rsp)
	jne	.LBB12_3
	jmp	.LBB12_7
	.p2align	4, 0x90
.LBB12_8:                               # %l_19
                                        #   in Loop: Header=BB12_7 Depth=1
	movl	20(%rsp), %ebx
	callq	fcb
	cltq
	imulq	$715827883, %rax, %rbp  # imm = 0x2AAAAAAB
	movq	%rbp, %rax
	shrq	$63, %rax
	sarq	$33, %rbp
	addl	%eax, %ebp
	addl	%ebx, %ebp
	movl	ia(%rip), %edi
	addl	28(%rsp), %edi
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	callq	fcg
	addl	%ebp, %eax
	subl	24(%rsp), %eax
	movl	%eax, 16(%rsp)
	movsd	40(%rsp), %xmm0         # xmm0 = mem[0],zero
	movsd	%xmm0, 32(%rsp)
.LBB12_7:                               # %l_18
                                        # =>This Inner Loop Header: Depth=1
	callq	fcf
	testb	$1, %al
	jne	.LBB12_8
	jmp	.LBB12_3
	.p2align	4, 0x90
.LBB12_5:                               # %l_24
                                        #   in Loop: Header=BB12_3 Depth=1
	movzbl	ba(%rip), %ebx
	movzbl	bd(%rip), %eax
	orb	%bl, %al
	andb	$1, %al
	movb	%al, bd(%rip)
	callq	fcf
	orb	%bl, %al
	movzbl	bc(%rip), %ecx
	notb	%cl
	orb	bd(%rip), %cl
	andb	%al, %cl
	andb	$1, %cl
	movb	%cl, bd(%rip)
.LBB12_3:                               # %l_21
                                        # =>This Inner Loop Header: Depth=1
	cmpb	$1, bb(%rip)
	jne	.LBB12_9
# %bb.4:                                # %l_22
                                        #   in Loop: Header=BB12_3 Depth=1
	cmpb	$1, bc(%rip)
	jne	.LBB12_3
	jmp	.LBB12_5
.LBB12_9:                               # %l_23
	movl	$-101, %eax
	addq	$48, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end12:
	.size	fcj, .Lfunc_end12-fcj
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI13_0:
	.quad	4638378360837603590     # double 123.321
.LCPI13_1:
	.quad	-4452010031096791040    # double -1.0E+11
.LCPI13_2:
	.quad	4936209963552724370     # double 1.0E+22
.LCPI13_3:
	.quad	4771362005757984768     # double 1.0E+11
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	subq	$32, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rsi, 24(%rsp)
	movl	$1, ia(%rip)
	movl	$1, ib(%rip)
	movl	$1, ic(%rip)
	movl	$1, id(%rip)
	movl	$1, ie(%rip)
	movabsq	$4591870180066957722, %rax # imm = 0x3FB999999999999A
	movq	%rax, fa(%rip)
	movq	%rax, fb(%rip)
	movq	%rax, fc(%rip)
	movq	%rax, fd(%rip)
	movq	%rax, fe(%rip)
	jmp	.LBB13_1
	.p2align	4, 0x90
.LBB13_5:                               # %l_31
                                        #   in Loop: Header=BB13_1 Depth=1
	movl	ia(%rip), %ebx
	callq	fcb
	addl	%ebx, %eax
	movl	%eax, 16(%rsp)
.LBB13_1:                               # %l_27
                                        # =>This Inner Loop Header: Depth=1
	movl	ia(%rip), %ebx
	movl	ib(%rip), %ebp
	callq	fcf
	cmpl	%ebp, %ebx
	jg	.LBB13_3
# %bb.2:                                # %l_27
                                        #   in Loop: Header=BB13_1 Depth=1
	testb	$1, %al
	je	.LBB13_6
.LBB13_3:                               # %l_28
                                        #   in Loop: Header=BB13_1 Depth=1
	callq	fcb
	movl	%eax, %r14d
	callq	fcb
	movsd	fe(%rip), %xmm0         # xmm0 = mem[0],zero
	movl	%eax, %edi
	callq	fcg
	movl	%eax, %r12d
	movl	20(%rsp), %r15d
	callq	fcb
	movl	%eax, %ebx
	callq	fcd
	movl	%ebx, %edi
	callq	fcg
	movl	%eax, %ebx
	movl	ia(%rip), %ebp
	callq	fcd
	movsd	%xmm0, (%rsp)           # 8-byte Spill
	callq	fce
	movl	%ebp, %edi
	movsd	(%rsp), %xmm0           # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movq	%rax, %rsi
	callq	fch
	movsd	%xmm0, (%rsp)           # 8-byte Spill
	callq	fcd
	movaps	%xmm0, %xmm1
	movq	sc(%rip), %rdx
	movl	%ebx, %edi
	movl	$123, %esi
	movsd	(%rsp), %xmm0           # 8-byte Reload
                                        # xmm0 = mem[0],zero
	callq	fci
	movsd	%xmm0, (%rsp)           # 8-byte Spill
	callq	fcd
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	callq	fcf
	movzbl	%al, %edx
	movl	%r12d, %edi
	movl	%r15d, %esi
	movsd	(%rsp), %xmm0           # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movsd	8(%rsp), %xmm1          # 8-byte Reload
                                        # xmm1 = mem[0],zero
	callq	fcj
	cmpl	%eax, %r14d
	jle	.LBB13_5
# %bb.4:                                # %l_30
                                        #   in Loop: Header=BB13_1 Depth=1
	movl	ia(%rip), %esi
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	movzbl	ba(%rip), %edx
	movl	$12, %edi
	movsd	.LCPI13_3(%rip), %xmm1  # xmm1 = mem[0],zero
	callq	fcj
	movl	%eax, 16(%rsp)
	jmp	.LBB13_1
.LBB13_6:                               # %l_29
	movl	16(%rsp), %r15d
	callq	fcb
                                        # kill: def $eax killed $eax def $rax
	leal	456(%rax), %ebx
	callq	fcd
	addsd	.LCPI13_0(%rip), %xmm0
	movl	%ebx, %edi
	callq	fcg
                                        # kill: def $eax killed $eax def $rax
	leal	123(%rax), %r14d
	movl	ia(%rip), %ebp
	addl	ib(%rip), %ebp
	movslq	ic(%rip), %rax
	imulq	$715827883, %rax, %rax  # imm = 0x2AAAAAAB
	movq	%rax, %rcx
	shrq	$63, %rcx
	sarq	$33, %rax
	addl	%ecx, %eax
	subl	%eax, %ebp
	movl	id(%rip), %ebx
	imull	ie(%rip), %ebx
	callq	fcb
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	movl	%eax, %edi
	callq	fcg
	movl	%eax, %ecx
	movl	%ebx, %eax
	cltd
	idivl	%ecx
	addl	%edx, %ebp
	movl	ia(%rip), %ebx
	addl	ib(%rip), %ebx
	movsd	fa(%rip), %xmm0         # xmm0 = mem[0],zero
	movsd	%xmm0, (%rsp)           # 8-byte Spill
	callq	fcd
	divsd	.LCPI13_1(%rip), %xmm0
	addsd	(%rsp), %xmm0           # 8-byte Folded Reload
	movsd	%xmm0, (%rsp)           # 8-byte Spill
	callq	fcd
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	callq	fce
	movl	%ebx, %edi
	movl	$123, %esi
	movsd	(%rsp), %xmm0           # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movsd	8(%rsp), %xmm1          # 8-byte Reload
                                        # xmm1 = mem[0],zero
	movq	%rax, %rdx
	callq	fci
	movsd	%xmm0, (%rsp)           # 8-byte Spill
	callq	fcd
	addsd	.LCPI13_2(%rip), %xmm0
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	callq	fce
	movl	$324, %edi              # imm = 0x144
	movsd	8(%rsp), %xmm0          # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movq	%rax, %rsi
	callq	fch
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	callq	fcf
	orb	ba(%rip), %al
	andb	bb(%rip), %al
	movzbl	%al, %edx
	movl	%r14d, %edi
	movl	%ebp, %esi
	movsd	(%rsp), %xmm0           # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movsd	8(%rsp), %xmm1          # 8-byte Reload
                                        # xmm1 = mem[0],zero
	callq	fcj
	addl	%r15d, %eax
	movl	%eax, 20(%rsp)
	xorl	%eax, %eax
	addq	$32, %rsp
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end13:
	.size	main, .Lfunc_end13-main
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
