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
                             17 
                             18 ;; Entity info
                     0009    19 sizeof_e        == 9
                     0064    20 max_entities    == 100
                             21 
                             22 
                             23 ;; Bit for matching & properties
                             24 
                     0007    25 e_cmps_alive_bit    = 7
                     0006    26 e_cmps_position_bit = 6
                     0005    27 e_cmps_input_bit    = 5
                     0004    28 e_cmps_physics_bit  = 4
                     0003    29 e_cmps_render_bit   = 3
                             30 
                             31 ;; Component Types (masks)
                     0000    32 e_cmps_invalid  = 0x00
                     0080    33 e_cmps_alive    = (1 << e_cmps_alive_bit)
                     0040    34 e_cmps_position = (1 << e_cmps_position_bit)
                     0020    35 e_cmps_input    = (1 << e_cmps_input_bit)
                     0010    36 e_cmps_physics  = (1 << e_cmps_physics_bit)
                     0008    37 e_cmps_render   = (1 << e_cmps_render_bit)
                     00FF    38 e_cmps_default  = 0xFF
                             39 
                             40 ;; Entity types
                     0000    41 e_type_mainchar     = 0
                     0001    42 e_type_enemy        = 1
                     0002    43 e_type_floor        = 2
                     0003    44 e_type_bullet       = 3
                             45 
                             46 ;; Public functions
                             47 .globl man_entity_init
                             48 .globl man_entity_create
                             49 .globl man_entity_destroy
                             50 .globl man_entity_forall
                             51 .globl man_entity_forall_matching
                             52 .globl man_entity_forall_pairs_matching
                             53 .globl man_entity_get_from_idx
                             54 .globl man_entity_set4destruction
                             55 .globl man_entity_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 .globl cpct_memcpy_asm
                             57 .globl man_entity_increase_num
                             58 .globl man_entity_decrease_num
                             59 .globl mainchar_entity
                             60 .globl increase_free_entity
                             61 .globl man_entity_first_entity
