## PLOT 4
## [N.B. System info
#    R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
#    Copyright (C) 2014 The R Foundation for Statistical Computing
#    Platform: x86_64-pc-linux-gnu (64-bit)
#    Ubuntu 12.04 ]

##   Steps to create plot4.png
##     2 read the header -- i.e., determine the column names
##     3 read the required data as a dataframe, using pipe & grep
##     4 assign the previously-determined header to the dataframe
##     5 add a datetime object to the dataframe
##     6 construct the plot

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
    #    the ":::" operator, the web tells me, forces use of the function
    #    from the desired namespace.
    base:::colnames(hpc) = base:::colnames(header)[1:9]

    # 5) Add a datetime object to the dataframe
    hpc$dto = as.POSIXct(paste(hpc$Date, hpc$Time, sep=" "),
                               format="%d/%m/%Y %H:%M:%S")

    return(hpc)
}

# Read the data and format it into a dataframe: steps 1-5
hpc = read_hpc("household_power_consumption.txt")

# 6) Construct and save the plot group
png(file="plot4.png", width=480, height=480)
par(mfrow = c(2,2))
with(hpc,
{ 
  title = "Global Active Power"
  plot(dto, Global_active_power, type="l", xlab="", ylab=title)

  title = "Voltage"
  plot(dto, Voltage, type="l", xlab="datetime", ylab=title)

  title = "Energy sub metering"
  units = ""
  plot(dto, Sub_metering_1, type="l", col="black",
       xlab="", ylab=paste(title, units, sep=" "))
  lines(dto, Sub_metering_2, col="red")
  lines(dto, Sub_metering_3, col="blue")
  # bty controls legend border; cex --> legend size
  legend("topright", c(colnames(hpc)[7:9]), lwd=c(1,1,1),
         col=c("black", "red", "blue"), cex=0.95, bty="n")

  plot(dto, Global_reactive_power, type="l", xlab="datetime")
})
dev.off()
