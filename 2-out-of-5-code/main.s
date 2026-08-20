// Condition 1 - Upper 3 bits must be 0
// Condition 2 - Exactly 2 of the lower 5 bits must be 1

.data
a: .word 0        # store final result

.text

    addi x6, x0, 0x12    # input value
    andi x7, x6, 0xE0      # check upper 3 bits
    bne  x7, x0, invalid   # if any of them is 1 => invalid

    addi x10, x0, 0        # x10 = count of 1-bits
    addi x8,  x0, 5        # check lower 5 bits

loop:
    andi x9, x6, 1         # grab LSB
    beq  x9, x0, skip      # if 0-bit, skip increment
    addi x10, x10, 1       # count this 1-bit

skip:
    srli x6, x6, 1         # shift right
    addi x8, x8, -1        # decrement bit counter
    bne  x8, x0, loop      # continue until 5 bits done

    # finished counting -> now check if exactly 2
    addi x11, x0, 2
    bne  x10, x11, invalid

valid:
    addi x10, x0, 0xFF     # SUCCESS -> store FF
    sw   x10, a(x0)
    j    done

invalid:
    addi x10, x0, 0x00     # FAILURE -> store 00
    sw   x10, a(x0)

done:
    nop
