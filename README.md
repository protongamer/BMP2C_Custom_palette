# Image2C_Custom_palette
This is an image to array (8 bits bmp structure) with a custom palette that determine how many colors are in this picture

![alt_text](https://github.com/protongamer/BMP2C_Custom_palette/blob/main/thatprogram.png?raw=true)

How to convert ?

-First choose your bmp configuration
-Color definition :
-> RGB565 Will make a 16 bit array integer
-> RGB888 Will make a 32 bit array integer
-Palette format :
-> 16-colors mean there will be 2 color adresses per byte (0xAB -> A : adress 1 ; B = adress 2)
-> 256-colors mean there will be 1 color adress per byte (0xAB -> AB : adress 1)

Be aware that the number of color inside of the picture does not overflow the x-colors palette format.
An output log.txt will show the results after conversion.

Written in processing
(Made with Processing 4.0b)
