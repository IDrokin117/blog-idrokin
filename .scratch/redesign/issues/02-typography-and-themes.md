# 02: Typography, palette and light/dark themes

Parent: `.scratch/redesign/spec.md`

**What to build:** The site looks like typographic minimalism: one column, self-hosted variable serif (Source Serif 4, regular and italic, woff2) for text and headings, system sans-serif for small UI details (dates, labels, navigation), warm neutral background, one accent color, no gradients or decorative effects. Light and dark themes follow the reader's system setting with no toggle. Code blocks are highlighted with class-based output and two small color sets matching the palette. The layout adapts to phone width without horizontal scrolling. Exact palette and font weights are proposed and left for owner review.

**Blocked by:** 01

**Status:** resolved

- [x] Fonts are served from the site itself; no third-party font requests in the built HTML or CSS (automated check)
- [x] Body text is a comfortable serif at a readable line length
- [x] Light and dark themes switch by system preference only
- [x] Code highlighting is legible in both themes
- [x] Layout has no horizontal scroll at phone width
- [x] Palette and font choices are summarised in the ticket's `## Comments` for owner review
- [ ] Visual quality is reviewed manually in a browser (light, dark, phone width)

## Comments

Palette and fonts, proposed for owner review (visual check in a browser still pending, last criterion left unticked):

- Font: Source Serif 4 variable (latin subset, weights 200-900, regular + italic woff2, ~48 KB each), self-hosted in `static/fonts/`. Body 18px (17px on phones), line-height 1.65, column 40rem; headings weight 600. Small UI (nav, dates, tags, footer) in system sans at 13.6px.
- Light: bg `#faf7f2`, text `#2b2723`, muted `#7a7168`, rules `#e4ddd2`, code bg `#f1ece3`, accent `#9c3d1e` (burnt sienna).
- Dark: bg `#1c1a17`, text `#e6dfd3`, muted `#9a9086`, rules `#34302a`, code bg `#25221e`, accent `#e0885f`.
- Code highlighting: class-based, Zola generates `giallo-light.css` / `giallo-dark.css` from built-in themes `solarized-light` / `solarized-dark` (token colors), loaded by `prefers-color-scheme`; code block background overridden with the palette. Swap `light_theme`/`dark_theme` in `config.toml` to change.
