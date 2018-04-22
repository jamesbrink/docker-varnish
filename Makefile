#!/usr/bin/make -f

NAME=jamesbrink/varnish
TEMPLATE=Dockerfile.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template
.PHONY: test all clean latest 6.0.0 5.2.1 4.1.9
.DEFAULT_GOAL := latest

all: latest 6.0.0 5.2.1 4.1.9

latest:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp -rp patches/6.0.0/ $(@)/patches
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG VARNISH_VERSION.*/ARG VARNISH_VERSION="6.0.0"/g' $(@)/Dockerfile
	cd $(@) && docker build -t $(NAME):$(@) .

6.0.0:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp -rp patches/$(@)/ $(@)/patches
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG VARNISH_VERSION.*/ARG VARNISH_VERSION="$(@)"/g' $(@)/Dockerfile
	cd $(@) && docker build -t $(NAME):$(@) .

5.2.1:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp -rp patches/$(@)/ $(@)/patches
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG VARNISH_VERSION.*/ARG VARNISH_VERSION="$(@)"/g' $(@)/Dockerfile
	cd $(@) && docker build -t $(NAME):$(@) .

4.1.9:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp -rp patches/$(@)/ $(@)/patches
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG VARNISH_VERSION.*/ARG VARNISH_VERSION="$(@)"/g' $(@)/Dockerfile
	cd $(@) && docker build -t $(NAME):$(@) .

test: test-latest test-6.0.0 test-5.2.1 test-4.1.9

test-latest:
	if [ "`docker run --rm jamesbrink/varnish cat /etc/alpine-release`" != "3.7.0" ]; then exit 1;fi
	docker run -it --rm jamesbrink/varnish varnishd -V|grep --quiet "varnish-6.0.0"; if [ $$? -ne 0 ]; then exit 1;fi

test-6.0.0:
	if [ "`docker run --rm jamesbrink/varnish cat /etc/alpine-release`" != "3.7.0" ]; then exit 1;fi
	docker run -it --rm jamesbrink/varnish:6.0.0 varnishd -V|grep --quiet "varnish-6.0.0"; if [ $$? -ne 0 ]; then exit 1;fi

test-5.2.1:
	if [ "`docker run --rm jamesbrink/varnish cat /etc/alpine-release`" != "3.7.0" ]; then exit 1;fi
	docker run -it --rm jamesbrink/varnish:5.2.1 varnishd -V|grep --quiet "varnish-5.2.1"; if [ $$? -ne 0 ]; then exit 1;fi

test-4.1.9:
	if [ "`docker run --rm jamesbrink/varnish cat /etc/alpine-release`" != "3.7.0" ]; then exit 1;fi
	docker run -it --rm jamesbrink/varnish:4.1.9 varnishd -V|grep --quiet "varnish-4.1.9"; if [ $$? -ne 0 ]; then exit 1;fi

clean:
	rm -rf latest 6.0.0 5.2.1 4.1.9
