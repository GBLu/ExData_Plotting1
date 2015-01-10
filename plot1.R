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

# Try and find the data file. If it doesn't exist, warn the
# user and quit.
args = commandArgs(trailingOnly=TRUE)
if(length(args) > 0) {
    data_fn = args[1]
} else {
    data_fn = "household_power_consumption.txt"
}

print(data_fn)
if(file.access(data_fn, mode=4) < 0) {
    print(paste("Data file", data_fn, "can not be read."))
    print("Please include name of data file as command line argument.")
    quit()
}

# 2) If we get this far... read the header -- i.e. the column names
header = read.table(data_fn, na.strings="?", nrows=1, sep=";",
                    header=TRUE)
# [N.B. setting nrows=0, reads to end-of-file]

# 3) Now read the data of interest, for Feb 1 and 2 of 2007
#hpc = read.table(pipe('grep "^[1-2]/2/2007" household_power_consumption.txt'),
#                 na.strings="?", stringsAsFactors=FALSE, sep=";")

# Saw in Class Forum post that GREP is not part of the R environment --
# I know it's not a Windows tool, but thought it came with R --
# so switched to this more OS-independent method, as suggested in
# a Forum post by Alexey Burlutskiy

library(data.table)
# nrows should be 60*24*2 = 2880, the number of minutes in 2 days
nrows = as.integer(difftime(as.POSIXlt("2007-02-03"), as.POSIXlt("2007-02-01"),
                   units="mins"))
hpc   = fread(data_fn, skip="1/2/2007", nrows = nrows, na.strings = "?")

# 4) Assign column names to the data
#    something in data.table shadows colnames and gives me a warning;
#    the "::" operator, the web tells me, forces use of the function
#    from the desired namespace.
base::colnames(hpc) = base::colnames(header)[1:9]

# 5) Construct plot, using base plotting system
title = "Global Active Power"
units = "(kilowatts)"
png(file="plot1.png", width=480, height=480)
hist(hpc$Global_active_power, col="red", main=title, xlab=paste(title, units, sep=" "))
dev.off()
