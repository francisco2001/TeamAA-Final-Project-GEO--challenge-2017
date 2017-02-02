# Subseting HDF files (NDVI layer) and convert it to a tif file

HDFtoTIF <- function (hdf_files) {
  
  y <- list()
  for (i in 1:length(hdf_files)){
    
    names<- hdf_files[i]
    t<- ".tif"
    y[i]<- paste(names,t,sep="" )
    # Get a list of sds names
    sds <- get_subdatasets(paste0 ("data/",hdf_files[i]))
    # Isolate the name of the first sds
    name <- sds[1]
    print (name)
    filename <- y[i]
    gdal_translate(name, dst_dataset = paste0("data/",filename))
  }
}