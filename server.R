

library(shiny)
library(leaflet)
library(sp)
library(rgdal)

USAdata = readOGR(dsn = ".",layer = "usaewtest" )
pal <- colorNumeric(palette = 'YlOrRd', domain = USAdata$GINI)

server<-function(input, output) {
  output$map<-renderLeaflet({ 
    leaflet() %>% 
      addTiles(options=tileOptions(minZoom = 3)) %>% 
      setView(93.85,37.45,zoom =4) %>%
      setMaxBounds(-167.276413,5.499550,-52.233040, 83.162102) %>%
      addPolygons(data=USAdata, weight = 0.5, fillColor = ~pal(GINI),
                  color = 'lightgrey', fillOpacity = 0.75,
                  smoothFactor = 0.2) %>%
      addLegend(pal = pal,
                values = USAdata$GINI, title="2013 Gini")
  })
}