SHELL := /bin/bash

docker-test:
	# prepare qemu
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker run --rm $$DOCKER_USERNAME/arm32v7-pandas:latest /bin/bash -c "python -c \"import pandas; print('Importing pandas worked, for version: ' + pandas.__version__);\""

docker-image:
	# prepare qemu
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker build -t arm32v7-pandas --build-arg PANDAS_VERSION=$$PANDAS_VERSION .

docker-upload:
	echo "$$DOCKER_PASSWORD" | docker login -u "$$DOCKER_USERNAME" --password-stdin
	docker tag arm32v7-pandas:latest $$DOCKER_USERNAME/arm32v7-pandas:latest || travis_terminate 1
	docker push $$DOCKER_USERNAME/arm32v7-pandas:latest || travis_terminate 1
	docker tag arm32v7-pandas:latest $$DOCKER_USERNAME/arm32v7-pandas:$$PANDAS_VERSION
	docker push $$DOCKER_USERNAME/arm32v7-pandas:$$PANDAS_VERSION
	# docker tag arm32v7-pandas:latest  $$DOCKER_USERNAME/arm32v7-pandas:$$TRAVIS_BUILD_NUMBER
	# docker push $$DOCKER_USERNAME/arm32v7-pandas:$$TRAVIS_BUILD_NUMBER
