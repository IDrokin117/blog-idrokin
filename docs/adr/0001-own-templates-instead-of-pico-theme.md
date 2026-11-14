# Own templates instead of the pico theme

The site used the third-party `pico` Zola theme as a git submodule, with local overrides on top. We dropped it and now ship our own base layout, header, footer, page templates and a single Sass stylesheet (`sass/style.scss`).

## Considered options

- **Keep `pico` and override more.** Rejected: the result looked generic, every visual change fought the theme, and the theme brought features we do not want (search, comments).
- **Switch to another third-party theme.** Rejected: same coupling, and it would still not support Series or the Resume print layout without overrides.
- **Own templates and one stylesheet (chosen).** A few hundred lines of Sass and a handful of templates; full control over typography, light/dark themes and print.

## Consequences

- No submodule and no `theme` key in `config.toml`; a fresh clone builds without `git submodule update`.
- We maintain the templates ourselves, including Zola upgrades. Zola 0.23 removed shortcodes in favour of components, so reusable snippets live in `templates/components.html` (see `docs/development.md`).
- Search and giscus comments were removed along with the theme; nothing in the repository refers to them.
- Fonts are self-hosted; there are no third-party requests at runtime.
