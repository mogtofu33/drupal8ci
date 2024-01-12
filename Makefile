test:
	docker build --tag test-drupal-ci ./drupal && docker run -it --rm test-drupal-ci bash