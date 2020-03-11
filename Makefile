DEST_DIR=/usr/local/bin

.PHONY: install
install:
	sudo rm -rf /usr/share/templates
	sudo cp -r new/templates /usr/share/templates
	sudo cp -f new/new $(DEST_DIR)
	sudo cp -f clean $(DEST_DIR)
	sudo cp -f list  $(DEST_DIR)
