# Development

## Zola

The site is built with [Zola](https://www.getzola.org/) (tested with 0.23.6). Install it:

- Download a release binary from https://github.com/getzola/zola/releases and put it on `PATH`, or
- `cargo install --locked --git https://github.com/getzola/zola`, or use your package manager.

## Commands

- Build: `zola build` (output in `public/`); preview: `zola serve`.
- Tests: `tests/run.sh`. It builds the site from `tests/fixture/content` (real templates, config and static files) into a temporary directory and asserts on the built HTML and files with `bash` and `grep`. Zola is taken from `$ZOLA` if set, otherwise from `PATH`.

Add a test case by adding fixture content under `tests/fixture/content` and a `has`/`lacks`/`exists`/`absent` line in `tests/run.sh`.

## Resume PDF and deploy

`scripts/build.sh` is the one local command: it builds the site into `public/`, runs `zola check --skip-external-links` (a broken internal link fails it), and renders the built Resume page to `public/files/resume.pdf` (stable URL `/files/resume.pdf`, linked from the Resume page as "Download PDF"). The PDF is never committed. It needs Zola (`$ZOLA` or `PATH`) and headless Chrome or Chromium (`$CHROME`, or `google-chrome`/`chromium` on `PATH`). The PDF look comes from the `@media print` rules in `sass/style.scss`.

Why headless Chrome: it is preinstalled on GitHub's `ubuntu-latest`, runs locally with no extra Python/system stack, and renders the real stylesheet with full modern CSS (WeasyPrint lags on CSS support and needs Pango). A local Chromium can also come from Playwright (`npx playwright-core install chromium-headless-shell`); point `$CHROME` at it.

The workflow `.github/workflows/zola.yml` runs: checkout, install pinned Zola (`ZOLA_VERSION`), `tests/run.sh`, `scripts/build.sh`, then (only on `main`) publish `public/` to the `gh-pages` branch. Pull requests build and check without publishing.

## Content components (no shortcodes)

Zola 0.23 removed shortcodes (that was the cause of the old "Unknown function `draw_image`" error). Reusable snippets are Tera components in `templates/components.html`, used in markdown as `{{ <draw_image path="images/x.jpg" /> }}`. Components cannot read `config` but can call `get_url`, so the image URL needs no `base_url` argument.

## Revealing Projects

Projects are hidden: `content/projects/_index.md` has `render = false` and the sample Project is a draft. To reveal them:

1. In `content/projects/_index.md`, set `render = true`.
2. In `config.toml`, add `{ name = "Projects", path = "/projects/" }` to `extra.top_menu`.
3. Remove `draft = true` from the Project pages you want to publish.

Project front matter: `title`, `description` (one-line summary), `extra.stack` (list), `extra.repo` (repository URL), `extra.status` (`active` or `archived`), optional `extra.demo` (URL).

## Per-page scripts

There is no site-wide script bundle. A page loads a script only if its front matter declares `extra.script = "js/name.js"` (path relative to `static/`).

## Series

A Series is a content page `content/series/<slug>.md` (title, description) rendered with `series_page.html`. The `series` taxonomy is declared in `config.toml` with `render = false`: it only groups Posts and has no pages of its own. A Post joins one Series with `taxonomies = { series = ["<slug>"] }` and sets its position with `extra.part = N`. Parts are ordered by that number, and drafts are excluded.
