.sess_libs <- .libPaths()
source("rv/scripts/rvr.R")
source("rv/scripts/activate.R")

# The VS Code R extension (>= 3.0) attaches through the `sess` package, which is
# installed in the user library that rv hides. Load it and its imports from
# there, preferring the rv library for any package it already provides.
if (interactive() && identical(Sys.getenv("TERM_PROGRAM"), "vscode")) {
  try(local({
    lib <- c(.libPaths(), .sess_libs)
    imports <- utils::packageDescription("sess", lib.loc = lib)$Imports
    pkgs <- trimws(sub("\\(.*", "", strsplit(imports, ",")[[1]]))
    for (p in c(pkgs, "sess")) loadNamespace(p, lib.loc = lib)
  }), silent = TRUE)
}
rm(.sess_libs)
