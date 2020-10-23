library(shiny)
source("main.R")

countries.list <- get.countries.list()
  
ui <- fluidPage(title = "Covid-19 Geographically overview",
               fluidRow(
                    column(width = 6, offset = 1, h3(paste("Geographically overview - covid-19"))),
                    column(width = 4, offset = 8, selectInput(
                                                                inputId = "select.country",
                                                                choices = unique(countries.list),
                                                                label = "Selecteer je land",
                                                                selected = "Wereldwide"
                                                              )
                           )
                ),
                leafletOutput("world.map"),
                hr(),
                wellPanel(
                  fluidRow(
                    
                      column(width = 4,"Geselecteerd optie",h2(textOutput("country.txt"))),
                      column(width = 4,"Totaal aantal gevallen",h4(textOutput("confirmed.cases.txt")), align="center"),
                      column(width = 4,"Sterfgevallen", h4(textOutput("confirmed.deaths.txt")), align="center"),
                  ),
                  fluidRow(
                    column(width = 12,
                           checkboxInput(inputId = "moreinfo", label = "Meer informatie bekijken", value = FALSE),
                           conditionalPanel(
                              condition = "input.moreinfo == true",
                                fluidRow(
                                        column(width = 4,
                                           dateRangeInput("date", 
                                                          "Selecteer een datum interval",
                                                              start = "2020-01-01",
                                                                end = Sys.Date(),
                                                                  min = "2020-01-01",
                                                                    max = Sys.Date())
                                        ),
                                        column(width = 4,style = "margin-top: 25px;", actionButton(inputId = "date.range", label="Update")),
                                        column(width = 2)
                                ),
                              fluidRow(width = 12,
                                        plotOutput("plot.evaluation")
                              )
                           )
                    )
                  )
                )
)