;; INIT OF ENTITIES.S

;; ----------------- TODO -----------------------
;;  Delete entity
;;  Being able to destroy and create entities
;;
;;
;;
;;
;;
;; ---------------------------------------------
.include "entities.h.s"

next_free_entity: .dw array_entities
num_entities: .db 0 ;; Actual number of entities created
array_entities: .ds sizeof_e * max_entities

;; Functions for entities

;; Initializes the array of entities
man_entity_init::
ret

;; Creates the entity
man_entity_create::
    ;; Is there free space?
    ld a, (num_entities)
    cp #max_entities
    jr z, skip_ce
     
    ;; Free space -> create entity
    ;; ld hl, #mainchar_entity ;; From
    ld de, (next_free_entity) ;; To
    ld bc, #sizeof_e ;; Size
    call cpct_memcpy_asm    ;; Changes AF, BC, DE, HL

    call increase_free_entity
    call man_entity_increase_num

    ;; No free space -> Skip
    skip_ce:
ret

man_entity_destroy::
ret 

;; Pointer to function
function_for_all: .db #0x00, #0x00
count: .db #sizeof_e
;; ----------------------------------------------------------- ;;
;; INPUT -> HL: contains the function                          ;;
;; General function to apply to all entities                   ;;
;; ----------------------------------------------------------- ;;
man_entity_forall::
    ld (function_for_all), hl
    call man_entity_first_entity ;; IX points to the first entity

    ld a, #max_entities
    ld (count), a

    loop_forall:
        ld ix, (next_free_entity)
        ld hl, #afterjp
        push hl

        ld hl, (function_for_all)
        jp (hl)

        afterjp:
            call increase_free_entity
            ld a, (count)
            dec a
            ld (count), a
    jr nz, loop_forall

    final:
        call man_entity_first_entity
ret

;; ---------------------------------------------
;; Applies a function filtering specific criteria
;; B -> Mask of bytes (e_cmps)
;; ---------------------------------------------
man_entity_forall_matching::
    ld (function_for_all), hl
    call man_entity_first_entity ;; IX points to the first entity

    ld a, #max_entities
    ld (count), a

    loop_forall_matching:
    push bc
        ld ix, (next_free_entity)   ;; Look
        ld a, e_cmps(ix)
        and b
        cp b
        jr nz, afterjp_matching

        continue:
            ld hl, #afterjp_matching
            push hl

            ld hl, (function_for_all)
            jp (hl)

            afterjp_matching:
                call increase_free_entity
                ld a, (count)
                dec a
                ld (count), a
                pop bc
    jr nz, loop_forall_matching

    final_matching:
        call man_entity_first_entity
ret


;; ----------------------------------------------------
;;  Compares a pair of entities under a specific criteria
;;  IY -> The other pair
;;  B -> Mask to filter
;; -----------------------------------------------------

man_entity_forall_pairs_matching::
ret 

;; INPUT: A -> ID of the entity
;; OUTPUT: IX -> The entity
man_entity_get_from_idx::

    ;; Acceder al elemento 4 de un array de 4 campos
    ;; array[3] = inicio + (3*4)


ret 

man_entity_set4destruction::
ret 

;; ---------------------------------------------------
;; Updates all entities 
;; HL -> Function for all entities
;; ---------------------------------------------------
man_entity_update::
ret

;; Increases the value of the counter num_entities
man_entity_increase_num::
    ld a, (num_entities)
    inc a
    ld (num_entities),a
ret

;; Decreases the value of the counter num_entities
man_entity_decrease_num::
    ld a, (num_entities)
    dec a
    ld (num_entities),a
ret

;; Updates the direction of the next_free_entity pointer
increase_free_entity::
    ld hl, (next_free_entity)
    ld bc, #sizeof_e
    add hl, bc
    ld (next_free_entity), hl
ret

;; Changes the entity controller to ix register
man_entity_first_entity::
    ld hl, #array_entities
    ld (next_free_entity), hl
    ;; ld ix, (next_free_entity)
ret