BEAMERS := power-arch-tech-beamer

.PHONY: all clean $(BEAMERS)
all: $(BEAMERS)

$(BEAMERS):
	mkdir -p $@/out
	docker run --rm --volume "$(PWD):/data" -w /data/$@ pandoc/extra \
		-d ../beamer.yaml $@.md -o $@.pdf

clean:
	rm -rf $(addsuffix /out,$(BEAMERS))
