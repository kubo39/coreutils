.PHONY: all clean

DC ?= dmd

SRC_DIR = source
TARGET_DIR = bin

all: arch \
	false \
	hostid \
	logname \
	mkdir \
	nproc \
	pwd \
	sleep \
	tee \
	timeout \
	true \
	uname \
	wc \
	whoami

arch:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

false:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

hostid:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

logname:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

mkdir:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

nproc:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

pwd:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

sleep:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

tee:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

timeout:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

true:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

uname:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

wc:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

whoami:
	$(DC) -of=$(TARGET_DIR)/$@ $(SRC_DIR)/$@.d

clean:
	$(RM) $(TARGET_DIR)/*
