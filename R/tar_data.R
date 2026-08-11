# Datasets the chapters read. Both are kept out of git: the Parquet file is too
# large, and the e-Stat table needs an API key to fetch.

# Download one month of NYC TLC Yellow Taxi trip records (Parquet) into data/.
# Used by lesson/largedata.qmd. The file is gitignored; this target fetches it
# on demand and skips the download if it is already present.
# Source: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
download_taxi <- function(path) {
  if (!file.exists(path)) {
    dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
    url <- paste0(
      "https://d37ci6vzurychx.cloudfront.net/trip-data/",
      "yellow_tripdata_2024-01.parquet"
    )
    curl::curl_download(url, path, mode = "wb")
  }
  path
}

# Fetch the 2022 Employment Status Survey (就業構造基本調査) from e-Stat and
# return regular / non-regular / other-employed / not-employed head counts by
# sex and 5-year age band (25-54), plus a 25-54 "Total". Two statsDataId are
# combined: 0004008100 gives the 15+ population and the non-employed, 0004008150
# gives the regular / non-regular split; their employed totals agree exactly.
# Requires an e-Stat application id in the ESTAT_APP_ID environment variable.
# Used by lesson/visualization.qmd (drawn there via tar_read()).
fetch_employment_status <- function() {
  app_id <- Sys.getenv("ESTAT_APP_ID")
  ages <- c("03", "04", "05", "06", "07", "08")
  age_lab <- c(
    "03" = "25-29",
    "04" = "30-34",
    "05" = "35-39",
    "06" = "40-44",
    "07" = "45-49",
    "08" = "50-54"
  )

  # 15+ population and work status (includes the non-employed).
  pop <- estatapi::estat_getStatsData(
    appId = app_id,
    statsDataId = "0004008100",
    cdArea = "00000",
    cdCat01 = c("1", "2"),
    cdCat02 = "0",
    cdCat04 = "0",
    cdCat03 = ages,
    cdCat05 = c("0", "1", "2")
  ) |>
    dplyr::transmute(
      sex = dplyr::recode(cat01_code, "1" = "male", "2" = "female"),
      age_group = unname(age_lab[cat03_code]),
      status = dplyr::recode(
        cat05_code,
        "0" = "pop",
        "1" = "employed",
        "2" = "not_employed"
      ),
      value
    ) |>
    tidyr::pivot_wider(names_from = status, values_from = value)

  # Regular / non-regular split among the employed.
  emp <- estatapi::estat_getStatsData(
    appId = app_id,
    statsDataId = "0004008150",
    cdArea = "00000",
    cdCat01 = c("1", "2"),
    cdCat02 = "0",
    cdCat04 = "00",
    cdCat05 = "00",
    cdCat03 = ages,
    cdCat06 = c("11", "12")
  ) |>
    dplyr::transmute(
      sex = dplyr::recode(cat01_code, "1" = "male", "2" = "female"),
      age_group = unname(age_lab[cat03_code]),
      status = dplyr::recode(cat06_code, "11" = "regular", "12" = "nonregular"),
      value
    ) |>
    tidyr::pivot_wider(names_from = status, values_from = value)

  wide <- dplyr::left_join(pop, emp, by = c("sex", "age_group")) |>
    dplyr::mutate(other_employed = employed - regular - nonregular) |>
    dplyr::select(
      sex,
      age_group,
      regular,
      nonregular,
      other_employed,
      not_employed
    )

  total <- wide |>
    dplyr::summarise(dplyr::across(regular:not_employed, sum), .by = sex) |>
    dplyr::mutate(age_group = "Total")

  dplyr::bind_rows(wide, total) |>
    tidyr::pivot_longer(
      regular:not_employed,
      names_to = "status",
      values_to = "n"
    )
}

tar_data <- tar_plan(
  tar_target(
    taxi_parquet,
    download_taxi("data/yellow_tripdata_2024-01.parquet"),
    format = "file"
  ),
  employment_status = fetch_employment_status()
)
