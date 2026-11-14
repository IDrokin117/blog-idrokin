# 01: Site skeleton without `pico`

Parent: `.scratch/redesign/spec.md`

**What to build:** The site builds with one command on its own base layout, header, footer and a single Sass stylesheet, with no third-party theme. The menu is exactly Home, Posts, Resume. The blog section is called "Posts" everywhere. Search and comments are gone; tags and the RSS feed work. Posts list and a single Post page render in a bare, unstyled-beyond-basics form. A test harness exists that builds the site from a dedicated fixture content set (Posts, a Post outside any Series, a Resume) and asserts on the built HTML and files, so later tickets add their cases to it. The harness is plain `bash` + `grep` with no new dependencies; installing Zola for local runs is documented.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] `pico` submodule and theme config removed; site has own templates and one Sass stylesheet
- [ ] A single command builds the site; the test harness builds the fixture content set and runs assertions
- [ ] Menu contains exactly Home, Posts, Resume
- [ ] Blog section titled "Posts" consistently (config, section title, headings)
- [ ] Search index, search widget, giscus config and widget are removed; no search or giscus assets in the build
- [ ] RSS feed is generated and tags pages work
- [ ] An existing Post URL is unchanged after the rebuild
- [ ] Domain and CNAME unchanged
- [ ] Site content and template text are English only
