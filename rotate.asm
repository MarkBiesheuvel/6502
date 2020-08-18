; This program is intended to run on the 6502 computer by Ben Eater (https://eater.net/6502)
;
; Components:
; - W65C02  (Microprocessor)
; - 28C256  (256K EEPROM)
; - 62256   (256K SRAM)
; - W65C22  (Versatile Interface Adapter)
; - HD44780 (LCD controller)


; The W65C22 Versatile Interface Adapter is enabled when a15 is low and both a14 and a13 are low
; Therefore the Interface Adapter is located from address $6000 to $7FFF
; The W65C22 has 4 bit registers that can be addressed, these are connected to a0 through a3
; Therefore a4 through 12 are ignored (for example $6001 is equivalent to $6**1 and $7**1)
IORB = $6000 ; Input/Output Register "B"
IORA = $6001 ; Input/Output Register "A"
DDRB = $6002 ; Data Direction Register "B"
DDRA = $6003 ; Data Direction Register "A"

; The AT28C256 EEPROM is enabled when address line 15 (a15) is high
; Therefore the EEPROM is located from address $8000 to $FFFF
EEPROM = $8000 ; Start of the EEPROM

; Vector locations for NMI, RES and IRQ on the W65C02
NMI = $FFFA ; Non-Maskable Interrupt
RES = $FFFC ; Reset
IRQ = $FFFE ; Interrupt Request

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
  ; Set all pins of I/O register B of the Interface Adapter to output
  lda #%11111111
  sta DDRB

  ; Initialize accumulator with a value of seven 0s and one 1, and send it to register B of the Interface Adapter
  lda #%00010000
  sta IORB

  ; Make sure the Carry flag is 0 so it does not get rotated in
  clc

loop:
  ; Rotate accumulator right until carry is not set
  ror
  bcs loop

  ; Send accumulator to to register B of the Interface Adapter
  sta IORB

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
