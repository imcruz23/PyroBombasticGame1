ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;; This file contains all the indexes to adress to the entities
                              2 
                              3 .module Entity_Manager
                              4 
                              5 ;;------------------------------------------------------
                              6 ;; Entities
                              7 ;; Definition of entity structure fields
                              8 
                     0000     9 e_cmps      == 0
                     0001    10 e_x         == 1
                     0002    11 e_y         == 2
                     0003    12 e_vx        == 3
                     0004    13 e_vy        == 4
                     0005    14 e_color     == 5
                     0006    15 e_type      == 6
                     0007    16 e_prv_ptr   == 7      ;; Pointer, 2 bytes
                     0009    17 e_width     == 9
                     000A    18 e_height    == 10
                             19 
                             20 ;; Entity info
                     000B    21 sizeof_e        == 11
                     0064    22 max_entities    == 100
                             23 
                             24 
                             25 ;; Bit for matching & properties
                             26 
                     0007    27 e_cmps_alive_bit    = 7
                     0006    28 e_cmps_position_bit = 6
                     0005    29 e_cmps_input_bit    = 5
                     0004    30 e_cmps_physics_bit  = 4
                     0003    31 e_cmps_render_bit   = 3
                             32 
                             33 ;; Component Types (masks)
                     0000    34 e_cmps_invalid  = 0x00
                     0080    35 e_cmps_alive    = (1 << e_cmps_alive_bit)
                     0040    36 e_cmps_position = (1 << e_cmps_position_bit)
                     0020    37 e_cmps_input    = (1 << e_cmps_input_bit)
                     0010    38 e_cmps_physics  = (1 << e_cmps_physics_bit)
                     0008    39 e_cmps_render   = (1 << e_cmps_render_bit)
                     00FF    40 e_cmps_default  = 0xFF
                             41 
                             42 ;; Entity types
                     0000    43 e_type_mainchar     = 0
                     0001    44 e_type_enemy        = 1
                     0002    45 e_type_floor        = 2
                     0003    46 e_type_bullet       = 3
                             47 
                             48 ;; Public functions
                             49 .globl man_entity_init
                             50 .globl man_entity_create
                             51 .globl man_entity_destroy
                             52 .globl man_entity_forall
                             53 .globl man_entity_forall_matching
                             54 .globl man_entity_forall_pairs_matching
                             55 .globl man_entity_get_from_idx
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 .globl man_entity_set4destruction
                             57 .globl man_entity_update
                             58 .globl cpct_memcpy_asm
                             59 .globl man_entity_increase_num
                             60 .globl man_entity_decrease_num
                             61 .globl mainchar_entity
                             62 .globl increase_free_entity
                             63 .globl man_entity_first_entity
