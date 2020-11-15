library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(shiny)
source("main.R")

countries.list <- get.countries.list()

title = "Geographically overview Covid-19"
  
ui <- fluidPage(titlePanel(title, windowTitle = title),
               fluidRow(
                    column(width = 6, offset = 1),
                    column(width = 4, offset = 8, selectInput(
                                                                inputId = "select.country",
                                                                choices = unique(countries.list),
                                                                label = "Select a country",
                                                                selected = "Worldwide"
                                                              ) )
                ),
                fluidRow(
                   column(width = 3,
                        wellPanel(
                          fluidRow(
                            
                            fluidRow(width = 4, h4(textOutput("country.txt")),align="center",br()),
                            fluidRow(width = 4,"Total cases",h4(textOutput("confirmed.cases.txt")), align="center"),
                            fluidRow(width = 4,"Total deaths", h4(textOutput("confirmed.deaths.txt")), align="center"),
                            fluidRow(plotOutput("plot.evaluation",height = "200px"))
                            
                          )
                              
                        )
                      ),
                   column(width = 9,leafletOutput("world.map",height="420px"))
                  ),
                fluidRow(
                  column(width = 6,textOutput(outputId = "desc"),align="right"),
                  column(width = 6,tags$a(href = "https://www.kaggle.com/imdevskp/corona-virus-report", "Source: Kaggle", target = "_blank"), align="left"))
               )
                
