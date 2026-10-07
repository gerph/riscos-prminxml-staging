# RISC OS staging documents

This repository holds PRM-in-XML documents (`src/<area>/.../<name>.xml`) and an
`index.xml` that builds them into one indexed manual set. Use the
`writing-prminxml` skill for the document format.

## Adding a new document

1. Lint it alone: `riscos-prminxml -f lint src/<path>.xml`.
2. Check the language: British English in prose (`licence` as a noun,
   `-ise`, `behaviour`, `dispatcher`), and run the words through
   `/usr/share/dict/british-english-large`. Fix prose only; never change
   identifiers (SWI, error, message or system variable names) or values
   belonging to another format.
3. Add a `<page href="...">` to `index.xml` in the section matching the
   subject (`3rdparty`, `riscos5`, `select/...`, `acorn`). `href` is the path
   under the section `dir`, without `.xml`.
4. Check there are no trailing spaces in the changed files.
5. `make lint` and `make output`; check the new files do not appear in the
   failure list, then commit on a feature branch, naming the files explicitly.

## Known build noise

* `make lint` currently reports validation failures from older documents
  (`src/acorn/*`, `filters-iconborders`, `iconpriorities`, some networking
  pages, `rtc`). They are not caused by newly added documents.
* Header generation (`output/header/*.h`) reports ignored errors for every
  document because the stylesheet cannot be fetched; this is an environment
  limitation.
* `logs/`, `output/`, `tmp/` are build products and are not committed.
