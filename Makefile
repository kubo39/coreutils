.PHONY: all clean

DMD = dmd

SRC_DIR = source
TARGET_DIR = bin

all: false \
	logname \
	nproc \
	pwd \
	sleep \
	timeout \
	true \
	whoami

false:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

logname:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

nproc:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

pwd:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

sleep:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

timeout:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

true:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

whoami:
	$(DMD) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

clean:
	$(RM) $(TARGET_DIR)/*
