#Function to read and reproject vectors

ReadandProject <- function (vector) {
  proj <- CRS('+proj=utm +zone=20 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ')
  if (vector == as.character(bounds)){
    ReadVec <- readOGR(vector, layer=ogrListLayers(vector))
    SelectVec <- ReadVec[ReadVec$NOME == "Amazonas", ]#sub-set desired administrative boundary
    FinalVec <- spTransform(SelectVec, proj)
  }
  else if (vector == as.character(secroads)){ #topology problem of original secondary roads due to number of observation
    dir.create('data/written_files', showWarnings = FALSE)
    dsn= file.path('data/written_files/sec_roads.shp')
    WriteVec <- ogr2ogr(as.character(vector), dsn, t_srs='EPSG:32620', f='ESRI Shapefile', verbose=T, progress=T)
    FinalVec <- readOGR(dsn, layer=ogrListLayers(dsn))
  }
  else if (vector == vector){
    ReadVec <- readOGR(vector, layer=ogrListLayers(vector))
    FinalVec <- spTransform(ReadVec, proj)    
  }
  return(FinalVec)
}


