# printing tt_datasets returns all the values as aprinted data.frame if not interactive

    Code
      print(ds, is_interactive = FALSE)
    Output
         Week       Date                                                  Data
      1     1 2018-04-02                                      US Tuition Costs
      2     2 2018-04-09                               NFL Positional Salaries
      3     3 2018-04-16                                      Global Mortality
      4     4 2018-04-23                         Australian Salaries by Gender
      5     5 2018-04-30                                ACS Census Data (2015)
      6     6 2018-05-07                                  Global Coffee Chains
      7     7 2018-05-14                                      Star Wars Survey
      8     8 2018-05-21                                   US Honey Production
      9     9 2018-05-29                                 Comic book characters
      10   10 2018-06-05                                    Biketown Bikeshare
      11   11 2018-06-12                               FIFA World Cup Audience
      12   12 2018-06-19                              Hurricanes & Puerto Rico
      13   13 2018-06-26                                   Alcohol Consumption
      14   14 2018-07-03                                Global Life Expectancy
      15   15 2018-07-10                                        Craft Beer USA
      16   16 2018-07-17                                          Exercise USA
      17   17 2018-07-23                            p-hack-athon collaboration
      18   18 2018-07-31                          Dallas Animal Shelter FY2017
      19   19 2018-08-07                                        Airline Safety
      20   20 2018-08-14                                  Russian Troll Tweets
      21   21 2018-08-21                                      California Fires
      22   22 2018-08-28                                             NFL Stats
      23   23 2018-09-04                                    Fast Food Calories
      24   24 2018-09-11                                    Cats vs Dogs (USA)
      25   25 2018-09-18                                 US Flights or Hypoxia
      26   26 2018-09-25                               Global Invasive Species
      27   27 2018-10-02                                             US Births
      28   28 2018-10-09                                      US Voter Turnout
      29   29 2018-10-16                                College Major & Income
      30   30 2018-10-23                                   Horror Movie Profit
      31   31 2018-10-30                             R and R package downloads
      32   32 2018-11-06                                US Wind Farm locations
      33   33 2018-11-13                                          Malaria Data
      34   34 2018-11-20 Thanksgiving Dinner or Transgender Day of Remembrance
      35   35 2018-11-27                                     Baltimore Bridges
      36   36 2018-12-04                               Medium Article Metadata
      37   37 2018-12-11                            NYC Restaurant inspections
      38   38 2018-12-18                                        Cetaceans Data
                                                                                         Source
      1                                                                       onlinembapage.com
      2                                                                             Spotrac.com
      3                                                                      ourworldindata.org
      4                                                                             data.gov.au
      5                                                                     census.gov , Kaggle
      6  Starbucks: kaggle.com , Tim Horton: timhortons.com , Dunkin Donuts: odditysoftware.com
      7                                                                 fivethirtyeight package
      8                                                                        USDA, Kaggle.com
      9                                                                 FiveThirtyEight package
      10                                                                            BiketownPDX
      11                                                                FiveThirtyEight package
      12                                                                FiveThirtyEight package
      13                                                                FiveThirtyEight package
      14                                                                     ourworldindata.org
      15                                                                             data.world
      16                                                                                    CDC
      17                                                                   simplystatistics.org
      18                                                                        Dallas OpenData
      19                                                                FiveThirtyEight Package
      20                                                                    FiveThirtyEight.com
      21                                                                           BuzzFeed.com
      22                                                             pro-football-reference.com
      23                                                                  fastfoodnutrition.org
      24                                                                             data.world
      25                                                      faa.govSoaring Society of America
      26                                                             Paini et al, 2016griis.org
      27                                                                fivethirtyeight package
      28                                                                             data.world
      29                                                                    fivethirtyeight/ACS
      30                                                                        the-numbers.com
      31                                                                  cran-logs.rstudio.com
      32                                                                               usgs.gov
      33                                               ourworldindata.orgMalaria Data Challenge
      34                                                                    fivethirtyeightTDoR
      35                                                         Federal Highway Administration
      36                                                                             Kaggle.com
      37                                                     NYC OpenData/NYC Health Department
      38                                                                            The Pudding
                                             Article
      1                            onlinembapage.com
      2                          fivethirtyeight.com
      3                           ourworldindata.org
      4                                  data.gov.au
      5                                   No article
      6                              flowingdata.com
      7                          fivethirtyeight.com
      8                                  Bee Culture
      9                          FiveThirtyEight.com
      10               Biketown cascadiaRconf/cRaggy
      11                         FiveThirtyEight.com
      12                         FiveThirtyEight.com
      13                         FiveThirtyEight.com
      14                          ourworldindata.org
      15                               thrillist.com
      16    CDC - National Health Statistics Reports
      17                                p-hack-athon
      18              Dallas OpenData FY2017 Summary
      19                        538 - Airline Safety
      20                  538 - Russian Troll Tweets
      21 BuzzFeed News - California Fires, RMarkdown
      22                                     eldo.co
      23                  franchiseopportunities.com
      24                             Washington Post
      25               travelweekly.comSSA - Hypoxia
      26                  Paini et al, 2016griis.org
      27                                538 - Births
      28                                Star Tribune
      29                             fivethirtyeight
      30                             fivethirtyeight
      31                                  No Article
      32                         Wind Market Reports
      33             ourworldindata.org malariaAtlas
      34                         fivethirtyeightTDoR
      35                               Baltimore Sun
      36                            TidyText package
      37                             FiveThirtyEight
      38                                 The Pudding

# printing tt_available returns all the values as a printed data.frame if not interactive

    Code
      print(ds, is_interactive = FALSE)
    Output
      Year: 2020
      
         Week       Date                                Data
      1     1 2019-12-31      Bring your own data from 2019!
      2     2 2020-01-07                    Australian Fires
      3     3 2020-01-14                           Passwords
      4     4 2020-01-21                         Song Genres
      5     5 2020-01-28                 San Francisco Trees
      6     6 2020-02-04                      NFL Attendance
      7     7 2020-02-11                      Hotel Bookings
      8     8 2020-02-18             Food's Carbon Footprint
      9     9 2020-02-25                 Measles Vaccination
      10   10 2020-03-03                           NHL Goals
      11   11 2020-03-10 College Tuition, Diversity, and Pay
      12   12 2020-03-17                          The Office
      13   13 2020-03-24              Traumatic Brain Injury
      14   14 2020-03-31                     Beer Production
      15   15 2020-04-07                      Tour de France
      16   16 2020-04-14                    Best Rap Artists
      17   17 2020-04-21                     GDPR Violations
      18   18 2020-04-28                   Broadway Musicals
      19   19 2020-05-05                     Animal Crossing
      20   20 2020-05-12                   Volcano Eruptions
      21   21 2020-05-19                    Beach Volleyball
                                    Source                           Article
      1                                                                     
      2              Bureau of Meteorology                    NY Times & BBC
      3             Knowledge is Beautiful          Information is Beautiful
      4                           spotifyr                     Kaylin Pavlik
      5                     data.sfgov.org                         SF Weekly
      6             Pro Football Reference                        Casino.org
      7  Antonio, Almeida, and Nunes, 2019                         tidyverts
      8                                nu3           r-tastic by Kasia Kulma
      9             The Wallstreet Journal           The Wall Street Journal
      10               HockeyReference.com                   Washington Post
      11                TuitionTracker.org                TuitionTracker.org
      12                           schrute                       The Pudding
      13                               CDC CDC Traumatic Brain Injury Report
      14                               TTB               Brewers Association
      15                       tdf package         Alastair Rushworth's blog
      16                         BBC Music      Simon Jockers at Datawrapper
      17                   Privacy Affairs                   Roel Hogervorst
      18                          Playbill                      Alex Cookson
      19                       Villager DB                           Polygon
      20                       Smithsonian                 Axios & Wikipedia
      21                      BigTimeStats       FiveThirtyEight & Wikipedia
      
      
      Year: 2019
      
         Week       Date                               Data
      1     1 2019-01-01      #Rstats & #TidyTuesday Tweets
      2     2 2019-01-08                    TV's Golden Age
      3     3 2019-01-15                     Space Launches
      4     4 2019-01-22               Incarceration Trends
      5     5 2019-01-29     Dairy production & Consumption
      6     6 2019-02-05 House Price Index & Mortgage Rates
      7     7 2019-02-12               Federal R&D Spending
      8     8 2019-02-19                   US PhD's Awarded
      9     9 2019-02-26                French Train Delays
      10   10 2019-03-05             Women in the Workplace
      11   11 2019-03-12                        Board Games
      12   12 2019-03-19     Stanford Open Policing Project
      13   13 2019-03-26                  Seattle Pet Names
      14   14 2019-04-02               Seattle Bike Traffic
      15   15 2019-04-09        Tennis Grand Slam Champions
      16   16 2019-04-16    The Economist Data Viz Mistakes
      17   17 2019-04-23                         Anime Data
      18   18 2019-04-30            Chicago Bird Collisions
      19   19 2019-05-07   Global Student to Teacher Ratios
      20   20 2019-05-14                Nobel Prize Winners
      21   21 2019-05-21               Global Plastic Waste
      22   22 2019-05-28                       Wine Ratings
      23   23 2019-06-04                      Ramen Ratings
      24   24 2019-06-11                         Meteorites
      25   25 2019-06-18              Christmas Bird Counts
      26   26 2019-06-25               Global UFO Sightings
      27   27 2019-07-02           Media Franchise Revenues
      28   28 2019-07-09                  Women's World Cup
      29   29 2019-07-16                    R4DS Membership
      30   30 2019-07-23                   Wildlife Strikes
      31   31 2019-07-30                        Video Games
      32   32 2019-08-06                 Bob Ross paintings
      33   33 2019-08-13                     Roman Emperors
      34   34 2019-08-20                 Nuclear Explosions
      35   35 2019-08-27               Simpsons Guest Stars
      36   36 2019-09-03                        Moore's Law
      37   37 2019-09-10            Amusement Park Injuries
      38   38 2019-09-17               National Park Visits
      39   39 2019-09-24                   School Diversity
      40   40 2019-10-01                      All the Pizza
      41   41 2019-10-08                       Powerlifting
      42   42 2019-10-15                   Car Fuel Economy
      43   43 2019-10-22               Horror movie ratings
      44   44 2019-10-29                NYC Squirrel Census
      45   45 2019-11-05               Bike & Walk Commutes
      46   46 2019-11-12                          CRAN Code
      47   47 2019-11-19                NZ Bird of the Year
      48   48 2019-11-26                  Student Loan Debt
      49   49 2019-12-03             Philly Parking Tickets
      50   50 2019-12-10             Replicating plots in R
      51   51 2019-12-17                     Adoptable dogs
      52   52 2019-12-24                    Christmas Songs
                                                           Source
      1                                                    rtweet
      2                                                      IMDb
      3                               JSR Launch Vehicle Database
      4                                            Vera Institute
      5                                                      USDA
      6                                   FreddieMac & FreddieMac
      7                                                      AAAS
      8                                                       NSF
      9                                                      SNCF
      10                          Census Bureau & Bureau of Labor
      11                                         Board Game Geeks
      12   Stanford Open Policing Project SOPP - arXiv:1706.05678
      13                                              seattle.gov
      14                                              seattle.gov
      15                                                Wikipedia
      16                                            The Economist
      17                                              MyAnimeList
      18                                       Winger et al, 2019
      19                                                   UNESCO
      20                                                   Kaggle
      21                                        Our World In Data
      22                                                   Kaggle
      23                                        TheRamenRater.com
      24                                                     NASA
      25                                      Bird Studies Canada
      26                                                   NUFORC
      27                                                Wikipedia
      28                                               data.world
      29                                               R4DS Slack
      30                                                      FAA
      31                                                Steam Spy
      32                                          FiveThirtyEight
      33                                   Wikipedia / Zonination
      34                                                    SIPRI
      35                                                Wikipedia
      36                                                Wikipedia
      37                                  Data.world & Saferparks
      38                                               Data.world
      39                                                     NCES
      40 Jared Lander & Ludmila Janda, Tyler Richards, DataFiniti
      41                                     OpenPowerlifting.org
      42                                                      EPA
      43                                                     IMDB
      44                                          Squirrel Census
      45                                                      ACS
      46                                                     CRAN
      47                          New Zealand Forest and Bird Org
      48                                  Department of Education
      49                                         Open Data Philly
      50                                        Simply Statistics
      51                                                Petfinder
      52                                        Billboard Top 100
                                       Article
      1                     stackoverflow.blog
      2                          The Economist
      3                          The Economist
      4                         Vera Institute
      5                                    NPR
      6                                Fortune
      7                         New York Times
      8                           #epibookclub
      9                            RTL - Today
      10                         Census Bureau
      11                       fivethirtyeight
      12               SOPP - arXiv:1706.05678
      13                        Curbed Seattle
      14                         Seattle Times
      15                       Financial Times
      16                         The Economist
      17                           MyAnimeList
      18                    Winger et al, 2019
      19           Center for Public Education
      20                         The Economist
      21                     Our World in Data
      22                                Vivino
      23                         Food Republic
      24          The Guardian - Meteorite map
      25         Hamilton Christmas Bird Count
      26                         Example Plots
      27           reddit/dataisbeautiful post
      28                             Wikipedia
      29                R4DS useR Presentation
      30                                   FAA
      31                             Liza Wood
      32                       FiveThirtyEight
      33          reddit.com/r/dataisbeautiful
      34                     Our World in Data
      35                             Wikipedia
      36                             Wikipedia
      37                            Saferparks
      38               fivethirtyeight article
      39               Washington Post article
      40                 Tyler Richards on TWD
      41                         Elias Oziolor
      42                          Ellis Hughes
      43                       Stephen Follows
      44                               CityLab
      45                                   ACS
      46                    Phillip Massicotte
      47 Dragonfly Data Science & Nathan Moore
      48                      Dignity and Debt
      49                      NBC Philadelphia
      50                       Rafael Irizarry
      51                           The Pudding
      52                        A Dash of Data
      
      
      Year: 2018
      
         Week       Date                                                  Data
      1     1 2018-04-02                                      US Tuition Costs
      2     2 2018-04-09                               NFL Positional Salaries
      3     3 2018-04-16                                      Global Mortality
      4     4 2018-04-23                         Australian Salaries by Gender
      5     5 2018-04-30                                ACS Census Data (2015)
      6     6 2018-05-07                                  Global Coffee Chains
      7     7 2018-05-14                                      Star Wars Survey
      8     8 2018-05-21                                   US Honey Production
      9     9 2018-05-29                                 Comic book characters
      10   10 2018-06-05                                    Biketown Bikeshare
      11   11 2018-06-12                               FIFA World Cup Audience
      12   12 2018-06-19                              Hurricanes & Puerto Rico
      13   13 2018-06-26                                   Alcohol Consumption
      14   14 2018-07-03                                Global Life Expectancy
      15   15 2018-07-10                                        Craft Beer USA
      16   16 2018-07-17                                          Exercise USA
      17   17 2018-07-23                            p-hack-athon collaboration
      18   18 2018-07-31                          Dallas Animal Shelter FY2017
      19   19 2018-08-07                                        Airline Safety
      20   20 2018-08-14                                  Russian Troll Tweets
      21   21 2018-08-21                                      California Fires
      22   22 2018-08-28                                             NFL Stats
      23   23 2018-09-04                                    Fast Food Calories
      24   24 2018-09-11                                    Cats vs Dogs (USA)
      25   25 2018-09-18                                 US Flights or Hypoxia
      26   26 2018-09-25                               Global Invasive Species
      27   27 2018-10-02                                             US Births
      28   28 2018-10-09                                      US Voter Turnout
      29   29 2018-10-16                                College Major & Income
      30   30 2018-10-23                                   Horror Movie Profit
      31   31 2018-10-30                             R and R package downloads
      32   32 2018-11-06                                US Wind Farm locations
      33   33 2018-11-13                                          Malaria Data
      34   34 2018-11-20 Thanksgiving Dinner or Transgender Day of Remembrance
      35   35 2018-11-27                                     Baltimore Bridges
      36   36 2018-12-04                               Medium Article Metadata
      37   37 2018-12-11                            NYC Restaurant inspections
      38   38 2018-12-18                                        Cetaceans Data
                                                                                         Source
      1                                                                       onlinembapage.com
      2                                                                             Spotrac.com
      3                                                                      ourworldindata.org
      4                                                                             data.gov.au
      5                                                                     census.gov , Kaggle
      6  Starbucks: kaggle.com , Tim Horton: timhortons.com , Dunkin Donuts: odditysoftware.com
      7                                                                 fivethirtyeight package
      8                                                                        USDA, Kaggle.com
      9                                                                 FiveThirtyEight package
      10                                                                            BiketownPDX
      11                                                                FiveThirtyEight package
      12                                                                FiveThirtyEight package
      13                                                                FiveThirtyEight package
      14                                                                     ourworldindata.org
      15                                                                             data.world
      16                                                                                    CDC
      17                                                                   simplystatistics.org
      18                                                                        Dallas OpenData
      19                                                                FiveThirtyEight Package
      20                                                                    FiveThirtyEight.com
      21                                                                           BuzzFeed.com
      22                                                             pro-football-reference.com
      23                                                                  fastfoodnutrition.org
      24                                                                             data.world
      25                                                      faa.govSoaring Society of America
      26                                                             Paini et al, 2016griis.org
      27                                                                fivethirtyeight package
      28                                                                             data.world
      29                                                                    fivethirtyeight/ACS
      30                                                                        the-numbers.com
      31                                                                  cran-logs.rstudio.com
      32                                                                               usgs.gov
      33                                               ourworldindata.orgMalaria Data Challenge
      34                                                                    fivethirtyeightTDoR
      35                                                         Federal Highway Administration
      36                                                                             Kaggle.com
      37                                                     NYC OpenData/NYC Health Department
      38                                                                            The Pudding
                                             Article
      1                            onlinembapage.com
      2                          fivethirtyeight.com
      3                           ourworldindata.org
      4                                  data.gov.au
      5                                   No article
      6                              flowingdata.com
      7                          fivethirtyeight.com
      8                                  Bee Culture
      9                          FiveThirtyEight.com
      10               Biketown cascadiaRconf/cRaggy
      11                         FiveThirtyEight.com
      12                         FiveThirtyEight.com
      13                         FiveThirtyEight.com
      14                          ourworldindata.org
      15                               thrillist.com
      16    CDC - National Health Statistics Reports
      17                                p-hack-athon
      18              Dallas OpenData FY2017 Summary
      19                        538 - Airline Safety
      20                  538 - Russian Troll Tweets
      21 BuzzFeed News - California Fires, RMarkdown
      22                                     eldo.co
      23                  franchiseopportunities.com
      24                             Washington Post
      25               travelweekly.comSSA - Hypoxia
      26                  Paini et al, 2016griis.org
      27                                538 - Births
      28                                Star Tribune
      29                             fivethirtyeight
      30                             fivethirtyeight
      31                                  No Article
      32                         Wind Market Reports
      33             ourworldindata.org malariaAtlas
      34                         fivethirtyeightTDoR
      35                               Baltimore Sun
      36                            TidyText package
      37                             FiveThirtyEight
      38                                 The Pudding
      
      

