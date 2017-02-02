#Function to download and unzip raster image

GetVectors <- function(url, filename) {
  file = paste0('data/', basename(url)) #i.e. data/railways.zip
  download.file (url=url, destfile=file, method="auto", mode="wb")
  unzip (file, exdir=paste0('data/', filename))
  myVector <- list.files(paste0('data/', filename), pattern = glob2rx('*.shp'), full.names = TRUE)
  file.remove (file)
  return (myVector)
}
