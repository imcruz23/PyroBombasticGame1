;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.globl man_entity_forall
.globl man_entity_create
.globl cpct_isKeyPressed_asm
.globl cpct_scanKeyboard_asm

;; ----------------------------------------
;; Puts actions in certain keys
;; ----------------------------------------
keyactions::
    .dw Key_O, key_left_action
    .dw Key_P, key_right_action
    .dw Key_Q, key_up_action
    .dw Key_A, key_down_action
    .dw Key_Space, key_space_action
    .dw 0x0000

;; ------------------------------------
;;  Horizontal movement
;; ------------------------------------
key_left_action::
    ld e_vx(ix), #-1
ret

key_right_action::
    ld e_vx(ix), #1
ret

;; ------------------------------------
;;  Vertical movement
;; ------------------------------------
key_up_action::
    ld e_vy(ix), #-2
ret

key_down_action::
    ld e_vy(ix), #2
ret

;; ------------------------------------
;;  Extra action: shoot
;; ------------------------------------
key_space_action::
    ;; TODO
ret

;;cmps2 == e_cmps_position | e_cmps_alive | e_cmps_render | e_cmps_physics
 ;;bullet_entity:: .db cmps2, #0x1A, #0x1A, 2, 0, #0xFF , e_type_bullet
;; Structure of templates:
;;          cmps(entities.h.s) -- x -- y -- e_type (entities.h.s)


sys_physics_keyboard::
    ld e_vx(ix), #0
    ld e_vy(ix), #0
    ld iy, #keyactions-4
    
    ;; Checks if any key is pressed
    nextkey:
        ld bc, #4
        add iy, bc
        
        ;; Check next key code
        ld l, (iy)
        ld h, 1(iy)
        
        ;; Check for null to end
        ld a, l
        or h
        ret z

        ;; Test Key and perform
        call cpct_isKeyPressed_asm
    jr z, nextkey

    ;; Key is pressed, perform key_left_action
    ld hl, #nextkey
    push hl
    ld l, 2(iy)
    ld h, 3(iy)
    jp (hl)

;; --------------------------------------
;;  Update all entities' physics
;;  B -> mask for filter
;; --------------------------------------

sys_physics_update::
    ld hl, #phy_update_forone
    ld b, #e_cmps_input ;; Condition: entity must have input
    call man_entity_forall_matching
ret


sys_update_bullets::
    ld a, e_vx(ix);;vx
    ld b, e_x(ix);;x
    add a, b
    ld e_x(ix), a 

    ld a, e_vy(ix);;vy
    ld b, e_y(ix);;y
    add a, b
    ld e_y(ix), a
ret

phy_update_forone::
        call cpct_scanKeyboard_asm
        call sys_physics_keyboard
        ;ld a, 1(ix)  ;; speed 
        ;add 3(ix)
        ;ld 1(ix), a
        ld a, e_vx(ix);;vx
        ld b, e_x(ix);;x
        add a, b
        ld e_x(ix), a 

        ld a, e_vy(ix);;vy
        ld b, e_y(ix);;y
        add a, b
        ld e_y(ix), a

ret

