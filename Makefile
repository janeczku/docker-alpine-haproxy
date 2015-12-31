IMAGE = janeczku/alpine-haproxy
VERSIONS = 1.5_1.5.14 1.6_1.6.3

.PHONY: all $(VERSIONS)

all: $(VERSIONS) tag-latest

$(VERSIONS): MAJOR = $(firstword $(subst _, ,$@))
$(VERSIONS): MINOR = $(lastword $(subst _, ,$@))
$(VERSIONS):
	@echo "=> building $(IMAGE):$(MAJOR)"
	docker build -t $(IMAGE):$(MAJOR) -f Dockerfile.v$(MAJOR) .
	docker tag -f $(IMAGE):$(MAJOR) $(IMAGE):$(MINOR)
	@echo "=> pushing $(IMAGE):$(MAJOR)"
	docker push $(IMAGE):$(MAJOR)
	docker push $(IMAGE):$(MINOR)

tag-latest: MAJOR = $(firstword $(subst _, ,$(word $(words $(VERSIONS)),$(VERSIONS))))
tag-latest:
	docker tag -f $(IMAGE):$(MAJOR) $(IMAGE):latest
	@echo "=> pushing $(IMAGE):latest"
	docker push $(IMAGE):latest
