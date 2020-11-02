library(shiny)
source("main.R")

countries.list <- get.countries.list()
  
ui <- fluidPage(title = "Covid-19 Geographically overview",
               fluidRow(
                    column(width = 6, offset = 1, h3("Geographically overview - covid-19")),
                    column(width = 4, offset = 8, selectInput(
                                                                inputId = "select.country",
                                                                choices = unique(countries.list),
                                                                label = "Selecteer je land",
                                                                selected = "Wereldwide"
                                                              ) )
                ),
                fluidRow(
                   column(width = 3,
                        wellPanel(
                          fluidRow(
                            
                            fluidRow(width = 4, h4(textOutput("country.txt")),align="center",br()),
                            fluidRow(width = 4,"Totaal aantal gevallen",h4(textOutput("confirmed.cases.txt")), align="center"),
                            fluidRow(width = 4,"Sterfgevallen", h4(textOutput("confirmed.deaths.txt")), align="center"),
                            fluidRow(plotOutput("plot.evaluation",height = "200px"))
                          )
                              
                        )
                      ),
                   column(width = 9,leafletOutput("world.map",height="420px")) 
                  )
                )
