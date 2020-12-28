# replace-md

[![build status](https://github.com/paasim/replace-md/workflows/check/badge.svg)](https://github.com/paasim/replace-md/actions)

A haskell command-line tool for inserting/replacing sections in markdown-documents.

## Install
Can be installed with [stack] by running

    stack install replace-md

## Examples

The following example shows how the section `### second subsection` is updated from a separate file:

```bash
$ # An example document
$ cat file.md
# An example

## first section

1st section.

Contents.

### first subsection

1.1.

### second subsection

1.2.

#### subsubsection

This will be replaced.

### third subsection

1.3.


## second section

This is the last section.

The end.


$ # Contents of an updated second section
$ cat contents.md
### second subsection

This is an updated version of the second subsection.

Contents of the second subsection.

#### subsubsections can also exist

This is a fact.


$ # Update the contents using replace-md
$ cat file.md | replace-md-exe contents.md
# An example

## first section

1st section.

Contents.

### first subsection

1.1.

### second subsection

This is an updated version of the second subsection.

Contents of the second subsection.

#### subsubsections can also exist

This is a fact.

### third subsection

1.3.


## second section

This is the last section.

The end.
```

