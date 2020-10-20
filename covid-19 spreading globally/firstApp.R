library(shiny)
library(leaflet)
library(dplyr)



setwd("C:/Users/Ramiro/Desktop/Covid-19 Shiny/Opdracht1")

country <- read.csv("countries.csv", sep = ",", stringsAsFactors = FALSE, encoding = "Latin-1")
country[nrow(country)+1,] = c("WW",0,0,"Worldwide")
country[, 2]  <- as.numeric(country[, 2])
country[, 3]  <- as.numeric(country[, 3])

ui <- fluidPage(
  titlePanel("Covid-19 spreading globally"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "name",
        label = "Select your country",
        choices = unique(country$name),
        selected = "Worldwide"
      )
    ),
    mainPanel(
      leafletOutput("map"),
      textOutput("text")
    )
  )
)

server <- function(input, output){
 selected_country <- reactive({ 
   country %>% 
     filter(name == input$name) 
  })
 
 output$map <- renderLeaflet({
   
   leaflet() %>% 
     addTiles() %>%
      setView(	
        selected_country()$longitude,
        selected_country()$latitude,
        zoom= ifelse(selected_country()$name == "Worldwide", 2 , 6)
        )
   
    })
   output$text <- renderText(
   {
     paste("Country: ", selected_country()$name, 
              "\nlong: ", selected_country()$longitude, 
                "\nlat: ", selected_country()$latitude)
   }
 )
 
}

shinyApp(ui = ui, server = server)