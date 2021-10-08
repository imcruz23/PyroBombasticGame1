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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                             55 .globl man_entity_get_from_idx
                             56 .globl man_entity_set4destruction
                             57 .globl man_entity_update
                             58 .globl cpct_memcpy_asm
                             59 .globl man_entity_increase_num
                             60 .globl man_entity_decrease_num
                             61 .globl mainchar_entity
                             62 .globl increase_free_entity
                             63 .globl man_entity_first_entity
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
   4550                      11 man_entity_init::
   4550 C9            [10]   12 ret
                             13 
                             14 ;; Creates the entity
   4551                      15 man_entity_create::
                             16     ;; Is there free space?
   4551 3A 03 41      [13]   17     ld a, (num_entities)
   4554 FE 64         [ 7]   18     cp #max_entities
   4556 28 10         [12]   19     jr z, skip_ce
                             20      
                             21     ;; Free space -> create entity
                             22     ;; ld hl, #mainchar_entity ;; From
   4558 ED 5B 01 41   [20]   23     ld de, (next_free_entity) ;; To
   455C 01 0B 00      [10]   24     ld bc, #sizeof_e ;; Size
   455F CD 28 46      [17]   25     call cpct_memcpy_asm    ;; Changes AF, BC, DE, HL
                             26 
   4562 CD D8 45      [17]   27     call increase_free_entity
   4565 CD C8 45      [17]   28     call man_entity_increase_num
                             29 
                             30     ;; No free space -> Skip
   4568                      31     skip_ce:
   4568 C9            [10]   32 ret
                             33 
   4569                      34 man_entity_destroy::
   4569 C9            [10]   35 ret 
                             36 
                             37 ;; Pointer to function
   456A 00 00                38 function_for_all: .db #0x00, #0x00
   456C 0B                   39 count: .db #sizeof_e
                             40 ;; ----------------------------------------------------------- ;;
                             41 ;; INPUT -> HL: contains the function                          ;;
                             42 ;; General function to apply to all entities                   ;;
                             43 ;; ----------------------------------------------------------- ;;
   456D                      44 man_entity_forall::
   456D 22 6A 45      [16]   45     ld (function_for_all), hl
   4570 CD E3 45      [17]   46     call man_entity_first_entity ;; IX points to the first entity
                             47 
   4573 3E 64         [ 7]   48     ld a, #max_entities
   4575 32 6C 45      [13]   49     ld (count), a
                             50 
   4578                      51     loop_forall:
   4578 DD 2A 01 41   [20]   52         ld ix, (next_free_entity)
   457C 21 84 45      [10]   53         ld hl, #afterjp
   457F E5            [11]   54         push hl
                             55 
   4580 2A 6A 45      [16]   56         ld hl, (function_for_all)
   4583 E9            [ 4]   57         jp (hl)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                             58 
   4584                      59         afterjp:
   4584 CD D8 45      [17]   60             call increase_free_entity
   4587 3A 6C 45      [13]   61             ld a, (count)
   458A 3D            [ 4]   62             dec a
   458B 32 6C 45      [13]   63             ld (count), a
   458E 20 E8         [12]   64     jr nz, loop_forall
                             65 
   4590                      66     final:
   4590 CD E3 45      [17]   67         call man_entity_first_entity
   4593 C9            [10]   68 ret
                             69 
                             70 ;; ---------------------------------------------
                             71 ;; Applies a function filtering specific criteria
                             72 ;; B -> Mask of bytes (e_cmps)
                             73 ;; ---------------------------------------------
   4594                      74 man_entity_forall_matching::
   4594 22 6A 45      [16]   75     ld (function_for_all), hl
   4597 CD E3 45      [17]   76     call man_entity_first_entity ;; IX points to the first entity
                             77 
   459A 3E 64         [ 7]   78     ld a, #max_entities
   459C 32 6C 45      [13]   79     ld (count), a
                             80 
   459F                      81     loop_forall_matching:
   459F C5            [11]   82     push bc
   45A0 DD 2A 01 41   [20]   83         ld ix, (next_free_entity)   ;; Look
   45A4 DD 7E 00      [19]   84         ld a, e_cmps(ix)
   45A7 A0            [ 4]   85         and b
   45A8 B8            [ 4]   86         cp b
   45A9 20 08         [12]   87         jr nz, afterjp_matching
                             88 
   45AB                      89         continue:
   45AB 21 B3 45      [10]   90             ld hl, #afterjp_matching
   45AE E5            [11]   91             push hl
                             92 
   45AF 2A 6A 45      [16]   93             ld hl, (function_for_all)
   45B2 E9            [ 4]   94             jp (hl)
                             95 
   45B3                      96             afterjp_matching:
   45B3 CD D8 45      [17]   97                 call increase_free_entity
   45B6 3A 6C 45      [13]   98                 ld a, (count)
   45B9 3D            [ 4]   99                 dec a
   45BA 32 6C 45      [13]  100                 ld (count), a
   45BD C1            [10]  101                 pop bc
   45BE 20 DF         [12]  102     jr nz, loop_forall_matching
                            103 
   45C0                     104     final_matching:
   45C0 CD E3 45      [17]  105         call man_entity_first_entity
   45C3 C9            [10]  106 ret
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
   45C4                     115 man_entity_forall_pairs_matching::
   45C4 C9            [10]  116 ret 
                            117 
                            118 ;; INPUT: A -> ID of the entity
                            119 ;; OUTPUT: IX -> The entity
   45C5                     120 man_entity_get_from_idx::
                            121 
                            122     ;; Acceder al elemento 4 de un array de 4 campos
                            123     ;; array[3] = inicio + (3*4)
                            124 
                            125 
   45C5 C9            [10]  126 ret 
                            127 
   45C6                     128 man_entity_set4destruction::
   45C6 C9            [10]  129 ret 
                            130 
                            131 ;; ---------------------------------------------------
                            132 ;; Updates all entities 
                            133 ;; HL -> Function for all entities
                            134 ;; ---------------------------------------------------
   45C7                     135 man_entity_update::
   45C7 C9            [10]  136 ret
                            137 
                            138 ;; Increases the value of the counter num_entities
   45C8                     139 man_entity_increase_num::
   45C8 3A 03 41      [13]  140     ld a, (num_entities)
   45CB 3C            [ 4]  141     inc a
   45CC 32 03 41      [13]  142     ld (num_entities),a
   45CF C9            [10]  143 ret
                            144 
                            145 ;; Decreases the value of the counter num_entities
   45D0                     146 man_entity_decrease_num::
   45D0 3A 03 41      [13]  147     ld a, (num_entities)
   45D3 3D            [ 4]  148     dec a
   45D4 32 03 41      [13]  149     ld (num_entities),a
   45D7 C9            [10]  150 ret
                            151 
                            152 ;; Updates the direction of the next_free_entity pointer
   45D8                     153 increase_free_entity::
   45D8 2A 01 41      [16]  154     ld hl, (next_free_entity)
   45DB 01 0B 00      [10]  155     ld bc, #sizeof_e
   45DE 09            [11]  156     add hl, bc
   45DF 22 01 41      [16]  157     ld (next_free_entity), hl
   45E2 C9            [10]  158 ret
                            159 
                            160 ;; Changes the entity controller to ix register
   45E3                     161 man_entity_first_entity::
   45E3 21 04 41      [10]  162     ld hl, #array_entities
   45E6 22 01 41      [16]  163     ld (next_free_entity), hl
                            164     ;; ld ix, (next_free_entity)
   45E9 C9            [10]  165 ret
