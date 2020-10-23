library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)

country <- build.map()

server <- function(input, output) {
  
  selected_country <- reactive({ 
    country %>% 
      filter(name == input$select.country)
  })
  
  output$world.map <- renderLeaflet({
    
    leaflet() %>% 
      addTiles() %>%
      setView(selected_country()$longitude,
              selected_country()$latitude,
              zoom= ifelse(selected_country()$name == "Wereldwide", 2 , 5)) %>%
      addCircles(lng = country$longitude,
                 lat = country$latitude,
                 color = "red",
                 stroke = FALSE,
                 radius = ifelse(country$name != "Wereldwide",sqrt(country$Cumulative_cases)*500,0),
                 fillOpacity = 0.5,
                 popup = show.popup(country)
      ) 
    
    
  })
  output$plot.evaluation <- renderPlot({
    build.country.graphic(selected_country())
  })
  
  output$country.txt <- renderText({
    selected_country()$name
  })
  
  output$confirmed.cases.txt <- renderText({
    get.confirmed.cases.txt(selected_country())
  })
  
  output$confirmed.deaths.txt <- renderText({
    get.confirmed.deaths.txt(selected_country())
  })
  
}