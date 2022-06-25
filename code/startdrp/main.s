@comment = @
@immidiate value/integer. things like that = #
@= means to load an address or a large value (larger than 16 bits)
@[] means a memory address


.equ LED, 25 @gpio 25
.equ SLEEP_TIME, 1000000 @sleep time in ms

.thumb_func
.global main

.align 4 @necessary alignment for thumb

main:
    mov r0, #LED
    bl initialize_gpio

    mov r0, #LED
    bl gpio_set_out

    loop:
        mov r0, #LED
        bl gpio_on

        ldr r0, =SLEEP_TIME
        bl sleep_us_32

        mov r0, #LED
        bl gpio_off

        ldr r0, =SLEEP_TIME
        bl sleep_us_32

        b loop

.data
    .align 4