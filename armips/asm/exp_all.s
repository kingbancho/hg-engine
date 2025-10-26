; exp_all_HG_SS.asm by Yako
; enables exp-share for all pokémon in the party

.nds
.thumb

XP_MULT equ 1; multiplier for exp gain 
XP_DIV equ 1; divisor for exp gain

SCALE_XP equ 1 ; set to 1 to scale exp based on the number of mons gaining exp
SKIP_MSG equ 1 ; set to 1 to skip the "exp gained" message

;.definelabel REVERT, 1

_s32_div_f equ 0x020f2998

.open "base/overlay/overlay_0012.bin", 0x022378C0

; BtlCmd_CalcExpGain
.org 0x223E750 
    mov r0, r0 ; always take exp share path (i.e. pretend every mon is holding an exp share)

.org 0x0223e79e
.area 66, 0x0
    mov r7, #0x9c
    add r7, r5 ; r2 = &ctx->gainedExp (0x9c offset in ctx)
    mov r1, XP_MULT
    mul r0, r1
    mov r1, XP_DIV
    blx _s32_div_f ; premultiply exp by multiplier/divisor
    lsr r4, r0, #1 ; r4 = exp/2
    ldr r1, [sp,#4] ; r1 = expMonsCount
    cmp r1, #0
    beq expshare_exp ; skip if no mons gaining regular exp
    mov r0, r4
    .if SCALE_XP != 1
    blx _s32_div_f ; r0 = exp/(2*expMonsCount) ; regular exp
    .endif
    cmp r0, #0
    bne store_exp_normal
    mov r0, #1
store_exp_normal:
    str r0, [r7] ; ctx->gainedExp = r0
expshare_exp:
    ldr r1, [sp,#0x0] ; r1 = expShareCount
    cmp r1, #0
    beq end_exp_calc ; skip if no mons gaining exp share exp
    mov r0, r4
    .if SCALE_XP != 1
    blx _s32_div_f ; r0 = exp/(2*expShareCount)
    .endif
    cmp r0, #0
    bne store_exp_expshare
    mov r0, #1
store_exp_expshare:
    str r0, [r7,#4] ; ctx->partyGainedExp = r0 ; exp share exp
end_exp_calc:
    b 0x0223e80e
.endarea

; Task_GetExp
.org 0x22458F4
    b 0x224591A ; skip check for exp share item
.org 0x02245A58
    mov r0, r0 ; skip check for exp share item

.org 0x02245b44
.if SKIP_MSG
    ; Remove message
    .area 0x2E, 0x0
        add sp, #0xd8
        mov r0, #3
        str r0, [r4,#0x28]
    .endarea
.else
    ; Restore original instructions
    .byte 0x11, 0x21, 0x2d, 0xa8, 0x41, 0x70, 0x28, 0x02, 0x38, 0x43, 0x2e, 0x90, 0x0e, 0x98, 0x2f, 0x90
    .byte 0x20, 0x68, 0xf5, 0xf7, 0xdf, 0xfd, 0x03, 0x1c, 0x20, 0x68, 0x10, 0x99, 0x2d, 0xaa, 0xf6, 0xf7
    .byte 0x97, 0xfc, 0x20, 0x63, 0x07, 0x20, 0x60, 0x63, 0xa0, 0x6a, 0x36, 0xb0, 0x40, 0x1c, 0xa0, 0x62
.endif

.ifdef REVERT ; restore original code
    ; BtlCmd_CalcExpGain
    .org 0x223E750
        bne 0x223E758
    .org 0x223E79E
        .byte 0x20, 0xd0, 0x44, 0x08, 0x01, 0x99, 0x20, 0x1c, 0xb4, 0xf6, 0xf8, 0xe8, 0x29, 0x1c, 0x9c, 0x31
        .byte 0x08, 0x60, 0x28, 0x1c, 0x9c, 0x30, 0x00, 0x68, 0x00, 0x28, 0x03, 0xd1, 0x28, 0x1c, 0x01, 0x21
        .byte 0x9c, 0x30, 0x01, 0x60, 0x00, 0x99, 0x20, 0x1c, 0xb4, 0xf6, 0xe8, 0xe8, 0x29, 0x1c, 0xa0, 0x31
        .byte 0x08, 0x60, 0x28, 0x1c, 0xa0, 0x30, 0x00, 0x68, 0x00, 0x28, 0x19, 0xd1, 0x01, 0x20, 0xa0, 0x35
        .byte 0x28, 0x60, 0x15, 0xe0    
    ; Task_GetExp
    .org 0x0223E034
        beq #0x223E05A
    .org 0x0223E198
        bne #0x223E1A8
.endif

.close
