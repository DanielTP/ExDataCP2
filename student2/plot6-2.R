#Read the rds data for PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
#Read the rds data for Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")
NEI.sub <- NEI[NEI$fips == "24510"|NEI$fips == "06037", ]

library(ggplot2)

png(filename = "plot6.png", width = 580, height = 580, units = "px", bg = "transparent")
motor <- grep("motor", SCC$Short.Name, ignore.case = T)
motor <- SCC[motor, ]
motor <- NEI.sub[NEI.sub$SCC %in% motor$SCC, ]

g <- ggplot(motor, aes(year, Emissions, color = fips))
g + geom_line(stat = "summary", fun.y = "sum") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle("Comparison of Total Emissions From Motor\n Vehicle Sources in Baltimore City\n and Los Angeles County from 1999 to 2008") +
        scale_colour_discrete(name = "Group", label = c("Los Angeles","Baltimore"))
dev.off()
