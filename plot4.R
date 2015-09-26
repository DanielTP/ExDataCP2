library(dplyr)

# Checking data
if ((!file.exists("summarySCC_PM25.rds")) | (!file.exists("Source_Classification_Code.rds"))) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(url, destfile = "NEI_data.zip")
        unzip("NEI_data.zip")
}

# Reading & Processing data (Time-Consuming!!!)
data_pm <- readRDS("summarySCC_PM25.rds")
data_sc <- readRDS("Source_Classification_Code.rds")
data_pm2 <- tbl_df(data_pm[,c(2,4,6)])
data_sc2 <- tbl_df(data_sc[,c(1,4)])

# Getting Coal-related SCC and Calculate total emissions
data_pm2 <- group_by(data_pm2, SCC, year)
data_plot <- summarize(data_pm2, Emissions = sum(Emissions))
list_SCC <- data_sc2[grep("* - Coal", data_sc2$EI.Sector),]
intersect(names(list_SCC), names(data_plot))
data_plot2 <- merge(data_plot, list_SCC, all = F)
data_plot2 <- group_by(data_plot2, year)
data_plot3 <- summarize(data_plot2, Emissions = sum(Emissions))

# Plot
png("plot4.png")
plot(data_plot3$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions from Coal Combusition-Related Sources (tons)", xaxt = "n")
axis(1, at = c(1,2,3,4), labels = data_plot3$year)
dev.off()
