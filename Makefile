.PHONY: run
run: usleep
	PATH="$$PATH:$$PWD" ./ProgFS/QtPalmtop/bin/z/Words.sh

usleep: usleep.c
	gcc -o $@ -O3 $<
