library(data.table)
library(leaflet)
library(shiny)
library(IC2)
library(plyr)
library(tigris)
library(rgdal)
library(sp)


#Vars to pull from the CSVs
variables<-c("PUMA", "ST", "HINCP", "WGTP", "ADJINC")

#Read in the .csv and merge to one df 
a<-fread("ss13husa.csv", select=variables) 
b<-fread("ss13husb.csv", select=variables)
hdata<-data.frame(rbind(a, b))

#Need state-specific identifiers for PUMAs

hdata$chars<-nchar(hdata$PUMA)
hdata$PUMAID[hdata$chars==3]<-with(hdata[hdata$chars==3,],paste(ST,PUMA,sep='00'))
hdata$PUMAID[hdata$chars==4]<-with(hdata[hdata$chars==4,],paste(ST,PUMA,sep='0'))
hdata$PUMAID[hdata$chars==5]<-with(hdata[hdata$chars==5,],paste(ST,PUMA,sep=''))
hdata$PUMAID[hdata$ST<10]<-with(hdata[hdata$ST<10,],paste("0",PUMAID,sep = ''))

#Inflation Adjustment
hdata$AHINCP<-hdata$HINCP*(hdata$ADJINC/1000000)

#Can either remove negative values or set them to zero with:
hdata$AHINCP[hdata$AHINCP<0]<-0


# function calculates Ginis 
return.Gini<-function(da) {
  calcSGini(da$AHINCP,w=da$WGTP,param=2)
}

#gets applied to every st
hState<-dlply(hdata, .(ST), return.Gini)

#Extract the gini values
GiniRaw<-unlist(hState)
GINI<-GiniRaw[1:51*5-4]

#List of states
ST<-unique(hdata$ST)

hSTresults<-data.frame(cbind(ST,GINI))

#Repeats process for PUMA Ginis
hPUMA<-dlply(hdata, .(PUMAID), return.Gini)
GiniRaw<-unlist(hPUMA)
GINI<-GiniRaw[1:2351*5-4]
hPUMAresults<-data.frame(cbind(GINI,as.character(substr(names(GINI),0,7))))

us_states <- unique(fips_codes$state)[1:51]

pumas_list <- lapply(us_states, function(x) {
  pumas(state = x, cb = TRUE)
})

#Creates a single shapefile
USA <- rbind_tigris(pumas_list)


#Adds in the Gini information
USAdata<-geo_join(USA, hPUMAresults, "GEOID10","V2")
USAdata$GINI<-as.numeric(levels(USAdata$GINI))[USAdata$GINI]

writeOGR(USAdata, "./deploy", "usaewtest", driver="ESRI Shapefile")


system("say finished")
