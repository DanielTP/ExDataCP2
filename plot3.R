library(dplyr)
library(ggplot2)

# Checking data
if ((!file.exists("summarySCC_PM25.rds")) | (!file.exists("Source_Classification_Code.rds"))) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(url, destfile = "NEI_data.zip")
        unzip("NEI_data.zip")
}

# Reading & Processing data
data_pm <- readRDS("summarySCC_PM25.rds")
data_pm2 <- tbl_df(data_pm)
rm(data_pm)

# Calculate emissions of different types in Baltimore City
data_pm2 <- group_by(data_pm2,fips,year,type)
data_plot <- summarize(data_pm2,sum(Emissions))
data_plot2 <- data_plot[data_plot$fips == 24510,]
names(data_plot2)[4] <- "Emissions"

# Plot
png("plot3.png")
ggplot(data_plot2, aes(year, Emissions)) + geom_point() + facet_wrap( ~ type, nrow = 2, ncol = 2) + labs(x = "Year") + labs(y = "Total Emissions in Baltimore City (tons)")
dev.off()
