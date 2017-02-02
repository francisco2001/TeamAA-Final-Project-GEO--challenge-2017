## Function to visualize result

# x=masked difference; y=roads and rivers buffer; thresholdmin & thresholdmax = range of difference, all=with other maps or just the main result, y/n?
PlotResult <- function (x, y, thresholdmin, thresholdmax, all){
  if (all == 'y'){
    format <- par(mfrow=c(2,2))
    
    #plot inset
    raster::getData("ISO3")
    Brazil <- raster::getData("GADM", country='BRA', level=0)
    Col <- raster::getData("GADM", country = 'COL', level=0)
    Brazil1 <- spTransform(Brazil, CRS(proj4string(mroadsBuffer)))
    Col1 <- spTransform(Col, CRS(proj4string(mroadsBuffer)))
    plot(Brazil1, col = F, axes=FALSE)
    invisible(text(getSpPPolygonsLabptSlots(Brazil1),labels = as.character(Brazil1$NAME_ENGLISH), cex = 1, col = "black", font = 2))
    plot(Col1, col = F, axes=FALSE, add=T)
    invisible(text(getSpPPolygonsLabptSlots(Col1),labels = as.character(Col1$NAME_ENGLISH), cex = 1, col = "black", font = 2))
    plot (amazonBoundsShp, xlim=c(-699378.2, 1269266.2), ylim=c(-1087670.2,  249453.5), col='grey', add=T, main='inset of major countries wihtin')
    box()
    
    #plot key results
    breakpoints <- c(0.0, -0.3, -0.6, -1.0) #general range just, may differ
    colours <- c('red', 'orange', 'yellow', 'green')
    plot (x, breaks=breakpoints, col=colours, raster=T, main='Range of NDVI difference', xlim=c(-699378.2, 1269266.2), ylim=c(-1087670.2,  249453.5))
    breakpoints1 <- c(thresholdmin, thresholdmax)
    colours1 <- c('red', 'yellow')
    plot (x, breaks=breakpoints1, col=colours1, main=paste('NDVI difference from', thresholdmin, 'to', thresholdmax), xlim=c(-699378.2, 1269266.2), ylim=c(-1087670.2,  249453.5))
    plot(y, col = F, cex = .1, add=T)
    change_mask <- mask(x ,RoadsRivers)
    plot (change_mask, breaks=breakpoints1, col=colours1, main=paste('NDVI difference from', thresholdmin, 'to', thresholdmax, 'at buffer'), xlim=c(-699378.2, 1269266.2), ylim=c(-1087670.2,  249453.5))
    par(format)
  } 
  
  else if (all == 'n'){
    breakpoints <- c(thresholdmin, thresholdmax)
    colours <- c('red', 'yellow')
    plot (x, breaks=breakpoints, col=colours,main=paste('NDVI difference from', thresholdmin, 'to', thresholdmax), xlim=c(-672800.1, 1270261.7), ylim=c(-1095821.7,  177633.6))
    plot(y, col = F, border='black', cex = .6, add=T, fill=F)
  }
}


  