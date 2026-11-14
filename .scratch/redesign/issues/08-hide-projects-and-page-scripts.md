# 08: Hide Projects; allow per-page scripts

Parent: `.scratch/redesign/spec.md`

**What to build:** The Projects section stays in the repository but is not rendered: no page, no menu entry, no link anywhere; its sample page is a draft. The Project page format is defined for the future (title, one-line summary, stack list, repository link, status active/archived, optional demo link) with a plain list showing summary and stack, no cards or images. Revealing Projects later is a small config change. Separately, a page can declare its own script to load via front matter, with no site-wide script bundle, so a Quiz can be added later.

**Blocked by:** 01

**Status:** resolved

- [x] No Projects page or link exists in the built output (automated check)
- [x] Sample Project page is a draft
- [x] Project page and list templates exist for the defined format and are verified by temporarily revealing Projects
- [x] The way to reveal Projects is documented in one place
- [x] A page with a script declared in front matter loads only that script; pages without it load no scripts (automated check)
