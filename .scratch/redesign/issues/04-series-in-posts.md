# 04: Series: taxonomy, Post label and navigation, Series page

Parent: `.scratch/redesign/spec.md`

**What to build:** An author assigns a Post to a Series with two front matter fields: the `series` taxonomy value and a Part number in extra front matter. Series title and description live in a content page per Series. A Post in a Series shows "Series name · Part N of M" above its title, linking to the Series page; at its end it shows previous/next links within the Series and a collapsed list of all published Parts. Parts are ordered by Part number, not date. Draft Parts never appear in any list, count or navigation, and there are no "coming soon" placeholders. The Series page shows title, description and the ordered list of Parts. A Post belongs to at most one Series: the template uses the first value and the build warns on more than one. Series and tags are independent.

**Blocked by:** 01

**Status:** ready-for-agent

- [ ] Fixture set includes a two-Part Series, a Series containing a draft Part, and a Post outside any Series
- [ ] Series label shows correct name, Part N and total M, and links to the Series page
- [ ] Prev/next links and the collapsed Parts list are present and correct
- [ ] Parts are ordered by Part number even when dates are out of sequence
- [ ] Draft Parts are excluded from the label's total, navigation, lists and Series page
- [ ] A Post outside any Series shows no Series elements
- [ ] The Series page shows title, description and ordered Parts
- [ ] A Post assigned to more than one Series triggers a build warning
- [ ] All of the above are automated checks on built output
