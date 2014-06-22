##Originally ran on 10.6.8 Mac and R version 3.1.0

##Download, unzip and assign dataframes
URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./data.zip",method="curl")
unzip("./data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Subset SCC for SCC IDs that are related to vehicles
##Subset NEI data for the SCC IDs that are related to vehicles
Vehicle<-SCC$SCC[grep("[Vv]ehicle",SCC$EI.Sector)]
Vehicle_data<-NEI[NEI$SCC %in% Vehicle,]

##Subset for Baltimore data
VB_data<-Vehicle_data[which(Vehicle_data$fips=="24510"),]

##Sum emissions by year for Baltimore vehicles data
Q5<-aggregate(VB_data$Emissions ~VB_data$year,data=VB_data,FUN="sum")

##Create plot
##Plot points and add trendline
png("plot5.png",width=480,height=480)
plot(Q5$Year,Q5$Emissions,pch=20,main="Vehicle Emissions in Baltimore Over Time",xlab="Year",ylab="Emissions")
fit<-glm(Q5$Emissions~Q5$Year)
co<-coef(fit)
abline(fit,col="blue",lwd=2)
dev.off()