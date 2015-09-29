#---------------------------#   &\.../&\
#     ___ plot3.R ___       #   'o  o: /     ,HF~
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

# 3. **ggplot2**
# Of the four types of sources indicated by the type (point,
# nonpoint, onroad, nonroad) variable, which of these four
# sources have seen decreases in emissions from 1999-2008
# for Baltimore City? Which have seen increases in emissions
# from 1999-2008?

# Subset to Baltimore City, MD
dat2 <- dat[dat$fips == "24510",]

# Summarize Data
emTotal <- summarize(group_by(dat2,year,type),sum(Emissions))
names(emTotal) <- make.names(names(emTotal))

# Setting up the plot
g <- ggplot(emTotal,aes(year,sum.Emissions.))
g <- g + geom_line(aes(color=type),size=2) 
g <- g + labs(title="Emissions by Year by Source Type, Baltimore City")
g <- g + labs(x="Year")
g <- g + labs(y="Total Emissions (tons)")

# Creating the png
png(filename = "plot3-1.png",width=600,height=480)
print(g)
dev.off()

# Cleaning up
rm(list = c("emTotal","dat2","g"))
