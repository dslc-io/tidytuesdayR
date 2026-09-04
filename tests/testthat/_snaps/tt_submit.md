# tt_find_dataset_files errors informatively for extra files

    Code
      tt_find_dataset_files(test_path("fixtures", "tt_submission_extra"))
    Condition <tidytuesdayR-error-extra_files>
      Error in `tt_find_dataset_files()`:
      ! `path` should only contain submission files.
      x Extra files: fixtures/tt_submission_extra/extra.R

# tt_find_dataset_files errors informatively for missing files

    Code
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing"))
    Condition <tidytuesdayR-error-missing_expected>
      Error in `tt_find_expected_files()`:
      ! All expected files must exist in `path`.
      x Missing files: 'fixtures/tt_submission_missing/cleaning.R'

# tt_find_dataset_files errors informatively for missing images

    Code
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing_image1"))
    Condition <tidytuesdayR-error-missing_images>
      Error in `tt_find_images()`:
      ! All images in meta.yaml must exist in `path`.
      x Missing images: 'fixtures/tt_submission_missing_image1/states_population.png'

---

    Code
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing_image2"))
    Condition <tidytuesdayR-error-no_images>
      Error in `tt_find_images()`:
      ! No images found in meta.yaml

# tt_find_dataset_files errors informatively for missing dictionary

    Code
      tt_find_dataset_files(test_path("fixtures", "tt_submission_missing_md"))
    Condition <tidytuesdayR-error-missing_dictionaries>
      Error in `tt_find_dictionaries()`:
      ! All datasets must have an associated md file in `path`.
      x Missing dictionaries: 'fixtures/tt_submission_missing_md/states.md'

# tt_find_csv_files errors when CSV exceeds 25MB

    Code
      tt_find_csv_files(test_path("fixtures", "tt_submission"))
    Condition <tidytuesdayR-error-csv_size>
      Error in `tt_validate_csv_sizes()`:
      ! CSV files must be <= 25MB to upload to GitHub.
      x Files too large:
      * fixtures/tt_submission/states.csv (30M)

# tt_find_csv_files handles multiple large CSVs

    Code
      tt_find_csv_files(test_path("fixtures", "tt_submission"))
    Condition <tidytuesdayR-error-csv_size>
      Error in `tt_validate_csv_sizes()`:
      ! CSV files must be <= 25MB to upload to GitHub.
      x Files too large:
      * fixtures/tt_submission/file1.csv (31457280)
      * fixtures/tt_submission/file2.csv (41943040)

