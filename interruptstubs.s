.set IRQ_BASE, 0x20

.section .text

.extern _ZN16InterruptManager15handleInterruptEhj


.macro HandleException num
.global _ZN16InterruptManager16HandleException\num\()Ev
_ZN16InterruptManager16HandleException\num\()Ev
    movb $\num, (interruptnumber)
    jmp int_bottom
.endm

.macro HandleInterruptRequest num
.global _ZN16InterruptManager26HandleInterruptRequest\num\()Ev
_ZN16InterruptManager26HandleInterruptRequest\num\()Ev
    movb $\num + IRQ_BASE, (interruptnumber)
    jmp int_bottom
.endm


HandleException 0x00
HandleException 0x01


int_bottom:

    pusha
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    
    pushl %esp
    push (interruptnumber)
    call _ZN16InterruptManager15HandleInterruptEhj
    #addl $5, %esp
    mov %eax, %esp # switch the stack

    # restore registers
    popl %gs
    popl %fs
    popl %es
    popl %ds
    
.global _ZN16InterruptManager22IgnoreInterruptRequestEv
_ZN16InterruptManager22IgnoreInterruptRequestEv:
    iret


.data
    interruptnumber: .byte 0