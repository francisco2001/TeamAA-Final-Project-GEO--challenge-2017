#Function to buffer roads and rivers

BufferVectors <- function (vector, width){
  if (width <= '1000'){ #buffer for rivers is lesser than roads according to the reference paper
    buffer <-gBuffer(vector, width=1000, quadsegs=5, capStyle="ROUND") 
    df<- data.frame(id = getSpPPolygonsIDSlots(buffer))
    row.names(df) <- getSpPPolygonsIDSlots(buffer)
    riverBuffer <- SpatialPolygonsDataFrame(buffer, df)
    riverBuffer$description <- 1:nrow(riverBuffer)
    riverBuffer$description <- as.character(width)
    return (riverBuffer)
  }
  else if (width == width){
    buffer <-gBuffer(vector, width=width, quadsegs=5, capStyle="ROUND")
    df<- data.frame(id = getSpPPolygonsIDSlots(buffer))
    row.names(df) <- getSpPPolygonsIDSlots(buffer)
    roadsBuffer <- SpatialPolygonsDataFrame(buffer, df)
    roadsBuffer$description <- 1:nrow(roadsBuffer)
    roadsBuffer$description <- as.character(width)
    return (roadsBuffer)
  }
}
