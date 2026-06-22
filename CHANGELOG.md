## [11.0.0] - 2026-06-22

### 🚀 Features

- Add 9.4 PHP 8.1, remove 9.2
- *(env)* Create dotenv file to use for makefile and gitlab ci variables

### 🐛 Bug Fixes

- Add metatada, latest docker, jobs names
- Typo
- Disable cache
- Junit test report file
- Install python testinfra from debian packages to avoid venv errors.
- Update testinfra config for xunit2 and avoid error
- Use official nodejs install, set composer allow superuser, fix styles
- Drush update
- *(xdebug)* Pin xdebug for issue 3405976
- Failing install
- New image docker fix
- Minor clean, update style for chrome headless
- *(ci)* Set back previous and chrome [skip ci]
- *(yarn)* Node install failing issue #65
- *(node)* Regression bug, get classic node instead of fnm
- *(ci)* Job template
- *(ci)* Missing stage
- *(ci)* Missing envsubst
- *(docker)* More silent, clean not needed programs
- *(make)* Clean and silence
- Update php 8.3 for 10.4
- Missing php packages and drush
- Too soon for phpunit 11
- No space in dotenv
- Packages and dependencies, reduce layers
- Avoid direct call to core-dev
- Move drush in main composer.json
- Guzzle update workaround
- Multiline for readability, update test php modules
- Fix previous php 8.4 guzzle error [skip ci]
- Do not run next build by default
- Pin version, do_release was ignored [skip ci]
- Set global errors stop [skip ci]
- Guzzle psr7 version

### 🧪 Testing

- First tests on gitlab ci script
- Update php modules test
- Run with bash
- Fix fnm version test
- Disable node check for now
- Fix and cleanup
- Fix tests templates suffix
- Update yarn test

### ⚙️ Miscellaneous Tasks

- Initial release on new namespace
- Clean
- Remove 9.3, add Drupal 10, update third party
- Update node 18
- Add 10.1, remove 9.4
- Add 10.1, remove 9.4 in scripts and ci
- No more tpl, replaced by build-arg
- Add local build and tests
- *(update)* Update composer third party
- Update main version
- Bump to 11.1
- Enable 11.1 images
- Bump versions, add 11.2
- Bump robo to 5
- Phpunit failing not detected
- Bumpd images, add more previous
- Remove 10.5 and 11.2
- Bump to 11 only, put back 11.2,
