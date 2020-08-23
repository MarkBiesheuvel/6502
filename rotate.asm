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
ADDRESS_REGISTER_B = $6000 ; Input/Output Register "B"
ADDRESS_REGISTER_A = $6001 ; Input/Output Register "A"
ADDRESS_DATA_DIRECTION_B = $6002 ; Data Direction Register "B"
ADDRESS_DATA_DIRECTION_A = $6003 ; Data Direction Register "A"

; The AT28C256 EEPROM is enabled when address line 15 (a15) is high
; Therefore the EEPROM is located from address $8000 to $FFFF
ADDRESS_EEPROM = $8000 ; Start of the EEPROM

; Vector locations for NMI, RES and IRQ on the W65C02
ADDRESS_NMI_VECTOR = $FFFA ; Non-Maskable Interrupt
ADDRESS_RES_VECTOR = $FFFC ; Reset
ADDRESS_IRQ_VECTOR = $FFFE ; Interrupt Request

  ; This program is stored on the EEPROM
  ; So all addresses should start at the corresponding address
  .org ADDRESS_EEPROM

nonMaskableInterrupt:
  ; No non-maskable interrupt implemented yet
  rti

interruptRequest:
  ; No interrupt request implemented yet
  rti

resetProgram:
  ; Set all pins of I/O register A and B of the Interface Adapter to output
  lda #%11111111
  sta ADDRESS_DATA_DIRECTION_A
  sta ADDRESS_DATA_DIRECTION_B

resetRegiserB:
  ; Clear register A of the Interface Adapter
  lda #%00000000
  sta ADDRESS_REGISTER_A

  ; Initialize accumulator with a value of seven 0s and one 1, and send it to register B of the Interface Adapter
  lda #%10000000
  sta ADDRESS_REGISTER_B

  ; Make sure the Carry flag is 0 so it does not get rotated in
  clc

rotateRegisterB:
  ; Rotate accumulator right
  ror

  ; If the carry is set, continue with rotating register A
  bcs resetRegisterA

  ; Send accumulator to to register B of the Interface Adapter
  sta ADDRESS_REGISTER_B

  jmp rotateRegisterB

resetRegisterA:
  ; Clear register B of the Interface Adapter
  lda #%00000000
  sta ADDRESS_REGISTER_B

  ; Initialize accumulator with a value of seven 0s and one 1, and send it to register A of the Interface Adapter
  lda #%10000000
  sta ADDRESS_REGISTER_A

  ; Make sure the Carry flag is 0 so it does not get rotated in
  clc

rotateRegisterA:
  ; Rotate accumulator right
  ror

  ; If the carry is set, continue with rotating register B
  bcs resetRegiserB

  ; Send accumulator to to register A of the Interface Adapter
  sta ADDRESS_REGISTER_A

  jmp rotateRegisterA

  ; Vector location of NMIB (non-maskable interrupt)
  ; Run interrupt routine at label "nonMaskableInterrupt"
  .org ADDRESS_NMI_VECTOR
  .word nonMaskableInterrupt

  ; Vector location for RESB (reset)
  ; Reset program counter to label "resetProgram"
  .org ADDRESS_RES_VECTOR
  .word resetProgram

  ; Vector location for BRK/IRQB (break/interrupt request)
  ; Run interrupt routine at label "interruptRequest"
  .org ADDRESS_IRQ_VECTOR
  .word interruptRequest
