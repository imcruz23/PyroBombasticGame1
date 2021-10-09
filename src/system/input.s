
;; INIT OF INPUT.S

.globl cpct_isKeyPressed_asm
.globl man_entity_get_from_idx

move_left:
    ld e_vx(ix), #-1
ret 

move_right:
    ld e_vx(ix), #1
ret

move_up:
    ld e_vy(ix), #-1
ret

move_down:
    ld e_vy(ix), #1
ret 

shoot:
    ;; TODO
ret

key_actions:
    .dw     Key_O,      move_left
    .dw     Key_P,      move_right
    .dw     Key_Q,      move_up
    .dw     Key_A,      move_down
    .dw     Key_Space,  shoot
    .dw 0

sys_input_check_keyboard_and_update_player:
    ;; Reset velocity
    ld e_vx(ix), #0
    ld e_vy(ix), #0

    ;; Check keyboard for input
    call cpct_scanKeyboard_f_asm

    ;; Key-Action Check-call Looop
    ld iy, #key_actions-4

    loop_keys:
        ld l, 0(iy) ;; HL = Next Key
        ld h, 1(iy) ;;

        ;; Check if key is null
        ld a, l ;; A = H | L
        or h
        ret z   ;; A = 0, Key = null, ret
        
        ld hl, #loop_keys ;; ret
        push hl
        call cpct_isKeyPressed_asm
        ld l, 2(iy)
        ld h, 3(iy)
        jp(hl)
    ;; ret is implicit

    
sys_input_update::
    xor a   ;; A = 0
    call man_entity_get_from_idx
    call sys_input_check_keyboard_and_update_player
ret