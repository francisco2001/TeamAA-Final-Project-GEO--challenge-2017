# Download Function

Mod_DOWNLOAD <- function (dates){
  #Create data folder
  dir.create(file.path('data/'), showWarnings = FALSE)
  setwd("data")
  
  
  ### NEED SOME CONTROL FLOW##############
  for (i in 1:length(dates)) {
    if (i==1) {
      
      ModisDownload("MOD13Q1",h=c(10,11,12) ,v=c(09),dates= dates[i],version = "006")
      ModisDownload("MOD13Q1",h=11 ,v=08,dates=dates[i],version = "006")
    }
    
    else if (i==2) {
      ModisDownload("MOD13Q1",h=c(10,11,12) ,v=c(09),dates=dates[i],version = "006")
      ModisDownload("MOD13Q1",h=11 ,v=08,dates=dates [i],version = "006")
    }
  }
  
  getwd()
  setwd("../")
}





