from bitstring import BitArray

with open('finch.coe', 'w') as f:
    f.write('memory_initialization_radix=2;\n')
    f.write('memory_initialization_vector=\n')

    with open("finch.bin", 'rb') as t:
        byte = t.read(1)
        while byte:
            c = BitArray(hex=hex(byte[0]))
            byte = t.read(1)
            c_char = c.bin
            if len(c_char) == 4: c_char = '0000' + c_char
            if byte:
                f.write(c_char + ',\n')
            else:
                f.write(c_char + ';\n')
