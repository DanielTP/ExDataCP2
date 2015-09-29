#---------------------------#   &\.../&\
#     ___ plot6.R ___       #   'o  o: /     ,HF~
# Sarah Michel              #  (@  `'\:\     WF~
# 2015-09-21                #   \U` ,.;:`"-,,+WF`
# Course Project #2         #   /WWF~ """"""""\!
# Exploratory Data Analysis #   $WF~   '' ,(   \
# Coursera                  #   $``\'',-"`##`\ :
#---------------------------#  /#/  \?`   #  7,/

# Libraries
packages <- c("dplyr", "ggplot2")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
        install.packages(setdiff(packages, rownames(installed.packages())))  
}
library(dplyr)
library(ggplot2)
rm(packages)

# Go to correct working directory which contains
# Source_Classification_Code.rds and summarySCC_PM25.rds.
# Files can be downloaded from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd ("E:/0.0 Coursera/4.0 Exploratory Data Analysis/Course Project 2/")
# setwd ("YOUR_DIRECTORY_HERE")


# Check if files are there before proceeding
if (!(all(c("Source_Classification_Code.rds","summarySCC_PM25.rds") %in% dir()))) {
        stop ("Files not found.")
}

# Read & merge files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
dat <- merge(NEI,SCC,by.x = "SCC",by.y = "SCC")
rm(list=c("NEI","SCC"))

# 6.
# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in Los Angeles
# County, California (fips == "06037"). Which city has seen
# greater changes over time in vehicle emissions?

# Subset to motor vehicle sources
dat <- dat[grep("vehicle",dat$EI.Sector,ignore.case=TRUE),]

# Subset to Baltimore City, MD
dat <- dat[dat$fips %in% c("24510","06037"),]
dat$fips <- factor(dat$fips,labels=c("Los Angeles","Baltimore"))

# Summarize Data
emTotal <- summarize(group_by(dat,year,fips,EI.Sector),sum(Emissions))
names(emTotal) <- make.names(names(emTotal))

# Setting up the plot
g <- ggplot(emTotal,aes(year,sum.Emissions.))
g <- g + geom_bar(stat="identity",width=2,aes(fill=factor(EI.Sector)))
g <- g + labs(title="Emissions by Year for Motor Vehicle sources")
g <- g + labs(x="Year")
g <- g + labs(y="Total Emissions (tons)")
g <- g + scale_fill_discrete(
        name="Motor Vehicle \n Emission Sector"
        ,breaks=c("Mobile - On-Road Diesel Heavy Duty Vehicles","Mobile - On-Road Diesel Light Duty Vehicles","Mobile - On-Road Gasoline Heavy Duty Vehicles","Mobile - On-Road Gasoline Light Duty Vehicles")
        ,labels=c("Diesel, Heavy Duty","Diesel, Light Duty","Gasoline, Heavy Duty","Gasoline,Light Duty"))
g <- g + scale_x_continuous(breaks=c(1999,2002,2005,2008))
g <- g + facet_grid(. ~ fips)

# Creating the png
png(filename = "plot6.png",width=900,height=480)
print(g)
dev.off()

# Cleaning up
rm(list = c("emTotal","dat2","g"))
