# Minimal Varnish Docker Container

[![Build Status](https://travis-ci.org/jamesbrink/docker-varnish.svg?branch=master)](https://travis-ci.org/jamesbrink/docker-varnish) [![Docker Automated build](https://img.shields.io/docker/automated/jamesbrink/varnish.svg)](https://hub.docker.com/r/jamesbrink/varnish/) [![Docker Pulls](https://img.shields.io/docker/pulls/jamesbrink/varnish.svg)](https://hub.docker.com/r/jamesbrink/varnish/) [![Docker Stars](https://img.shields.io/docker/stars/jamesbrink/varnish.svg)](https://hub.docker.com/r/jamesbrink/varnish/) [![](https://images.microbadger.com/badges/image/jamesbrink/varnish.svg)](https://microbadger.com/images/jamesbrink/varnish "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jamesbrink/varnish.svg)](https://microbadger.com/images/jamesbrink/varnish "Get your own version badge on microbadger.com")  


## About

This is a just a varnish container.

## Usage

Extending from this image. 

```Dockerfile
FROM jamesbrink/varnish
COPY ./MyApp /MyApp
RUN apk add --update my-deps...
```

Running a simple glxgears test. 

```shell
$ docker run -i -t --rm jamesbrink/varnish bash
```

## Environment Variables


| Variable | Default Value   | Description |
| -------- | --------------- | ----------- |
| `ENV`    | `DEFAULT_VALUE` | Description |

