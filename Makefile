TIMESTAMP      := $(shell date -u +"%Y%m%d%H%M%S")
DOCKER         := $(shell { command -v podman || command -v docker; })
IMAGE_NAME := zmk


.PHONY: clean setup firmware_rm docker_image_rm flash

all: setup build

build: firmware/$$(TIMESTAMP)-left.uf2 firmware/$$(TIMESTAMP)-right.uf2

clean: firmware_rm docker_image_rm

firmware_rm:
	rm -f firmware/*.uf2

docker_image_rm:
	$(DOCKER) image rm -f $(IMAGE_NAME)

firmware/%-left.uf2 firmware/%-right.uf2: config/adv360.keymap
	$(DOCKER) run --rm -it --name zmk    \
		-v $(PWD)/firmware:/app/firmware \
		-v $(PWD)/config:/app/config:ro  \
		-e TIMESTAMP=$(TIMESTAMP)        \
		$(IMAGE_NAME)

clean:
	rm -f firmware/*.uf2
	$(DOCKER) image rm zmk docker.io/zmkfirmware/zmk-build-arm:stable

setup: Dockerfile bin/build.sh config/west.yml
	$(DOCKER) build --progress=plain --tag $(IMAGE_NAME) --file Dockerfile .

flash:
	./bin/flash.sh
