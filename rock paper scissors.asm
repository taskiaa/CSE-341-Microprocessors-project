
.MODEL SMALL

.STACK 100H

.DATA  

    CR              db 13,10,'$' 
    
    conti db "Do you want to continue (y/n)?: $"             

    select_mode db "Press 1 for Player vs Computer, Press 2 for Player vs Player; You Picked: $"

    choice db ?    ; Variable to store user's choice

    nwl db 0Dh, 0Ah, "$"         ; Carriage return + line feed for newline

    entry1 db "Please give your name: $"

    errormsg db "Wrong input $"

    drawmsg db "It's a draw $"

    r_p_s_Choice db "Choose 1 for Rock, 2 for Paper, 3 for Scissors: $"

    playername db 21, ?, "$" ; Buffer to store player's name (maximum 20 characters + null terminator)

    randomnum db 0           ; Variable to store the generated random number

    round db 0

    player1score db 5

    comscore db 5

    player2score db ?

    winmsg db "You won. $"

    losemsg db "You lost. $"

    yscore db "Your Score: $"

    cscore db "Computer Score: $"


    PL1             db 'Player 1: $', 0

    PL2             db 'Player 2: $', 0

    Player1_Name    db 20 dup(?)    ; Buffer for Player 1's name

    Player2_Name    db 20 dup(?)    ; Buffer for Player 2's name

    Player1_Score   db 0            ; Score tracker for Player 1

    Player2_Score   db 0            ; Score tracker for Player 2

    RoundCount      db 06h            ; Counter for rounds  

    Round_limit     db 5            ; Set the round limit to 5

    Player1_Score_Msg db 'Player 1 Score: $'

    Player2_Score_Msg db 'Player 2 Score: $'

    P1Winner_Msg    db 'PLayer1 is the winner! $'

    P2Winner_Msg    db 'PLayer2 is the winner! $'


.CODE

    MAIN PROC

    MOV AX, @DATA

    MOV DS, AX

Gamestart: 

     mov round,05h 
     
     mov RoundCount,06h


    lea dx, select_mode

    mov ah, 9

    int 21h


    ; Read user's choice

    mov ah, 1       ; Function to read a character from the keyboard

    int 21h         ; Read the character

    mov choice, al  ; Store the choice


    ; Process the user's choice

    cmp choice, '1'

    je playerVsComputer

    cmp choice, '2'    

    je playerVsPlayer

    jg showerror

       

    showerror:

        lea dx, errormsg  ; Display the menu again

        mov ah, 9

        int 21h

        jmp exitProgram  ; Jump to exit the program


    playerVsComputer:

           

        mov ah,2

        mov dl,10

        int 21h

        mov dl,13

        int 21h

       

        lea dx, entry1  ; Display message for player vs computer

        mov ah, 9

        int 21h

       

        ; Prompt for player's name

        LEA DX, playername

        MOV AH, 0AH ; Buffered input

        INT 21H

       

        mov ah,2

        mov dl,10

        int 21h

        mov dl,13

        int 21h

        LEA DX, r_p_s_Choice

        MOV AH, 9 ; Buffered input

        INT 21H

       

        mov ah,2

        mov dl,10

        int 21h

        mov dl,13

        int 21h

    looping:

                   

             

        sub round,1h

                        

                   

        ; Read player's choice (Rock/Paper/Scissors)

        mov ah, 1       ; Function to read a character from the keyboard

        int 21h         ; Read the character

        mov r_p_s_Choice, al  ; Store the choice

       

        CALL generaterandomnumber

        ADD randomnum, 49  ; Adjust to get a range from 1 to 3 (Rock/Paper/Scissors)

        MOV AH, 2 ; Function to display character

        MOV DL, r_p_s_Choice ; Display the user's choice

         

        INT 21h ; Display the character


        MOV DL, ',' ; Display comma

        INT 21h ; Display the character


        MOV DL, randomnum ; Display the computer's choice

       

        INT 21h ; Display the character

                   

        ; Compare user's choice with computer's choice

        mov ch, randomnum

        mov cl, r_p_s_Choice

        cmp cl, ch

        je draw  ; If both choices are the same, it's a tie


        ; Game logic based on choices

        cmp r_p_s_Choice, '1'

        je checkrandom23

        cmp r_p_s_Choice, '2'

        je checkrandom13

        cmp r_p_s_Choice, '3'

        je checkrandom12

        jmp exitProgram  ; Invalid choice

       

    checkrandom23:

        cmp randomnum, '2'

        je computerwin

        cmp randomnum, '3'

        je playerwin

        jmp draw  ; If none of the above conditions met, it's a tie


    checkrandom13:

        cmp randomnum, '1'

        je playerwin

        cmp randomnum, '3'

        je computerwin

        jmp draw  ; If none of the above conditions met, it's a tie


    checkrandom12:

        cmp randomnum, '1'

        je computerwin

        cmp randomnum, '2'

        je playerwin

        jmp draw  ; If none of the above conditions met, it's a tie


    draw:

        mov ch,0

        mov cl,0

        lea dx, drawmsg

        mov ah, 9

        int 21h

        mov ah,2

        mov dl,10

        int 21h

        mov dl,13

        int 21h

        jmp looping


    playerwin:


        add player1score,1

        sub comscore,1

        lea dx, winmsg

        mov ah, 9

        int 21h


        lea dx, yscore

        mov ah, 9

        int 21h

             

        mov ah,2

        mov ch, player1score

        add ch,48

        mov dl, ch

        int 21h  

           

        MOV DL, ',' ; Display comma

        INT 21h ; Display the character

                   

        lea dx, cscore

        mov ah, 9

        int 21h

             

        mov ah,2

        mov ch, comscore

        add ch,48

        mov dl, ch

        int 21h                    

           

        mov ah,2

        mov dl,10

        int 21h

        mov dl,13

        int 21h

           

        cmp round,0

        jl declarewinner

        jmp checkscore


    computerwin:

        add comscore,1

        sub player1score,1

        lea dx, losemsg

        mov ah, 9

        int 21h

           

        lea dx, yscore

        mov ah, 9

        int 21h

             

        mov ah,2

        mov ch, player1score

        add ch,48

        mov dl, ch

        int 21h        


        MOV DL, ',' ; Display comma

        INT 21h ; Display the character

           

        lea dx, cscore

        mov ah, 9

        int 21h

        mov ah,2

        mov ch, comscore

        add ch,48

        mov dl, ch

        int 21h

                                   

        mov ah,2

        mov dl,10

        int 21h

        mov dl,13

        int 21h

           

        cmp round,0

        je declarewinner            

        jmp checkscore    


    checkscore:      

        cmp player1score,10

        je declarewinner

        jmp looping

        cmp comscore, 10

        je declarewinner

        jmp looping

           

    declarewinner:

        mov ch, player1score

        mov cl, comscore

        cmp ch,cl

        jg youwin

        jl youlose

        je decdraw

         

    youwin:

        lea dx, winmsg

        mov ah, 9

        int 21h 
        
        
 lea dx, conti

           mov ah, 9

            int 21h  
            
            mov ah,1
            int 21h 
            
            cmp al,79h
            
            je Gamestart

        jmp exitProgram

    youlose:

        lea dx, losemsg

        mov ah, 9

        int 21h 
        
        
 lea dx, conti

           mov ah, 9

            int 21h  
            
            mov ah,1
            int 21h 
            
            cmp al,79h
            
            je Gamestart

        jmp exitProgram        

           

    decdraw:  

        lea dx, drawmsg

        mov ah, 9

        int 21h
        
        
 lea dx, conti

           mov ah, 9

            int 21h  
            
            mov ah,1
            int 21h 
            
            cmp al,79h
            
            je Gamestart

        jmp exitProgram

         

    exitProgram:

        ; Clean up and exit the program

        mov ah, 4Ch     ; DOS function to terminate the program

        int 21h  

           

    generaterandomnumber PROC

        MOV AH, 0       ; Function to get system time

        INT 1Ah         ; Call BIOS interrupt to get time in CX:DX


        MOV AX, DX      ; Move DX (random value) to AX

        XOR DX, DX      ; Clear DX

        MOV BX, 3       ; Set divisor to get a number between 0 to 2

        DIV BX          ; Divide AX by BX


        MOV randomnum, DL ; Store the random number in randomnum

        RET             ; Return from the procedure


    generaterandomnumber ENDP        

   

    playerVsPlayer:

        lea dx, nwl

        mov ah, 9

        int 21h


        MOV DX, OFFSET r_p_s_Choice      ; Game Instruction

        MOV AH, 09h

        INT 21h

   

        MOV DX, OFFSET CR       ; print Carrier Return

        MOV AH, 09h

        INT 21h  

        MOV AX, OFFSET Round_limit        ; Load round limit into AX

        MOV AH, 09h

        INT 21h

        MOV AX, OFFSET RoundCount         ; Load rounds played counter into AX

        MOV AH, 09h

        INT 21h

       

    GAME_LOOP:

        MOV DX, OFFSET PL1      ; Prompt of player1

        MOV AH, 09h

        INT 21h

       

        MOV AH,08               ; Function to read a char from keyboard (Input by Player1)

        INT 21h                 ; the char saved in AL

        MOV AH,02               ; Function to display a char  

        MOV BL,AL               ; Copy a saved char in AL to BL

        MOV DL,AL               ; Copy AL to DL to output it

        INT 21h

       

        MOV DX, OFFSET CR       ; print Carrier Return

        MOV AH, 09h

        INT 21h

       

        MOV DX, OFFSET PL2      ; Prompt of player2

        MOV AH, 09h

        INT 21h

       

        MOV AH,08               ; Function to read a char from keyboard (Input by Player2)

        INT 21h                 ; the char saved in AL

        MOV AH,02               ; Function to display a char  

        MOV BH,AL               ; Copy a saved char in AL to BH

        MOV DL,AL               ; Copy AL to DL to output it

        INT 21h


        MOV DX, OFFSET CR       ; print Carrier Return

        MOV AH, 09h

        INT 21h

       

        CMP BL, BH

        JE  DrawRound

        CMP BL, '1'

        JE  EQ1  

        CMP BL, '2'

        JE  EQ2

        CMP BL, '3'

        JE  EQ3

       

    EQ1:

        CMP BH, '2'

        JE  P2_Win  

        CMP BH, '3'

        JE  P1_Win  


    EQ2:  

        CMP BH, '1'

        JE  P1_Win  

        CMP BH, '3'

        JE  P2_Win

 

    EQ3:  

        CMP BH, '1'

        JE  P2_Win  

        CMP BH, '2'

        JE  P1_Win

   

    DrawRound:

        sub roundcount,1h

        JMP CheckEndGame

    P1_Win:

        INC Player1_Score

        sub roundcount,1h  

        JMP CheckEndGame

    P2_Win:

        INC Player2_Score

        sub roundcount,1h

        JMP CheckEndGame

 

    ; Game logic (Rock-Paper-Scissors)

    ; Update scores for Player 1 and Player 2 accordingly

    ; Display round result and scores

    ; Check if 5 rounds are done; if yes, break the loop

    CheckEndGame:    

        CMP RoundCount, 0

        JE COMPARE_SCORES

       

        ; Loop back for the next round

        JMP GAME_LOOP


    COMPARE_SCORES:  

    ; Display scores for both players

    ; Compare scores to declare a winner or a draw

    ; Display the result

    ; Display Player 1's score

        MOV DX, OFFSET Player1_Score_Msg

        MOV AH, 09h

        INT 21h


        MOV AL, Player1_Score

        ADD AL, 30h  ; Convert score to ASCII

        MOV DL, AL

        MOV AH, 02h

        INT 21h


        ; Display Player 2's score    

        MOV DX, OFFSET CR       ; print Carrier Return

        MOV AH, 09h

        INT 21h


        MOV DX, OFFSET Player2_Score_Msg

        MOV AH, 09h

        INT 21h

   

        MOV AL, Player2_Score

        ADD AL, 30h  ; Convert score to ASCII

        MOV DL, AL

        MOV AH, 02h

        INT 21h

   

        MOV DX, OFFSET CR       ; print Carrier Return

        MOV AH, 09h

        INT 21h


        ; Compare scores to declare a winner or a draw

        MOV CH, PLayer1_Score

        MOV CL, PLayer2_Score

        CMP CH, CL

        JE GAME_DRAW

        JL PLAYER2_WINS

        JG PLAYER1_WINS


PLAYER1_WINS:

    MOV DX, OFFSET P1Winner_Msg

    MOV AH, 09h

    INT 21h
    
     lea dx, conti

           mov ah, 9

            int 21h  
            
            mov ah,1
            int 21h 
            
            cmp al,79h
            
            je Gamestart
    

    JMP Exit


PLAYER2_WINS:

    MOV DX, OFFSET P2Winner_Msg

    MOV AH, 09h

    INT 21H
    
     lea dx, conti

           mov ah, 9

            int 21h  
            
            mov ah,1
            int 21h 
            
            cmp al,79h
            
            je Gamestart  
            
            
    

    JMP Exit


GAME_DRAW:

    MOV DX, OFFSET drawmsg
    
     MOV AH, 09h

    INT 21h
    
    lea dx, conti

           mov ah, 9

            int 21h  
            
            mov ah,1
            int 21h 
            
            cmp al,79h
            
            je Gamestart 
            
         


Exit:

; Exit program

MOV AH, 4Ch      ; Function to exit

MOV AL, 00       ; Return 00

INT 21h

END MAIN                  



