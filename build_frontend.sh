#!/usr/bin/env sh

UID="$(id -u)" GID="$(id -g)" docker-compose build builder && UID="$(id -u)" GID="$(id -g)" docker-compose run builder;