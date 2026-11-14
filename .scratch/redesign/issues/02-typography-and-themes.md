# 02: Typography, palette and light/dark themes

Parent: `.scratch/redesign/spec.md`

**What to build:** The site looks like typographic minimalism: one column, self-hosted variable serif (Source Serif 4, regular and italic, woff2) for text and headings, system sans-serif for small UI details (dates, labels, navigation), warm neutral background, one accent color, no gradients or decorative effects. Light and dark themes follow the reader's system setting with no toggle. Code blocks are highlighted with class-based output and two small color sets matching the palette. The layout adapts to phone width without horizontal scrolling. Exact palette and font weights are proposed and left for owner review.

**Blocked by:** 01

**Status:** ready-for-agent

- [ ] Fonts are served from the site itself; no third-party font requests in the built HTML or CSS (automated check)
- [ ] Body text is a comfortable serif at a readable line length
- [ ] Light and dark themes switch by system preference only
- [ ] Code highlighting is legible in both themes
- [ ] Layout has no horizontal scroll at phone width
- [ ] Palette and font choices are summarised in the ticket's `## Comments` for owner review
- [ ] Visual quality is reviewed manually in a browser (light, dark, phone width)
