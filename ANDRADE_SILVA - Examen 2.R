#Univeristé Paris Nanterre
#M2 - Données et Société
#Aimêe ANDRADE SILVA - 44013004

library(tidyverse)
library(skimr)
library(readr)
library(modelr) # pour obtenir des prédictions
library(plotly) # pour des visualisations interactives
library(dagitty) # pour les graphes causaux


# Télécharger les données et prémier analise---------

happiness <- read_csv("~/Downloads/WHR_2023 - WHR_2023.csv")

skim(happiness)
# Le jeux de donnée presente des pays/région selon 7 indexs: gdp, suport sociale,
# expectative de vie, possibilité de faire les decisions, generosité et corruption.
# Ces indexs forment les données numériques et le pays et région sont de données type character.
# Avec le skim, en regardant les histograms, on peut voir une distribuition plus
# centraliser des données concernant le 'happinness score' et 'healthy_life_expectancy', 
# ça qu'indique la plupart de données referants à ses indices sont problablement entre le premier
# et le troisème quartile, et d'une percepetion moyenne de ces indices. 
# Le 'gdp_per_capita' se concentre au milieu et au centre, ça qu'indique
# que selon ce données la distribuition est gdp par personne est plutôt moyenne ou élévé.
# Le soutien social a une distribuition plus elargi, mais garde aussi une bonne qualité
# de données vers les derniers quartiles, ça qui peut indiqué aussi un soutien social élévé
# aux pays étudiés.
# Le 'freedom' a la grande quantité de ses données concentrés vers le indicatives plus élévés
# au contraire de "generosity" et 'corruption' qui indiquent une perception baisse
# selon l'étude.

# Vérifier les possibles relations et décision d'étude-----
plot(happiness) 

# Avec la representation de ce plot, on peut voir que certains variables sont corrélés
# de manière linear positive avec le happinness_score, tels que 'gdp_per_capita', 'social_support' et
# 'healthy_life_expectancy'.

# BUT: Compreende comment le 'gdp_per_capita' et le 'social_support' (variables independentes)
# influencient le 'happiness_score' (variable dependente)

# Régression linear multiple (prédicteurs quanti)------

# 1) Trouver le meilleiur modèle

### sans interactions
modele_happiness <- lm(`happiness_score` ~ `gdp_per_capita` + `social_support`, 
                       data = happiness)
summary(modele_happiness)
# p-value: < 2.2e-16 - Ce value indique que la relation entre les varibles choisis est très significative
# Adjusted R-squared:  0.7552 - Indique que 75% du 'happiness_score' pout être expliquer
# pour ce modèle

### avec interaction
modele_happiness_int <- lm(`happiness_score` ~ `gdp_per_capita` * `social_support`, 
                           data = happiness)
summary(modele_happiness_int)
# p-value: < 2.2e-16 - Ce value indique que la relation entre les varibles choisis est très significative
# Adjusted R-squared:  0.0.7691 - Indique que 77% du 'happiness_score' pout être expliquer
# pour ce modèle

# CHOIX: En tant donné que les deux values de R-squared sont très similaires, on pourrait
# assumer que les interations entre les variables 'gdp_per_capita' et 'social_support'
# peut être ne pas assez relevant pour expliquer ce phenomene. Le modèle multiple sans
# interactions est donc suffisant pour capturer modèle principal dans les données.


# 2) PLOT avec modèle sans interactions

happiness %>%
  add_predictions(modele_happiness) %>%
  plot_ly(x = ~`gdp_per_capita`,
          y = ~`social_support`) %>%
  add_trace(z = ~`happiness_score`, type = "scatter3d", size =1) %>%
  add_trace(z = ~pred, type = "mesh3d")

# Sur cette representation, on peut voir les points qui correpondent aux réponses trouvés
# dans le jeux de données et le plateau en orange nous montre l'estimative faite pour le
# modèle proposé. On voit qui cette representation suivre la direction et l'emplacement
# des données sur la representation d'une manière assez cohérente, avec une quantité large
# de données proche de la estiamation.
# Ce graphe nous permet de voir aussi que plus le 'gdp' ou le 'social_suppot' est grand/fort,
# plus élévé est le 'happinness_score', ce qui nous reonvoie a l'ideia de la correlation
# linear positive.


# CONCLUSION -----

# Nous avons observer que selon de jeux de données, il y a une forte relation de linearité positive
# entre la varable dependente ('happinnes_score') et les variables independentes ('gdp_per_capita'
# et 'social_support'). Cependant, l'analyse nous a montré aussi que les deux varaibles indepentes,
# si corrélés, ne démontrent pas une grande pertinence pour l’interprétation des données, et il 
# suffit d’étudier simplement leur interaction isolé avec la variable dépendante.
# Il est donc possible d'assumer que les pays ou régions qu'ont un gdp per capita plus grande,
# ou un soutien social forte, les persones sont plus joyeuses.


#DAGITTY ----------

happiness_selected <- happiness %>%
  select(3:5)

happiness_dag <- dagitty('
dag {
bb="0,0,1,1"
gdp_per_capita [exposure,pos="0.381,0.476"]
happiness_score [outcome,pos="0.474,0.179"]
social_support [pos="0.642,0.445"]
gdp_per_capita -> happiness_score
social_support -> happiness_score
}
')
plot(happiness_dag)


impliedConditionalIndependencies(happiness_dag) # indépendances théoriques impliquées par le graphe

plotLocalTestResults(localTests(happiness_dag, happiness_selected)) # test de toutes les indépendances vis-à-vis des corrélations dans les données


# ANLYSE: Ce graphique représente mon hypothèse selon laquelle le score de bonheur est 
# influencé par le gdp et le soutien social. Avec cette représentation, Dagitty 
# suppose que les variables gdp et soutien social agissent indépendamment, ce qui peut 
# être vu dans le résultat du code impliedConditionalIndependencies. Ensuite, à 
# travers la représentation graphique de la dépendance conditionnelle, on peut voir que 
# les valeurs de l'intervalle de confiance sont proches de zéro, ce qui confirmerait 
# l'idée que ces variables agissent indépendamment sur le score de bonheur.

