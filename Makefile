#!/usr/bin/make -f

NAME=jamesbrink/varnish
TEMPLATE=Dockerfile.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template
.PHONY: test all clean latest
.DEFAULT_GOAL := latest

all: latest

latest:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG TEMPLATE_VERSION.*/ARG TEMPLATE_VERSION="0.1.0"/g' $(@)/Dockerfile
	cp varnish.alpine.patch $(@)
	# cd $(@) && TEMPLATE_VERSION="0.1.0" IMAGE_NAME=$(NAME):$(@) ./hooks/build
	docker build -t $(NAME):$(@) $(@)

test: test-latest

test-latest:
	if [ "`docker run jamesbrink/varnish cat /etc/alpine-release`" != "3.7.0" ]; then exit 1;fi
	docker run -it jamesbrink/varnish varnishd -V|grep --quiet "varnish-6.0.0"; if [ $$? -ne 0 ]; then exit 1;fi

clean:
	rm -rf latest
