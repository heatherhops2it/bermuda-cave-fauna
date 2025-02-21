
# load packages -----------------------------------------------------------

library(tidyverse)
library(readr)
# library("worms")  # install.packages("worms")
library(worrms)
library(progress)  # install.packages("progress")




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

## load in the list of all soniferous species
son_spp <- read_csv(file = "soniferous-species-list.csv") |> 
  separate(Taxon, c("Genus", "Species", "Subspecies"), " ") |> 
  select(Genus, Species, "Soniferous Category")

bda_spp <- read_csv(file = "bermuda-species.csv")



# exploration --------------------------------------------------------------

unique(df_son$Phylum)
unique(bda_spp$Phylum)


## So the soniferous families dataset only contains vertebrate species. Annoying!

son_info <- df_son |> 
  select(Phylum, Class, Order, Family, Genus, Species) 

## How many lines from son_spp are on df_son? I can remove them?
uk_son_spp <- son_spp |> 
  anti_join(df_son, by = "Genus")

## make a df that has the geni not included on df_son:
uk_son_gen <- uk_son_spp |> 
  select(Genus, Species) |> 
  mutate(Taxon = paste(Genus, Species)) |> 
  mutate(AlphaID = wm_name2id_(Taxon))



## the uk_son_spp is the species that are labelled as soniferous but are not in the 'Species from WORMS' folder

# create the progress bar
n_iter <- 16279
pb <- progress_bar$new(format = "(:spin) [:bar] :percent [Elapsed time: :elapsedfull || Estimated time remaining: :eta]",
                       total = n_iter,
                       complete = "=",   # Completion bar character
                       incomplete = "-", # Incomplete bar character
                       current = ">",    # Current bar character
                       clear = FALSE,    # If TRUE, clears the bar when finish
                       width = 200) 


# set up dataframes for for loop
df_tax <- data_frame(NULL)
df_wo <- data_frame(NULL)

for (i in 1:length(uk_son_gen$Genus)) {
  # progress counter
  pb$tick()
  
  # get the name of the species
  name <- uk_son_gen$Genus[i]
  
  # use it in worrms functions to get taxon info, and save to 'writeover' dataframe
  df_wo <- wm_classification(id = wm_name2id(name)) |> 
    select(rank, scientificname) |> 
    pivot_wider(names_from = rank, values_from = scientificname)
  
  # add it to the dataframe for taxonomy
  df_tax <- df_tax |> 
    bind_rows(df_wo)
}









