# MinIO R implementation
# https://blog.min.io/minio-apache-arrow-r/
library(devtools)
install_github("nagdevAmruthnath/minio.s3", force=TRUE)
library("minio.s3")
library(aws.s3)
library(tidyverse)
library(dplyr)
library(readr)
library(png)
library(jpeg)

# Setting the environment variables
# http://192.168.178.23:9001/browser/templategenerator
Sys.setenv("AWS_ACCESS_KEY_ID" = "health",
           "AWS_SECRET_ACCESS_KEY" = "NOentry#23",
           "AWS_S3_ENDPOINT" = "192.168.178.23:9000")

# Get files from the MinIO server
get_bucket(bucket = 'templategenerator', region = "", use_https = F)
b <- get_bucket(bucket = 'templategenerator', region = "", use_https = F)
csv_file <- aws.s3::s3read_using(FUN = read.csv, object = "SDNN.csv", bucket = b, opts = list(use_https = FALSE, region = ""))
head(csv_file)

image_file <- aws.s3::s3read_using(FUN = readJPEG, object = "MLD.Kurs.jpg", bucket = b, opts = list(use_https = FALSE, region = ""))
grid::grid.raster(image_file)
