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

# data.table needed for fread
library(data.table)


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
    #   Saw in Class Forum post that GREP is not part of the R environment --
    #   I know it's not a Windows tool, but thought it came with R --
    #   so switched to this more OS-independent method, as suggested in
    #   Forum post by Alexey Burlutskiy

    nrows = as.integer(difftime(as.POSIXct("2007-02-03"), as.POSIXct("2007-02-01"),
                       units="mins"))
    hpc   = fread("household_power_consumption.txt", skip="1/2/2007",
                  nrows = nrows, na.strings = "?")

    # 4) Assign column names to the data
    #    something in data.table shadows colnames and gives me a warning;
    #    the "::" operator, the web tells me, forces use of the function
    #    from the desired namespace.
    base::colnames(hpc) = base::colnames(header)[1:9]

    # 5) Add a datetime object to the dataframe
    hpc$dto = as.POSIXct(paste(hpc$Date, hpc$Time, sep=" "),
                               format="%d/%m/%Y %H:%M:%S")

    return(hpc)
}

# ========== MAIN ========== #

# Try and find the data file. If it doesn't exist,
# warn the user and quit.
args = commandArgs(trailingOnly=TRUE)
if(length(args) > 0) {
    data_fn = args[1]
} else {
    data_fn = "household_power_consumption.txt"
}

if(file.access(data_fn, mode=4) < 0) {
    print(paste("Data file", data_fn, "can not be located or read."))
    print("Please include name of data file as command line argument.")
    quit()
}

# Assuming we could fine the data file...
# read the data and format it into a dataframe: i.e., carry out steps 1-5
hpc = read_hpc("household_power_consumption.txt")

# 6) Construct and save the plot
title = "Global Active Power"
units = "(kilowatts)"
png(file="plot2.png", width=480, height=480)
plot(hpc$dto, hpc$Global_active_power, type="l", xlab="", ylab=paste(title, units, sep=" "))
dev.off()
