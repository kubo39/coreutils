.PHONY: all clean

DMD = dmd

SRC_DIR = source
TARGET_DIR = bin

all: false \
	logname \
	pwd \
	true

false:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/false.d

logname:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/logname.d

pwd:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/pwd.d

true:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/true.d

clean:
	$(RM) $(TARGET_DIR)/*
