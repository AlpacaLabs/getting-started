BINARY_PATH ?= /Applications/draw.io.app/Contents/MacOS/draw.io
FILE_PATH := architecture.drawio

.PHONY: all
all:
	${BINARY_PATH} --export --page-index 0 --output arch-0.jpg --format jpg ${FILE_PATH}
	${BINARY_PATH} --export --page-index 1 --output arch-1.jpg --format jpg ${FILE_PATH}
	${BINARY_PATH} --export --page-index 2 --output arch-2.jpg --format jpg ${FILE_PATH}
	${BINARY_PATH} --export --page-index 3 --output arch-3.jpg --format jpg ${FILE_PATH}
	${BINARY_PATH} --export --page-index 4 --output arch-4.jpg --format jpg ${FILE_PATH}
