.PHONY: all clean

DMD = dmd

SRC_DIR = source
TARGET_DIR = bin

all: true \
	false

true:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/true.d

false:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/false.d

clean:
	$(RM) $(TARGET_DIR)/*
