library(shiny)
library(leaflet)
library(dplyr)



setwd("C:/Users/Ramiro/Desktop/Data-science/data-science-2020/covid-19 spreading globally")

#Get countries coordinates
country <- read.csv("countries.csv", sep = ",", stringsAsFactors = FALSE,encoding = "UTF-8")
country[nrow(country)+1,] = c("WW",0,0,"Worldwide")
country[, 2]  <- as.numeric(country[, 2])
country[, 3]  <- as.numeric(country[, 3])

#get covid-19 data
covid.19 <- read.csv("global-data.csv", sep = ",", stringsAsFactors = FALSE,encoding = "UTF-8")

#subset with the last cumulative numbers
covid.19.last.cum.numbers <- covid.19 %>% group_by(Country) %>% slice(n()) 
covid.19.last.cum.numbers <- covid.19.last.cum.numbers[c(3,6,8:8)]

#merge countries with cumulative data
country <- merge(country,covid.19.last.cum.numbers, by.x = "name", by.y = "Country", all.x=TRUE)

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
 
 #get covid-19 information from country name
 get.country.data <- function(name){
   return(covid.19.last.cum.numbers %>% filter(Country == name))
 }
 #compress values to example: 10M -> 10.000.000
 
 
 popup_label <- paste("<br>", country$name,
                      "<hr>Confirmed cases: ",country$Cumulative_cases,
                      "<br>Confirmed deaths: ",country$Cumulative_deaths)
 
 output$map <- renderLeaflet({
   
   leaflet() %>% 
     addTiles() %>%
      setView(selected_country()$longitude,
                selected_country()$latitude,
                  zoom= ifelse(selected_country()$name == "Worldwide", 2 , 5)) %>%
      addCircles(lng = country$longitude,
                        lat = country$latitude,
                          color = "red",
                            stroke = FALSE,
                              radius = sqrt(country$Cumulative_cases)*500,
                                fillOpacity = 0.5,
                                  popup = popup_label
                       ) 
          
   
    })
   output$text <- renderText(
   {
     paste("Country: ", selected_country()$name, 
              "\nlong: ", selected_country()$longitude, 
                "\nlat: ", selected_country()$latitude,
                  "cumulative: ", get.country.data(selected_country()$name)$Cumulative_cases)
     
       
    
   }
 )
 
}

shinyApp(ui = ui, server = server)