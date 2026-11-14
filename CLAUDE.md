## Language

All project documents and in-repo text are written in English: `CLAUDE.md`, `GLOSSARY.md`, ADRs, specs, tickets, `docs/agents/*`, commit messages, and site content. Chat replies to the user may be in another language.

## Agent skills

### Issue tracker

Issues and specs live locally as markdown files under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.

## Development

Zola site with its own templates (no theme). Build: `scripts/build.sh` (site, internal link check, Resume PDF via headless Chrome into `public/files/resume.pdf`); tests: `tests/run.sh`; preview: `zola serve`. Zola 0.23 has no shortcodes, use components from `templates/components.html`. Projects are hidden and are revealed via config; per-page scripts via `extra.script`. Details in `docs/development.md`; decisions in `docs/adr/`.
