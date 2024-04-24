



run:
	docker run --rm --volume "$(PWD)/..:/data" -w /data pandoc/extra -d build-beamer/beamer.yaml src/iommu-intro.md -o docker.pdf

