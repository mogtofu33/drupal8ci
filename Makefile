DRUPAL_STABLE_8=8.9
DRUPAL_LEGACY_9=9.1
DRUPAL_STABLE_9=9.2
DRUPAL_8_PHP=7.4
DRUPAL_9_PHP=8.0

TPL=tpl/common

define prepare
	@echo "Create $(1) from ${TPL} for Drupal $(1) with PHP $(2)..."
	@rm -rf ./$(1)/;
	@cp -r ./${TPL}/ ./$(1)/;
	@IMAGE_TAG="$(1)" PHP_VERSION="$(2)" envsubst < "./$(TPL)/Dockerfile" > "./$(1)/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/composer.json" > "./$(1)/composer.json";
	@echo "...Done!"
endef

prepare:
	$(call prepare,${DRUPAL_STABLE_8},${DRUPAL_8_PHP})
	$(call prepare,${DRUPAL_LEGACY_9},${DRUPAL_9_PHP})
	$(call prepare,${DRUPAL_STABLE_9},${DRUPAL_9_PHP})

.PHONY: prepare
