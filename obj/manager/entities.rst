ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;; INIT OF ENTITIES.S
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              2 .include "entities.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                             55 .globl man_entity_update
                             56 .globl cpct_memcpy_asm
                             57 .globl man_entity_increase_num
                             58 .globl man_entity_decrease_num
                             59 .globl mainchar_entity
                             60 .globl increase_free_entity
                             61 .globl man_entity_first_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              3 
   4101 04 41                 4 next_free_entity: .dw array_entities
   4103 00                    5 num_entities: .db 0 ;; Actual number of entities created
   4104                       6 array_entities: .ds sizeof_e * max_entities
                              7 
                              8 ;; Functions for entities
                              9 
                             10 ;; Initializes the array of entities
   4488                      11 man_entity_init::
   4488 C9            [10]   12 ret
                             13 
                             14 ;; Creates the entity
   4489                      15 man_entity_create::
                             16     ;; Is there free space?
   4489 3A 03 41      [13]   17     ld a, (num_entities)
   448C FE 64         [ 7]   18     cp #max_entities
   448E 28 10         [12]   19     jr z, skip_ce
                             20      
                             21     ;; Free space -> create entity
                             22     ;; ld hl, #mainchar_entity ;; From
   4490 ED 5B 01 41   [20]   23     ld de, (next_free_entity) ;; To
   4494 01 09 00      [10]   24     ld bc, #sizeof_e ;; Size
   4497 CD 60 45      [17]   25     call cpct_memcpy_asm    ;; Changes AF, BC, DE, HL
                             26 
   449A CD 10 45      [17]   27     call increase_free_entity
   449D CD 00 45      [17]   28     call man_entity_increase_num
                             29 
                             30     ;; No free space -> Skip
   44A0                      31     skip_ce:
   44A0 C9            [10]   32 ret
                             33 
   44A1                      34 man_entity_destroy::
   44A1 C9            [10]   35 ret 
                             36 
                             37 ;; Pointer to function
   44A2 00 00                38 function_for_all: .db #0x00, #0x00
   44A4 09                   39 count: .db #sizeof_e
                             40 ;; ----------------------------------------------------------- ;;
                             41 ;; INPUT -> HL: contains the function                          ;;
                             42 ;; General function to apply to all entities                   ;;
                             43 ;; ----------------------------------------------------------- ;;
   44A5                      44 man_entity_forall::
   44A5 22 A2 44      [16]   45     ld (function_for_all), hl
   44A8 CD 1B 45      [17]   46     call man_entity_first_entity ;; IX points to the first entity
                             47 
   44AB 3E 64         [ 7]   48     ld a, #max_entities
   44AD 32 A4 44      [13]   49     ld (count), a
                             50 
   44B0                      51     loop_forall:
   44B0 DD 2A 01 41   [20]   52         ld ix, (next_free_entity)
   44B4 21 BC 44      [10]   53         ld hl, #afterjp
   44B7 E5            [11]   54         push hl
                             55 
   44B8 2A A2 44      [16]   56         ld hl, (function_for_all)
   44BB E9            [ 4]   57         jp (hl)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                             58 
   44BC                      59         afterjp:
   44BC CD 10 45      [17]   60             call increase_free_entity
   44BF 3A A4 44      [13]   61             ld a, (count)
   44C2 3D            [ 4]   62             dec a
   44C3 32 A4 44      [13]   63             ld (count), a
   44C6 20 E8         [12]   64         jr nz, loop_forall
                             65 
   44C8                      66         final:
   44C8 CD 1B 45      [17]   67             call man_entity_first_entity
   44CB C9            [10]   68 ret
                             69 
                             70 ;; ---------------------------------------------
                             71 ;; Applies a function filtering specific criteria
                             72 ;; B -> Mask of bytes (e_cmps)
                             73 ;; ---------------------------------------------
   44CC                      74 man_entity_forall_matching::
   44CC 22 A2 44      [16]   75     ld (function_for_all), hl
   44CF CD 1B 45      [17]   76     call man_entity_first_entity ;; IX points to the first entity
                             77 
   44D2 3E 64         [ 7]   78     ld a, #max_entities
   44D4 32 A4 44      [13]   79     ld (count), a
                             80 
   44D7                      81     loop_forall_matching:
   44D7 C5            [11]   82     push bc
   44D8 DD 2A 01 41   [20]   83         ld ix, (next_free_entity)   ;; Look
   44DC DD 7E 00      [19]   84         ld a, e_cmps(ix)
   44DF A0            [ 4]   85         and b
   44E0 B8            [ 4]   86         cp b
   44E1 20 08         [12]   87         jr nz, afterjp_matching
                             88 
   44E3                      89         continue:
   44E3 21 EB 44      [10]   90             ld hl, #afterjp_matching
   44E6 E5            [11]   91             push hl
                             92 
   44E7 2A A2 44      [16]   93             ld hl, (function_for_all)
   44EA E9            [ 4]   94             jp (hl)
                             95 
   44EB                      96             afterjp_matching:
   44EB CD 10 45      [17]   97                 call increase_free_entity
   44EE 3A A4 44      [13]   98                 ld a, (count)
   44F1 3D            [ 4]   99                 dec a
   44F2 32 A4 44      [13]  100                 ld (count), a
   44F5 C1            [10]  101                 pop bc
   44F6 20 DF         [12]  102             jr nz, loop_forall_matching
                            103 
   44F8                     104             final_matching:
   44F8 CD 1B 45      [17]  105                 call man_entity_first_entity
   44FB C9            [10]  106 ret
                            107 
                            108 
                            109 ;; ----------------------------------------------------
                            110 ;;  Compares a pair of entities under a specific criteria
                            111 ;;  IY -> The other pair
                            112 ;;  B -> Mask to filter
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                            113 ;; -----------------------------------------------------
                            114 
   44FC                     115 man_entity_forall_pairs_matching::
   44FC C9            [10]  116 ret 
                            117 
                            118 ;; INPUT: A -> ID of the entity
                            119 ;; OUTPUT: IX -> The entity
   44FD                     120 man_entity_get_from_idx::
                            121 
                            122     ;; Acceder al elemento 4 de un array de 4 campos
                            123     ;; array[3] = inicio + (3*4)
                            124 
                            125 
   44FD C9            [10]  126 ret 
                            127 
   44FE                     128 man_entity_set4destruction::
   44FE C9            [10]  129 ret 
                            130 
                            131 ;; ---------------------------------------------------
                            132 ;; Updates all entities 
                            133 ;; HL -> Function for all entities
                            134 ;; ---------------------------------------------------
   44FF                     135 man_entity_update::
   44FF C9            [10]  136 ret
                            137 
                            138 ;; Increases the value of the counter num_entities
   4500                     139 man_entity_increase_num::
   4500 3A 03 41      [13]  140     ld a, (num_entities)
   4503 3C            [ 4]  141     inc a
   4504 32 03 41      [13]  142     ld (num_entities),a
   4507 C9            [10]  143 ret
                            144 
                            145 ;; Decreases the value of the counter num_entities
   4508                     146 man_entity_decrease_num::
   4508 3A 03 41      [13]  147     ld a, (num_entities)
   450B 3D            [ 4]  148     dec a
   450C 32 03 41      [13]  149     ld (num_entities),a
   450F C9            [10]  150 ret
                            151 
                            152 ;; Updates the direction of the next_free_entity pointer
   4510                     153 increase_free_entity::
   4510 2A 01 41      [16]  154     ld hl, (next_free_entity)
   4513 01 09 00      [10]  155     ld bc, #sizeof_e
   4516 09            [11]  156     add hl, bc
   4517 22 01 41      [16]  157     ld (next_free_entity), hl
   451A C9            [10]  158 ret
                            159 
                            160 ;; Changes the entity controller to ix register
   451B                     161 man_entity_first_entity::
   451B 21 04 41      [10]  162     ld hl, #array_entities
   451E 22 01 41      [16]  163     ld (next_free_entity), hl
                            164     ;; ld ix, (next_free_entity)
   4521 C9            [10]  165 ret
