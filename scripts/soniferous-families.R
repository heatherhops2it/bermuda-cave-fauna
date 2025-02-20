
# load packages -----------------------------------------------------------

library(tidyverse)



# load data ---------------------------------------------------------------

files <- list.files(path = "C:/Users/hng9/Box/Research - Endemics/Soniferous Marine Fauna/Underwater Sonifery Code/WoRMS Underwater Sonifery Code/Species from WoRMS",
                    full.names = TRUE)

df_son <- data_frame(NULL)
df_null <- data_frame(NULL)
i <- NULL

for (i in files) {
 df_null <- read_csv(file = i)
 
 df_son <- df_son |> 
   bind_rows(df_null)
}


bda_spp <- read_csv(file = "bermuda-species.csv")



# exploration --------------------------------------------------------------

unique(df_son$Phylum)
unique(bda_spp$Phylum)

## So the soniferous dataset only contains vertebrate species. Annoying!

