#Function to deal with large vector datasets via gdal

ReadLargeFiles <- function (vector){
  print ('make sure you run function above first')
  clipper=file.path("data/written_files/amazon.shp")
  writeOGR(amazonBoundsShp, dsn=clipper, layer="amazon", driver="ESRI Shapefile", overwrite_layer=TRUE,morphToESRI=TRUE) #write clipping extent shp
  dsn= file.path('data/written_files/sec_roads.shp')
  dsn_clip=file.path("data/written_files/sec_roads_clip.shp")
  WriteVec <- ogr2ogr(dsn, dsn_clip, t_srs='EPSG:32620', f='ESRI Shapefile', clipsrc=clipper, verbose=T, progress=T)
  FinalVec <- readOGR(dsn_clip, layer=ogrListLayers(dsn_clip))
  return (FinalVec)
}


