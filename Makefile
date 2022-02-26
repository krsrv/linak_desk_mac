CFLAGS := -framework Foundation -framework CoreBluetooth -fobjc-weak
SRC_FILES := $(wildcard *.m)
H_FILES := $(wildcard *.h)

run: $(SRC_FILES) $(H_FILES)
	gcc ${CFLAGS} $(SRC_FILES) -o $@

clean:
	rm -f run *.out
