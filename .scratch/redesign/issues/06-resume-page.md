# 06: Resume as a markdown page with print styles

Parent: `.scratch/redesign/spec.md`

**What to build:** The Resume is written once in a single markdown content file: contacts (email, GitHub, LinkedIn, location) in front matter, body with Summary, Experience, Skills, Education headings. The existing hand-maintained HTML resume content is moved into this file, not rewritten. The template only lays out and styles it. A recruiter can read it on a phone, and printing from the browser produces a clean document via a print stylesheet.

**Blocked by:** 01

**Status:** ready-for-agent

- [ ] One markdown file is the only source of Resume content; old HTML resume markup is removed
- [ ] Contacts come from front matter and render on the page
- [ ] Summary, Experience, Skills, Education sections render from markdown (automated check on the fixture and the real Resume)
- [ ] Existing resume content is preserved (moved, not edited)
- [ ] Print stylesheet yields a clean single-flow document (reviewed manually via browser print preview)
