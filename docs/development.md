# Development

## Zola

The site is built with [Zola](https://www.getzola.org/) (tested with 0.23.6). Install it:

- Download a release binary from https://github.com/getzola/zola/releases and put it on `PATH`, or
- `cargo install --locked --git https://github.com/getzola/zola`, or use your package manager.

## Commands

- Build: `zola build` (output in `public/`); preview: `zola serve`.
- Tests: `tests/run.sh`. It builds the site from `tests/fixture/content` (real templates, config and static files) into a temporary directory and asserts on the built HTML and files with `bash` and `grep`. Zola is taken from `$ZOLA` if set, otherwise from `PATH`.

Add a test case by adding fixture content under `tests/fixture/content` and a `has`/`lacks`/`exists`/`absent` line in `tests/run.sh`.

## Known issue

Zola 0.23.6 fails to render the `draw_image` shortcode used in `content/posts/hello-world.md` ("Unknown function `draw_image`"), even for a trivial shortcode in a scratch project. Not investigated further; the deploy action may use a different Zola version.

## Revealing Projects

Projects are hidden: `content/projects/_index.md` has `render = false` and the sample Project is a draft. To reveal them:

1. In `content/projects/_index.md`, set `render = true`.
2. In `config.toml`, add `{ name = "Projects", path = "/projects/" }` to `extra.top_menu`.
3. Remove `draft = true` from the Project pages you want to publish.

Project front matter: `title`, `description` (one-line summary), `extra.stack` (list), `extra.repo` (repository URL), `extra.status` (`active` or `archived`), optional `extra.demo` (URL).

## Per-page scripts

There is no site-wide script bundle. A page loads a script only if its front matter declares `extra.script = "js/name.js"` (path relative to `static/`).
