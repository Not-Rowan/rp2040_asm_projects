@comment = @
@immidiate value/integer. things like that = #
@= means to load an address or a large value (larger than 16 bits)
@[] means a memory address

.thumb_func
.align 4


.global sleep_us_32
sleep_us_32:
    @max sleep time: 2,147,483,648 microseconds or 2,147,483 milliseconds or 2147 seconds or 35 minutes

    @params:
    @r0 = time to sleep (in microseconds)

    @other registers in use:
    @r1 = time_raw_base
    @r2 = start time of time_raw_base with low offset (0x28)
    @r3 = current time of time_raw_base with low offset (0x28)
    @r4 = check for max value

    ldr r4, =maxMicrosecondValue
    cmp r0, r4
    bge cancel

    @get time_raw_base value and initialize it
    ldr r1, =time_raw_base

    ldr r2, [r1, #time_raw_low] @#time_raw_low

    time_loop_lo:
        ldr r3, [r1, #time_raw_low] @#time_raw_low

        sub r3, r3, r2
        
        cmp r3, r0
        blt time_loop_lo


    cancel:
    bx lr


.global initialize_gpio
initialize_gpio:
    @params:
    @r0 = gpio number

    @other registers in use:
    @r1 = gpio bank0 base address
    @r2 = gpio function (0x5 sio)

    @gpio offsets are 8 bytes large so multiply gpio pin num by 8
    lsl r0, #3

    @load gpio bank0 base address (with gpio offset added)
    ldr r1, =gpio_bank_base
    ldr r1, [r1]
    add r1, r0

    @load gpio function offset (sio: 0x5) and add to gpio bank base address
    ldr r2, =gpio_bank_SIO
    ldr r2, [r2]
    str r2, [r1, #0x4]

    bx lr


.global gpio_set_out
gpio_set_out:
    @put a bit into r3 and move it to the correct gpio number
    movs r3, #1
    lsl r3, r0

    @load gpio output enable address into r2
    ldr r2, =gpio_oe
    
    @turn the address in r2 into an actual address
    ldr r2, [r2]

    @store the bit in r3 into the address in r2
    str r3, [r2]

    @return
    bx lr


@same process for everything else


.global gpio_on
gpio_on:
    movs r3, #1
    lsl r3, r0
    ldr r2, =gpio_output_set
    ldr r2, [r2]
    str r3, [r2]

    bx lr


.global gpio_off
gpio_off:
    movs r3, #1
    lsl r3, r0
    ldr r2, =gpio_output_clear
    ldr r2, [r2]
    str r3, [r2]
    bx lr


@stop program execution
.global stop
stop:
    b stop

@you need to store the value as a word because the processor requires 32 bit addresses and not 16 bit addresses
.data
    .align 4 @necessary alignment for thumb

    @gpio data
    gpio_oe: .word 0xd0000024
    gpio_output_set: .word 0xd0000014
    gpio_output_clear: .word 0xd0000018

    @base gpio user bank 0 = 0x40014000
    @0x5 = func
    gpio_bank_base: .word 0x40014000
    gpio_bank_SIO: .word 0x5

    @raw timer stuff (for some reason i cant use a word label. deal with it rowan it is not that important)
    .equ time_raw_base, 0x40054000
    .equ time_raw_low, 0x28
    .equ time_raw_high, 0x24


    @important variables (max values)
    .equ maxMicrosecondValue, 0x7FFFFFFF

