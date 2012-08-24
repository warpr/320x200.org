; -*- mode: Asm; -*-

;  doslinux.asm - a study of OS independant x86 binaries.
;  public domain (no copyright) 2001 Kuno Woudt <warp-tmt@dds.nl> 

;  This file produces an executable which runs on both linux and dos.
;  I can do this because dos .com files have no header at all and
;  just start executing from the first byte in the file, and ofcourse
;  the ELF header provides enough unused fields for the dos code to
;  repair the damages of the first few instructions and then jump out
;  of the header to a safe place :)

;  The dos code could possibly write a copy of this file with a valid
;  PE header and execute that. which would be a nice gimmick for a
;  4k or 64k intro. But that's the future, currently this file just
;  prints 'hello dos!' on dos and 'hello linux!' on linux.
    
;  use 'nasm -f bin doslinux.asm -o doslinux.com' to assemble.

    
BITS 16                                 ; dos code first.

        org 0x0000                      ; file offsets.
%define DOS_RELOC 0x0100                ; dos relocation offset
%define LNX_RELOC 0x08048000            ; linux relocation offset

zero                                    ; label = 0, for times.

ehdr            db      0x7F, "ELF"     ;   ELF header.
                db      1, 1, 1, 0      ;

; the ELF header assembles to the following code:
; 00000000  7F45              jg 0x47
; 00000002  4C                dec sp
; 00000003  46                inc si
; 00000004  0101              add [bx+di],ax
; 00000006  0100              add [bx+si],ax

; afaik most flags can be anything on startup, so it may
; jump to 0x47 and it may not :)
; so I need to fix any damages the above code does
; and then jump to 0x47.
                inc     sp              ;
                sub     [bx+si],ax      ;
                sub     [bx+di],ax      ;
                jmp     short _jmp_dos  ;

BITS 32                                 ;

                times   0x10 - $ + zero db  0  ;   (the rest of) e_ident
                dw      2               ;   e_type
                dw      3               ;   e_machine
                dd      1               ;   e_version
                dd      _start_linux + LNX_RELOC ;   e_entry
                dd      phdr            ;   e_phoff
                dd      0               ;   e_shoff
                dd      0               ;   e_flags (unused on intel)
                dw      ehdrsize        ;   e_ehsize
                dw      phdrsize        ;   e_phentsize

; please note the first 8 bytes of the phdr overlap the ehdr. this is safe 
; as the values are identical. if you're interested in squeezing more
; bytes out of it at the cost of some safety, have a look at Brian Raiter's
; work at http://www.muppetlabs.com/~breadbox/software/tiny/home.html.

                                        ; Elf32_Phdr
phdr            dw      1               ;   e_phnum         ; p_type
                dw      0               ;   e_shentsize     ;
                dw      0               ;   e_shnum         ; p_offset
                dw      0               ;   e_shstrndx      ;

ehdrsize        equ     $ - ehdr

                dd      LNX_RELOC       ;   p_vaddr
                dd      LNX_RELOC       ;   p_paddr (ignored)
                dd      filesize        ;   p_filesz
                dd      filesize        ;   p_memsz
                dw      5               ;   p_flags
                db      0               ;
BITS 16                                 ;

; i assume most bits in p_flags are either reserved, ignored
; or atleast it won't hurt if they are set.

_jmp_dos        jmp     short _start_dos ; this jump is the MSB of p_flags and the LSB of p_align.
                db      0               ; p_align = 0x00000001
_start_dos      dw      0               ; add [bx+si],al

phdrsize        equ     $ - phdr

                sub     [bx+si],al      ; repair damage just in case.
                push    cs              ; i think cs = ds, but let's do
                pop     ds              ; it ourselves just to be sure.
                mov     ah,0x09         ; write to stdout.
                mov     dx, _msg_dos + DOS_RELOC ;
                int     0x21            ;
                ret                     ;

BITS 32                                 ; 

_start_linux    sub     eax,eax         ;
                mov     al,4            ; eax = 4, sys_write
                xor     ebx, ebx        ;
                inc     ebx             ; ebx = 1, stdout
                mov     ecx, _msg_linux + LNX_RELOC ; pointer to message.
                sub     edx,edx         ; 
                mov     dl, _msg_length ; edx = size of message
                int     0x80            ; 
    
                sub     ebx, ebx        ; return 0 
                sub     eax, eax        ; 
                inc     eax             ; sys_exit
                int     0x80            ;  

_msg_dos        db      'hello dos!',13,10,'$'
_msg_linux      db      'hello linux!',13,10,'$'
_msg_length     equ     $ - _msg_linux  ; size of message
    
filesize        equ     $
