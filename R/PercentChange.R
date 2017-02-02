#Function that calculates the areas and percentage of changes that are within the buffer zone 

changes.areas <- function (x, y, thresholdmin, thresholdmax){
  x[!is.na(x$layer),]
  y[!is.na(y$layer),]
  inBuffer <- x[x <= thresholdmax & x >= thresholdmin]
  areaBuffer <- length(inBuffer) * (232*230)
  haBuffer <- areaBuffer / 10000
  inTotal <- y[y <= thresholdmax & y >= thresholdmin]
  areaTotal<- length(inTotal) * (232*230)
  haTotal <- areaTotal / 10000
  percentChange <- (haBuffer / haTotal) *100
  return (percentChange)
  } 

