library(readxl)
corpus7_monstresmarins_metadonnees_uniquement_1_ <- read_excel("~/Documents/Master DES/Exploitation numériques/corpus7_monstresmarins_metadonnees_uniquement (1).xlsx")
View(corpus7_monstresmarins_metadonnees_uniquement_1_)

monsters <- corpus7_monstresmarins_metadonnees_uniquement_1_

library(tidyverse)
library(skimr)
skim(monsters)


duplicated(monsters$title, monsters$description)
monsters_dup <- monsters[duplicated(monsters$title, monsters$description), ]

monsters_unique <- monsters[!duplicated(monsters$title, monsters$description), ]


# Mot à chercher
mot <- "monstre marin corporation"

# Filtrer les lignes contenant le mot dans n'importe quelle colonne
monstres_filtre <- monsters_unique[!apply(monsters_unique, 1, function(row) any(grepl(mot, row, ignore.case = TRUE))), ]

# Supprimer les " " de duration
monstres_filtre$duration <- as.numeric(gsub('"', '', monstres_filtre$duration))

# Convertir les date de publication
monstres_filtre$publication_date <- as.Date(monstres_filtre$publication_date)

# Creer la colonne année
monstres_filtre$year <- format(monstres_filtre$publication_date, "%Y")



# Save the data to a CSV file
write.csv(monstres_filtre, "monstres_marins_clean.csv", row.names = FALSE)


skim(monstres_filtre)
