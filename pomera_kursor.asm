;;;;;;;;;;;;;;;;; PROJEKAT IZ RACUNARSKE ELEKTRONIKE ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; Carna Djokovic 300/2012
;;;;;;;;;;;;;;;;; Jelena Zivkovic 134/2012
;;;;;;;;;;;;;;;;; maj 2016

INCLUDE Irvine32.inc

; Velicina prozora
xmin = 0 
xmax = 79
ymin = 0
ymax = 24

BUFFER_SIZE = 501
.DATA
row db ?
col db ?

buffer BYTE BUFFER_SIZE DUP(? )
filename     BYTE "output.txt", 0
fileHandle   HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file", 0dh, 0ah, 0
titleStr BYTE "Projekat iz racunarske elektronike: 11", 0

.code
main PROC
INVOKE SetConsoleTitle, ADDR titleStr


; Pravljenje novog fajla
mov	edx, OFFSET filename
call	CreateOutputFile
mov	fileHandle, eax
; Proverava greske pri kreiranju fajla
cmp eax, INVALID_HANDLE_VALUE
jne setCursor
mov edx, OFFSET str1; prikazi gresku
call WriteString
jmp quit

setCursor :
mov dh, 0; postavlja kursor na nulu
mov dl, 0
call gotoxy
mov row, dh
mov col, dl
call moveit
exit

main ENDP

moveit proc
Get_key :
call readchar
cmp al, 'u'
je moveup
cmp al, 'b'
je  movedown
cmp al, 'l'
je  moveleft
cmp al, 'r'
je  moveright
cmp al, 0Dh; 0D je oznaka za enter
je exit1
jmp get_key

moveup :
call log_action

mov dh, row; dh je za y koordinatu
sub dh, 1; kada se pomera na gore mora da se smanji
mov dl, col
.IF dh< ymin || dh > ymax
mov dh,ymin
call gotoxy
mov row, dh; stavi sada nove vrednosti u row i col
mov col, dl
jmp get_key
.ENDIF
call gotoxy
mov row, dh
mov col, dl
jmp get_key; vrati se da cekas sledeci taster

movedown :
call log_action
mov dh, row
add dh, 1; kada se pomera na dole mora da se uvecava
mov dl, col
.IF dh<= ymin || dh >= ymax
mov dh, ymax
call gotoxy
mov row, dh; stavi sada nove vrednosti u row i col
mov col, dl
jmp get_key
.ENDIF
call gotoxy
mov row, dh
mov col, dl
jmp get_key

moveright :
call log_action
mov dl, col
add dl, 1
mov dh, row
.IF dl <= xmin || dl >= xmax
mov dl, xmax
call gotoxy
mov row, dh
mov col, dl
jmp get_key
.ENDIF
call gotoxy
mov row, dh
mov col, dl
jmp get_key

moveleft :
call log_action
mov dl, col
sub dl, 1
mov dh, row
.IF dl<= xmin || dl >= xmax
mov dl, xmin
call gotoxy
mov row, dh
mov col, dl
jmp get_key
.ENDIF
call gotoxy
mov row, dh
mov col, dl
jmp get_key

exit1:
call CloseFile
ret
moveit endp

log_action proc

mov edi, OFFSET buffer
stosb; upisuje karakter u memoriju iz al registra
mov eax, fileHandle
mov edx, OFFSET buffer
mov ecx, 1; jedan po jedan karakter
call WriteToFile

ret
log_action endp

quit :
exit

END main