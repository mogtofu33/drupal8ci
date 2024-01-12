build:
	@docker build --progress=plain --tag test-drupal-ci ./drupal
	@# docker build --progress=plain --tag test-drupal-ci --build-arg IMAGE_TAG='10.2' ./drupal
	@docker run -it --rm test-drupal-ci bash

test:
	@docker run -d --name test-ci test-drupal-ci
	@docker exec test-ci /tests/prepare-tests.sh
	docker exec -w /tests test-ci pytest-3