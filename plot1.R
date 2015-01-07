## PLOT 1
## [N.B. System info
#    R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
#    Copyright (C) 2014 The R Foundation for Statistical Computing
#    Platform: x86_64-pc-linux-gnu (64-bit)
#    Ubuntu 12.04 ]

##   Steps to create plot1.png
##     1 read the header -- i.e., determine the column names
##     2 read the required data, using pipe & grep instead of subsetting
##     3 assign the previously-determined header to the data
##     4 add datetime object to dataframe, for plotting
##     5 construct the plot

# [N.B. The use of "read.table" was suggested by Prof. Peng in
#  this post <www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html> .
#
#  It looks like "fread" in the package "data.table" might be an even better
#  method for extracting the data of interest, since it appears to allow
#  certain columns to be included/excluded; have yet to experiment with this. ]

# 2) Read the header -- i.e. the column names
header = read.table("household_power_consumption.txt", 
                    na.strings="?", nrows=1, sep=";",
                    header=TRUE)
# [N.B. setting nrows=0, reads to end-of-file]

# 3) Now read the data of interest, for Feb 1 and 2 of 2007
hpc = read.table(pipe('grep "^[1-2]/2/2007" household_power_consumption.txt'),
                 na.strings="?", stringsAsFactors=FALSE, sep=";")

# 4) Assign column names to the data
colnames(hpc) = colnames(header)

# 5) Construct plot, using base plotting system
title = "Global Active Power"
units = "(kilowatts)"
png(file="plot1.png", width=480, height=480)
hist(hpc$Global_active_power, col="red", main=title, xlab=paste(title, units, sep=" "))
dev.off()
