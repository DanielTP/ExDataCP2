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
data_sc <- readRDS("Source_Classification_Code.rds")
data_pm <- transform(data_pm, fips = factor(fips), SCC = factor(SCC), Pollutant = factor(Pollutant), type = factor(type), year = factor(year))
list_SCC <- data_sc[grep("* - Coal", data_sc$EI.Sector),]
for (i in 1 : length(list_SCC$SCC)) {
        data_pm3 <- data_pm[data_pm$SCC == as.character(list_SCC[i,1]),]
        if (i == 1) {
                data_pm2 <- data_pm3
        } else {
                data_pm2 <- cbind(data_pm2,data_pm3)
        }
}
data_pm3 <- tbl_df(data_pm2)
data_pm4 <- summarize(data_pm3,)


# Plot
png("plot3.png")
ggplot(data_m, aes(year, emi)) + geom_point() + facet_wrap( ~ type, nrow = 2, ncol = 2) + labs(x = "Year") + labs(y = "Total Emissions in Baltimore City (tons)")

dev.off()
