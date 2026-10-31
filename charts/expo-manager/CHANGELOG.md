# Changelog

## [2.0.0](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.8...expo-manager-2.0.0) (2026-10-31)


### ⚠ BREAKING CHANGES

* **expo-manager:** the chart needs web image 2.0.1 or later; an older (root, port 80) web image fails its probes unless web.containerPort is 80 and the web security contexts are cleared.
* values and resources change shape. Images are ghcr.io/befritco/expo/api and /web; api.persistence splits into .reports and .photos; the rethinkdb block follows the new single or multi-node subchart; ingress annotations are no longer defaulted; the bitnami/common dependency is gone. See the README's "Upgrading from 1.x" section for the data move.

### Features

* **expo-manager:** Microsoft 365 OAuth2 for the checkout email ([#27](https://github.com/Befritco/helm-charts/issues/27)) ([02a28b9](https://github.com/Befritco/helm-charts/commit/02a28b9985e07c63d261a6eeb9b79c6d926d31cf))
* **expo-manager:** run the web pod unprivileged with a read-only root filesystem ([#29](https://github.com/Befritco/helm-charts/issues/29)) ([792857f](https://github.com/Befritco/helm-charts/commit/792857febf82859a63d73e56345ebb1de14fb4a0))
* per-workload service accounts, API docs off by default ([#26](https://github.com/Befritco/helm-charts/issues/26)) ([8969fb4](https://github.com/Befritco/helm-charts/commit/8969fb4f816b487761c4219293d2d37db8b48785))
* rework charts for the rebuilt application, add a RethinkDB chart, publish as OCI ([#20](https://github.com/Befritco/helm-charts/issues/20)) ([1d0c4de](https://github.com/Befritco/helm-charts/commit/1d0c4deb55724c471ff8d9e0dc4b5fef3a5721ad))


### Bug Fixes

* **expo-manager:** default exposition.logo to empty ([#24](https://github.com/Befritco/helm-charts/issues/24)) ([ba5df25](https://github.com/Befritco/helm-charts/commit/ba5df25f98425d89ecb2df98193833cecabce052))
* **expo-manager:** exposition defaults match the API's seed ([#28](https://github.com/Befritco/helm-charts/issues/28)) ([cdda6d6](https://github.com/Befritco/helm-charts/commit/cdda6d67f4eda9ef77f5c3d47c061eb7c5043b06))

## [1.0.8](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.7...expo-manager-1.0.8) (2023-01-28)


### Bug Fixes

* Updated dep ([a66ae1f](https://github.com/Befritco/helm-charts/commit/a66ae1f45d5a042b1a0822b43da2cc37d5c7cabc))

## [1.0.7](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.6...expo-manager-1.0.7) (2023-01-28)


### Miscellaneous Chores

* release 1.0.7 ([c00f102](https://github.com/Befritco/helm-charts/commit/c00f102b922697dacddfa60de2a3191e4b348bba))

## [1.0.6](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.5...expo-manager-1.0.6) (2023-01-27)


### Bug Fixes

* fixed port ([2598cab](https://github.com/Befritco/helm-charts/commit/2598cab13555204bc02a0d6eeb18f79ba52be1e5))

## [1.0.5](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.4...expo-manager-1.0.5) (2023-01-26)


### Bug Fixes

* fixed probe ([d7141f6](https://github.com/Befritco/helm-charts/commit/d7141f6f790560beeeeb0410d41b06c35066300a))

## [1.0.4](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.3...expo-manager-1.0.4) (2023-01-26)


### Bug Fixes

* fixed multiple typos ([93419a8](https://github.com/Befritco/helm-charts/commit/93419a8039a69338d61643e629e2af7cd78ea271))
* fixed multiple typos ([5470e43](https://github.com/Befritco/helm-charts/commit/5470e43865d1899fc9bee75d0f01ed2112d278f8))
* fixed rethinkdb hostname ([4bd9264](https://github.com/Befritco/helm-charts/commit/4bd9264334c71bde2aa44da41b6674052e5ee756))

## [1.0.3](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.2...expo-manager-1.0.3) (2023-01-26)


### Bug Fixes

* fixed duplicate entry ([00566a6](https://github.com/Befritco/helm-charts/commit/00566a6f39c773a36997d24f684016d01d0fbe05))

## [1.0.2](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.1...expo-manager-1.0.2) (2023-01-26)


### Bug Fixes

* Fixed pull secrets ([a4f0331](https://github.com/Befritco/helm-charts/commit/a4f03313115641d11b0c02b47b788421436e015a))

## [1.0.1](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.0...expo-manager-1.0.1) (2023-01-26)


### Bug Fixes

* fixed typo in notes ([4b9c1f0](https://github.com/Befritco/helm-charts/commit/4b9c1f04d11d2c6d7c879e8019c5502f70d49528))

## [1.0.0](https://github.com/Befritco/helm-charts/compare/expo-manager-v1.0.3...expo-manager-1.0.0) (2023-01-26)


### Bug Fixes

* updated notes ([6a0230d](https://github.com/Befritco/helm-charts/commit/6a0230d320c9e43cc0ff53d287389540cfe78960))


### Miscellaneous Chores

* release 1.0.0 ([68cae09](https://github.com/Befritco/helm-charts/commit/68cae09b18dc0e8602ed2630c4c1b204bb92d132))

## [1.0.3](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.2...expo-manager-1.0.3) (2023-01-26)


### Bug Fixes

* trigger ci ([29f79ce](https://github.com/Befritco/helm-charts/commit/29f79ce8dc0cf9bbcb8b0a614119be56ce4703af))

## [1.0.2](https://github.com/Befritco/helm-charts/compare/expo-manager-1.0.1...expo-manager-1.0.2) (2023-01-23)


### Bug Fixes

* trigger ci ([b00de09](https://github.com/Befritco/helm-charts/commit/b00de095819e1d7aa0f16ad9ab4463ba1c60e8d2))

## [1.0.1](https://github.com/Befritco/helm-charts/compare/expo-manager-v1.0.0...expo-manager-1.0.1) (2023-01-23)


### Bug Fixes

* trigger ci ([f96685f](https://github.com/Befritco/helm-charts/commit/f96685f280c10e74f7c1f4441c0a5ab1f7d8007f))

## 1.0.0 (2023-01-23)


### Bug Fixes

* trigger ci ([f96685f](https://github.com/Befritco/helm-charts/commit/f96685f280c10e74f7c1f4441c0a5ab1f7d8007f))
