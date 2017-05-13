; this proram computes the roots of a quadratic equation
; ax*x + bx + c = 0

EXTERN scanf
EXTERN printf

GLOBAL main

SEGMENT .data
prompt: DB "Enter three numbers: ",0
format: DB "%lf %lf %lf",0
output: DB "Equation %.3lfx^2 %+.3lfx  %+.3lf = 0 ",0
solut1: DB "has no real roots",10,0
solut2: DB 10,"The roots are: %.3lf and %.3lf",10,0

SEGMENT .bss
a:    RESQ 1              ; storage for the coefficients a, b, and c
b:    RESQ 1
c:    RESQ 1
x1:   RESQ 1              ; x1 = (-b - sqrt(b*b-4*a*c))/(2*a)
x2:   RESQ 1              ; x2 = (-b + sqrt(b*b-4*a*c))/(2*a)

SEGMENT .text
main:  
; PRINT THE PROMPT
       push prompt
       call printf
       add  esp, 4

; INPUT a, b, and c
       push c
       push b
       push a
       push format
       call scanf
       add  esp, 16

; OUTPUT THE EQUATION
       push dword [c+4]
       push dword [c]
       push dword [b+4]
       push dword [b]
       push dword [a+4]
       push dword [a]
       push output
       call printf
       add  esp, 28

; COMPUTE 2*a
       finit              ; initialize FPU
       fld1               ; fstack: 1.0
       fld  qword [a]     ; fstack: a, 1.0
       fscale             ; fstack: 2*a, 1.0

; COMPUTE DET=b*b-4*a*c
       fxch st1           ; fstack: 1.0, 2*a
       fld1               ; fstack: 1.0, 1.0, 2*a
       faddp st1          ; fstack: 2.0, 2*a
       fld  qword [a]     ; fstack: a, 2.0, 2*a
       fmul qword [c]     ; fstack: a*c, 2.0, 2*a
       fscale             ; fstack: 4*a*c, 2.0, 2*a
       fxchp              ; fstack: 4*a*c, 2*a
       fld  qword [b]     ; fstack: b, 4*a*c, 2*a
       fmul qword [b]     ; fstack: b*b, 4*a*c, 2*a
       fsubrp st1, st0    ; fstack: b*b-4*a*c, 2*a     

; CHECK THE SIGN OF DET 
       ftst               ; compate det with 0
       fstsw ax           ; store the fstatus in AX
       sahf               ; store AX in FLAGS register
       jae  .L1
       mov  ebx, 4
       push solut1        ; report NO REAL ROOTS
       jmp  .L2
       
; COMPUTE X1
.L1:   fsqrt              ; fstack: sqrt(b*b-4*a*c), 2*a
       fld  qword [b]     ; fstack: b, sqrt(b*b-4*a*c), 2*a
       fchs               ; fstack: -b, sqrt(b*b-4*a*c), 2*a
       fsub st1           ; fstack: -b-sqrt(b*b-4*a*c), sqrt(), 2*a
       fdiv st2           ; fstack: x1, sqrt(b*b-4*a*c), 2*a
       fstp qword [x1]    ; fstack: sqrt(b*b-4*a*c), 2*a
; COMPUTE X2
       fld  qword [b]     ; fstack: b, sqrt(b*b-4*a*c), 2*a
       fsubp st1          ; fstack: sqrt(b*b-4*a*c)-b, 2*a
       fdivrp st1         ; fstack: x2
       fstp qword [x2]    ; fstack: (empty)            

; OUTPUT THE ROOTS       
       mov  ebx, 20
       push dword [x2+4]
       push dword [x2]
       push dword [x1+4]
       push dword [x1]
       push solut2
.L2:   call printf
       add esp, ebx

       ret

