# Checking data
if ((!file.exists("summarySCC_PM25.rds")) | (!file.exists("Source_Classsification_Code.rds"))) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(url, destfile = "NEI_data.zip")
        unzip("NEI_data.zip")
}

# Reading & Processing data
data_pm <- readRDS("summarySCC_PM25.rds")
data_pm <- transform(data_pm, fips = factor(fips), SCC = factor(SCC), Pollutant = factor(Pollutant), type = factor(type), year = factor(year))

# Calculate emissions in 4 years
sum_99 <- sum(data_pm[data_pm$year == 1999,4])
sum_02 <- sum(data_pm[data_pm$year == 2002,4])
sum_05 <- sum(data_pm[data_pm$year == 2005,4])
sum_08 <- sum(data_pm[data_pm$year == 2008,4])

# Plot
png("plot1.png")
plot(c(sum_99, sum_02, sum_05, sum_08), type = "l", xlab = "Year", ylab = "Total Emissions from PM2.5 in US(tons)", xaxt = "n")
axis(1, at = c(1,2,3,4), labels = c("1999", "2002", "2005", "2008"))
dev.off()
