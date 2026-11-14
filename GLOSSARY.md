# Personal Site

Igor Drokin's personal Zola site: a showcase for recruiters and fellow engineers (Resume, Projects) plus a blog. The site language is English.

## Language

**Post**:
A single blog article published on the site.
_Avoid_: Note, article, entry

**Series**:
A named, ordered group of Posts on one topic, meant to be read in sequence. Implemented as a content page under `content/series/` plus a non-rendered `series` taxonomy that Posts join.
_Avoid_: Collection, category, tag group

**Part**:
The position of a Post within a Series, set by an explicit number rather than by publication date. A Post belongs to at most one Series.
_Avoid_: Episode, chapter

**Project**:
A page about a specific thing the author has built. The Projects section is hidden for now because there are no public Projects; revealing it is a config change (see `docs/development.md`).
_Avoid_: Work, portfolio item

**Resume**:
The author's professional resume. The only source is a markdown file; the HTML page is rendered by Zola and the PDF is generated from it by headless Chrome at build time.
_Avoid_: CV

**Quiz**:
An interactive quiz that runs entirely in the reader's browser. Not implemented yet.
_Avoid_: Test, survey
