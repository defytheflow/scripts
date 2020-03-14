SRC_DIR     = /usr/local/src
SYMLINK_DIR = /usr/local/bin
SHARE_DIR   = /usr/share
DEST_DIR    = /usr/local/bin

.PHONY: install
install:
	sudo rm -rf $(SHARE_DIR)/templates
	sudo cp -r new/templates $(SHARE_DIR)/templates
	sudo cp -f new/new $(DEST_DIR)
	sudo cp -r clean $(SRC_DIR)
	sudo ln -fs $(SRC_DIR)/clean/clean.sh $(SYMLINK_DIR)/clean
