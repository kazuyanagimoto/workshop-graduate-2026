# Zenn-style link card for a GitHub repository. Fetches the repo metadata
# from the GitHub API at render time (cached afterwards by Quarto's freeze)
# and returns an htmltools tag, so it can be emitted directly from a chunk:
#
#   github_card("owner/repo")
#
# Falls back to a plain link if the API is unreachable (e.g. offline render).
github_card <- function(repo) {
  url <- paste0("https://github.com/", repo)

  info <- tryCatch(
    jsonlite::fromJSON(paste0("https://api.github.com/repos/", repo)),
    error = function(e) NULL
  )
  if (is.null(info)) {
    return(htmltools::tags$a(href = url, url))
  }

  # MIT-licensed GitHub mark from Octicons (mark-github-16)
  octicon <- htmltools::HTML(paste0(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16" fill="currentColor" aria-hidden="true">',
    '<path d="M8 0c4.42 0 8 3.58 8 8a8.013 8.013 0 0 1-5.45 7.59c-.4.08-.55-.17-.55-.38 0-.27.01-1.13.01-2.2 0-.75-.25-1.23-.54-1.48 1.78-.2 3.65-.88 3.65-3.95 0-.88-.31-1.59-.82-2.15.08-.2.36-1.02-.08-2.12 0 0-.67-.22-2.2.82-.64-.18-1.32-.27-2-.27-.68 0-1.36.09-2 .27-1.53-1.03-2.2-.82-2.2-.82-.44 1.1-.16 1.92-.08 2.12-.51.56-.82 1.28-.82 2.15 0 3.06 1.86 3.75 3.64 3.95-.23.2-.44.55-.51 1.07-.46.21-1.61.55-2.33-.66-.15-.24-.6-.83-1.23-.82-.67.01-.27.38.01.53.34.19.73.9.82 1.13.16.45.68 1.31 2.69.94 0 .67.01 1.3.01 1.49 0 .21-.15.45-.55.38A7.995 7.995 0 0 1 0 8c0-4.42 3.58-8 8-8Z"></path>',
    "</svg>"
  ))

  meta <- htmltools::tagList(octicon, htmltools::tags$span("GitHub"))
  if (!is.null(info$language)) {
    meta <- htmltools::tagList(
      meta,
      htmltools::tags$span(class = "github-card-lang-dot"),
      htmltools::tags$span(info$language)
    )
  }
  if (isTRUE(info$stargazers_count > 0)) {
    meta <- htmltools::tagList(
      meta,
      htmltools::tags$span("★"),
      htmltools::tags$span(format(info$stargazers_count, big.mark = ","))
    )
  }

  htmltools::tags$a(
    class = "github-card",
    href = url,
    target = "_blank",
    rel = "noopener",
    htmltools::tags$img(
      class = "github-card-avatar",
      src = paste0("https://github.com/", info$owner$login, ".png?size=120"),
      alt = paste0("GitHub avatar of ", info$owner$login)
    ),
    htmltools::tags$div(
      class = "github-card-body",
      htmltools::tags$div(class = "github-card-title", info$full_name),
      if (!is.null(info$description)) {
        htmltools::tags$div(class = "github-card-desc", info$description)
      },
      htmltools::tags$div(class = "github-card-meta", meta)
    )
  )
}
