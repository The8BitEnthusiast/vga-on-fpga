from PIL import Image

image = Image.open("image.png")

pixels = image.load()

out_file = open("image.bin", "wb")

for y in range(256):

    for x in range(128):

        try:

            out_file.write(bytes(pixels[x, y]))

        except IndexError:

            out_file.write(bytes(0))
