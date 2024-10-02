;================================================
; module  : Final version of code
; created : Hana Hadidi 
;================================================

;some useful bit address equates
RDpin equ 0B3h
WRpin equ 0B2h
A0pin equ 0B5h
A1pin equ 0B4h

;lookup table for keypad values

org 8000h

KCODE0: db 06h,5Bh,4Fh,71h
KCODE1: db 66h,6Dh,7Dh,79h
KCODE2: db 07h,7Fh,67h,5Eh
KCODE3: db 77H,3Fh,7Ch,58h

;start address for program

org 8100h

start:
;configure 8255 control register
;set port A and B to output
setb A0pin
setb A1pin
mov P1, #81h
Lcall write

;set port CU output and CL as input

; clear digit registers (just to be on safe side)
mov R0,#00h
mov R1,#00h
mov R2,#00h
mov R3,#00h

;------- Start Keypad Loop ---------


Kloop:
clr A0pin
setb A1pin

;sets lower nibble of P1 capable of recieving data
mov a,#0FFh
mov P1, a
lcall write  ;write all 1's to lower nibble of port C , this prepare lower nibble for read acess

;pulse read pin (low) to transfer Port C values to P1
clr RDpin
mov a,P1
setb RDpin

anl a,#0Fh
cjne a,#00h, main
acall display_value
sjmp Kloop

;main long calls all required subjunctions
main:
acall shift_registers_accross
acall get_input_position
acall check_if_F_pressed
acall display_value
lcall delay2
sjmp kloop

;shifts the registers accross after each input to avoid over writing them
shift_registers_accross:
mov a,R2
mov R3,a
mov a,R1
mov R2,a
mov a,R0
mov R1,a
ret

;checks which row is high by setting all columns high, and branches out to set the DPTR to point to a set of kcode if it returns a high value in the upper nibble.
get_input_position:
mov p1, #00011111b ;check which row is high
lcall write
lcall read
anl a,#00001111b
cjne a,#0h,point_row_1 ;if high have pointer point to correct KCode


mov p1, #00101111b
lcall write
lcall read
anl a,#00001111b
cjne a,#0h,point_row_2


mov p1, #01001111b
lcall write
lcall read
anl a,#00001111b
cjne a,#0h,point_row_3


mov p1, #10001111b
lcall write
lcall read
anl a,#00001111b
cjne a,#0h,point_row_4

;moves the correct set of KCode into DPTR for the row the keypress was found on, and jumps to column check.
point_row_1:
mov DPTR, #KCODE0
sjmp get_column

point_row_2:
mov DPTR, #KCODE1
sjmp get_column

point_row_3:
mov DPTR, #KCODE2
sjmp get_column

point_row_4:
mov DPTR, #KCODE3
sjmp get_column

;checks which column keypress is on by branching if the lower nibble returns high, increments the DPTR each time it moves accross to check the next column.
get_column:
	mov P1,#11110000b
	lcall write
	lcall read
	anl a,#0Fh
	cjne a,#00000001b,column_2
	sjmp read_and_store_value
	
	column_2:
	inc DPTR
	mov P1,#11110000b
	lcall write
	lcall read
	anl a,#0Fh
	cjne a,#00000010b,column_3
	sjmp read_and_store_value
	
	column_3:
	inc dptr
	mov p1, #11110000b
	lcall write
	lcall read
	anl a,#0Fh
	cjne a,#00000100b,Column_4
	sjmp read_and_store_value
	
	column_4:
	inc DPTR
	sjmp read_and_store_value

;uses indexed addressing to store the DPTR value into R0.
read_and_store_value:
clr a
movc a, @a+dptr ; Read the value at DPTR and store it in the accumulator
mov r0, a  ; Store the recent value in R0 
ret 

;compares most recent keypress stored in R0 to display hex configuration of 'F', if true it clears the registers by moving #00h into them then returns to main with 'ret'.If false it branches to 'ret' to return to main.
check_if_F_pressed:
    cjne r0,#71h,return_to_output
    mov R0,#00h
    mov R1,#00h
    mov R2,#00h
    mov R3,#00h
    return_to_output:
    ret

;uses port A to store the configuration of each number using R0-R3, and port B has constant values depending on which of the 4 segments to display the number or letter on.
display_value:
 ;write digit R0 to port A
    clr A0pin
    clr A1pin
    mov     P1, R0
    Lcall write
    ;activate digit R0 (port B)
    setb A0pin
    clr A1pin
    mov     P1, #00000001b
    Lcall write
    mov p1,#00000000b
    lcall write

 ;write digit R1 to port A
    clr A0pin
    clr A1pin
    mov     P1, R1
    Lcall write
    ;activate digit R1 (port B)
    setb A0pin
    clr A1pin
    mov     P1, #00000010b
    Lcall write
    mov p1,#00000000b
    lcall write

;write digit R2 to port A
    clr A0pin
    clr A1pin
    mov     P1, R2
    Lcall write
 ;activate digit R2 (port B)
    setb A0pin
    clr A1pin
    mov     P1, #00000100b
    Lcall write
        mov p1,#00000000b
    lcall write

;write digit R3 to port A
    clr A0pin
    clr A1pin
    mov     P1, R3
    Lcall write
 ;activate digit R3 (port B)
    setb A0pin
    clr A1pin
    mov     P1, #00001000b
    Lcall write
    mov p1,#00000000b
    lcall write
ret

;used to add a delay to reduce debounce
delay:
	mov r7,#7fh
delay1:
	mov r6,#0ffh
delay2: 
	djnz r6,delay2
	djnz r7,delay1
	ret


;----- 8255 WRITE Subroutine -------
;used once address and data lines setup
write:  
	clr  WRpin
	nop
	setb WRpin
	nop
	ret
read:
	clr RDpin
	nop
	mov a,P1
	nop
	setb RDpin
	ret
;----- End WRITE Subroutine -------

end
;END
