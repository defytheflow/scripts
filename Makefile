SRC_DIR  = /usr/local/src
DEST_DIR = /usr/local/bin

.PHONY: install
install:
	sudo cp -r new $(SRC_DIR)
	sudo ln -fs $(SRC_DIR)/new/new.sh $(DEST_DIR)/new
	sudo cp -r clean $(SRC_DIR)
	sudo ln -fs $(SRC_DIR)/clean/clean.sh $(DEST_DIR)/clean
	sudo cp include-order $(DEST_DIR)
