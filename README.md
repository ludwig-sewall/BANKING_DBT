# Manufacturing — dbt mesh demo

Ten-plant manufacturer: production (MES), maintenance (CMMS) and quality (QMS), joined on `plant_key`.

Every directory below is its own dbt project. `group_analytics` reads only the public models of the
source projects via cross-project `ref()`. Every project installs `platform/` as a local package for
shared macros and generic tests.

| Directory | Platform project | Public models | Models (stg / int / marts) |
|---|---|---|---|
| `platform/` | `op_platform` | Shared macros and generic tests (installed as a local package by every project), `dim_calendar` | — |
| `production/` | `op_production` | `dim_production_plants`, `dim_production_machines`, `fct_production_runs`, `fct_production_machine_monthly`, `fct_production_plant_monthly` | 3 / 3 / 5 |
| `maintenance/` | `op_maintenance` | `dim_maintenance_work_centers`, `dim_maintenance_equipment`, `fct_maintenance_work_orders`, `fct_maintenance_work_center_monthly` | 4 / 3 / 4 |
| `quality/` | `op_quality` | `dim_quality_inspection_sites`, `fct_quality_inspections`, `fct_quality_defect_pareto`, `fct_quality_site_monthly` | 4 / 3 / 4 |
| `group_analytics/` | `op_group_analytics` | `dim_plant_360`, `fct_plant_monthly`, `fct_machine_reliability`, `dim_plant_scorecards` | 0 / 5 / 5 |

## Raw data

Loaded into Snowflake `RAW_*` schemas by provisioning (not dbt seed). Reporting date is
`as_of_date` = 2026-03-31; history covers April 2025 to March 2026.

| Table | Rows | Contents |
|---|---:|---|
| `raw_production.plants` | 10 | One row per plant; plant_key is shared with maintenance and quality. |
| `raw_production.machines` | 53 | One row per machine with its rated output. |
| `raw_production.production_runs` | 2533 | One row per production run. Aborted runs stop early. |
| `raw_maintenance.work_centers` | 9 | One row per plant maintenance team. Lyon outsources maintenance and has none. |
| `raw_maintenance.equipment` | 46 | Maintained equipment. machine_serial is the MES machine_id. |
| `raw_maintenance.work_orders` | 828 | Preventive and corrective work orders. |
| `raw_maintenance.parts_usage` | 932 | Spare parts booked against work orders. |
| `raw_quality.inspection_sites` | 10 | One QA site per plant. |
| `raw_quality.inspections` | 1667 | Sampled inspections; pending ones are from the last two days. |
| `raw_quality.defects` | 1816 | Defects found during inspections, by code and severity. |
| `raw_quality.complaints` | 41 | Customer complaints traced back to a site. |

- Plants have a health profile: Gdańsk and Porto run older kit with lower availability, more breakdowns, more scrap and more complaints.
- Ghent closed in December 2025, so its history stops there. Lyon outsources maintenance and has no CMMS work center.
- Maintenance equipment carries the MES machine_id as machine_serial, so group_analytics can join machines across systems.
- Inspections from the last two days are pending; defect rows add up to defective units on each inspection.

## Layout

```text
manufacturing/
  skeleton.json                      # projects, dependencies, raw data location (read by provisioning)
  raw_data/raw_<domain>/<table>.csv  # source data, loaded into RAW_* schemas
  platform/                          # macros, generic tests, dim_calendar
  <domain>/
    dependencies.yml                 # local package ../platform (+ upstream projects for group_analytics)
    models/staging/<source>/         # stg_<source>__<table>: rename, cast, decode; 1:1 with raw tables
    models/intermediate/             # int_<entity>__<verb>: joins and aggregation
    models/marts/                    # dim_* / fct_*: tables; public models carry enforced contracts
    tests/                           # assert_* singular tests (unit tests live next to the models)
  scripts/check_naming.py
```

## Conventions

- Only staging models select from sources. Marts never read staging directly when an intermediate exists.
- Shared logic lives in `platform` macros: `platform.money`, `platform.safe_divide`, `platform.month_start`,
  `platform.add_months`, `platform.days_between`, `platform.as_of_date`, `platform.anonymize`.
- Generic tests `platform.non_negative` and `platform.in_range` come from the same package.
- Public models have `access: public` and an enforced contract. Everything else stays `protected`.
- Names are snake_case with `stg_`, `int_`, `dim_`, `fct_`, `assert_` prefixes; CI runs `scripts/check_naming.py`.

## Testing

Every model has a grain test, every source table a key test, and every project has unit and singular
tests. `scripts/check_test_coverage.py` enforces this in CI; the counts below come from it.

| Project | Models | Built-in | Custom (platform) | Package (hub) | Source | Singular | Unit |
|---|---:|---:|---:|---:|---:|---:|---:|
| `platform` | 2 | 4 | 3 | 2 | 0 | 4 | 1 |
| `production` | 11 | 31 | 12 | 9 | 6 | 2 | 1 |
| `maintenance` | 11 | 36 | 4 | 5 | 8 | 2 | 1 |
| `quality` | 11 | 31 | 6 | 5 | 8 | 2 | 1 |
| `group_analytics` | 10 | 23 | 4 | 3 | 0 | 2 | 1 |

| Test type | What it shows | Where to look |
|---|---|---|
| Built-in generic | `unique`, `not_null`, `accepted_values`, `relationships` (also on sources) | `production/models/marts/_production__models.yml` |
| Custom generic | Tests written once as Jinja macros in `platform`: `platform.non_negative`, `platform.in_range`, `platform.not_after_as_of`, `platform.sums_match` (reconciles totals, also across projects) | `platform/macros/generic_tests/`, `group_analytics/models/marts/_group_analytics__models.yml` |
| Package (hub.getdbt.com) | `dbt_utils.unique_combination_of_columns` (grain), `expression_is_true`, `equal_rowcount`, `accepted_range` with `where`, `not_constant`, `at_least_one`; `dbt_expectations.expect_column_values_to_match_regex` (ID formats), `expect_table_row_count_to_be_between` | `dependencies.yml`, any `_*__models.yml` |
| Templated singular | One Jinja loop stamps the same check over every public model (`assert_public_models_not_empty`) | `<project>/tests/assert_public_models_not_empty.sql` |
| Singular | Hand-written SQL assertions for rules that do not fit a generic test | `<project>/tests/assert_*.sql` |
| Unit | Logic tested on fixed input rows, no warehouse data needed | `unit_tests:` blocks in `models/**/_*.yml` |
| Contracts | Enforced column names, types and `not_null` constraints on every public model | `config.contract.enforced` on public models |
| Thresholds | `severity` + `warn_if` / `error_if`: known data quality issues warn, a spike fails | `expression_is_true` with `config:` in the marts YAML |
| Source freshness | `loaded_at_field` + `warn_after` on the entity tables | `models/staging/<source>/_<source>__sources.yml` |

One threshold test per vertical is set to warn on the sample data on purpose, so a build shows what a
non-blocking data quality signal looks like.
