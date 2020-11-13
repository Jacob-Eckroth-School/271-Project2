;Name: Jacob Eckroth
;Date: October 11, 2020
;Program Number Two
;Program Description: This program asks the user for input into their username.
;It then asks for input for an amount of fibonacci numbers to display. First the program
;Checks if this is a valid number, and then checks if that number is within the range 1-46. If 
;Either is false, it re-prompts the user. If it is in the range, then the fibonacci numbers are
;Calculated and displayed to the screen. Then we say goodbye to the user.
TITLE Fibonacci Calculator

 .386
 .model flat,stdcall
 .stack 4096
 ExitProcess PROTO, dwExitCode:DWORD

INCLUDE Irvine32.inc


.data				;variable initializations here.

programTitle BYTE "Fibonacci Numbers",13,10,0
authorName BYTE "Programmed by Jacob Eckroth",13,10,0
usernamePrompt BYTE "What's your name? ",0
helloGreeting BYTE "Hello, ", 0
fibonacciInfo BYTE "Enter the number of Fibonacci terms to be displayed... It should be an integer in the range [1, 46]...",13,10,0
fibonacciPrompt BYTE "How many Fibonacci terms do you want? ", 0
outOfRangePrompt BYTE "Out of range. Enter a number in [1, 46]",13,10,0
invalidInputPrompt BYTE "Invalid Input! Please enter a series of numbers 0-9 between 1 and 46!",13,10,0
certifiedNotice BYTE "Results certified by Leonardo Bonacci",13,10,0
goodbyePrompt BYTE "Goodbye, ", 0
period BYTE ".",0
spacer BYTE "    ",0            ;spacer between numbers


previousNumber DWORD 0
currentNumber DWORD 1
numberCount DWORD 0             ;keeps track of the numbers printed per line for fib
upperLimit = 46 


;Color Declarations
defaultColor = 7
userInputColor = 11
errorColor = 4

.data?
userName BYTE 64 DUP(?)

stringFibInput  BYTE 64 DUP(?)
fibLength DWORD ?

currentFibNumber BYTE ?
maxFibNumber DWORD ?
previousPreviousNumber DWORD ?

.code
main PROC
   
;WELCOME SECTION

;Prints Program Information
    mov     edx, offset programTitle
    call    WriteString
    mov     edx, offset authorName
    call    WriteString
    call    crlf
    

;USER INFO SECTION

;Gets userName
    mov     edx, offset usernamePrompt
    call    WriteString
    mov     edx, offset userName
    mov     ecx, SIZEOF userName


    mov     eax, userInputColor
    call    SetTextColor
    call    ReadString
    
    mov     eax, defaultColor
    call    setTextColor

    
;Greets User
    mov     edx, offset helloGreeting
    call    WriteString
    mov     eax, userInputColor
    call    SetTextColor
    mov     edx, offset userName

    call    WriteString
    mov     eax, defaultColor
    call    SetTextColor
    call    crlf
    call    crlf

;prompts how many Fib numbers the user wants:
    mov     edx, offset fibonacciInfo
    call    WriteString
    jmp     startFib


;Jumps back here if the input is invalid to prompt the user again. 
invalidInput:
    mov     eax, errorColor                    ;sets color to red for error message
    call    setTextColor
    mov     edx, offset invalidInputPrompt
    call    WriteString
    jmp     startFib

outOfRange:
    mov     eax, errorColor
    call    setTextColor
    mov     edx, offset outOfRangePrompt
    call    WriteString
    


;Gets user input for the fib number and verifies it is greater or equal to 1, and less than or equal to upperLimit
startFib:
    mov     eax, defaultColor
    call    setTextColor
    call    crlf
    mov     edx, offset fibonacciPrompt
    call    WriteString
    mov     edx, offset stringFibInput
    mov     ecx, 63                         ;63 is the maximum amount of characters they can enter with room for null. Note, they will never be entering this many and the input being valid.
   
    mov     eax, userInputColor
    call    SetTextColor
    call    ReadString
    mov     ecx, eax                        ;Moves the character count into eax, and ecx for the next loop
    mov     fibLength, eax
    mov     eax, defaultColor
    call    SetTextColor
    mov     edx, offset stringFibInput


                                            ;Checks all the characters in a string to see if they are all valid ascii codes for numbers. If not, prompts for re-entry
isStringNumber: 
    mov     al,  BYTE PTR [edx]             ;Access at address edx, which we keep increasing to go through the string.
    call    IsDigit
    jnz     invalidInput
    inc     edx
    loop    isStringNumber
  



;Converts the string that we know is a valid number into a decimal, and tests if it is in the range 1-46 If not we restart asking for user input
    mov     edx, offset stringFibInput
    mov     ecx, fibLength
    call    ParseDecimal32
    mov     maxFibNumber, eax
    cmp     maxFibNumber, upperLimit
    jg      outOfRange
    cmp     maxFibNumber , 1
    jl      outOfRange
    call    crlf
    call    crlf




;FIBS ALGORITHM

;Calculate and Print Fibonacci number, using an iterative approach of keepiing track of the previous 2 numbers. 
calculateFib:
    mov     ecx, maxFibNumber

fibLoop:
    mov     eax, currentNumber
    call    WriteDec
    mov     edx, offset spacer
    call    writeString

;Tests if we've printed 4 numbers, if we have then a newline is printed, and the numbercount is reset
    inc     numberCount
    cmp     numberCount, 4
    jne     noNextLine
    call    crlf
    mov     numberCount, 0

noNextLine:                                 ;Jump to here if we haven't printed 4 numbers on a line yet.
;Calculates the next fibonacci number and stores it in currentNumber
    mov     eax, previousNumber
    mov     previousPreviousNumber, eax
    mov     eax, currentNumber
    mov     previousNumber, eax
    add     eax, previousPreviousNumber
    mov     currentNumber, eax

    loop    fibLoop





;FAREWELL
;Prints goodbye and other notices.
    call    crlf
    call    crlf
    mov     edx, offset certifiedNotice
    call    writeString

    mov     edx, offset goodbyePrompt
    call    writeString
    mov     eax, userInputColor
    call    SetTextColor
    mov     edx, offset userName
    call    writeString
    mov     eax, defaultColor
    call    SetTextColor
    mov     edx, offset period
    call    writeString


INVOKE ExitProcess, 0
main ENDP
END main