from PIL import Image

file_name = "ship.png"
img = Image.open(file_name).convert("RGBA")

width, height = img.size

with open(f"{file_name}.asm", "w") as f:
    f.write(f"; {width}x{height}\n")

    pixels = []

    for y in range(height):
        for x in range(width):
            r, g, b, a = img.getpixel((x, y))

            if a == 0:
                pixels.append("0x00000000")
            else:
                argb = (
                    (a << 24) |
                    (r << 16) |
                    (g << 8)  |
                    b
                )

                pixels.append(f"0x{argb:08X}")

    f.write("background:\n")
    f.write(".array ")
    f.write(", ".join(pixels))
    f.write("\n")

print(f"Arquivo salvo em {file_name}.asm")