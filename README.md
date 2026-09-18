# Befritco Helm charts

Helm charts for the Expo event-operations platform:

- [`charts/expo-manager`](charts/expo-manager) — the application (API + web) that Flux deploys as
  `batibouw-2025` and future exposition instances.
- [`charts/rethinkdb`](charts/rethinkdb) — a single-node RethinkDB StatefulSet, used as a
  dependency of `expo-manager` or standalone.

Both charts are published as OCI artifacts to `ghcr.io/befritco/charts` and, for compatibility
with plain Helm repo tooling, as a classic index on GitHub Pages.

## Install

### From the OCI registry (recommended)

```console
helm install my-expo-manager oci://ghcr.io/befritco/charts/expo-manager --version 2.0.0
```

```console
helm install my-rethinkdb oci://ghcr.io/befritco/charts/rethinkdb --version 1.0.0
```

`helm show chart`, `helm show values` and `helm pull` all work the same way against an
`oci://` reference.

### From the Pages index

```console
helm repo add befritco https://befritco.github.io/helm-charts
helm repo update
helm install my-expo-manager befritco/expo-manager
```

See each chart's own README (generated from `values.yaml` — do not edit by hand) for the full
list of values, including the "Upgrading from 1.x" section on `charts/expo-manager`.

## GitOps (Flux) with OCIRepository + HelmRelease

Point a Flux `OCIRepository` at the chart instead of a `HelmRepository`, then reference it from
the `HelmRelease` with `chartRef`:

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: OCIRepository
metadata:
  name: expo-manager
  namespace: flux-system
spec:
  interval: 30m
  url: oci://ghcr.io/befritco/charts/expo-manager
  ref:
    semver: "2.x"
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: expo-manager
  namespace: flux-system
spec:
  interval: 10m
  chartRef:
    kind: OCIRepository
    name: expo-manager
```

Optionally verify the [cosign](https://github.com/sigstore/cosign) keyless signature that
`publish-chart.yaml` attaches to every pushed chart, by adding a `verify` block to the
`OCIRepository`:

```yaml
  verify:
    provider: cosign
    matchOIDCIdentity:
      - issuer: "^https://token.actions.githubusercontent.com$"
        subject: "^https://github.com/Befritco/helm-charts/.github/workflows/publish-chart.yaml@refs/heads/main$"
```

If the cluster's Flux predates `chartRef`, use a `HelmRepository` of `type: oci` pointed at
`oci://ghcr.io/befritco/charts/expo-manager` instead.

## How releases work

This repo uses [release-please](https://github.com/googleapis/release-please) with
[Conventional Commits](https://www.conventionalcommits.org/):

1. Commits landing on `main` (`feat:`, `fix:`, `feat!:`, ...) accumulate into a release pull
   request per chart, opened/updated by `release-please.yaml`. A `feat!:` (or a `BREAKING CHANGE:`
   footer) touching `charts/expo-manager` bumps its major version; `charts/rethinkdb` starts at
   `1.0.0`.
2. Merging the release PR makes release-please tag the released chart(s) as
   `<chart>-<version>` (e.g. `expo-manager-2.0.0`, `rethinkdb-1.0.0`) and cut a GitHub Release per
   chart.
3. For each released chart, `release-please.yaml` calls the reusable `publish-chart.yaml`, which
   checks out the tag, packages the chart, pushes it to
   `oci://ghcr.io/befritco/charts/<chart>`, signs the resulting image keylessly with `cosign`, and
   uploads the packaged `.tgz` to the chart's GitHub Release.
4. A final `pages-index` job downloads every packaged chart and regenerates `index.yaml` on the
   `gh-pages` branch once (never per chart, to avoid racing pushes to that branch), so
   `https://befritco.github.io/helm-charts/index.yaml` stays in sync with the OCI artifacts.

## Continuous integration

`lint-and-test.yaml` runs on every pull request touching `charts/**`, `ct.yaml` or
`.github/workflows/**`:

- `lint`: `ct lint`, `helm template` against every `charts/*/ci/*-values.yaml` piped through
  `kubeconform` (including the Gateway API CRDs, via the datreeio schema catalog), and a
  README/`values.schema.json` freshness check with bitnami's `readme-generator-for-helm`.
- `install`: on same-repository PRs only (secrets are unavailable on fork PRs), spins up a `kind`
  cluster and runs `ct install` for every changed chart.

## One-time setup

These steps are manual and out of scope for the workflows in this repo:

- **Allow public packages** for the `Befritco` GitHub organization (Organization settings →
  Packages).
- **After the first successful release**, set both `ghcr.io/befritco/charts/expo-manager` and
  `ghcr.io/befritco/charts/rethinkdb` packages to **public** (Package settings → Danger Zone →
  Change visibility). Until then, `helm install ... oci://...` and the `kind` install test in CI
  cannot pull them anonymously.
- **Access to the private `ghcr.io/befritco/expo/api` image**, needed by the `install` CI job and
  by real deployments. Either:
  - grant `Befritco/helm-charts` (or the consuming cluster's pull identity) read access on the
    `expo/api` package directly (preferred — no long-lived token to rotate), or
  - create a repo secret `GHCR_PULL_TOKEN` (a classic PAT with `read:packages`) — the `install`
    job falls back to it when package-level access isn't granted.
- **Optional `RELEASE_PLEASE_TOKEN` repo secret**: if this repo's branch protection or other CI
  needs to run on release-please's own release PRs, set this to a token from a distinct identity
  (a GitHub App or a bot PAT) — the default `GITHUB_TOKEN` cannot trigger further workflow runs on
  the PRs it opens.
