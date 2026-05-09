# Nonparametric Analysis of NYC Public Safety Events (2015–2024)

![R](https://img.shields.io/badge/R-4.3%2B-blue)
![Tests](https://img.shields.io/badge/nonparametric%20tests-33-orange)
![Datasets](https://img.shields.io/badge/datasets-3%20NYC%20Open%20Data-green)
![Records](https://img.shields.io/badge/records-%E2%89%8812.55M-red)

**Dharani Bhumireddy**
M.S. Data Science | University at Albany, State University of New York (SUNY)
Nonparametric Statistics Course Project | Period of Analysis: 2015–2024

**Supervisor:** Mian Adnan, Assistant Professor, Department of Mathematics & Statistics, University at Albany, SUNY
---

## Project Overview

This project performs a comprehensive nonparametric statistical analysis of three
large NYC public safety datasets covering the period 2015–2024:

| Dataset | Records | Columns | Size | Agency |
|---|---|---|---|---|
| **Road Accidents** | 1,636,872 | 29 | ~850 MB | NYPD |
| **Assaults & Thefts** | 4,861,139 | 35 | ~2.4 GB | NYPD |
| **Fire Incidents** | 6,054,083 | 29 | ~1.9 GB | FDNY |
| **Total** | **≈12.55 million** | — | **≈5.15 GB** | — |

### Why Nonparametric Methods?

The distributions of accident counts, response times, injury counts, and crime
indicators are heavily skewed, contain outliers, and do not satisfy normality
assumptions required by parametric tests. Nonparametric tests make no distribution
assumptions and are appropriate for:
- Ordinal data (age groups, offense severity codes)
- Count data (daily accident counts per borough)
- Time-series data (monthly incident sequences)
- Large-sample rank-based inference

---

## File Structure

```
nyc-nonparam-analysis/
│
├── R/
│   ├── ASSAULTS_THEFTS.Rmd    ← 12 nonparametric tests + 5 visualizations
│   ├── ROAD_ACCIDENTS.Rmd     ← 11 nonparametric tests + 6 visualizations
│   └── FIRE_INCIDENTS.Rmd     ← 10 nonparametric tests + 5 visualizations
│
├── data/
│   ├── NYC_ASSAULTS_THEFTS/   ← Place raw CSV parts here (download links below)
│   ├── NYC_ROAD_ACCIDENTS/    ← Place raw CSV parts here
│   └── NYC_FIRE_INCIDENTS/    ← Place raw CSV parts here
│
├── outputs/
│   ├── assaults_thefts/       ← Cleaned data, test results CSV, PDF, HTML
│   ├── road_accidents/        ← Cleaned data, test results CSV, PDF, HTML
│   ├── fire_incidents/        ← Cleaned data, test results CSV, PDF, HTML
│   └── combined/              ← ALL_33_Nonparametric_Test_Results.csv
│
├── run_all.R                  ← Master script: renders all 3 Rmd files
├── .gitignore
└── README.md
```

---

## Data Download

**The raw data files are too large for GitHub (5.15 GB total).**
Download each dataset from NYC Open Data and place the CSV parts in the
corresponding `data/` subfolder.

### Road Accidents
- **Source:** NYPD Motor Vehicle Collisions — Crashes
- **URL:** https://data.cityofnewyork.us/Transportation/Motor-Vehicle-Collisions-Crashes/h9gi-nx95
- **Place files in:** `data/NYC_ROAD_ACCIDENTS/`
- **Rename to:** `NYC_1_ROAD_ACCIDENTS_RAW.csv`, `NYC_2_...`, etc.

### Assaults & Thefts
- **Source:** NYPD Complaint Data Historic
- **URL:** https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
- **Filter:** OFNS_DESC contains "ASSAULT" OR "LARCENY" OR "ROBBERY"
- **Place files in:** `data/NYC_ASSAULTS_THEFTS/`
- **Rename to:** `NYC_1_ASSAULTS_THEFTS_RAW.csv`, `NYC_2_...`, etc.

### Fire Incidents
- **Source:** FDNY Fire Incident Dispatch Data
- **URL:** https://data.cityofnewyork.us/Public-Safety/Fire-Incident-Dispatch-Data/8m42-w767
- **Place files in:** `data/NYC_FIRE_INCIDENTS/`
- **Rename to:** `NYC_1_FIRE_INCIDENTS_RAW.csv`, `NYC_2_...`, etc.

---

## How to Run

### Option 1 — Run everything at once

```r
# From project root in RStudio or R console
source("run_all.R")
```

This renders all 3 Rmd files (PDF + HTML), saves cleaned CSVs,
saves test result CSVs, and combines all 33 results.

### Option 2 — Run individually in RStudio

```r
# Assaults & Thefts (12 tests)
rmarkdown::render("R/ASSAULTS_THEFTS.Rmd", output_format = "pdf_document")

# Road Accidents (11 tests)
rmarkdown::render("R/ROAD_ACCIDENTS.Rmd", output_format = "pdf_document")

# Fire Incidents (10 tests)
rmarkdown::render("R/FIRE_INCIDENTS.Rmd", output_format = "pdf_document")
```

### Option 3 — Knit in RStudio

Open any `.Rmd` file → click the **Knit** button → choose PDF or HTML.

### Update data paths

Before running, update the file paths in the `file-paths` chunk of each Rmd:

```r
# In R/ASSAULTS_THEFTS.Rmd
paths <- c(
  "data/NYC_ASSAULTS_THEFTS/NYC_1_ASSAULTS_THEFTS_RAW.csv",
  # ... your actual file names
)
```

---

## Required R Packages

All packages are installed automatically when you run the scripts.

| Package | Version | Purpose |
|---|---|---|
| `dplyr` | ≥1.1 | Data manipulation |
| `tidyr` | ≥1.3 | Pivoting and reshaping |
| `lubridate` | ≥1.9 | Date/time parsing |
| `stringr` | ≥1.5 | String cleaning |
| `readr` | ≥2.1 | Fast CSV reading |
| `ggplot2` | ≥3.4 | All visualizations |
| `scales` | ≥1.2 | Axis formatting |
| `tseries` | ≥0.10 | Runs Test |
| `coin` | ≥1.4 | Permutation tests |
| `knitr` | ≥1.43 | Table formatting |
| `rmarkdown` | ≥2.25 | Document rendering |
| `RColorBrewer` | ≥1.1 | Color palettes |
| `gridExtra` | ≥2.3 | Multi-panel plots |

---

## All 33 Nonparametric Tests

### Assaults & Thefts (12 Tests)

| # | Test | Variables | H₀ |
|---|---|---|---|
| 1 | Sign Test | ADDR_PCT_CD vs median=100 | Median equals 100 |
| 2 | Wilcoxon Signed Rank (1-sample) | KY_CD | Distribution symmetric |
| 3 | Mann-Whitney U | ADDR_PCT_CD: Manhattan vs Brooklyn | Same distribution |
| 4 | Kruskal-Wallis | ADDR_PCT_CD across 5 boroughs | All distributions equal |
| 5 | Kolmogorov-Smirnov | ADDR_PCT_CD: Manhattan vs Queens | Same distribution shape |
| 6 | Spearman Correlation | ADDR_PCT_CD vs KY_CD | No monotonic association |
| 7 | Spearman Correlation Matrix | Victim vs Suspect age group codes | No rank association |
| 8 | Permutation Test | Mean KY_CD: Manhattan vs Brooklyn | Means equal under permutation |
| 9 | Sign + Wilcoxon + KW | Victim vs Suspect age groups | Age groups do not differ |
| 10 | Mann-Whitney + KW + KS | KY_CD: Bronx vs Queens | Same distribution |
| 11 | Spearman + KS | Borough code vs offense severity | No association |
| 12 | Permutation Test | Median ADDR_PCT_CD: Manhattan vs Brooklyn | Medians equal |

### Road Accidents (11 Tests)

| # | Test | Variables | H₀ |
|---|---|---|---|
| 1 | Permutation Test | LATITUDE vs LONGITUDE | No spatial dependence |
| 2 | Kruskal-Wallis | Daily counts across boroughs | Equal distributions |
| 3 | Wilcoxon Rank Sum | Monthly counts: 2015 vs 2020 | No year-to-year change |
| 4 | Mann-Whitney U | Injuries: Weekday vs Weekend | Same distribution |
| 5 | Spearman Correlation | Motorist injuries vs Cyclist injuries | No monotonic association |
| 6 | Kendall's Tau | Persons injured vs Killed | No concordance |
| 7 | Kruskal-Wallis | Accident year across boroughs | Same year distribution |
| 8 | Kruskal-Wallis | Fatalities by vehicle type | Equal fatality rates |
| 9 | Friedman Test | Accident counts: Year × Borough | No year × borough effect |
| 10 | Runs Test | Monthly accident sequence | Sequence is random |
| 11 | Wilcoxon Signed Rank | Pre vs Post 2019 monthly counts | No policy impact |

### Fire Incidents (10 Tests)

| # | Test | Variables | H₀ |
|---|---|---|---|
| 1 | Sign Test | Dispatch response time vs 0 | Median equals zero |
| 2 | Wilcoxon Signed Rank (paired) | Dispatch vs Incident response | Equal (paired) |
| 3 | Wilcoxon Rank Sum | Response: Top-2 ZIP codes | Equal distributions |
| 4 | Kruskal-Wallis | Response across Council Districts | All equal |
| 5 | Kolmogorov-Smirnov | Response distributions: Top-2 ZIPs | Same shape |
| 6 | Spearman Correlation | Dispatch time vs Incident response | No association |
| 7 | Kendall's Tau | Travel time vs Incident response | No concordance |
| 8 | Spearman Correlation | Travel time vs Incident response | No rank association |
| 9 | Friedman Test | Response time: Year × Borough | No year × borough effect |
| 10 | Runs Test | Monthly fire incident sequence | Sequence is random |

---

## Key Outputs per Dataset

Each Rmd produces:

| Output | Location |
|---|---|
| Cleaned dataset (CSV) | `outputs/{dataset}/xxx_cleaned.csv` |
| Test results table (CSV) | `outputs/{dataset}/xxx_Test_Results.csv` |
| PDF report | `outputs/{dataset}/xxx.pdf` |
| HTML report | `outputs/{dataset}/xxx.html` |
| 5–6 visualizations (embedded in report) | — |

---

## Visualizations

Each Rmd contains these charts (embedded in the PDF/HTML output):

### Assaults & Thefts
1. Bar — Incident count by borough
2. Line — Yearly trend by borough (with 2019 policy line)
3. Bar (horizontal) — Top 10 offense types
4. Heatmap — Victim vs Suspect age group cross-tabulation
5. Bar — Monthly seasonality by borough

### Road Accidents
1. Bar — Accident count by borough
2. Line — Yearly trend by borough
3. Bar (horizontal) — Injuries by vehicle type
4. Histogram — Weekday vs Weekend injury distribution
5. Heatmap — Monthly × Borough accident counts
6. Scatter — Motorist vs Cyclist injuries (Spearman)

### Fire Incidents
1. Bar — Median response time by borough (with FDNY 6-min target line)
2. Stacked bar — Response time components (Dispatch + Travel)
3. Line — Yearly response time trend
4. ECDF — Top-2 ZIP code response distributions (KS Test)
5. Scatter — Travel time vs Total response (Spearman)

---

## Reproducibility

All analyses are fully reproducible. Deterministic transformations:
- Date/time parsing with explicit format orders
- `set.seed(42)` for all permutation tests
- Column name standardization (uppercase, underscore-separated)
- Identical cleaning logic across all file parts before `bind_rows()`

To replicate exactly: download the data, update paths, run `source("run_all.R")`.

---


