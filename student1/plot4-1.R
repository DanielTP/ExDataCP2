#---------------------------#   &\.../&\
#     ___ plot4.R ___       #   'o  o: /     ,HF~
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

# 4.
# Across the United States, how have emissions from coal
# combustion-related sources changed from 1999-2008?

# Subset to coal combustion related sources
dat2 <- dat[grep("coal",dat$EI.Sector,ignore.case=TRUE),]

# Summarize Data
emTotal <- summarize(group_by(dat2,year,EI.Sector),sum(Emissions))
names(emTotal) <- make.names(names(emTotal))

# Setting up the plot
g <- ggplot(emTotal,aes(year,sum.Emissions./1000))
g <- g + geom_bar(stat="identity",width=2,aes(fill=factor(EI.Sector)))
g <- g + labs(title="Emissions by Year for Coal Combustion-related sources, US")
g <- g + labs(x="Year")
g <- g + labs(y="Total Emissions (thousands of tons)")
g <- g + scale_fill_discrete(
        name="Coal Emission Sector"
        ,breaks=c("Fuel Comb - Comm/Institutional - Coal","Fuel Comb - Electric Generation - Coal","Fuel Comb - Industrial Boilers, ICEs - Coal")
        ,labels=c("Commercial/Industrial","Electric Generation","Industrial Boilers, ICEs"))
g <- g + scale_x_continuous(breaks=c(1999,2002,2005,2008))

# Creating the png
png(filename = "plot4-1.png",width=600,height=480)
print(g)
dev.off()

# Cleaning up
rm(list = c("emTotal","dat2","g"))
