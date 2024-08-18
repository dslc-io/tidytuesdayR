# tt_load loads all data available

    Code
      tt_obj <- tt_load("2019-01-15")
    Message
      --- Compiling #TidyTuesday Information for 2019-01-15 ----
      --- There are 2 files available ---
      --- Starting Download ---
    Output
      
      	Downloading file 1 of 2: `agencies.csv`
      	Downloading file 2 of 2: `launches.csv`
      
    Message
      --- Download complete ---

# tt_load loads excel files properly

    Code
      tt_obj <- tt_load("2018-04-02")
    Message
      --- Compiling #TidyTuesday Information for 2018-04-02 ----
      --- There is 1 file available ---
      --- Starting Download ---
    Output
      
      	Downloading file 1 of 1: `us_avg_tuition.xlsx`
      
    Message
      --- Download complete ---

