PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

  .org $8000     ; The EEPROM is wired to start at $8000 instead of $0000

nmi:
  rti            ; No interrupt request implemented

irq:
  rti            ; No non-maskable interrupt implemented

reset:
  lda #$ff       ;
  sta DDRB       ; Set all pins on port B to output

  lda #$50       ; Initialize A register with 0x55
  sta PORTB      ; and send it to port B

loop:

  ror            ; Rotate A-register right
  sta PORTB      ; and send it to port B

  jmp loop

  .org $fffa     ; Vector location of NMIB (non-maskable interrupt)
  .word nmi      ; Run interrupt routine at label "nmi"

  .org $fffc     ; Vector location for RESB (reset)
  .word reset    ; Reset program counter to label "reset"

  .org $fffe     ; Vector location for BRK/IRQB (break/interrupt request)
  .word irq      ; Run interrupt routine at label "irq"
