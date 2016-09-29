IMAGE = nextjournal/alpine-haproxy
VERSIONS = 1.5_1.5.14 1.6_1.6.9

.PHONY: all $(VERSIONS)

all: $(VERSIONS) lua tag-latest

$(VERSIONS): MAJOR = $(firstword $(subst _, ,$@))
$(VERSIONS): MINOR = $(lastword $(subst _, ,$@))
$(VERSIONS):
	@echo "=> building $(IMAGE):$(MAJOR)"
	docker build --build-arg HAPROXY_VERSION=$(MINOR) -t $(IMAGE):$(MAJOR) -f Dockerfile.v$(MAJOR) .
	docker tag $(IMAGE):$(MAJOR) $(IMAGE):$(MINOR)
	@echo "=> pushing $(IMAGE):$(MAJOR)"
	docker push $(IMAGE):$(MAJOR)
	docker push $(IMAGE):$(MINOR)

lua: LATEST = $(word $(words $(VERSIONS)),$(VERSIONS))
lua: MAJOR = $(firstword $(subst _, ,$(LATEST)))
lua: MINOR = $(lastword $(subst _, ,$(LATEST)))
lua:
	@echo "=> building $(IMAGE):$(MAJOR)-lua"
	docker build --build-arg HAPROXY_VERSION=$(MINOR) --build-arg WITH_LUA=1 -t $(IMAGE):$(MAJOR)-lua -f Dockerfile.v$(MAJOR) .
	docker tag $(IMAGE):$(MAJOR)-lua $(IMAGE):$(MINOR)-lua
	@echo "=> pushing $(IMAGE):$(MAJOR)-lua"
	docker push $(IMAGE):$(MAJOR)-lua
	docker push $(IMAGE):$(MINOR)-lua


tag-latest: MAJOR = $(firstword $(subst _, ,$(word $(words $(VERSIONS)),$(VERSIONS))))
tag-latest:
	@echo "=> pushing $(IMAGE):latest"
	docker tag $(IMAGE):$(MAJOR) $(IMAGE):latest
	docker push $(IMAGE):latest
