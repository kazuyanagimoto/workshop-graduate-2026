# Repository conventions

## Prose: one paragraph per line (do NOT hard-wrap)

In `.qmd` and `.md` files, write each **paragraph as a single physical line**.
Do not insert line breaks within a paragraph: no hard-wrapping at ~80 characters, and no "one sentence per line" (semantic line breaks). Separate paragraphs with a blank line, and let the editor/renderer handle visual wrapping.

This **overrides** the machine-wide `quarto-r` skill rule that asks for one sentence per line. In this repository, sentences within a paragraph stay on the same line.

Scope: prose only. Keep code chunks formatted normally (the R formatter / `air` governs those), and keep list items, table rows, and YAML one-per-line as usual.

## Prose: use bold very sparingly

Default to plain text. Do not use bold (`**...**`) for routine emphasis; overusing it makes the text harder to read, not easier.

Reserve bold for at most one of these per passage:

- the single most important point of a section, or
- a structural label that starts a parallel item (e.g. a term being defined in a list, like `- ORC: ...`).

Do NOT bold technical terms, concept names, tool/package names, or numbers just to make them stand out. Terminology is not emphasis; readers will notice it anyway. When in doubt, leave it plain.

This applies to all prose (`.qmd`, `.md`); it generalises the `quarto-r` skill's "bold sparingly" slide rule to the whole repository.

## Code: write all comments in English

Write every comment and docstring in code in English. This applies to all languages (R, Python, shell, and others), to code chunks in `.qmd` files, and to both new and existing code.

Exception: Japanese is allowed only when it is intrinsic to the operation itself — for example, when the source data is in Japanese and a keyword, column name, or literal used for filtering or matching must be Japanese, and a short note explaining that literal is warranted. String literals and data values in Japanese are of course fine; this rule governs human-facing explanatory comments, not data.
