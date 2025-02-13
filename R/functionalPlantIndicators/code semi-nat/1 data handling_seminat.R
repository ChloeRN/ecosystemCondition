library(downloader)
library(sf)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(tidyverse)
library(readxl)
library(tmap)
library(tmaptools)

#### download ANO data from kartkatalogen to P-drive ####
# url <- "https://nedlasting.miljodirektoratet.no/naturovervaking/naturovervaking_eksport.gdb.zip"
download(url, dest="P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb.zip", mode="w") 
unzip ("P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb.zip", 
       exdir = "P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb2")

st_layers(dsn = "P:/41201785_okologisk_tilstand_2022_2023/data/naturovervaking_eksport.gdb2")

# SOMETHING NOT WORKING YET



#### upload data from P-drive ####
## ANO
st_layers(dsn = "P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb")
ANO.sp <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb",
                   layer="ANO_Art")
ANO.geo <- st_read("P:/41201785_okologisk_tilstand_2022_2023/data/Naturovervaking_eksport.gdb",
                  layer="ANO_SurveyPoint")
head(ANO.sp)
head(ANO.geo)


## ASO data from 2022
excel_sheets("P:/41201785_okologisk_tilstand_2022_2023/data/ASO/Semi-naturlig_eng_S123_2022.xlsx")

ASO.sp <- read_excel("P:/41201785_okologisk_tilstand_2022_2023/data/ASO/Semi-naturlig_eng_S123_2022.xlsx", 
                     sheet = "transektregistreringer_4")
ASO.geo <- read_excel("P:/41201785_okologisk_tilstand_2022_2023/data/ASO/Semi-naturlig_eng_S123_2022.xlsx",
                      sheet = "surveyPoint_0")
head(ASO.sp)
head(ASO.geo)


## Tyler indicator data
#ind.Tyler <- read.table("P:/41201785_okologisk_tilstand_2022_2023/data/functional plant indicators/Tyler et al_Swedish plant indicators.txt",
#                        sep = '\t', header=T, quote = '')
#head(ind.Tyler)

ind.Tyler <- read_excel("P:/41201785_okologisk_tilstand_2022_2023/data/functional plant indicators/Tyler et al.xlsx", 
                        sheet = "data")
ind.Tyler <- as.data.frame(ind.Tyler)
head(ind.Tyler)

## generalized species lists NiN
load("P:/41201785_okologisk_tilstand_2022_2023/data/functional plant indicators//reference from NiN/Eco_State.RData")
str(Eco_State)

#### data handling - functional indicator data ####
names(ind.Tyler)[1] <- 'species'
ind.Tyler$species <- as.factor(ind.Tyler$species)
summary(ind.Tyler$species)
ind.Tyler <- ind.Tyler[!is.na(ind.Tyler$species),]
ind.Tyler[,'species.orig'] <- ind.Tyler[,'species']
ind.Tyler[,'species'] <- word(ind.Tyler[,'species'], 1,2)
#ind.Tyler2 <- ind.Tyler
#ind.Tyler <- ind.Tyler2
ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler.dup <- ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler[ind.Tyler$species %in% ind.Tyler.dup,c("Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance","species.orig","species")]
ind.Tyler <- ind.Tyler %>% filter( !(species.orig %in% list("Ammophila arenaria x Calamagrostis epigejos",
                                                            "Anemone nemorosa x ranunculoides",
                                                            "Armeria maritima ssp. elongata",
                                                            "Asplenium trichomanes ssp. quadrivalens",
                                                            "Calystegia sepium ssp. spectabilis",
                                                            "Campanula glomerata 'Superba'",
                                                            "Dactylorhiza maculata ssp. fuchsii",
                                                            "Erigeron acris ssp. droebachensis",
                                                            "Erigeron acris ssp. politus",
                                                            "Erysimum cheiranthoides L. ssp. alatum",
                                                            "Euphrasia nemorosa x stricta var. brevipila",
                                                            "Galium mollugo x verum",
                                                            "Geum rivale x urbanum",
                                                            "Hylotelephium telephium (ssp. maximum)",
                                                            "Juncus alpinoarticulatus ssp. rariflorus",
                                                            "Lamiastrum galeobdolon ssp. argentatum",
                                                            "Lathyrus latifolius ssp. heterophyllus",
                                                            "Medicago sativa ssp. falcata",
                                                            "Medicago sativa ssp. x varia",
                                                            "Monotropa hypopitys ssp. hypophegea",
                                                            "Ononis spinosa ssp. hircina",
                                                            "Ononis spinosa ssp. procurrens",
                                                            "Pilosella aurantiaca ssp. decolorans",
                                                            "Pilosella aurantiaca ssp. dimorpha",
                                                            "Pilosella cymosa ssp. gotlandica",
                                                            "Pilosella cymosa ssp. praealta",
                                                            "Pilosella officinarum ssp. peleteranum",
                                                            "Poa x jemtlandica (Almq.) K. Richt.",
                                                            "Poa x herjedalica Harry Sm.",
                                                            "Ranunculus peltatus ssp. baudotii",
                                                            "Sagittaria natans x sagittifolia",
                                                            "Salix repens ssp. rosmarinifolia",
                                                            "Stellaria nemorum L. ssp. montana",
                                                            "Trichophorum cespitosum ssp. germanicum")
) )
ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler.dup <- ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler[ind.Tyler$species %in% ind.Tyler.dup,c("Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance","species.orig","species")]
# getting rid of sect. for Hieracium
ind.Tyler <- ind.Tyler %>% mutate(species=gsub("sect. ","",species.orig))
ind.Tyler[,'species'] <- word(ind.Tyler[,'species'], 1,2)

ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler.dup <- ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]
ind.Tyler[ind.Tyler$species %in% ind.Tyler.dup,c("Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance","species.orig","species")]
# only hybrids left -> get rid of these
ind.Tyler <- ind.Tyler[!duplicated(ind.Tyler[,'species']),]
ind.Tyler[duplicated(ind.Tyler[,'species']),"species"]

ind.Tyler$species <- as.factor(ind.Tyler$species)
summary(ind.Tyler$species)
# no duplicates left

ind.dat <- ind.Tyler
rm(ind.Tyler)


# fix some species name issues
ind.dat <- ind.dat %>% 
  mutate(species=str_replace(species,"Aconitum lycoctonum", "Aconitum septentrionale")) %>% 
  mutate(species=str_replace(species,"Carex simpliciuscula", "Kobresia simpliciuscula")) %>%
  mutate(species=str_replace(species,"Carex myosuroides", "Kobresia myosuroides")) %>%
  mutate(species=str_replace(species,"Clinopodium acinos", "Acinos arvensis")) %>%
  mutate(species=str_replace(species,"Artemisia rupestris", "Artemisia norvegica")) %>%
  mutate(species=str_replace(species,"Cherleria biflora", "Minuartia biflora"))
  



#### data handling - ANO data ####
head(ANO.sp)
head(ANO.geo)

## fix NiN information
ANO.geo$hovedtype_rute <- substr(ANO.geo$kartleggingsenhet_1m2,1,3) # take the 3 first characters
ANO.geo$hovedtype_rute <- gsub("-", "", ANO.geo$hovedtype_rute) # remove hyphon
unique(as.factor(ANO.geo$hovedtype_rute))

## fix NiN-variables
colnames(ANO.geo)
colnames(ANO.geo)[42:47] <- c("groeftingsintensitet",
                              "bruksintensitet",
                              "beitetrykk",
                              "slatteintensitet",
                              "tungekjoretoy",
                              "slitasje")
head(ANO.geo)

# remove variable code in the data
ANO.geo$groeftingsintensitet <- gsub("7GR-GI_", "", ANO.geo$groeftingsintensitet) 
unique(ANO.geo$groeftingsintensitet)
ANO.geo$groeftingsintensitet <- gsub("X", "NA", ANO.geo$groeftingsintensitet)
unique(ANO.geo$groeftingsintensitet)
ANO.geo$groeftingsintensitet <- as.numeric(ANO.geo$groeftingsintensitet)
unique(ANO.geo$groeftingsintensitet)

ANO.geo$bruksintensitet <- gsub("7JB-BA_", "", ANO.geo$bruksintensitet) 
unique(ANO.geo$bruksintensitet)
ANO.geo$bruksintensitet <- gsub("X", "NA", ANO.geo$bruksintensitet)
unique(ANO.geo$bruksintensitet)
ANO.geo$bruksintensitet <- as.numeric(ANO.geo$bruksintensitet)
unique(ANO.geo$bruksintensitet)

ANO.geo$beitetrykk <- gsub("7JB-BT_", "", ANO.geo$beitetrykk) 
unique(ANO.geo$beitetrykk)
ANO.geo$beitetrykk <- gsub("X", "NA", ANO.geo$beitetrykk)
unique(ANO.geo$beitetrykk)
ANO.geo$beitetrykk <- as.numeric(ANO.geo$beitetrykk)
unique(ANO.geo$beitetrykk)

ANO.geo$slatteintensitet <- gsub("7JB-SI_", "", ANO.geo$slatteintensitet) 
unique(ANO.geo$slatteintensitet)
ANO.geo$slatteintensitet <- gsub("X", "NA", ANO.geo$slatteintensitet)
unique(ANO.geo$slatteintensitet)
ANO.geo$slatteintensitet <- as.numeric(ANO.geo$slatteintensitet)
unique(ANO.geo$slatteintensitet)

ANO.geo$tungekjoretoy <- gsub("7TK_", "", ANO.geo$tungekjoretoy) 
unique(ANO.geo$tungekjoretoy)
ANO.geo$tungekjoretoy <- gsub("X", "NA", ANO.geo$tungekjoretoy)
unique(ANO.geo$tungekjoretoy)
ANO.geo$tungekjoretoy <- as.numeric(ANO.geo$tungekjoretoy)
unique(ANO.geo$tungekjoretoy)

ANO.geo$slitasje <- gsub("7SE_", "", ANO.geo$slitasje) 
unique(ANO.geo$slitasje)
ANO.geo$slitasje <- gsub("X", "NA", ANO.geo$slitasje)
unique(ANO.geo$slitasje)
ANO.geo$slitasje <- as.numeric(ANO.geo$slitasje)
unique(ANO.geo$slitasje)

## check that every point is present only once
length(levels(as.factor(ANO.geo$ano_flate_id)))
length(levels(as.factor(ANO.geo$ano_punkt_id)))
summary(as.factor(ANO.geo$ano_punkt_id))
# there's many double presences, probably some wrong registrations of point numbers,
# but also double registrations (e.g. ANO0159_55)
# CHECK THIS when preparing ecosystem-datasets for scaling




# fix species names
ANO.sp$Species <- ANO.sp$art_navn
unique(as.factor(ANO.sp$Species))
#ANO.sp$Species <- sub(".*?_", "", ANO.sp$Species) # lose the Norwegian name in the front
ANO.sp[,'Species'] <- word(ANO.sp[,'Species'], 1,2) # lose subspecies
ANO.sp$Species <- str_to_title(ANO.sp$Species) # make first letter capital
#ANO.sp$Species <- gsub("_", " ", ANO.sp$Species) # replace underscore with space
ANO.sp$Species <- gsub("( .*)","\\L\\1",ANO.sp$Species,perl=TRUE) # make capital letters after hyphon to lowercase
ANO.sp$Species <- gsub("( .*)","\\L\\1",ANO.sp$Species,perl=TRUE) # make capital letters after space to lowercase
unique(as.factor(ANO.sp$Species))
ANO.sp$Species <- gsub("�\u0097", "", ANO.sp$Species) # remove �\0097
unique(as.factor(ANO.sp$Species))
# removal does not work
# \u0097 stands for the special x, so these species are all hybrids that won't find a match with ind.dat anyways -> can be ignored


## merge species data with indicators
ANO.sp.ind <- merge(x=ANO.sp[,c("Species", "art_dekning", "ParentGlobalID")], 
                y= ind.dat[,c("species","Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance")],
                by.x="Species", by.y="species", all.x=T)
summary(ANO.sp.ind)


# checking which species didn't find a match
unique(ANO.sp.ind[is.na(ANO.sp.ind$Moisture),'Species'])


ANO.sp <- ANO.sp %>% 
  mutate(Species=str_replace(Species,"Arctous alpinus", "Arctous alpina")) %>%
  mutate(Species=str_replace(Species,"Betula tortuosa", "Betula pubescens")) %>%
  mutate(Species=str_replace(Species,"Blysmopsis rufa", "Blysmus rufus")) %>%
  mutate(Species=str_replace(Species,"Cardamine nymanii", "Cardamine pratensis")) %>%
  mutate(Species=str_replace(Species,"Carex adelostoma", "Carex buxbaumii")) %>%
  mutate(Species=str_replace(Species,"Carex leersii", "Carex echinata")) %>%
  mutate(Species=str_replace(Species,"Carex paupercula", "Carex magellanica")) %>%
  mutate(Species=str_replace(Species,"Carex simpliciuscula", "Kobresia simpliciuscula")) %>%
  mutate(Species=str_replace(Species,"Carex viridula", "Carex flava")) %>%
  mutate(Species=str_replace(Species,"Chamaepericlymenum suecicum", "Cornus suecia")) %>%
  mutate(Species=str_replace(Species,"Cicerbita alpina", "Lactuca alpina")) %>%
  mutate(Species=str_replace(Species,"Empetrum hermaphroditum", "Empetrum nigrum")) %>%
  mutate(Species=str_replace(Species,"Festuca prolifera", "Festuca rubra")) %>%
  mutate(Species=str_replace(Species,"Galium album", "Galium mollugo")) %>%
  mutate(Species=str_replace(Species,"Galium elongatum", "Galium palustre")) %>%
  mutate(Species=str_replace(Species,"Helictotrichon pratense", "Avenula pratensis")) %>%
  mutate(Species=str_replace(Species,"Helictotrichon pubescens", "Avenula pubescens")) %>%
  mutate(Species=str_replace(Species,"Hieracium alpina", "Hieracium Alpina")) %>%
  mutate(Species=str_replace(Species,"Hieracium alpinum", "Hieracium Alpina")) %>%
  mutate(Species=str_replace(Species,"Hieracium hieracium", "Hieracium Hieracium")) %>%
  mutate(Species=str_replace(Species,"Hieracium hieracioides", "Hieracium umbellatum")) %>%
  mutate(Species=str_replace(Species,"Hieracium murorum", "Hieracium Vulgata")) %>%
  mutate(Species=str_replace(Species,"Hieracium oreadea", "Hieracium Oreadea")) %>%
  mutate(Species=str_replace(Species,"Hieracium prenanthoidea", "Hieracium Prenanthoidea")) %>%
  mutate(Species=str_replace(Species,"Hieracium vulgata", "Hieracium Vulgata")) %>%
  mutate(Species=str_replace(Species,"Hieracium pilosella", "Pilosella officinarum")) %>%
  mutate(Species=str_replace(Species,"Hieracium vulgatum", "Hieracium umbellatum")) %>%
  mutate(Species=str_replace(Species,"Hierochloã« alpina", "Hierochloë alpina")) %>%
  mutate(Species=str_replace(Species,"Hierochloã« hirta", "Hierochloë hirta")) %>%
  mutate(Species=str_replace(Species,"Hierochloã« odorata", "Hierochloë odorata")) %>%
  mutate(Species=str_replace(Species,"Listera cordata", "Neottia cordata")) %>%
  mutate(Species=str_replace(Species,"Leontodon autumnalis", "Scorzoneroides autumnalis")) %>%
  mutate(Species=str_replace(Species,"Loiseleuria procumbens", "Kalmia procumbens")) %>%
  mutate(Species=str_replace(Species,"Mycelis muralis", "Lactuca muralis")) %>%
  mutate(Species=str_replace(Species,"Omalotheca supina", "Gnaphalium supinum")) %>%
  mutate(Species=str_replace(Species,"Omalotheca norvegica", "Gnaphalium norvegicum")) %>%
  mutate(Species=str_replace(Species,"Omalotheca sylvatica", "Gnaphalium sylvaticum")) %>%
  mutate(Species=str_replace(Species,"Oreopteris limbosperma", "Thelypteris limbosperma")) %>%
  mutate(Species=str_replace(Species,"Oxycoccus microcarpus", "Vaccinium microcarpum")) %>%
  mutate(Species=str_replace(Species,"Oxycoccus palustris", "Vaccinium oxycoccos")) %>%
  mutate(Species=str_replace(Species,"Phalaris minor", "Phalaris arundinacea")) %>%
  mutate(Species=str_replace(Species,"Pinus unicinata", "Pinus mugo")) %>%
  mutate(Species=str_replace(Species,"Poa alpigena", "Poa pratensis")) %>%
  mutate(Species=str_replace(Species,"Poa angustifolia", "Poa pratensis")) %>%
  mutate(Species=str_replace(Species,"Pyrola grandiflora", "Pyrola rotundifolia")) %>%
  mutate(Species=str_replace(Species,"Rumex alpestris", "Rumex acetosa")) %>%
  mutate(Species=str_replace(Species,"Syringa emodi", "Syringa vulgaris")) %>%
  mutate(Species=str_replace(Species,"Taraxacum crocea", "Taraxacum officinale")) %>%
  mutate(Species=str_replace(Species,"Taraxacum croceum", "Taraxacum officinale")) %>%
  mutate(Species=str_replace(Species,"Trientalis europaea", "Lysimachia europaea")) %>%
  mutate(Species=str_replace(Species,"Trifolium pallidum", "Trifolium pratense"))

## merge species data with indicators
ANO.sp.ind <- merge(x=ANO.sp[,c("Species", "art_dekning", "ParentGlobalID")], 
                    y= ind.dat[,c("species","Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance")],
                    by.x="Species", by.y="species", all.x=T)
summary(ANO.sp.ind)
# checking which species didn't find a match
unique(ANO.sp.ind[is.na(ANO.sp.ind$Moisture),'Species'])
# don't find synonyms for these in the ind lists

colnames(ANO.geo)

## adding information on ecosystem and condition variables
ANO.sp.ind <- merge(x=ANO.sp.ind, 
                y=ANO.geo[,c("GlobalID","ano_flate_id","ano_punkt_id","ssb_id","aar",
                             "hovedoekosystem_punkt","hovedtype_rute","kartleggingsenhet_1m2",
                             "bruksintensitet","beitetrykk","slatteintensitet", "tungekjoretoy","slitasje",
                             "vedplanter_total_dekning","busker_dekning","tresjikt_dekning","roesslyng_dekning")], 
            by.x="ParentGlobalID", by.y="GlobalID", all.x=T)
# trimming away the points without information on NiN, species or cover
ANO.sp.ind <- ANO.sp.ind[!is.na(ANO.sp.ind$Species),]
ANO.sp.ind <- ANO.sp.ind[!is.na(ANO.sp.ind$art_dekning),]

#rm(ANO.sp)

#ANO.sp <- ANO.sp[!is.na(ANO.sp$Hovedoekosystem_rute),] # need to check
unique(as.factor(ANO.sp.ind$hovedoekosystem_punkt))
unique(as.factor(ANO.sp.ind$hovedtype_rute))
unique(as.factor(ANO.sp.ind$kartleggingsenhet_1m2))

summary(ANO.sp.ind)
head(ANO.sp.ind)



#### data handling - ASO data ####
## make ASO.geo into a spatial object
names(ASO.geo)
ASO.geo <- st_as_sf(x = ASO.geo, 
                        coords = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +ellps=WGS84")

colnames(ASO.geo)
colnames(ASO.geo)[c(6,7,8,10,14,16,18,23,24)] <- c("Omradenummer_flatenummer","Eng_ID","ASO_ID","NiN_grunntype",
                                                   "bruksintensitet",
                                                   "beitetrykk",
                                                   "slatteintensitet",
                                                   "tungekjoretoy",
                                                   "slitasje")


## fix NiN-variables
# remove variable code in the data
ASO.geo$bruksintensitet
ASO.geo$bruksintensitet <- gsub("7JB-BA_", "", ASO.geo$bruksintensitet) 
unique(ASO.geo$bruksintensitet)
ASO.geo$bruksintensitet <- gsub("X", "NA", ASO.geo$bruksintensitet)
unique(ASO.geo$bruksintensitet)
ASO.geo$bruksintensitet <- as.numeric(ASO.geo$bruksintensitet)
unique(ASO.geo$bruksintensitet)

ASO.geo$beitetrykk
ASO.geo$beitetrykk <- gsub("7JB-BT_", "", ASO.geo$beitetrykk) 
unique(ASO.geo$beitetrykk)
ASO.geo$beitetrykk <- gsub("X", "NA", ASO.geo$beitetrykk)
unique(ASO.geo$beitetrykk)
ASO.geo$beitetrykk <- as.numeric(ASO.geo$beitetrykk)
unique(ASO.geo$beitetrykk)

ASO.geo$slatteintensitet
ASO.geo$slatteintensitet <- gsub("7JB-SI_", "", ASO.geo$slatteintensitet) 
unique(ASO.geo$slatteintensitet)
ASO.geo$slatteintensitet <- gsub("X", "NA", ASO.geo$slatteintensitet)
unique(ASO.geo$slatteintensitet)
ASO.geo$slatteintensitet <- as.numeric(ASO.geo$slatteintensitet)
unique(ASO.geo$slatteintensitet)

ASO.geo$tungekjoretoy
ASO.geo$tungekjoretoy <- gsub("MDirPRTK_", "", ASO.geo$tungekjoretoy) 
unique(ASO.geo$tungekjoretoy)
ASO.geo$tungekjoretoy <- gsub("X", "NA", ASO.geo$tungekjoretoy)
unique(ASO.geo$tungekjoretoy)
ASO.geo$tungekjoretoy <- as.numeric(ASO.geo$tungekjoretoy)
unique(ASO.geo$tungekjoretoy)

ASO.geo$slitasje
ASO.geo$slitasje <- gsub("MDirPRSE_", "", ASO.geo$slitasje) 
unique(ASO.geo$slitasje)
ASO.geo$slitasje <- gsub("X", "NA", ASO.geo$slitasje)
unique(ASO.geo$slitasje)
ASO.geo$slitasje <- as.numeric(ASO.geo$slitasje)
unique(ASO.geo$slitasje)



## fixing variable names and issues in ASO.sp
head(as.data.frame(ASO.sp))

colnames(ASO.sp)
colnames(ASO.sp)[8] <- "art_dekning"

# fix species names
ASO.sp <- as.data.frame(ASO.sp)

ASO.sp$Species <- ASO.sp$Navn
unique(as.factor(ASO.sp$Species))
ASO.sp$Species <- sub(".*?_", "", ASO.sp$Species) # lose the Norwegian name in the front
ASO.sp$Species <- gsub("_", " ", ASO.sp$Species) # replace underscore with space
ASO.sp$Species <- str_to_title(ASO.sp$Species) # make first letter capital
ASO.sp$Species <- gsub("( .*)","\\L\\1",ASO.sp$Species,perl=TRUE) # make capital letters after hyphon to lowercase
ASO.sp$Species <- gsub("( .*)","\\L\\1",ASO.sp$Species,perl=TRUE) # make capital letters after space to lowercase
ASO.sp[,'Species'] <- word(ASO.sp[,'Species'], 1,2) # lose subspecies

unique(as.factor(ASO.sp$Species))


## merge species data with indicators
ASO.sp.ind <- merge(x=ASO.sp[,c("Species", "art_dekning", "ParentGlobalID")], 
                          y= ind.dat[,c("species","Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance")],
                          by.x="Species", by.y="species", all.x=T)
summary(ASO.sp.ind)


# checking which species didn't find a match
unique(ASO.sp.ind[is.na(ASO.sp.ind$Light & 
                          is.na(ASO.sp.ind$Nitrogen)),'Species'])


# fix species name issues

ASO.sp <- ASO.sp %>% 
#    mutate(Species=str_replace(Species,"Arabis wahlenbergii", "Arabis hirsuta")) %>%
  #  mutate(Species=str_replace(Species,"Arctous alpinus", "Arctous alpina")) %>%
#  mutate(Species=str_replace(Species,"Betula tortuosa", "Betula pubescens")) %>%
#  mutate(Species=str_replace(Species,"Blysmopsis rufa", "Blysmus rufus")) %>%
  mutate(Species=str_replace(Species,"Cardamine dentata", "Cardamine pratensis")) %>%
#  mutate(Species=str_replace(Species,"Carex adelostoma", "Carex buxbaumii")) %>%
#  mutate(Species=str_replace(Species,"Carex leersii", "Carex echinata")) %>%
#  mutate(Species=str_replace(Species,"Carex paupercula", "Carex magellanica")) %>%
#  mutate(Species=str_replace(Species,"Carex simpliciuscula", "Kobresia simpliciuscula")) %>%
#  mutate(Species=str_replace(Species,"Carex viridula", "Carex flava")) %>%
  mutate(Species=str_replace(Species,"Chamaepericlymenum suecicum", "Cornus suecica")) %>%
  mutate(Species=str_replace(Species,"Chamerion angustifolium", "Chamaenerion angustifolium")) %>%
  mutate(Species=str_replace(Species,"Cicerbita alpina", "Lactuca alpina")) %>%
#    mutate(Species=str_replace(Species,"Cotoneaster scandinavicus", "Cotoneaster integerrimus")) %>%
#  mutate(Species=str_replace(Species,"Cotoneaster symondsii", "Cotoneaster integrifolius")) %>%
#  mutate(Species=str_replace(Species,"Cyanus montanus", "Centaurea montana")) %>%
  #  mutate(Species=str_replace(Species,"Empetrum hermaphroditum", "Empetrum nigrum")) %>%
#    mutate(Species=str_replace(Species,"Erysimum virgatum", "Erysimum strictum")) %>%
  #  mutate(Species=str_replace(Species,"Festuca prolifera", "Festuca rubra")) %>%
#    mutate(Species=str_replace(Species,"Festuca trachyphylla", "Festuca brevipila")) %>%
  mutate(Species=str_replace(Species,"Galium album", "Galium mollugo")) %>%
#  mutate(Species=str_replace(Species,"Galium elongatum", "Galium palustre")) %>%
  mutate(Species=str_replace(Species,"Helictotrichon pratense", "Avenula pratensis")) %>%
  mutate(Species=str_replace(Species,"Helictotrichon pubescens", "Avenula pubescens")) %>%
#  mutate(Species=str_replace(Species,"Hieracium alpina", "Hieracium Alpina")) %>%
#  mutate(Species=str_replace(Species,"Hieracium alpinum", "Hieracium Alpina")) %>%
#  mutate(Species=str_replace(Species,"Hieracium hieracium", "Hieracium Hieracium")) %>%
#  mutate(Species=str_replace(Species,"Hieracium hieracioides", "Hieracium umbellatum")) %>%
  mutate(Species=str_replace(Species,"Hieracium murorum", "Hieracium Vulgata")) %>%
#  mutate(Species=str_replace(Species,"Hieracium oreadea", "Hieracium Oreadea")) %>%
#  mutate(Species=str_replace(Species,"Hieracium prenanthoidea", "Hieracium Prenanthoidea")) %>%
#  mutate(Species=str_replace(Species,"Hieracium vulgata", "Hieracium Vulgata")) %>%
#  mutate(Species=str_replace(Species,"Hieracium pilosella", "Pilosella officinarum")) %>%
  mutate(Species=str_replace(Species,"Hieracium vulgatum", "Hieracium umbellatum")) %>%
#  mutate(Species=str_replace(Species,"Hierochloë« alpina", "Hierochloë alpina")) %>%
#  mutate(Species=str_replace(Species,"Hierochloë« hirta", "Hierochloë hirta")) %>%
#  mutate(Species=str_replace(Species,"Hierochloë« odorata", "Hierochloë odorata")) %>%
    mutate(Species=str_replace(Species,"Hylotelephium maximum", "Hylotelephium telephium")) %>%
    mutate(Species=str_replace(Species,"Listera cordata", "Neottia cordata")) %>%
  mutate(Species=str_replace(Species,"Listera ovata", "Neottia ovata")) %>%
#  mutate(Species=str_replace(Species,"Leontodon autumnalis", "Scorzoneroides autumnalis")) %>%
#    mutate(Species=str_replace(Species,"Lepidotheca suaveolens", "Matricaria discoidea")) %>%
  #  mutate(Species=str_replace(Species,"Loiseleuria procumbens", "Kalmia procumbens")) %>%
#    mutate(Species=str_replace(Species,"Malus ×domestica", "Malus domestica")) %>%
  #  mutate(Species=str_replace(Species,"Mycelis muralis", "Lactuca muralis")) %>%
#  mutate(Species=str_replace(Species,"Omalotheca supina", "Gnaphalium supinum")) %>%
  mutate(Species=str_replace(Species,"Omalotheca norvegica", "Gnaphalium norvegicum")) %>%
  mutate(Species=str_replace(Species,"Omalotheca sylvatica", "Gnaphalium sylvaticum")) %>%
  mutate(Species=str_replace(Species,"Oreopteris limbosperma", "Thelypteris limbosperma")) %>%
#  mutate(Species=str_replace(Species,"Oxycoccus microcarpus", "Vaccinium microcarpum")) %>%
#  mutate(Species=str_replace(Species,"Oxycoccus palustris", "Vaccinium oxycoccos")) %>%
#  mutate(Species=str_replace(Species,"Phalaris minor", "Phalaris arundinacea")) %>%
#  mutate(Species=str_replace(Species,"Pinus unicinata", "Pinus mugo")) %>%
#  mutate(Species=str_replace(Species,"Poa alpigena", "Poa pratensis")) %>%
#  mutate(Species=str_replace(Species,"Poa angustifolia", "Poa pratensis")) %>%
#  mutate(Species=str_replace(Species,"Poa humilis", "Poa pratensis")) %>%
    mutate(Species=str_replace(Species,"Potentilla anserina", "Argentina anserina")) %>%
  #  mutate(Species=str_replace(Species,"Pyrola grandiflora", "Pyrola rotundifolia")) %>%
    mutate(Species=str_replace(Species,"Rosa dumalis", "Rosa vosagiaca")) %>%
  mutate(Species=str_replace(Species,"Rubus fruticosus", "Rubus plicatus")) %>%
    mutate(Species=str_replace(Species,"Rumex alpestris", "Rumex acetosa")) #%>%
#  mutate(Species=str_replace(Species,"Syringa emodi", "Syringa vulgaris")) %>%
#  mutate(Species=str_replace(Species,"Taraxacum crocea", "Taraxacum officinale")) %>%
#  mutate(Species=str_replace(Species,"Taraxacum croceum", "Taraxacum officinale")) %>%
#  mutate(Species=str_replace(Species,"Trientalis europaea", "Lysimachia europaea")) %>%
#  mutate(Species=str_replace(Species,"Trifolium pallidum", "Trifolium pratense"))

## merge species data with indicators
ASO.sp.ind <- merge(x=ASO.sp[,c("Species", "art_dekning", "ParentGlobalID")], 
                    y= ind.dat[,c("species","Light","Moisture","Soil_reaction_pH","Nitrogen","Phosphorus","Grazing_mowing","Soil_disturbance")],
                    by.x="Species", by.y="species", all.x=T)
summary(ASO.sp.ind)
# checking which species didn't find a match
unique(ASO.sp.ind[is.na(ASO.sp.ind$Light & 
                          is.na(ASO.sp.ind$Nitrogen)),'Species'])

# the rest can be omitted


## adding information on ecosystem and condition variables to species data
names(ASO.sp.ind)
names(ASO.geo)
ASO.sp.ind <- merge(x=ASO.sp.ind, 
                    y=ASO.geo[,c("GlobalID","Omradenummer_flatenummer","Eng_ID","ASO_ID","NiN_grunntype")], 
                    by.x="ParentGlobalID", by.y="GlobalID", all.x=T)
# trimming away the points without information on NiN, species or cover
ASO.sp.ind <- ASO.sp.ind[!is.na(ASO.sp.ind$NiN_grunntype),]
ASO.sp.ind <- ASO.sp.ind[!is.na(ASO.sp.ind$Species),]
ASO.sp.ind <- ASO.sp.ind[!is.na(ASO.sp.ind$art_dekning),]

#rm(ASO.sp)
#rm(ASO.geo)


summary(ASO.sp.ind)
head(ASO.sp.ind)



#### data handling - reference data ####
# generalized species lists from NiN
str(Eco_State)

# sp
Eco_State$Concept_Data$Species$Species_List$species
# env
t(Eco_State$Concept_Data$Env$Env_Data)
# abun
t(Eco_State$Concept_Data$Species$Species_Data)

# transposing abundance data for bootstrapping
NiN.sp <- t(Eco_State$Concept_Data$Species$Species_Data)
NiN.sp <- as.data.frame(NiN.sp)
NiN.sp$sp <- as.factor(as.vector(Eco_State$Concept_Data$Species$Species_List$species))
# only genus and species name
NiN.sp$sp <- word(NiN.sp$sp, 1,2)
NiN.sp$spgr <- as.factor(as.vector(Eco_State$Concept_Data$Species$Species_List$art.code))
levels(NiN.sp$spgr)
# trimming to desired species groups (for åpen systems eg. removing trees ("a1a") )
NiN.sp <- NiN.sp[NiN.sp$spgr!="a1a",]

# environment data
NiN.env <- Eco_State$Concept_Data$Env$Env_Data

# merging with indicator values
NiN.sp.ind <- merge(NiN.sp,ind.dat, by.x="sp", by.y="species", all.x=T)
summary(NiN.sp.ind)

NiN.sp.ind[NiN.sp.ind==999] <- NA

# checking which species didn't find a match
unique(NiN.sp.ind[is.na(NiN.sp.ind$Moisture) & NiN.sp.ind$spgr %in% list("a1a","a1b","a1c"),'sp'])

# fix species name issues
ind.dat <- ind.dat %>% 
  mutate(species=str_replace(species,"Aconitum lycoctonum", "Aconitum septentrionale")) %>% 
  mutate(species=str_replace(species,"Carex simpliciuscula", "Kobresia simpliciuscula")) %>%
  mutate(species=str_replace(species,"Carex myosuroides", "Kobresia myosuroides")) %>%
  mutate(species=str_replace(species,"Clinopodium acinos", "Acinos arvensis")) %>%
  mutate(species=str_replace(species,"Artemisia rupestris", "Artemisia norvegica")) %>%
  mutate(species=str_replace(species,"Cherleria biflora", "Minuartia biflora"))



NiN.sp <- NiN.sp %>% 
  mutate(sp=str_replace(sp,"Aconitum lycoctonum", "Aconitum septentrionale")) %>% 
  mutate(sp=str_replace(sp,"Anagallis minima", "Lysimachia minima")) %>% 
  mutate(sp=str_replace(sp,"Arctous alpinus", "Arctous alpina")) %>%
  mutate(sp=str_replace(sp,"Betula tortuosa", "Betula pubescens")) %>%
  mutate(sp=str_replace(sp,"Blysmopsis rufa", "Blysmus rufus")) %>%
  mutate(sp=str_replace(sp,"Cardamine nymanii", "Cardamine pratensis")) %>%
  mutate(sp=str_replace(sp,"Carex adelostoma", "Carex buxbaumii")) %>%
  mutate(sp=str_replace(sp,"Carex leersii", "Carex echinata")) %>%
  mutate(sp=str_replace(sp,"Carex paupercula", "Carex magellanica")) %>%
  mutate(sp=str_replace(sp,"Carex simpliciuscula", "Kobresia simpliciuscula")) %>%
  mutate(sp=str_replace(sp,"Carex _vacillans", "Carex vacillans")) %>%
  mutate(sp=str_replace(sp,"Carex viridula", "Carex flava")) %>%
  mutate(sp=str_replace(sp,"Chamaepericlymenum suecicum", "Cornus suecia")) %>%
  mutate(sp=str_replace(sp,"Cornus suecia", "Cornus suecica")) %>%
  mutate(sp=str_replace(sp,"Cicerbita alpina", "Lactuca alpina")) %>%
  mutate(sp=str_replace(sp,"Dactylorhiza sphagnicola", "Dactylorhiza majalis")) %>%
  mutate(sp=str_replace(sp,"Diphasiastrum complanatum", "Lycopodium complanatum")) %>%
  mutate(sp=str_replace(sp,"Elymus alaskanus", "Elymus kronokensis")) %>%
  mutate(sp=str_replace(sp,"Empetrum hermaphroditum", "Empetrum nigrum")) %>%
  mutate(sp=str_replace(sp,"Erigeron eriocephalus", "Erigeron uniflorus")) %>%
  mutate(sp=str_replace(sp,"Festuca prolifera", "Festuca rubra")) %>%
  mutate(sp=str_replace(sp,"Galium album", "Galium mollugo")) %>%
  mutate(sp=str_replace(sp,"Galium elongatum", "Galium palustre")) %>%
  mutate(sp=str_replace(sp,"Glaux maritima", "Lysimachia maritima")) %>%
  mutate(sp=str_replace(sp,"Helictotrichon pratense", "Avenula pratensis")) %>%
  mutate(sp=str_replace(sp,"Helictotrichon pubescens", "Avenula pubescens")) %>%
  mutate(sp=str_replace(sp,"Hieracium alpina", "Hieracium Alpina")) %>%
  mutate(sp=str_replace(sp,"Hieracium alpinum", "Hieracium Alpina")) %>%
  mutate(sp=str_replace(sp,"Hieracium aurantiacum", "Pilosella aurantiaca")) %>%
  mutate(sp=str_replace(sp,"Hieracium hieracium", "Hieracium Hieracium")) %>%
  mutate(sp=str_replace(sp,"Hieracium hieracioides", "Hieracium umbellatum")) %>%
  mutate(sp=str_replace(sp,"Hieracium lactucella", "Pilosella lactucella")) %>%
  mutate(sp=str_replace(sp,"Hieracium murorum", "Hieracium Vulgata")) %>%
  mutate(sp=str_replace(sp,"Hieracium oreadea", "Hieracium Oreadea")) %>%
  mutate(sp=str_replace(sp,"Hieracium prenanthoidea", "Hieracium Prenanthoidea")) %>%
  mutate(sp=str_replace(sp,"Hieracium vulgata", "Hieracium Vulgata")) %>%
  mutate(sp=str_replace(sp,"Hieracium pilosella", "Pilosella officinarum")) %>%
  mutate(sp=str_replace(sp,"Hieracium vulgatum", "Hieracium umbellatum")) %>%
  mutate(sp=str_replace(sp,"Hierochloã« alpina", "Hierochloë alpina")) %>%
  mutate(sp=str_replace(sp,"Hierochloã« hirta", "Hierochloë hirta")) %>%
  mutate(sp=str_replace(sp,"Hierochloã« odorata", "Hierochloë odorata")) %>%
  mutate(sp=str_replace(sp,"Huperzia appressa", "Huperzia selago")) %>%
  mutate(sp=str_replace(sp,"Hylotelephium maximum", "Hylotelephium telephium")) %>%
  mutate(sp=str_replace(sp,"Lappula myosotis", "Lappula squarrosa")) %>%
  mutate(sp=str_replace(sp,"Lepidotheca suaveolens", "Matricaria discoidea")) %>%
  mutate(sp=str_replace(sp,"Listera cordata", "Neottia cordata")) %>%
  mutate(sp=str_replace(sp,"Leontodon autumnalis", "Scorzoneroides autumnalis")) %>%
  mutate(sp=str_replace(sp,"Loiseleuria procumbens", "Kalmia procumbens")) %>%
  mutate(sp=str_replace(sp,"Logfia arvensis", "Filago arvensis")) %>%
  mutate(sp=str_replace(sp,"Mentha _verticillata", "Mentha verticillata")) %>%
  mutate(sp=str_replace(sp,"Minuartia rubella", "Sabulina rubella")) %>%
  mutate(sp=str_replace(sp,"Minuartia stricta", "Sabulina stricta")) %>%
  mutate(sp=str_replace(sp,"Mycelis muralis", "Lactuca muralis")) %>%
  mutate(sp=str_replace(sp,"Omalotheca supina", "Gnaphalium supinum")) %>%
  mutate(sp=str_replace(sp,"Omalotheca norvegica", "Gnaphalium norvegicum")) %>%
  mutate(sp=str_replace(sp,"Omalotheca sylvatica", "Gnaphalium sylvaticum")) %>%
  mutate(sp=str_replace(sp,"Ononis arvensis", "Ononis spinosa")) %>%
  mutate(sp=str_replace(sp,"Oreopteris limbosperma", "Thelypteris limbosperma")) %>%
  mutate(sp=str_replace(sp,"Oxycoccus microcarpus", "Vaccinium microcarpum")) %>%
  mutate(sp=str_replace(sp,"Oxycoccus palustris", "Vaccinium oxycoccos")) %>%
  mutate(sp=str_replace(sp,"Phalaris minor", "Phalaris arundinacea")) %>%
  mutate(sp=str_replace(sp,"Phalaroides arundinacea", "Phalaris arundinacea")) %>%
  mutate(sp=str_replace(sp,"Pinus unicinata", "Pinus mugo")) %>%
  mutate(sp=str_replace(sp,"Platanthera montana", "Platanthera chlorantha")) %>%
  mutate(sp=str_replace(sp,"Poa alpigena", "Poa pratensis")) %>%
  mutate(sp=str_replace(sp,"Poa angustifolia", "Poa pratensis")) %>%
  mutate(sp=str_replace(sp,"Poa laxa", "Poa flexuosa")) %>%
  mutate(sp=str_replace(sp,"Poa _herjedalica", "Poa herjedalica")) %>%
  mutate(sp=str_replace(sp,"Poa _jemtlandica", "Poa jemtlandica")) %>%
  mutate(sp=str_replace(sp,"Poa lindebergii", "Poa arctica")) %>%
  mutate(sp=str_replace(sp,"Pyrola grandiflora", "Pyrola rotundifolia")) %>%
  mutate(sp=str_replace(sp,"Rhamnus catharticus", "Rhamnus cathartica")) %>%
  mutate(sp=str_replace(sp,"Rumex alpestris", "Rumex acetosa")) %>%
  mutate(sp=str_replace(sp,"Salix _fragilis", "Salix fragilis")) %>%
  mutate(sp=str_replace(sp,"Saxifraga _opdalensis", "Saxifraga opdalensis")) %>%
  mutate(sp=str_replace(sp,"Spergularia salina", "Spergularia marina")) %>%
  mutate(sp=str_replace(sp,"Syringa emodi", "Syringa vulgaris")) %>%
  mutate(sp=str_replace(sp,"Taraxacum crocea", "Taraxacum officinale")) %>%
  mutate(sp=str_replace(sp,"Taraxacum croceum", "Taraxacum officinale")) %>%
  mutate(sp=str_replace(sp,"Taraxacum erythrospermum", "Taraxacum officinale")) %>%
  mutate(sp=str_replace(sp,"Taraxacum hamatum", "Taraxacum officinale")) %>%
  mutate(sp=str_replace(sp,"Trientalis europaea", "Lysimachia europaea")) %>%
  mutate(sp=str_replace(sp,"Trifolium pallidum", "Trifolium pratense")) %>%
  mutate(sp=str_replace(sp,"Vicia orobus", "Vicia cassubica"))


## merge species data with indicators
NiN.sp.ind <- merge(NiN.sp,ind.dat, by.x="sp", by.y="species", all.x=T)
summary(NiN.sp.ind)

NiN.sp.ind[NiN.sp.ind==999] <- NA

# checking which species didn't find a match
unique(NiN.sp.ind[is.na(NiN.sp.ind$Light) & is.na(NiN.sp.ind$Nitrogen) & 
                    NiN.sp.ind$spgr %in% list("a1a","a1b","a1c")
                  ,'sp'])
# ok now


#### matching with NiN ecosystem types - semi-natural types ####
# NB! beware of rogue spaces in the 'Nature_type' & 'Sub_Type' variables, e.g. "Spring_Forest "
levels(NiN.env$Nature_Type)
NiN.seminat <- NiN.sp.ind[,c("sp",paste(NiN.env[NiN.env$Nature_Type %in% list("Semi_Natural ","Coastal_Heath"),"ID"]),colnames(ind.dat)[c(15:19,21,22)])]   # Light, Moisture, Soil_reaction_pH, Nitrogen, Grazing_mowing, Soil_disturbance

NiN.seminat[1,]
names(NiN.seminat)

cbind(colnames(NiN.seminat),
      c("",
        'T34-C1',
        'T34-C2a','T34-C2b','T34-C2c',
        '',
        'T34-C3',
        'T34-C4a','T34-C4b','T34-C4c','T34-C4d',
        'T34-C5a','T34-C5b','T34-C5c',
        'T34-C6a','T34-C6b','T34-C6c',
        '',
        rep('',7),
        'T32-C1C2','T32-C3C4',
        'T32-C5C20a',
        'T32-C7C8',
        'T32-C5C20b',
        'T32-C9a',
        'T32-C9b',
        'T32-C15',
        'T32-C21C6a',
        'T32-C21C6b',
        'T32-C10a',
        'T32-C10b',
        'T32-C16',
        'T41a','T41b',
        'T45-C1C2','T45-C3',
        'V10-C1C2','V10-C3',
        rep("",7)
      )
)


colnames(NiN.seminat)
colnames(NiN.seminat)[2:44] <- c( 'T34-C1',
                                  'T34-C2a','T34-C2b','T34-C2c',
                                  NA,
                                  'T34-C3',
                                  'T34-C4a','T34-C4b','T34-C4c','T34-C4d',
                                  'T34-C5a','T34-C5b','T34-C5c',
                                  'T34-C6a','T34-C6b','T34-C6c',
                                  NA,
                                  rep(NA,7),
                                  'T32-C1C2','T32-C3C4',
                                  'T32-C5C20a',
                                  'T32-C7C8',
                                  'T32-C5C20b',
                                  'T32-C9a',
                                  'T32-C9b',
                                  'T32-C15',
                                  'T32-C21C6a',
                                  'T32-C21C6b',
                                  'T32-C10a',
                                  'T32-C10b',
                                  'T32-C16',
                                  'T41a','T41b',
                                  'T45-C1C2','T45-C3',
                                  'V10-C1C2','V10-C3'
)
head(NiN.seminat)
colnames(NiN.seminat)
NiN.seminat <- NiN.seminat[,-c(6,18:25)]



# translating the abundance classes into %-cover
coverscale <- data.frame(orig=0:6,
                         cov=c(0, 1/32 ,1/8, 3/8, 0.6, 4/5, 1)
)

NiN.seminat.cov <- NiN.seminat
colnames(NiN.seminat.cov)
for (i in 2:35) {
  NiN.seminat.cov[,i] <- coverscale[,2][ match(NiN.seminat[,i], 0:6 ) ]
}

summary(NiN.seminat)
summary(NiN.seminat.cov)



save.image("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/data_seminat.RData")

load("P:/41201785_okologisk_tilstand_2022_2023/data/FPI_output large files for markdown/data_seminat.RData")
