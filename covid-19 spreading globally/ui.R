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
                 column(width = 12,
                        strong("Can this numbers be explained by airlines, highways or rail-connections? Or by big events like football matches and winter sports?"),
                        
                        tags$div(tags$br(),style="text-align: justify;","If we start look at facts, it shows apparently that certain events where someone who is infected without even knowing it, infects a lot of others at once. 
                                  While the image given so far is that these are \"super spreaders\", i.e. persons who, for one reason or another, infect many others, 
                                  I think that these events are occasions where the conditions of super spreading are optimal.",
                       
                       tags$br(),
                       tags$br(),
                                "Many events have been identified worldwide. All in the course of February. For example, a church meeting in Korea, an Islamic multi-day event in Malaysia, a Christian multi-day event in France and Mardi Gras in New Orleans.
                                In addition to these large-scale super spread events, there have also been many smaller scale super spread events. 
                                Meetings where significantly fewer people were present, but a large part of the attendees have become infected. 
                                These have for example been church services, choir rehearsals, or events around football matches. It seems, that where many people sing or talk in an enclosed space, one infected person can be responsible for the contamination of many by the emission of infected micro-drops.", 
                       tags$br(),
                       tags$br(),    
                                "And under unfavorable conditions (poor ventilation and low humidity) these micro-drops remain floating for a long time.
                                In Brabant-Limburg Carnival seems to have been a super spread event where many people got infected at the same time.",tags$a(href="https://www.maurice.nl/2020/04/23/thats-how-big-the-impact-of-super-spread-events-is/","[1]")),
                        
                       tags$br(),
                       tags$br(),
                 )  
                ),
                fluidRow(
                  column(width = 6,textOutput(outputId = "desc"),align="right"),
                  column(width = 6,tags$a(href = "https://www.kaggle.com/imdevskp/corona-virus-report", "Source: Kaggle", target = "_blank"), align="left"))
               )
                
