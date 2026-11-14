# 03: Home page

Parent: `.scratch/redesign/spec.md`

**What to build:** A recruiter opens the home page and within seconds understands who the author is: name, small avatar next to it, one or two lines about the author, and links to Resume, GitHub, LinkedIn and Email. Below that, the three latest Posts show whether the blog is active. The "about" text is drafted from the existing Resume content and left for owner approval.

**Blocked by:** 01

**Status:** resolved

- [x] Home shows name, avatar, a short about text, and links to Resume, GitHub, LinkedIn, Email
- [x] Home lists exactly the three latest Posts, newest first (automated check against the fixture set)
- [x] The about text is drafted from the Resume and flagged in `## Comments` for owner approval
- [x] The avatar image is web-appropriately sized (the current one is several MB)

## Comments

Needs owner approval: the about text on the home page (content/_index.md), drafted from the Resume summary:

> Senior software engineer and team lead with five years of experience in Python and Rust, building data processing systems and backend services on AWS. I write here about what I build and learn along the way.

Also confirm: GitHub link uses github.com/IDrokin117 (from the Resume; the old footer used a different account) and the avatar was converted to a 256px webp (about 20 KB).
