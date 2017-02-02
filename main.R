## Author: TeamAA (Arnan Araza, Francisco Arias)
##Geo challenge 2017
## 2 February 2017
## Theme title: Calculating the percentage of deforestation inside buffer zones from main and secondary roads and rivers inside Amazonia using two periods of MODIS NDVI


#Clean Workspace
rm(list=ls())

## loading functions
source ('R/MODIS_DOWNLOAD .R')
source ('R/Difference.R')
source ('R/Packages.R')
source ('R/HDFtoTIF.R')
source ('R/GetData.R')
source ('R/ReadProjectVector.R')
source ('R/Buffer.R')
source ('R/MergePeriod.R')
source ('R/ReadLargeFiles.R')
source ('R/PercentChange.R')
source ('R/Visualization.R')

# Install packages if neccesary
packages( c("rts" , "rgdal" , "rgeos","gdalUtils","maptools","clipr","gridExtra","sp","spatstat","DT","RCurl", "dplyr"))



####PART I : DOWNLOADING MODIS IMAGINERY AND PROCESSING 

#Login USERNAME to access NASA database
setNASAauth('username',"password") # Follow Download instructions text. 

#Periods to analyse
dates <- c('2000.03.05','2016.03.05') #Follow Download instructions to fill periods of analysis 
Mod_DOWNLOAD (dates)

#Converting HDF subset (NDVI) to tif files
hdf_files <- list.files('data', pattern = glob2rx('*.hdf'), full.names = FALSE)
print (hdf_files)
HDFtoTIF (hdf_files)

#Making list of tiff files, Merge tiles and re scale NDVI factor
tif_files_period1 <- list.files('data', pattern = glob2rx(paste0('*A',substr(dates[1],1,4),"*",".tif")), full.names = FALSE)
print (tif_files_period1)
tif_files_period2 <- list.files('data', pattern = glob2rx(paste0('*A',substr(dates[2],1,4),"*",".tif")),full.names = FALSE)
print (tif_files_period2)

merge_period1_UTM <- Mer_tiff (x= tif_files_period1,filename = "data/Merge_period1_UTM.tif") # Merging tiles per year 
plot (merge_period1_UTM, main= paste("Normalized Difference Vegetation Index (NDVI) year",substr(dates[1],1,4)))
merge_period2_UTM <- Mer_tiff (x= tif_files_period2, filename = "data/Merge_period2_UTM.tif")
plot (merge_period2_UTM,main =paste("Normalized Difference Vegetation Index (NDVI) year",substr(dates[2],1,4)))

#Checking if  extent are equals
all.equal(extent(merge_period1_UTM),extent(merge_period2_UTM))

#Difference between periods
Difference_periods <- overlay(merge_period1_UTM, merge_period2_UTM, fun= diff_periods)
extent1 = c(-1732161 , 2093657 ,-1141669,1153822)
plot (Difference_periods,ext= extent1, main= "Difference of NDVI values over the years of analysis")



####PART II: DOWNLOADING VECTOR AND PROCESSING VECTORS

##Download vectors
mainroadsFiles <- GetVectors ('http://servicos.dnit.gov.br/vgeo/0Arquivos/download1/rodovias_federais_SNV.zip', 'roads1')
secroadsFiles <- GetVectors ('ftp://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bcim/versao2016/shapefile/BCIM_TRA_versao2016.zip', 'roads2')
boundsFiles <- GetVectors ('ftp://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bcim/versao2016/shapefile/BCIM_LIM_versao2016.zip', 'boundary')

mainroads <- mainroadsFiles[1] #check list of files and pre-select since data source unpacks multiple data
secroads <- secroadsFiles[13]
rivers <- secroadsFiles[12]
bounds <- boundsFiles [8]

##Read files as shp and project 
mainroadsShp <-ReadandProject (mainroads)
secroadsShp <-ReadandProject (secroads) 
riversShp <-ReadandProject (rivers)
amazonBoundsShp <- ReadandProject (bounds)

##Read another function for large files like secondary roads in this script
secroadsShp2 <- ReadLargeFiles (secroadsShp)

##Clip vectors into desired extent
mroadsClip <- crop(mainroadsShp, amazonBoundsShp)
sroadsClip <- crop(secroadsShp2, amazonBoundsShp)  
mriversClip <- crop(riversShp, amazonBoundsShp)

#Buffer and Dissolve
mroadsBuffer <- BufferVectors(mroadsClip, '6000')
sroadsBuffer <- BufferVectors(sroadsClip, '6000')
mriversBuffer <- BufferVectors(mriversClip, '1000')
sroadsBuffer2 <- spTransform(sroadsBuffer, CRS(proj4string(mroadsBuffer))) #same projection but originated from a gdal product

#Merge vectors
allRoads <- rbind(mroadsBuffer, sroadsBuffer2)
RoadsRivers <- rbind(allRoads, mriversBuffer)
plot(RoadsRivers)


####PART III: CALCULATING CHANGES INSIDE BUFFER ZONES AND CHANGES OVER THE AMAZONIA STATE 

##Extract pixels with a decrease change in NDVI
extractinBuffer <- extract(Difference_periods, RoadsRivers, df=T) #inside buffer
extractinAmazon <- extract(Difference_periods, amazonBoundsShp, df=T) #whole Amazon state

##Compute area and percentage of changes inside Buffer zone and Amazon extent.
lowDiff <- changes.areas (extractinBuffer, extractinAmazon, -0.3, 0.0)
midDiff<-  changes.areas (extractinBuffer, extractinAmazon, -0.5,-0.3 )  
highDiff<- changes.areas (extractinBuffer, extractinAmazon, -2, -0.6)  
print(c("The percentage of changes between 0 and -0.3 is: ",lowDiff,
        "The percentage of changes between -0.3 and -0.5 is: ",midDiff,
        "The percentage of changes between  -0.6 and -2 is : ",highDiff))


####PART IV : Visualize

Difference_periods_mask <- mask(Difference_periods,amazonBoundsShp)

#Visualisation of key results 
PlotResult(Difference_periods_mask, RoadsRivers, -2.0, -0.6, 'y') #kindly refer to the functin script for arguments description


#Converting to KML 
Difference_period_mask_to_KML <- projectRaster(Difference_periods_mask, crs='+proj=longlat') #Reproject changes raster to Lat,long
KML(x=Difference_period_mask_to_KML, filename='data/Difference_period_mask.kml',overwrite=TRUE) #Create a KML of the changes of NDVI over the period of analysis





















