#!/bin/sh

docker-compose run --rm bot bundle exec rake
docker-compose up -d
docker-compose exec bot /bin/bash
