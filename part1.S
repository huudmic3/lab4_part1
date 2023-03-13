/* 
 * File: part1.S
 * Description: Assembly program that displays the following behaviors:
 *	OoO, RAW, WAW, WAR, Issue Queue full, Branch Miss 
 */

        .text
# Text segment
        .globl _start;

_start: # entry point
	# enable FPU
        li      t0, (3 << 13);
        csrs    mstatus, t0;

        # load floats into f0 and f1
        la      t0, WORD_F0;
        flw     f0, 0(t0);
        la      t0, WORD_F1;
        flw     f1, 0(t0);
        # load integers into t3 and t4
	li	t3, 420;
	li	t4, 69;
	
	fadd.s  f2, f0, f1; 
        fmul.s  f3, f2, f1; 		# Read-Write Hazard
	addi	t5, t4, 12; 		# Out-of-Order Execution

	li	t1, 27;
	li	t2, 29;
	add	t6, t1, t2;
	sub 	t6, t1, t2;		# Write-Write Hazard

	li	t3, 9;
	addi	t4, t5, 4;
	add	t5, t3, t1;		# Write-Read Hazard
	
	beq	t1, x0, _start;

i_q_full: #Filling up the issue queue with a bunch of div commands
	li	t1, 17;
	li	t2, 297;
	div	t3, t2, t1;
	div	t4, t3, t1;
	div	t5, t4, t1;
	div	t6, t5, t4;
	div	t2, t3, t6;
	div	t1, t5, t2;
	div	t4, t3, t1;
	div	t3, t4, t6;
	div	t5, t3, t1;
	div	t1, t5, t4;
	div	t6, t3, t1;
	div	t4, t6, t2;
	div	t2, t3, t4;
	div	t5, t1, t2;
	div	t3, t5, t6;

        # exit
        li      a0, 0;  # set exit value to 0
        li      a7, 93; # set syscall to `exit`

        ecall;

        .data
# Data segment
WORD_F0: .word 0x431a0000 # 154.0
WORD_F1: .word 0x41700000 #  15.0

        .section ".tohost","aw",@progbits
        .globl tohost
        .globl fromhost
        .align 6
tohost: .dword 0
        .align 6
fromhost: .dword 0
