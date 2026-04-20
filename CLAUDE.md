# CLAUDE.md

## Project

R/Quarto analysis of a survey experiment measuring normative prerequisites of parenthood in the Czech Republic. Respondents rated parental readiness of couples whose traits were varied randomly across 6 components (vignette gender, partnership status, housing, daycare availability, employment stability, income). The main output is `analysis.html`, a self-contained rendered document.

The user works in **Positron** (not RStudio). The `.Rproj` file is kept as a project root marker but the `.Rproj.user/` directory is gitignored and should not be recreated.

## File structure

- `analysis.qmd` — the entire analysis: data cleaning → descriptive stats → mixed effects models → plots
- `config.R` — sets `data_path`, `output_plots`, `output_tables` to local subfolders
- `data/` — place `original_data.sav` here (gitignored, not in repo)
- `plots/` — ggsave outputs land here (gitignored)
- `tables/` — Word table exports land here (gitignored)

## Key design decisions

- Data is an SPSS `.sav` file loaded with `haven::read_sav()`, converted to factors with `as_factor()`, snake_cased with `janitor::clean_names()`
- Raw data is wide (6 vignettes per row); a three-step column rename dance moves the vignette number from prefix to suffix so `pivot_longer` can split on the trailing `_1`–`_6`
- `vskol_fix` is a corrected version of `vskol` (daycare availability) — the original factor levels were reversed and are fixed after the pivot
- Income (`vplat`) reference category is 39,000 CZK (middle level)
- `stej` (not `stejne`) is the variable flagging respondents who saw repeated vignettes
- `model_variable_levels` (built in `AMCE-plot-data-cleaning`) is reused in both interaction plot wrangling chunks — it provides the full variable/level scaffold for inserting reference category rows at zero
- `components` is defined once in `MM-plot-data-cleaning` and reused downstream
- `sjmisc::add_rows()` is used instead of `dplyr::bind_rows()` to preserve haven labels

## Models

All models are `lmer` with respondent random intercepts. Hypothesis tests use Kenward-Rogers F-tests (`pbkrtest::KRmodcomp`) comparing each interaction model to `m_base_mod`. Only `m_interaction_woman` and `m_interaction_income` are plotted; the others (`m_interaction_r_sex`, `m_interaction_r_housing`, `m_interaction_r_parent`) appear only in the F-test table.

## Session log — 2026-04-20

Migrated project from OneDrive-based paths to local `data/`, `plots/`, `tables/` folders. Replaced `config.R` with simple relative paths. Removed `.Rhistory` and `.Rproj.user/`. Set `editor: source` in YAML. Fixed a batch of bugs (redundant `relevel`, dead `scale_y_discrete`, wrong `warning:` option spelling, `stejne` → `stej` in prose, stale OneDrive references). Removed dead code (`q3rec`, duplicate `components` definitions, commented-out titles and filter, `scales`/`stringr` from explicit library list). Aligned income interaction section structure with woman section. Separated patchwork export into its own chunk. Full render passed with no errors (52 chunks).
