ROM = tetrisdx.gbc
SOURCE_FILE = harddrop.asm
OBJECT_FILE = harddrop.o
OUTPUT = harddrop.gbc

all:
	rgbasm -v $(SOURCE_FILE) -o $(OBJECT_FILE)
	rgblink -v -O $(ROM) -o $(OUTPUT) $(OBJECT_FILE)
	rgbfix -v -f gh $(OUTPUT)
