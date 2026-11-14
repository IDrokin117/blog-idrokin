# Resume PDF is generated at build time, not committed

The Resume has one source: `content/resume/` markdown. The HTML page is rendered by Zola; the PDF is produced from that built page by headless Chrome in `scripts/build.sh`, which CI (`.github/workflows/zola.yml`) also runs. The PDF is written to `public/files/resume.pdf` (stable URL `/files/resume.pdf`) and is never committed.

## Considered options

- **Commit a hand-maintained PDF.** Rejected: it drifts from the web Resume and needs manual work on every edit.
- **WeasyPrint or another Python HTML-to-PDF tool.** Rejected: lags on modern CSS and needs extra system libraries (Pango).
- **Headless Chrome (chosen).** Preinstalled on GitHub's `ubuntu-latest`, easy to run locally, and renders the real stylesheet; the PDF look comes from the `@media print` rules in `sass/style.scss`.

## Consequences

- The PDF always matches the web Resume.
- Building the PDF locally needs Chrome or Chromium (`$CHROME`, or `google-chrome`/`chromium` on `PATH`).
- The PDF look is reviewed manually; tests only assert that the link exists and the file is produced.
