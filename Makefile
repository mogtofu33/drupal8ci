#!/bin/bash

DRUPAL_PREVIOUS=9.5
DRUPAL_PREVIOUS_DEV=^9.5
DRUPAL_PREVIOUS_PHP=8.1
DRUPAL_CURRENT=10.1
DRUPAL_CURRENT_DEV=^10.1
DRUPAL_CURRENT_PHP=8.2
DRUPAL_NEXT=10.2
DRUPAL_NEXT_DEV=^10.2
DRUPAL_NEXT_PHP=8.2

TPL=drupal-tpl

define prepare
	@echo "Create $(1) from ${TPL} for Drupal $(1)..."
	@rm -rf ./$(1)/;
	@cp -r ./${TPL}/ ./$(1)/;
	@IMAGE_TAG="$(1)" PHP_VERSION="$(2)" CORE_DEV="$(3)" envsubst < "./$(TPL)/Dockerfile" > "./$(1)/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/composer.json" > "./$(1)/composer.json";
	@PHP_VERSION="$(2)" envsubst < "./$(TPL)/tests/test_php.py" > "./$(1)/tests/test_php.py";
	@DRUPAL_VERSION="$(1)" envsubst < "./$(TPL)/tests/test_drush.py" > "./$(1)/tests/test_drush.py";
	@echo "...Done!"
endef

prepare:
	$(call prepare,${DRUPAL_PREVIOUS},${DRUPAL_PREVIOUS_PHP},${DRUPAL_PREVIOUS_DEV})
	$(call prepare,${DRUPAL_CURRENT},${DRUPAL_CURRENT_PHP},${DRUPAL_CURRENT_DEV})
	$(call prepare,${DRUPAL_NEXT},${DRUPAL_NEXT_PHP},${DRUPAL_NEXT_DEV})

.PHONY: prepare
