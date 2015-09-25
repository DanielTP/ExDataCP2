
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

# Getting Coal-related SCC and Calculate total emissions (Time-Consuming!!!)
list_SCC <- data_sc[grep("Mobile - *", data_sc$EI.Sector),]
sum_99 <- 0
sum_02 <- 0
sum_05 <- 0
sum_08 <- 0
for (i in 1 : length(list_SCC$SCC)) {
        data_pm2 <- data_pm[(data_pm$SCC == as.character(list_SCC[i,1])) & (data_pm$fips == "24510"),]
        sum_99 <- sum_99 + sum(data_pm2[data_pm2$year == 1999,4])
        sum_02 <- sum_02 + sum(data_pm2[data_pm2$year == 2002,4])
        sum_05 <- sum_05 + sum(data_pm2[data_pm2$year == 2005,4])
        sum_08 <- sum_08 + sum(data_pm2[data_pm2$year == 2008,4])
}

# Plot
png("plot5.png")
plot(c(sum_99,sum_02,sum_05,sum_08), type = "l", xlab = "Year", ylab = "Total Coal Combusition-Related Sources (tons)", xaxt = "n")
axis(1, at = c(1,2,3,4), labels = c("1999", "2002", "2005", "2008"))
dev.off()
