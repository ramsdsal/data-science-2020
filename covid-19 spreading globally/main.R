#script with all functions


#load countries coordinates
country <- read.csv("countries.csv", sep = ",",encoding = "UTF-8")
covid.19 <- read.csv("global-data.csv", sep = ",", stringsAsFactors = FALSE,encoding = "UTF-8")


#function: no input, return unique countries name list
get.countries.list <- function(){
  new <- country[,4]
  new[length(new) + 1] <- "Wereldwide"
  
  return(new)
}


#function: no input, return a data.frame with countries and coordinates
build.map <- function(){
  
  country[nrow(country)+1,] = c("WW",0,0,"Wereldwide")
  country[, 2]  <- as.numeric(country[, 2])
  country[, 3]  <- as.numeric(country[, 3])
  country  <- country[, c(2:4)]
  
  #subset with the last cumulative numbers
  covid.19.last.cum.numbers <- covid.19 %>% group_by(Country) %>% slice(n()) 
  covid.19.last.cum.numbers <- covid.19.last.cum.numbers[c(3,6,8:8)]
  
  #merge countries with cumulative data
  country <- merge(country,covid.19.last.cum.numbers, by.x = "name", by.y = "Country", all.x=TRUE)
  
  #clean not avaible data
  country <- clean.not.avaible.values(country)
  # fill wereldwide data
  country[country$name == "Wereldwide", "Cumulative_cases"] <- sum(country$Cumulative_cases)
  country[country$name == "Wereldwide", "Cumulative_deaths"] <- sum(country$Cumulative_deaths) 
  
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
                            "Totaal aantal gevallen: ", country$Cumulative_cases,
                              br(),
                                "Sterfgevallen: ",country$Cumulative_deaths)
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
                      c(0, 1e3, 1e6, 1e9, 1e12) )  # modify this if negative numbers are possible
  paste(round( as.numeric(gsub("\\,","",tx))/10^(3*(div-1)), 2), 
        c("","K","M","B","T")[div] )}


#build world graphic
build.wereldwide.graphic <- function(){
  
}
#build country graphic
build.country.graphic <- function(country){
  
  data <- covid.19 %>% filter(Country == country$name)
  data <- data[,c(1,6,8)]
  data2 <- data.frame(x = data$X.U.FEFF.Date_reported,y = data$Cumulative_cases,z = data$Cumulative_deaths)
  data2$x <- as.Date(data2$x)
  #data2 <- tail(data2,14)
  ggplot(data2, aes(x), width=100, height=100,show.legend = FALSE) + 
    geom_line(aes(y = y, colour = "red")) + 
    geom_line(aes(y = z, colour = "blue"))+
    ylab('Aantalen')+xlab('Datum')+
    scale_colour_manual(name = 'Legend',values =c('blue'='blue','red'='red'), labels = c('Gevallen','Sterf'))
}



  

