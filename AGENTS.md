# RISC OS staging documents

This repository holds PRM-in-XML documents (`src/<area>/.../<name>.xml`) and an
`index.xml` that builds them into one indexed manual set. Use the
`writing-prminxml` skill for the document format.

## Adding a new document

1. New documents use the 1.03 DTD (`-//Gerph//DTD PRM documentation 1.03//EN`,
   `http://gerph.org/dtd/103/prm.dtd`); do not use 1.02.
2. Lint it alone: `riscos-prminxml -f lint src/<path>.xml`.
3. Check the language: British English in prose (`licence` as a noun,
   `-ise`, `behaviour`, `dispatcher`), and run the words through
   `/usr/share/dict/british-english-large`. Fix prose only; never change
   identifiers (SWI, error, message or system variable names) or values
   belonging to another format.
4. Add a `<page href="...">` to `index.xml` in the section matching the
   subject (`3rdparty`, `riscos5`, `select/...`, `acorn`). `href` is the path
   under the section `dir`, without `.xml`.
5. Check there are no trailing spaces in the changed files.
6. `make lint` and `make output`; check the new files do not appear in the
   failure list, then commit on a feature branch, naming the files explicitly.

## Converting the captured HTML in `riscos6/`

The `riscos6/<area>/*.html` pages are captures of the original documentation.
Convert each page to `src/select/<area>/<name>.xml`, one commit per page.

1. Read the whole page, and list the pages already converted in `src/` first.
   Where a document already exists, compare it with the HTML and add only the
   information which it lacks; do not rewrite it, and leave its history alone.
2. Compare each page with the original documentation text where it is available, since
   the captured HTML lost some text (for example anything in angle brackets).
3. Keep all of the information. Restructure it (SWI definitions, service
   definitions with reason codes, tables for layouts and bit fields), but do
   not summarise. Keep the original's rationale, warnings and examples.
4. Where the original has an evident slip (a copy-pasted description, a
   duplicated entry number, a misspelt name), correct it and say so in the
   `<change>` of the PRM-in-XML revision. Leave SWI, service and variable names
   as they are written unless they are clearly wrong.
5. Metadata: maintainer Charles Ferguson; disclaimer '&copy; Gerph, 2006-<year>'
   (the capture footer says 3QD Developments Ltd 2013, which is not carried
   over; the original text dates from 2006); revision 1
   'Original documentation' dated 2006, noting that it was captured as HTML
   document version 1.03 (3 Nov 2015), then the PRM-in-XML revision.
6. Check the SWI and service numbers against the HTML, and the entry numbers of
   library chunks for gaps.
7. Add the page to `index.xml`, then lint, build and commit the XML and
   `index.xml` together.

Format points which cause lint failures:

* `<value-table>`, `<offset-table>` and `<bitfield-table>` must be inside a
  `<p>` when they are in a `<use>` or a subsection; in `<register-use>` they
  can stand alone.
* `<item>` may not contain `<userinput>` or `<code>` directly; put the text in
  `<p>` inside the `<item>`.
* `<filename>` takes no attributes in the 1.03 DTD; `<em>` does not exist, use
  `<strong>`.
* A `<service-definition>` needs a `<related>` block, and `<sysvar-definition>`
  is used for system variables.
* A `<reference ... use-description="yes"/>` in running text renders only the
  description, not the name; use a plain reference instead.
* Reference type `subsection` (not `section`) is needed to link to a
  subsection by title.
* `number` and `reason` attributes are hexadecimal: write `&hex;3C` in text,
  and give the decimal value in brackets where the original used it.

## Known build noise

* `make lint` currently reports validation failures from older documents
  (`src/acorn/*`, `filters-iconborders`, `iconpriorities`, some networking
  pages, `rtc`). They are not caused by newly added documents.
* Header generation (`output/header/*.h`) reports ignored errors for every
  document because the stylesheet cannot be fetched; this is an environment
  limitation.
* `logs/`, `output/`, `tmp/` are build products and are not committed.
