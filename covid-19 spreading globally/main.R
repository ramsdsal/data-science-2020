#script with all functions
library(forcats)
library(leaflet)
library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)

#load countries coordinates
country <- read.csv("datasets/countries.csv", sep = ",",encoding = "UTF-8")
covid.19 <- read.csv("datasets/global-data.csv", sep = ",", stringsAsFactors = FALSE,encoding = "UTF-8")


#function: no input, return unique countries name list
get.countries.list <- function(){
  new <- country[,4]
  new[length(new) + 1] <- "Worldwide"
  
  return(new)
}

get.last.numbers <- function(){
  covid.19.last.cum.numbers <- covid.19 %>% group_by(Country) %>% slice(n()) 
  covid.19.last.cum.numbers <- covid.19.last.cum.numbers[c(3,6,8:8)]
  return(covid.19.last.cum.numbers)
}

get.rank.countries <- function(){
  data <- get.last.numbers()
  data <- data[order(data$Cumulative_cases,decreasing = TRUE),]
  return(head(data,5))
}

#function: no input, return a data.frame with countries and coordinates
build.map <- function(){
  
  country[nrow(country)+1,] = c("WW",0,0,"Worldwide")
  country[, 2]  <- as.numeric(country[, 2])
  country[, 3]  <- as.numeric(country[, 3])
  country  <- country[, c(2:4)]
  
  #subset with the last cumulative numbers
  
  covid.19.last.cum.numbers <- get.last.numbers()
  #merge countries with cumulative data
  country <- merge(country,covid.19.last.cum.numbers, by.x = "name", by.y = "Country", all.x=TRUE)
  
  #clean not avaible data
  country <- clean.not.avaible.values(country)
  # fill worldwide data
  country[country$name == "Worldwide", "Cumulative_cases"] <- sum(country$Cumulative_cases)
  country[country$name == "Worldwide", "Cumulative_deaths"] <- sum(country$Cumulative_deaths) 
  
  return(country)
}

clean.not.avaible.values <- function(list){
  
  list$Cumulative_cases[is.na(list$Cumulative_cases)] <- 0
  list$Cumulative_deaths[is.na(list$Cumulative_deaths)] <- 0
  
  return(list)
}

#function: input is a list, return a text.
show.popup <- function(country){
  
  popup_label <- paste(
                        country$name,
                          hr(),
                            "Total cases: ", country$Cumulative_cases,
                              br(),
                                "Total deaths: ",country$Cumulative_deaths)
}

#function: input is row, return txt
get.confirmed.cases.txt <- function(row){
  return(humanise.number(row$Cumulative_cases))
}

get.confirmed.deaths.txt <- function(row){
  return(humanise.number(row$Cumulative_deaths))
}

humanise.number <- function(tx) { 
  div <- findInterval(as.numeric(gsub("\\,", "", tx)), 
                      c(0, 1e3, 1e6, 1e9, 1e12) )  
  paste(round( as.numeric(gsub("\\,","",tx))/10^(3*(div-1)), 2), 
        c("","K","M","B","T")[div] )}

get.bron.text <- function(){
  "Data collected from January to September 2020"
}

#build country graphic
build.country.graphic <- function(country){
  
  if(country$name == "Worldwide"){
    d <- get.rank.countries()
    
    data <- data.frame(
      name=d$Country,
      val=d$Cumulative_cases
    )
    
    data %>%
      mutate(name = fct_reorder(name, val)) %>%
      ggplot(aes(x=name, y=val)) +
      ggtitle("Most infected countries")+
      geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
      coord_flip() +
      xlab("Countries") +
      ylab("Cases")+
      theme_bw()
    
  }else{
    tryCatch(
      expr = {
        
        data <- covid.19 %>% filter(Country == country$name)        
        data <- data[,c(1,6,8)]
        
        data$X.U.FEFF.Date_reported <- as.Date(data$X.U.FEFF.Date_reported)
        
        plot(data$X.U.FEFF.Date_reported,data$Cumulative_cases,type = "h",ylab="cases", xlab = "")
        axis.POSIXct(1, at=data$X.U.FEFF.Date_reported, format="%b")
        title(main="Infections")
      
        }, warning = function(w) {
          print(w)
        }, error = function(e) {
          print(e)
        }
    )
    
  }
}