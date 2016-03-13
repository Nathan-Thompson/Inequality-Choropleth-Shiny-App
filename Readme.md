# Inequality Choropleth Shiny App

![](/img/screen1.jpg)

This app. the [2013 ACS 1-year samples](https://www.census.gov/programs-surveys/acs/data/pums.html) to calculate [Gini](https://en.wikipedia.org/wiki/Gini_coefficient) values for every [Public Use Microdata Area](https://www.census.gov/geo/reference/puma.html). DataPull.R builds the shapefile with Gini attributes, and the ui/server files generate the map.


[Currently hosted here.](https://nthompson.shinyapps.io/deploy/)
*NOTE* Due to the large amount of polygons, this will take ~30sec to load. 

![](/img/screen2.jpg)

## Features To Add

-Add selectors for state level data, other years, other measures [Post-Tax Data](https://github.com/Nathan-Thompson/ACS-PUMS-PUMA-State-Inequality-Measures) 

-Ideally needs to be mapped with a TopoJSON for speed







