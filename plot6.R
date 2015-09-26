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
data_pmb <- tbl_df(data_pm[data_pm$fips == "24510",c(1,2,4,6)])
data_pml <- tbl_df(data_pm[data_pm$fips == "06037",c(1,2,4,6)])
data_sc2 <- tbl_df(data_sc[,c(1,4)])

# Getting Vehicles-related SCC and Calculate total emissions in Baltimore City
data_pmb <- group_by(data_pmb, SCC, year)
data_plotb <- summarize(data_pmb, Emissions = sum(Emissions))
list_SCC <- data_sc2[grep("* Vehicles", data_sc2$EI.Sector),]
intersect(names(list_SCC), names(data_plotb))
data_plotb2 <- merge(data_plotb, list_SCC, all = F)
data_plotb2 <- group_by(data_plotb2, year)
data_plotb3 <- summarize(data_plotb2, Emissions = sum(Emissions))

# Getting Vehicles-related SCC and Calculate total emissions in Los Angels County
data_pml <- group_by(data_pml, SCC, year)
data_plotl <- summarize(data_pml, Emissions = sum(Emissions))
intersect(names(list_SCC), names(data_plotl))
data_plotl2 <- merge(data_plotl, list_SCC, all = F)
data_plotl2 <- group_by(data_plotl2, year)
data_plotl3 <- summarize(data_plotl2, Emissions = sum(Emissions))

# Plot
y_max <- max(data_plotb3$Emissioins, data_plotl3$Emissions)
png("plot6.png")
plot(data_plotb3$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions from Motor Vehicles Sources (tons)", xaxt = "n", ylim = c(0,y_max+1000))
axis(1, at = c(1,2,3,4), labels = data_plotb3$year)
lines(data_plotl3$Emissions, col = "blue", xlab = "")
leg_txt = c("Baltimore City", "Los Angels County")
legend("topright", leg_txt, text.col = c("black","blue"), lty = c(1,1), col = c("black","blue"), cex = 1)
dev.off()
