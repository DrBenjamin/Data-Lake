# Snowflake R implementation
# https://quickstarts.snowflake.com/guide/analyze_data_with_r_using_posit_workbench_and_snowflake/index.html#0
# sv04740.west-europe.azure.snowflakecomputing.com
library(devtools)
install.packages(c("tidyverse", "DBI", "dbplyr", "gt", "gtExtras"))

# To get a bug fix or to use a feature from the development version, you can install the development version of odbc
install.packages("pak")
pak::pak("r-dbi/odbc")

# Loading libraries
library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)

# Install needed app with `brew install unixodbc`
# Configure /Users/ben/Library/ODBC/odbc.ini & odbcinst.ini
# https://lukas-r.blog/posts/2023-03-05-finally-solving-the-mac-m1-odbc-issue/
# https://stackoverflow.com/questions/69275130/how-do-i-install-the-odbc-driver-for-snowflake-successfully-on-an-m1-apple-silic

# Connect to the database
con <- DBI::dbConnect(
      drv = odbc::odbc(),
      dsn = "Snowflake",
      uid = "bengross_tech",
      pwd = "",
      account = "sv04740.west-europe.azure",
      authenticator = "SNOWFLAKE_JWT",
      PRIV_KEY_FILE = "C:\\Users\\120700002024\\.snowflake\\rsa_key.p8",
      PRIV_KEY_FILE_PWD = NULL,
      role = "HEALTH_DEV",
      warehouse = "WH_Health_UseCase_AI",
      database = "DB_BG_HEALTH",
      schema = "PUBLIC"
    )
conn <-
  DBI::dbConnect(
    drv = odbc::snowflake(),
    driver = "Snowflake Driver",
    dsn = "Snowflake",
    uid = "bengross_tech",
    pwd = "",
    account = "sv04740.west-europe.azure",
  )

dbListTables(con)
# No active warehouse selected in the current session.  Select an active warehouse with the 'use warehouse' command.
dbSendQuery(con, 'USE WAREHOUSE "WH_Health_UseCase_AI";')
dbSendQuery(con, 'USE DATABASE DB_BG_HEALTH;')
data <- dbReadTable(con, "ANZEIGE_PRE")
df <- dbGetQuery(
  con,
  'SELECT * FROM ANZEIGE_PRE;'
)

# SQL query translation
timeseries <- dplyr::tbl(con, 'ANZEIGE_PRE')
df <- dbGetQuery(con, 'SELECT * FROM ANZEIGE_PRE')
df <- as.data.frame(tbl(con, 'ANZEIGE_PRE')) %>%
  collect()
