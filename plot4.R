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
list_SCC <- grep("* - Coal", data_sc$EI.Sector)


sum_B99P <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 1999) & (data_pm$type == "POINT"),4])
sum_B99NP <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 1999) & (data_pm$type == "NONPOINT"),4])
sum_B99R <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 1999) & (data_pm$type == "ON-ROAD"),4])
sum_B99NR <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 1999) & (data_pm$type == "NON-ROAD"),4])
sum_B02P <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2002) & (data_pm$type == "POINT"),4])
sum_B02NP <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2002) & (data_pm$type == "NONPOINT"),4])
sum_B02R <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2002) & (data_pm$type == "ON-ROAD"),4])
sum_B02NR <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2002) & (data_pm$type == "NON-ROAD"),4])
sum_B05P <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2005) & (data_pm$type == "POINT"),4])
sum_B05NP <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2005) & (data_pm$type == "NONPOINT"),4])
sum_B05R <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2005) & (data_pm$type == "ON-ROAD"),4])
sum_B05NR <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2005) & (data_pm$type == "NON-ROAD"),4])
sum_B08P <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2008) & (data_pm$type == "POINT"),4])
sum_B08NP <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2008) & (data_pm$type == "NONPOINT"),4])
sum_B08R <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2008) & (data_pm$type == "ON-ROAD"),4])
sum_B08NR <- sum(data_pm[(data_pm$fips == "24510") & (data_pm$year == 2008) & (data_pm$type == "NON-ROAD"),4])
data_m_emi <- c(sum_B99P, sum_B99NP, sum_B99R, sum_B99NR, sum_B02P, sum_B02NP, sum_B02R, sum_B02NR, sum_B05P, sum_B05NP, sum_B05R, sum_B05NR, sum_B08P, sum_B08NP, sum_B08R, sum_B08NR) 
data_m_type <- rep(c("POINT", "NONPOINT", "ON-ROAD", "NON-ROAD"),4)
data_m_year <- c(rep(1999,4), rep(2002,4), rep(2005,4),rep(2008,4))
data_m <- data.frame(cbind(data_m_emi, data_m_type, data_m_year), stringsAsFactors = F)
names(data_m) <- c("emi", "type", "year")
data_m <- transform(data_m, emi = as.numeric(emi), type = factor(type), year = factor(year))

# Plot
png("plot3.png")
ggplot(data_m, aes(year, emi)) + geom_point() + facet_wrap( ~ type, nrow = 2, ncol = 2) + labs(x = "Year") + labs(y = "Total Emissions in Baltimore City (tons)")

dev.off()
