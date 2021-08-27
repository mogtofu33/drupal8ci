DRUPAL_STABLE_8=8.9
DRUPAL_LEGACY_9=9.1
DRUPAL_STABLE_9=9.2
DRUPAL_8_PHP=7.4
DRUPAL_9_PHP=8.0

# Temporary Druapl 9+.
# @todo: remove when 8.9 is deprecated
DRUPAL_STABLE_8_FIX=
DRUPAL_LEGACY_9_FIX="\"phpspec/prophecy-phpunit\""
DRUPAL_STABLE_9_FIX="\"phpspec/prophecy-phpunit\""

TPL=tpl/common

define prepare
	@echo "Create $(1) from ${TPL} for Drupal $(1) with PHP $(2)..."
	@rm -rf ./$(1)/;
	@cp -r ./${TPL}/ ./$(1)/;
	@IMAGE_TAG="$(1)" PHP_VERSION="$(2)" TEMP_FIX=$(3) envsubst < "./$(TPL)/Dockerfile" > "./$(1)/Dockerfile";
	@IMAGE_TAG="$(1)" envsubst < "./$(TPL)/composer.json" > "./$(1)/composer.json";
	@echo "...Done!"
endef

prepare:
	$(call prepare,${DRUPAL_STABLE_8},${DRUPAL_8_PHP},${DRUPAL_STABLE_8_FIX})
	$(call prepare,${DRUPAL_LEGACY_9},${DRUPAL_9_PHP},${DRUPAL_LEGACY_9_FIX})
	$(call prepare,${DRUPAL_STABLE_9},${DRUPAL_9_PHP},${DRUPAL_STABLE_9_FIX})

.PHONY: prepare
