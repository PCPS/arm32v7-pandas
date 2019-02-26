SHELL := /bin/bash

docker-test:
	docker run --rm logbook2cloud /bin/bash -c "pip install pytest; python -c \"import numpy; numpy.test('full');\""
	docker run --rm logbook2cloud /bin/bash -c "pip install pytest hypothesis; python -c \"import pandas; pandas.test();\""

docker-image:
	# prepare qemu
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker build -t arm32v7-pandas --build-arg PANDAS_VERSION=$$PANDAS_VERSION .

docker-upload:
	echo "$$DOCKER_PASSWORD" | docker login -u "$$DOCKER_USER" --password-stdin
	docker tag arm32v7-pandas:latest $$DOCKER_USERNAME/arm32v7-pandas:latest || travis_terminate 1
	docker push $$DOCKER_USERNAME/arm32v7-pandas:latest || travis_terminate 1
	docker tag arm32v7-pandas:latest $$DOCKER_USERNAME/arm32v7-pandas:$$PANDAS_VERSION
	docker push $$DOCKER_USERNAME/arm32v7-pandas:$$PANDAS_VERSION
	docker tag arm32v7-pandas:latest  $$DOCKER_USERNAME/arm32v7-pandas:$$TRAVIS_BUILD_NUMBER
	docker push $$DOCKER_USERNAME/arm32v7-pandas:$$TRAVIS_BUILD_NUMBER
