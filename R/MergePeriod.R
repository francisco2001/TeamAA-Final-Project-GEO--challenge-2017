# Merge Tiff FILES FUNCTION

#From list of tiles of each period we design a loop that creates a list of raster for each period, to be used in the merging function

Mer_tiff <- function (x,filename) {
  
  list.rast.per <- list()
  for (i in 1:length(x)) {
    
    list.rast.per[i] <- raster(readGDAL(paste0("data/",x[i])))
  
  }
  
  #Merging and Re scaling factor of NDVI for period1 (2000) and period2 (2016). Reproject to UTM zone 20
  Merge_period<- do.call(merge,list.rast.per)
  Merge_period_rScale <- Merge_period / (10000^2)
  merge_UTM <- projectRaster(Merge_period_rScale, crs='+proj=utm +zone=20 +datum=WGS84 +units=m +no_defs +ellps=WGS84',method ="bilinear", filename = filename,overwrite =TRUE)
    return(merge_UTM)
}
  
  
  
  
  
  
  
  