# Aimêe ANDRADE SILVA - 44013004
# Master 2 - Données et Société
# Analyse de données
# Examen 15/10/2024

library(tidyverse)
library(dplyr)
library(missMDA) # Pour imputer les valeurs manquants
library(FactoMineR)
library(factoextra)
library(explor)
library(skimr)
library(cluster)
library(shiny)

load("partiel_m2_2024_police_stops.rdata")

# DESCRIPTION DES DONNéES -------------------------

# Ces données sont relatives aux contrôles policiers dans la ville de San Diego (E.-U.) et
# continent informations sur les individus (âge, sexe et ethnie) et sur le contrôle (semaine,
# mois, année, raison et resultat).


skim(data_sample)
# Avec l'aide de la fonction skim, on peut voir les principaux informations sur la base
# de données de mannière résumé. Il contiant 7 variables du type "factor" et une variable
# du type numeric, ainsi que certains valeurs manquants. On regardant la seule variable
# numeric "subject_age", on peut voir que l'agê moyenne des individus était de 37.3, mais
# les données sont entre 10 et 99, avec une distribuition plus equilibré entre les premeirs
# quartis et une baissé à partir de l'age de 50 ans, comme montre l'histogram.

hist(data_sample$subject_age) # Histogram du jeux de données selon l'age des individus

# Pour ce travail je chercheré a tracer un profil des individus, en explorant leur données
# personnels, et je vais essayer de décrouvrir s'il existe entre les profils des indvidus
# et relation entre la motivation du contrôle. 


# Selection des colonnes et imputation des valeurs manquants

# Les colonnes selectionnés sont relatives à l'agê, ethnie, raison du contrôle et résultat
data_choisies <- data_sample %>%
  select(1, 2, 4, 5)


data_complete <- imputeFAMD(data_choisies)$completeObs # Data sans valeurs manquants


# EXPLOTATION DES DONNéES --------------------- 


# Analyse factorielle

# Pour la base de données être plutôt qualitative, j'ai choisi ce méthode et j'ai ajouté
# une variable quanti (âge)
data_mca <- MCA(data_complete, quanti.sup = 1)

# Representation Biplot des données choisies

fviz_mca_var(data_mca,
             repel = TRUE) #Visualisation des variables

# Ce premier plot presente tous les variables choisies, sauf l'age. Selon les valeurs des
# dimensions, il represente aussi seulement 24% des informations que les données peuvent
# nous donner, mais il permet de faire quelques obseervations:
# - "Personal Knowlege" et "Raison Call" sont les raisons principaux des crontôles.
# - "Arrest" et "Personal Knowledge" rasemblent être bien correlés, vue qu'elles vont dans
# la même direction et sont "à côté" l'une de lautre
# - "Black" rasemble être l'ethnie qui est plus "arrest" et elle a aussi une très forte
# correlation avec "Equipment Violation"


fviz_mca_biplot(data_mca,
                label = "var",
                habillage = data_complete$subject_race,
                repel = TRUE)

res <- explor::prepare_results(data_mca)
explor::MCA_var_plot(res, xax = 1, yax = 2, var_sup = TRUE, var_sup_choice = "subject_age",
                     var_lab_min_contrib = 0, col_var = "Variable", symbol_var = "Type", size_var = NULL,
                     size_range = c(10, 300), labels_size = 10, point_size = 56, transitions = TRUE,
                     labels_positions = NULL, labels_prepend_var = FALSE, xlim = c(-0.952, 1.79),
                     ylim = c(-1.61, 1.13))

# Avec ce denier visualisation on peut observer aussi que "âge" ne jeux pas une grande role
# sur la representation


# Clusterisation

data_echant <- data_complete %>%
  sample_n(1000) %>%
  select(1:4) # Echantiollage 

data_echant_mca <- MCA(data_echant, quanti.sup = 1) 

data_hcpc <- HCPC(data_echant_mca, nb.clust = -1)



data_hcpc$desc.ind

# para representant les individus plus au centre du cluster
# dist representent les individus plus éloinées des autres groupes, cad, ces qui plus
# dificillement seront classifiés differement

data_hcpc$desc.var

#Cla/Mod parle de la porcentages des indivus dans un cluster
#Mod/Cla parle de la porcentage des tous less indivius de cette categorie dans le clusters




