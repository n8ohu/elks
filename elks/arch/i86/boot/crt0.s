# 1 "boot/crt0.S"
! enable the autoconfig tool

# 1 "/usr/src/branch/rom_boot/elks/include/linuxmt/config.h" 1



# 1 "/usr/src/branch/rom_boot/elks/include/linuxmt/autoconf.h" 1
























































































































# 4 "/usr/src/branch/rom_boot/elks/include/linuxmt/config.h" 2
















































# 3 "boot/crt0.S" 2

|
|	Assembler boot strap hooks. This is called by setup
|
	.text
	.globl _main
	.extern	_start_kernel
	.extern _arch_boot

| note: this next instruction is part of the kernel restart fix for
| protexted mode. it must be 3 bytes long.
	.extern _kernel_restarted
	br _kernel_restarted
	
|
|	Setup passes these on the stack	
|	Setup patched to pass parameters in registers to avoid clobbering the
|	kernel when using the 286pmode extender.
|
_main:
# 31 "boot/crt0.S"

	mov	__endtext, bx
	mov	__enddata, si
	add	si, dx
	mov	__endbss, si

       

	mov	ax,ds           ;in ROMCODE stack is ready placed
	mov	ss,ax
	mov	sp,#_bootstack


!  overwrite start of main with a jmp to kernel_restarted()
!  this will give is a call stack trace instead of the "timer bug" message
!  no longer nessecary due to pmode fix. -AJB
!	.extern _redirect_main
!	call	_redirect_main

	call	_arch_boot
	call	_start_kernel
| Break point if it returns
	int	3
|
|	Segment beginnings	
|
	.data
	.globl __endtext
	.globl __enddata
	.globl __endbss
	

	.zerow	384
_bootstack:

| 768 byte boot stack. Print sp in wake_up and you'll see that more than
! 512 bytes of stack are used! 
| Must be in data as its in use when we wipe the BSS
__endtext:
	.word	0
__enddata:
	.word	0
__endbss:
	.word	0
	.bss
__sbss:
