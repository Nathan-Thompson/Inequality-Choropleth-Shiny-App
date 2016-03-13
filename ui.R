

library(shiny)
library(leaflet)

#options<-c("Gini Index"="gini", "Theil Index"="theil")



ui<-fluidPage(
  titlePanel("2013 Individual Income Inequality"),
  leafletOutput("map", width="100%", 600)
  #inputPanel( selectInput(inputId = "index", label = "Choose a Measue of Inequality", choices = ioptions),
  #            selectInput(inputId = "level", label = "Choose a Geography Level", choices = loptions)
  #            ) 
)    
