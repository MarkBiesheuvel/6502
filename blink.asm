; This program is intended to run on the 6502 computer by Ben Eater (https://eater.net/6502)
;
; Components:
; - W65C02  (Microprocessor)
; - 28C256  (256K EEPROM)
; - 62256   (256K SRAM)
; - W65C22  (Versatile Interface Adapter)
; - HD44780 (LCD controller)


; TODO: explain these addresses
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; The EEPROM is enabled when address line 15 (a15) is high
; Therefore the EEPROM is located from address $8000 to $FFFF
EEPROM = $8000

; Address locations for NMI, RES and IRQ on the 6502
NMI = $FFFA
RES = $FFFC
IRQ = $FFFE

  ; This program is stored on the EEPROM
  ; So all addresses should start at the corresponding address
  .org EEPROM

nmi:
  ; No non-maskable interrupt implemented yet
  rti

irq:
  ; No interrupt request implemented yet
  rti

reset:
  ; Set all pins on port B to output
  lda #$FF
  sta DDRB

  ; Initialize A register with 0x55 and send it to port B
  lda #$50
  sta PORTB

loop:
  ; Rotate A-register right and send it to port B
  ror
  sta PORTB

  jmp loop

  ; Vector location of NMIB (non-maskable interrupt)
  ; Run interrupt routine at label "nmi"
  .org NMI
  .word nmi

  ; Vector location for RESB (reset)
  ; Reset program counter to label "reset"
  .org RES
  .word reset

  ; Vector location for BRK/IRQB (break/interrupt request)
  ; Run interrupt routine at label "irq"
  .org IRQ
  .word irq
