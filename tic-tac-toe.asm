;This project was made by:
    ;1. Yonas Sintayehu - UGR/25397/14 
    ;2. Fahmi Dinsefa - UGR/25301/14
    ;3. Naol Fikadu - UGR/25588/14
    ;4. Kerob Gebru - UGR/25714/14
    ;5. Dureti Gnafero - UGR/25531/14


org 100h

start:
    mov dh, 10
    mov dl, 25
    mov bh, 0
    mov ah, 2
    int 10h

    mov ah, 09h
    lea dx, welcome_msg
    int 21h

    mov dh, 11
    mov dl, 25
    mov bh, 0
    mov ah, 2
    int 10h

    mov ah, 09h
    lea dx, press_any_key_msg
    int 21h

    mov ah, 0
    int 16h

    call clear_screen
    mov byte ptr [turn], 1
    mov byte ptr [move_count], 0

game_loop:
    call clear_screen
    mov ah, 09h
    lea dx, grid
    int 21h

    cmp byte ptr [move_count], 9
    je draw_game_over

    cmp byte ptr [turn], 1
    je player1_prompt

player2_prompt:
    lea dx, p2_move_text
    jmp prompt_move

player1_prompt:
    lea dx, p1_move_text

prompt_move:
    mov ah, 09h
    int 21h

    call get_and_validate_input

    call update_cell

    inc byte ptr [move_count]

    call toggle_turn

    jmp game_loop

draw_game_over:
    mov ah, 09h
    lea dx, draw_msg
    int 21h
    mov ah, 4Ch
    int 21h

clear_screen:
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    ret

get_and_validate_input:
    mov ah, 01h
    int 21h
    mov bl, al
    sub bl, '0'

    cmp bl, 1
    jl invalid_input
    cmp bl, 9
    jg invalid_input

    call check_cell
    ret

invalid_input:
    mov ah, 09h
    lea dx, invalid_msg
    int 21h
    jmp get_and_validate_input

check_cell:
    cmp bl, 1
    je check_one
    cmp bl, 2
    je check_two
    cmp bl, 3
    je check_three
    cmp bl, 4
    je check_four
    cmp bl, 5
    je check_five
    cmp bl, 6
    je check_six
    cmp bl, 7
    je check_seven
    cmp bl, 8
    je check_eight
    cmp bl, 9
    je check_nine
    ret

check_win_one:
    mov dl, byte ptr [turn]
    cmp byte ptr [two], dl
    jne check_vertical_one
    cmp byte ptr [three], dl
    je player_won

check_vertical_one:
    cmp byte ptr [four], dl
    jne check_diagonal_one
    cmp byte ptr [seven], dl
    je player_won

check_diagonal_one:
    cmp byte ptr [five], dl
    jne no_win
    cmp byte ptr [nine], dl
    je player_won
    ret

check_win_two:
    mov dl, byte ptr [turn]
    cmp byte ptr [one], dl
    jne check_vertical_two
    cmp byte ptr [three], dl
    je player_won

check_vertical_two:
    cmp byte ptr [five], dl
    jne no_win
    cmp byte ptr [eight], dl
    je player_won
    ret

check_win_three:
    mov dl, byte ptr [turn]
    cmp byte ptr [one], dl
    jne check_vertical_three
    cmp byte ptr [two], dl
    je player_won

check_vertical_three:
    cmp byte ptr [six], dl
    jne check_diagonal_three
    cmp byte ptr [nine], dl
    je player_won

check_diagonal_three:
    cmp byte ptr [five], dl
    jne no_win
    cmp byte ptr [seven], dl
    je player_won
    ret

check_win_four:
    mov dl, byte ptr [turn]
    cmp byte ptr [five], dl
    jne check_vertical_four
    cmp byte ptr [six], dl
    je player_won

check_vertical_four:
    cmp byte ptr [one], dl
    jne no_win
    cmp byte ptr [seven], dl
    je player_won
    ret

check_win_five:
    mov dl, byte ptr [turn]
    cmp byte ptr [two], dl
    jne check_vertical_five
    cmp byte ptr [eight], dl
    je check_diagonal_five

check_vertical_five:
    cmp byte ptr [four], dl
    jne check_diagonal_five
    cmp byte ptr [six], dl
    je player_won

check_diagonal_five:
    cmp byte ptr [one], dl
    jne check_reverse_diagonal_five
    cmp byte ptr [nine], dl
    je player_won

check_reverse_diagonal_five:
    cmp byte ptr [three], dl
    jne no_win
    cmp byte ptr [seven], dl
    je player_won
    ret

check_win_six:
    mov dl, byte ptr [turn]
    cmp byte ptr [four], dl
    jne check_vertical_six
    cmp byte ptr [five], dl
    je player_won

check_vertical_six:
    cmp byte ptr [three], dl
    jne no_win
    cmp byte ptr [nine], dl
    je player_won
    ret

check_win_seven:
    mov dl, byte ptr [turn]
    cmp byte ptr [eight], dl
    jne check_vertical_seven
    cmp byte ptr [nine], dl
    je player_won

check_vertical_seven:
    cmp byte ptr [one], dl
    jne check_diagonal_seven
    cmp byte ptr [four], dl
    je player_won

check_diagonal_seven:
    cmp byte ptr [five], dl
    jne no_win
    cmp byte ptr [three], dl
    je player_won
    ret

check_win_eight:
    mov dl, byte ptr [turn]
    cmp byte ptr [seven], dl
    jne check_vertical_eight
    cmp byte ptr [nine], dl
    je player_won

check_vertical_eight:
    cmp byte ptr [two], dl
    jne no_win
    cmp byte ptr [five], dl
    je player_won
    ret

check_win_nine:
    mov dl, byte ptr [turn]
    cmp byte ptr [seven], dl
    jne check_vertical_nine
    cmp byte ptr [eight], dl
    je check_diagonal_nine

check_vertical_nine:
    cmp byte ptr [three], dl
    jne check_diagonal_nine
    cmp byte ptr [six], dl
    je player_won

check_diagonal_nine:
    cmp byte ptr [five], dl
    jne no_win
    cmp byte ptr [one], dl
    je player_won
    ret

no_win:
    ret

player_won:
    call update_cell
    call clear_screen
    mov ah, 09h
    lea dx, grid
    int 21h
    cmp byte ptr [turn], 1
    je player1_won

    mov ah, 09h
    lea dx, player2_won_text
    int 21h
    jmp exit

player1_won:
    mov ah, 09h
    lea dx, player1_won_text
    int 21h
    jmp exit

check_one:
    cmp byte ptr [one], 0
    jne cell_occupied
    call check_win_one
    ret

check_two:
    cmp byte ptr [two], 0
    jne cell_occupied
    call check_win_two
    ret

check_three:
    cmp byte ptr [three], 0
    jne cell_occupied
    call check_win_three
    ret

check_four:
    cmp byte ptr [four], 0
    jne cell_occupied
    call check_win_four
    ret

check_five:
    cmp byte ptr [five], 0
    jne cell_occupied
    call check_win_five
    ret

check_six:
    cmp byte ptr [six], 0
    jne cell_occupied
    call check_win_six
    ret

check_seven:
    cmp byte ptr [seven], 0
    jne cell_occupied
    call check_win_seven
    ret

check_eight:
    cmp byte ptr [eight], 0
    jne cell_occupied
    call check_win_eight
    ret

check_nine:
    cmp byte ptr [nine], 0
    jne cell_occupied
    call check_win_nine
    ret

cell_occupied:
    mov ah, 09h
    lea dx, occupied_msg
    int 21h
    jmp get_and_validate_input

update_cell:
    cmp bl, 1
    je update_one
    cmp bl, 2
    je update_two
    cmp bl, 3
    je update_three
    cmp bl, 4
    je update_four
    cmp bl, 5
    je update_five
    cmp bl, 6
    je update_six
    cmp bl, 7
    je update_seven
    cmp bl, 8
    je update_eight
    cmp bl, 9
    je update_nine
    ret

update_one:
    mov al, [turn]
    mov byte ptr [one], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_one
    mov al, "O"
    jmp update_grid_one

update_two:
    mov al, [turn]
    mov byte ptr [two], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_two
    mov al, "O"
    jmp update_grid_two

update_three:
    mov al, [turn]
    mov byte ptr [three], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_three
    mov al, "O"
    jmp update_grid_three

update_four:
    mov al, [turn]
    mov byte ptr [four], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_four
    mov al, "O"
    jmp update_grid_four

update_five:
    mov al, [turn]
    mov byte ptr [five], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_five
    mov al, "O"
    jmp update_grid_five

update_six:
    mov al, [turn]
    mov byte ptr [six], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_six
    mov al, "O"
    jmp update_grid_six

update_seven:
    mov al, [turn]
    mov byte ptr [seven], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_seven
    mov al, "O"
    jmp update_grid_seven

update_eight:
    mov al, [turn]
    mov byte ptr [eight], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_eight
    mov al, "O"
    jmp update_grid_eight

update_nine:
    mov al, [turn]
    mov byte ptr [nine], al
    mov al, "X"
    cmp [turn], 1
    je update_grid_nine
    mov al, "O"
    jmp update_grid_nine

update_grid_one:
    mov byte ptr grid+1, al
    ret

update_grid_two:
    mov byte ptr grid+5, al
    ret

update_grid_three:
    mov byte ptr grid+9, al
    ret

update_grid_four:
    mov byte ptr grid+27, al
    ret

update_grid_five:
    mov byte ptr grid+31, al
    ret

update_grid_six:
    mov byte ptr grid+35, al
    ret

update_grid_seven:
    mov byte ptr grid+53, al
    ret

update_grid_eight:
    mov byte ptr grid+57, al
    ret

update_grid_nine:
    mov byte ptr grid+61, al
    ret

place_x:
    mov al, 'X'
    ret

toggle_turn:
    cmp byte ptr [turn], 1
    je switch_to_2
    mov byte ptr [turn], 1
    ret

switch_to_2:
    mov byte ptr [turn], 2
    ret

exit:
    mov ah, 4Ch
    mov al, 0
    int 21h

player1_won_text db 'The game is ended with player1 as a winner', 13, 10, "$"
player2_won_text db 'The game is ended with player2 as a winner', 13, 10, "$"
welcome_msg      db 'Welcome to Tic-Tac-Toe!', 13, 10, '$'
press_any_key_msg db 'Press any key to continue!', 13, 10, "$"
grid db ' 1 | 2 | 3 ', 13, 10, '-----------', 13, 10, ' 4 | 5 | 6 ', 13, 10, '-----------', 13, 10, ' 7 | 8 | 9 ', 13, 10, '$'
p1_move_text db 'Player 1 (X), make your move: $'
p2_move_text db 'Player 2 (O), make your move: $'
invalid_msg db 'Invalid input! Choose a number between 1 and 9.', 13, 10, '$'
occupied_msg db 'Cell already occupied. Try again.', 13, 10, '$'
draw_msg db 'Game over! It is a draw.', 13, 10, '$'
turn db 1
move_count db 0
one db 0
two db 0
three db 0
four db 0
five db 0
six db 0
seven db 0
eight db 0
nine db 0
