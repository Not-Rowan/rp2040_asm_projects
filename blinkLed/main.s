@comment = @
@immidiate value = #
@= means to load an arbitrary 32 bit value within a single instruction (even though aarm only supports smaller immidiate values)


@assign led to 25 (pin25 onboard led)
.EQU LED, 25
@set sleep time (in ms)
.EQU SLEEP, 500

@make global function to call in c file
.global assembly
assembly:
    @initialize led using gpio init (r0 as first arg)
    mov r0, #LED @move the value of LED to r0
    bl gpio_init @branch to label (gpio init function)

    @initialize gpio dir (arg1 (r0) as led pin, arg2 (r1) as direction (GPIO_OUT))
    mov r0, #LED @move the value of LED to r0
    mov r1, #1 @move the value of 1 to r1
    bl link_gpio_set_dir @branch to label (gpio_set_dir function (that i linked))

    @start the loop
    loop:
        @toggle led to on using link_gpio_put (r0 as led pin, r1 as value (1))
        mov r0, #LED @move the value of LED to r0
        mov r1, #1 @move the value of 1 to r1
        bl link_gpio_put @branch to label (gpio_put function (that i linked))

        ldr r0, =SLEEP @load the value of SLEEP to r0
        bl sleep_ms @branch to label (sleep_ms function)

        @toggle led to off using link_gpio_put (r0 as led pin, r1 as value (0))
        mov r0, #LED @move the value of LED to r0
        mov r1, #0 @move the value of 0 to r1
        bl link_gpio_put @branch to label (gpio_put function (that i linked))

        ldr r0, =SLEEP @load the value of SLEEP to r0
        bl sleep_ms @branch to label (sleep_ms function)

        b loop @branch to loop

