##Originally ran on 10.6.8 Mac and R version 3.1.0

##Load necessary lattice package
##Download, unzip and assign dataframes
library(lattice)
library(datasets)
URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./data.zip",method="curl")
unzip("./data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Subset SCC for SCC IDs that shows "vehicles" as the source
##Subset NEI data for the SCC IDs that are related to vehicles
Vehicle<-SCC$SCC[grep("[Vv]ehicle",SCC$EI.Sector)]
Vehicle_data<-NEI[NEI$SCC %in% Vehicle,]

##Subset for Baltimore and Los Angeles data
VB_data<-Vehicle_data[which(Vehicle_data$fips=="24510"),]
V_LA_data<-Vehicle_data[which(Vehicle_data$fips=="06037"),]
Q6_Raw<-rbind(VB_data,V_LA_data)

##Sum emissions by city and year
Q6<-aggregate(Q6_Raw$Emissions ~Q6_Raw$year+Q6_Raw$fips,data=Q6_Raw,FUN="sum")

##Relabel and rename location IDs for city
##Convert emissions columns into numbers
names(Q6)<-c("Year","Location","Emissions")
Q6<-as.data.frame(sapply(Q6,gsub,pattern="06037",replacement="Los Angeles"))
Q6<-as.data.frame(sapply(Q6,gsub,pattern="24510",replacement="Baltimore"))
Q6$Emissions<-as.numeric(as.character(Q6$Emissions))

##Create plot
##Plot points for Baltimore and Los Angeles using the lattice package. 
##Also show trend by adding regression line
png("plot6.png",width=480,height=480)
xyplot(Q6$Emissions~Q6$Year|Q6$Location, main="Baltimore VS Los Angeles Vehicle Emissions", xlab="Year",ylab="Emissions",panel = function(x,y, ...) {
  panel.xyplot(x,y, ...) 
  panel.lmline(x,y,col = 2)
})
dev.off()
