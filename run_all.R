# run_all.R
# NYC Nonparametric Analysis — Master Run Script
#
# This script renders all 3 R Markdown files and combines results.
# Run this once to produce PDFs, HTML reports, and the combined results CSV.
#
# Usage (from project root):
#   Rscript run_all.R
#   — or —
#   source("run_all.R")   in RStudio
#
# Author : Dharani Bhumireddy
# Project: Nonparametric Analysis of NYC Public Safety Events (2015–2024)
# Course : Applied Statistics — M.S. Data Science, University at Albany, SUNY
#Supervisor: Mian Adnan, Assistant Professor, Department of Mathematics & Statistics, University at Albany, SUNY
# ── install packages if needed ─────────────────────────────────────────────
required_pkgs <- c(
  "rmarkdown", "knitr",
  "dplyr", "tidyr", "stringr", "lubridate", "purrr",
  "readr", "ggplot2", "tseries", "coin",
  "scales", "RColorBrewer", "gridExtra"
)
new_pkgs <- required_pkgs[!(required_pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs)) {
  install.packages(new_pkgs, repos = "https://cran.r-project.org")
}
invisible(lapply(required_pkgs, library, character.only = TRUE))

cat("=" , strrep("=", 59), "\n")
cat("  NYC Nonparametric Analysis — Master Run Script\n")
cat("  Author: Dharani Bhumireddy\n")
cat("  M.S. Data Science | University at Albany, SUNY\n")
cat("=", strrep("=", 59), "\n\n")

# ── create output directories ──────────────────────────────────────────────
dirs_needed <- c(
  "outputs/assaults_thefts",
  "outputs/road_accidents",
  "outputs/fire_incidents",
  "outputs/combined",
  "data/NYC_ASSAULTS_THEFTS",
  "data/NYC_ROAD_ACCIDENTS",
  "data/NYC_FIRE_INCIDENTS"
)
for (d in dirs_needed) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

# ── render each Rmd ────────────────────────────────────────────────────────
rmd_files <- list(
  list(
    rmd    = "R/ASSAULTS_THEFTS.Rmd",
    label  = "Assaults & Thefts",
    n_tests = 12
  ),
  list(
    rmd    = "R/ROAD_ACCIDENTS.Rmd",
    label  = "Road Accidents",
    n_tests = 11
  ),
  list(
    rmd    = "R/FIRE_INCIDENTS.Rmd",
    label  = "Fire Incidents",
    n_tests = 10
  )
)

render_times <- list()
for (f in rmd_files) {
  cat("──────────────────────────────────────────────────────\n")
  cat("  Rendering:", f$label, "(", f$n_tests, "tests )\n")
  cat("  File:", f$rmd, "\n")
  cat("──────────────────────────────────────────────────────\n")

  start_time <- proc.time()

  tryCatch({
    # Render PDF
    rmarkdown::render(
      input       = f$rmd,
      output_format = "pdf_document",
      output_dir  = paste0("outputs/", tolower(gsub(" & ", "_", f$label)),
                           gsub(" ", "_", f$label)),
      quiet       = FALSE,
      envir       = new.env(parent = globalenv())
    )
    cat("  ✓ PDF rendered successfully\n")

    # Render HTML
    rmarkdown::render(
      input       = f$rmd,
      output_format = "html_document",
      output_dir  = paste0("outputs/", tolower(gsub(" & ", "_", f$label)),
                           gsub(" ", "_", f$label)),
      quiet       = FALSE,
      envir       = new.env(parent = globalenv())
    )
    cat("  ✓ HTML rendered successfully\n")
  }, error = function(e) {
    cat("  ✗ Error rendering", f$label, ":\n")
    cat("    ", conditionMessage(e), "\n")
  })

  elapsed <- proc.time() - start_time
  render_times[[f$label]] <- elapsed["elapsed"]
  cat("  Time:", round(elapsed["elapsed"], 1), "seconds\n\n")
}

# ── combine all test results ───────────────────────────────────────────────
cat("Combining test results from all datasets...\n")

result_files <- c(
  "outputs/assaults_thefts/Assaults_Thefts_Test_Results.csv",
  "outputs/road_accidents/Road_Accidents_Test_Results.csv",
  "outputs/fire_incidents/Fire_Incidents_Test_Results.csv"
)

dataset_labels <- c("Assaults & Thefts", "Road Accidents", "Fire Incidents")

combined_results <- lapply(seq_along(result_files), function(i) {
  path <- result_files[i]
  if (file.exists(path)) {
    df <- read.csv(path, stringsAsFactors = FALSE)
    df$Dataset <- dataset_labels[i]
    df
  } else {
    cat("  ⚠ Missing:", path, "\n")
    NULL
  }
})

combined_results <- Filter(Negate(is.null), combined_results)

if (length(combined_results) > 0) {
  all_tests <- dplyr::bind_rows(combined_results)

  # Reorder columns
  first_cols <- c("Dataset", "Test_Num", "Test")
  rest_cols  <- setdiff(names(all_tests), first_cols)
  all_tests  <- all_tests[, c(first_cols, rest_cols)]

  # Save
  combined_path <- "outputs/combined/ALL_33_Nonparametric_Test_Results.csv"
  write.csv(all_tests, combined_path, row.names = FALSE)
  cat("  ✓ Combined results saved to:", combined_path, "\n\n")

  # Print summary
  n_sig   <- sum(grepl("Reject", all_tests$Decision) &
                 !grepl("Fail",   all_tests$Decision), na.rm = TRUE)
  n_total <- nrow(all_tests)

  cat("=", strrep("=", 59), "\n")
  cat("  ANALYSIS COMPLETE — SUMMARY\n")
  cat("=", strrep("=", 59), "\n")
  cat(sprintf("  Total tests run        : %d\n", n_total))
  cat(sprintf("  Significant (p<0.05)   : %d  (%.1f%%)\n",
              n_sig, n_sig / n_total * 100))
  cat(sprintf("  Not significant        : %d  (%.1f%%)\n",
              n_total - n_sig, (n_total - n_sig) / n_total * 100))
  cat("\n  By dataset:\n")
  dataset_summary <- all_tests %>%
    dplyr::group_by(Dataset) %>%
    dplyr::summarise(
      total = dplyr::n(),
      sig   = sum(grepl("Reject", Decision) & !grepl("Fail", Decision),
                  na.rm = TRUE),
      .groups = "drop"
    )
  for (i in seq_len(nrow(dataset_summary))) {
    cat(sprintf("    %-22s : %d/%d significant\n",
                dataset_summary$Dataset[i],
                dataset_summary$sig[i],
                dataset_summary$total[i]))
  }
  cat("\n  Output files:\n")
  cat("    outputs/assaults_thefts/   — PDF, HTML, cleaned CSV, test results\n")
  cat("    outputs/road_accidents/    — PDF, HTML, cleaned CSV, test results\n")
  cat("    outputs/fire_incidents/    — PDF, HTML, cleaned CSV, test results\n")
  cat("    outputs/combined/          — ALL 33 tests combined CSV\n")
  cat("=", strrep("=", 59), "\n")
}
