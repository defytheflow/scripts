SRC_DIR     = /usr/local/src
SYMLINK_DIR = /usr/local/bin

.PHONY: install
install:
	sudo cp -r new $(SRC_DIR)
	sudo ln -fs $(SRC_DIR)/new/new.sh $(SYMLINK_DIR)/new
	sudo cp -r clean $(SRC_DIR)
	sudo ln -fs $(SRC_DIR)/clean/clean.sh $(SYMLINK_DIR)/clean
