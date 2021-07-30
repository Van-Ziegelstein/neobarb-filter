# Changelog for neobarb-filter


## Version 3.2.3
- Updated to lts-18.4 and ensured compatibility with Pandoc 2.14.1

## Version 3.2.2
- Updated to lts-17.11 and ensured compatibility with Pandoc 2.13

## Version 3.2.2
- The special paragraph in the chapter "Konkurrenz" now uses LaTeX's 
  center environment in the manuscript, hence the restyling is no longer
  necessary.

## Version 3.2.0
- Reworked paragraph style fixes to make use of Pandoc's
  new ability to preserve LaTeX environments as Div blocks with
  custom classes.
- Dropped obsolete matching rules.
- Ensured compatibility with Pandoc 2.11.4

## Version 3.1.2
- Updated to lts-16.31 and Pandoc 2.11.3.2

## Version 3.1.1
- Compatibility with Pandoc 2.11.0.2

## Version 3.1.0
- Pillagers: added a new function to wrap the separator images inside custom Divs.
  This facilitates the implementation of global paragraph indenting (via CSS)
  while keeping the first sentence in a chapter and after a separator left aligned.

## Version 3.0.0
- Books: added conversion rules for stories from the Klotzverse (authored by Eliphas).
- Project renamed: removed the "tex" constraint from the name, as we're already using the filter with different input formats.

## Version 2.1.0
- Typography: added some filter functions for English single and double quotes.

## Version 2.0.0
- Feature extension: refactored the script so that multiple books and languages can be handled.

## Version 1.0.1
- Updated to lts 16.1
- Minor adjustments to the parsers (triggered by pre-publication changes in the book manuscript).

## Version 1.0.0

- Created the project.
