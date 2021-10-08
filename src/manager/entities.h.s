;; This file contains all the indexes to adress to the entities

.module Entity_Manager

;;------------------------------------------------------
;; Entities
;; Definition of entity structure fields

e_cmps      == 0
e_x         == 1
e_y         == 2
e_vx        == 3
e_vy        == 4
e_color     == 5
e_type      == 6
e_prv_ptr   == 7      ;; Pointer, 2 bytes
e_width     == 9
e_height    == 10

;; Entity info
sizeof_e        == 11
max_entities    == 100


;; Bit for matching & properties

e_cmps_alive_bit    = 7
e_cmps_position_bit = 6
e_cmps_input_bit    = 5
e_cmps_physics_bit  = 4
e_cmps_render_bit   = 3

;; Component Types (masks)
e_cmps_invalid  = 0x00
e_cmps_alive    = (1 << e_cmps_alive_bit)
e_cmps_position = (1 << e_cmps_position_bit)
e_cmps_input    = (1 << e_cmps_input_bit)
e_cmps_physics  = (1 << e_cmps_physics_bit)
e_cmps_render   = (1 << e_cmps_render_bit)
e_cmps_default  = 0xFF

;; Entity types
e_type_mainchar     = 0
e_type_enemy        = 1
e_type_floor        = 2
e_type_bullet       = 3

;; Public functions
.globl man_entity_init
.globl man_entity_create
.globl man_entity_destroy
.globl man_entity_forall
.globl man_entity_forall_matching
.globl man_entity_forall_pairs_matching
.globl man_entity_get_from_idx
.globl man_entity_set4destruction
.globl man_entity_update
.globl cpct_memcpy_asm
.globl man_entity_increase_num
.globl man_entity_decrease_num
.globl mainchar_entity
.globl increase_free_entity
.globl man_entity_first_entity