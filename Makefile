#!make

.PHONY: help build test

ifneq (,$(wildcard ./VERSION.env))
include VERSION.env
endif

ifeq ($(origin IMAGE_VERSION),undefined)
$(error Missing env variable IMAGE_VERSION!)
endif

help:
	@sed \
		-e '/^[a-zA-Z0-9_\-]*:.*##/!d' \
		-e 's/:.*##\s*/:/' \
		-e 's/^\(.\+\):\(.*\)/$(shell tput setaf 6)\1$(shell tput sgr0):\2/' \
		$(MAKEFILE_LIST) | column -c2 -t -s :

define build
	@echo "Build $(1) with Drupal:$(2) PHP:$(3) Node:$(4)..."
	PHP_VERSION="$(3)" envsubst < "./drupal/tests/test_php.py.tpl" > "./drupal/tests/test_php.py" ;
	NODE_VERSION="$(4)" envsubst < "./drupal/tests/test_packages.py.tpl" > "./drupal/tests/test_packages.py" ;
	DRUPAL_VERSION="$(2)" envsubst < "./drupal/tests/test_drush.py.tpl" > "./drupal/tests/test_drush.py" ;
	docker build \
		--tag test-drupal-ci:$(2) \
		--build-arg IMAGE_VERSION=$(1) \
		--build-arg IMAGE_TAG=$(2) \
		--build-arg PHP_VERSION=$(3) \
		--build-arg NODE_VERSION=$(4) \
		./drupal ;
endef

define test
	@echo "Run tests for $(1)..."
	@docker run -d --name test-ci-$(1) test-drupal-ci:$(1)
	@docker exec test-ci-$(1) /tests/prepare-tests.sh
	@docker exec -w /tests test-ci-$(1) pytest-3
endef

build: ## Locally build images
	$(call build,${IMAGE_VERSION},${DRUPAL_PREVIOUS},${DRUPAL_PREVIOUS_PHP},${NODE_VERSION})
	$(call build,${IMAGE_VERSION},${DRUPAL_CURRENT},${DRUPAL_CURRENT_PHP},${NODE_VERSION})
# $(call build,${IMAGE_VERSION},${DRUPAL_NEXT},${DRUPAL_NEXT_PHP},${NODE_VERSION})

test: ## Locally test images
	$(call test,${DRUPAL_PREVIOUS})
	$(call test,${DRUPAL_CURRENT})
# $(call test,${DRUPAL_NEXT})