## PLOT 2
## [N.B. System info 
#    R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
#    Copyright (C) 2014 The R Foundation for Statistical Computing
#    Platform: x86_64-pc-linux-gnu (64-bit)
#    Ubuntu 12.04 ]

##   Steps to create plot2.png
##     1 read the header -- i.e., determine the column names
##     2 read the required data as a dataframe
##     3 assign the previously-determined header to the dataframe
##     4 add a datetime object to the dataframe
##     5 construct the plot
##
##   See comments in plot1.R relating to reading the data file.

read_hpc <- function(data_fn) 
{
    # [N.B. The use of "read.table" was suggested by Prof. Peng in
    #  this post <www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html> .
    #
    #  It looks like "fread" in the package "data.table" might be an even better
    #  method for extracting the data of interest, since it allows certain columns
    #  to be included/excluded; but I haven't yet experimented with this. ]

    # 2) Read the header -- i.e. the column names
    header = read.table(data_fn,
                        na.strings="?", nrows=1, sep=";",
                        header=TRUE)
    # [N.B. setting nrows=0, reads to end-of-file]

    # 3) Now read the data of interest, for Feb 1 and 2 of 2007
    hpc = read.table(pipe('grep "^[1-2]/2/2007" household_power_consumption.txt'),
                     na.strings="?", stringsAsFactors=FALSE, sep=";")

    # 4) Assign appropriate column names to the data
    colnames(hpc) = colnames(header)

    # 5) Add a datetime object to the dataframe
    hpc$dto = as.POSIXlt(paste(hpc$Date, hpc$Time, sep=" "),
                               format="%d/%m/%Y %H:%M:%S")

    return(hpc)
}

# Read the data and format it into a dataframe: steps 1-5

hpc = read_hpc("household_power_consumption.txt")

# 6) Construct and save the plot
title = "Global Active Power"
units = "(kilowatts)"
png(file="plot2.png", width=480, height=480)
plot(hpc$dto, hpc$Global_active_power, type="l", xlab="", ylab=paste(title, units, sep=" "))
dev.off()
