# Resume PDF is generated at build time, not committed

The Resume has one source: `content/resume/` markdown. The HTML page is rendered by Zola; the PDF is produced from that built page by WeasyPrint (`scripts/resume-pdf.py`, run via `uv`) in `scripts/build.sh`, which CI (`.github/workflows/zola.yml`) also runs. The PDF is written to `public/files/resume.pdf` (stable URL `/files/resume.pdf`) and is never committed.

## Considered options

- **Commit a hand-maintained PDF.** Rejected: it drifts from the web Resume and needs manual work on every edit.
- **Headless Chrome (first choice, replaced 2026-11-14).** Renders the real stylesheet, but locally under WSL it needed either the Windows Chrome (unreliable from scripts) or a Linux Chromium plus many system libraries.
- **WeasyPrint via uv (chosen).** One Python dependency, installed by `uv run` from the script's inline metadata; only Pango is needed from the system. Trade-off: weaker modern CSS support, so the `@media print` rules in `sass/style.scss` override anything it cannot handle (e.g. `clamp()`, theme colors).

## Consequences

- The PDF always matches the web Resume.
- Building the PDF locally needs `uv` and Pango.
- The PDF look is reviewed manually; tests only assert that the link exists and the file is produced.
