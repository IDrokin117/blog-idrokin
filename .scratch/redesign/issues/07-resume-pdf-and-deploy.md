# 07: Resume PDF and deploy pipeline

Parent: `.scratch/redesign/spec.md`

**What to build:** Every deploy renders the built Resume page to a PDF with a print-capable HTML-to-PDF tool and writes it into the site output at a stable URL; the Resume page links to it as "Download PDF", so the PDF always matches the web Resume. The deploy workflow replaces the current GitHub Pages deploy action with explicit steps: checkout, install Zola, build, internal link check, generate PDF, publish to the same `gh-pages` branch. A single local command reproduces the build and the PDF. The hand-maintained committed PDF is removed. Deploy still happens only from `main`; the branch `redesign` builds and checks without publishing.

**Blocked by:** 01, 06

**Status:** resolved

- [x] Resume page has a "Download PDF" link pointing to a stable URL
- [x] The PDF exists in the built output at that URL (automated check)
- [x] One local command builds the site and produces the PDF
- [x] Workflow runs checkout, Zola install, build, link check, PDF, publish to `gh-pages`; the old deploy action is gone
- [x] Broken internal links fail the pipeline before publishing
- [x] Domain, CNAME and deploy branch unchanged
- [x] Committed `resume.pdf` removed
- [ ] The PDF's look is reviewed manually (owner)
