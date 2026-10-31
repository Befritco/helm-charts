# Changelog

## 1.0.0 (2026-10-31)


### ⚠ BREAKING CHANGES

* values and resources change shape. Images are ghcr.io/befritco/expo/api and /web; api.persistence splits into .reports and .photos; the rethinkdb block follows the new single or multi-node subchart; ingress annotations are no longer defaulted; the bitnami/common dependency is gone. See the README's "Upgrading from 1.x" section for the data move.

### Features

* per-workload service accounts, API docs off by default ([#26](https://github.com/Befritco/helm-charts/issues/26)) ([8969fb4](https://github.com/Befritco/helm-charts/commit/8969fb4f816b487761c4219293d2d37db8b48785))
* rework charts for the rebuilt application, add a RethinkDB chart, publish as OCI ([#20](https://github.com/Befritco/helm-charts/issues/20)) ([1d0c4de](https://github.com/Befritco/helm-charts/commit/1d0c4deb55724c471ff8d9e0dc4b5fef3a5721ad))


### Miscellaneous Chores

* release 1.0.0 ([68cae09](https://github.com/Befritco/helm-charts/commit/68cae09b18dc0e8602ed2630c4c1b204bb92d132))
* release 1.0.7 ([c00f102](https://github.com/Befritco/helm-charts/commit/c00f102b922697dacddfa60de2a3191e4b348bba))
