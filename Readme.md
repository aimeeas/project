```markdown
# EXAMEN 1 : Analyse des contrôles policiers à San Diego
📌 **Objectif** : Étudier l’influence de l’âge et de l’ethnie sur les motifs de contrôle policier à travers de l’Analyse Factorielle et la Clusterisation.

## Exploration des données :
- Utilisation de `skimr::skim()` pour un aperçu rapide des données.
- Identification des variables pertinentes : âge, sexe, ethnie, motifs des contrôles.

## Préparation des données :
- Imputation des valeurs manquantes avec `imputeFAMD()`.
- Sélection des variables d'intérêt : âge, ethnie, raison du contrôle et résultat.

## Analyse des correspondances multiples (ACM) :
- Application de l'ACM avec `FactoMineR::MCA()`.
- Visualisation des résultats avec `factoextra::fviz_mca_var()` pour identifier les principales raisons de contrôles et la distribution des individus selon les variables.

## Classification et segmentation :
- Utilisation de la classification hiérarchique sur composantes principales (HCPC) avec `FactoMineR::HCPC()`.
- Exploration des résultats de la segmentation pour analyser les groupes homogènes.

---

# EXAMEN 2 : Impact du PIB et du soutien social sur le bonheur
📌 **Objectif** : Évaluer l'impact du PIB par habitant et du soutien social sur le score de bonheur via une régression linéaire multiple.

## Exploration des données :
- Identification des principales variables : `happiness_score`, `gdp_per_capita`, `social_support`.
- Visualisation des distributions avec `ggplot2` pour comprendre la répartition des données.

## Analyse des relations entre variables :
- Création de scatterplots pour observer les corrélations entre le PIB, le soutien social et le score de bonheur.
- Utilisation de `lm()` pour créer des modèles de régression linéaire multiple.

## Modélisation statistique :
- Application de la régression linéaire multiple avec deux modèles : un sans interaction et un avec interaction (`happiness_score ~ gdp_per_capita + social_support` et `happiness_score ~ gdp_per_capita * social_support`).
- Utilisation de `summary()` pour interpréter les résultats des modèles.

## Visualisation des résultats :
- Génération d'un graphique 3D avec `scatterplot3d` pour comparer les prédictions du modèle avec les données réelles.

## Analyse causale :
- Construction d'un modèle causal avec `dagitty` pour tester les relations entre les variables.

---

# TOURISME : Participation au tourisme en Europe
📌 **Objectif** : Analyser la participation au tourisme en Europe et identifier les pays les plus voyageurs (2016-2023).

## Importation et préparation des données :
- Filtrage des données pour ne conserver que les voyages d'au moins une nuit (`duration == "N_GE1"`) et les voyages internationaux (`c_dest == "FOR"`).
- Transformation des colonnes pour les rendre compatibles avec l'analyse (conversion de colonnes de texte en numériques et nettoyage des données avec `dplyr`).

## Nettoyage et transformation des données :
- Suppression des valeurs manquantes avec `na.omit()` ou remplacement des données incorrectes par `NA`.
- Renommage des pays en utilisant des noms complets (ex : "FR" → "France") avec `mutate()` et `dplyr`.
- Transformation des données en format "long" avec `pivot_longer()` pour faciliter la visualisation et l’analyse.

## Analyse des pays les plus voyageurs :
- Visualisation des tendances avec des graphiques de séries temporelles à l’aide de `ggplot2::geom_line()` et `facet_wrap()` pour observer l’évolution de la participation touristique par pays.
- Comparaison des tendances d’utilisation de l’avion avant et après la pandémie en utilisant `geom_line()` pour observer les variations des voyages annuels en avion pour les 10 pays principaux.

---

# MONSTRES MARINS : Traitement et Nettoyage des Données
📌 **Objectif** : Traiter et nettoyer un fichier Excel contenant des métadonnées sur plus de 7 millions de vidéos autour de la thématique monstres marins afin d'obtenir des données exploitables.

## Détection et suppression des doublons :
- Identification des entrées identiques basées sur `title` et `description`, puis suppression des doublons avec `duplicated()`.

## Filtrage des données :
- Suppression des entrées contenant un mot-clé spécifique ("monstre marin corporation") à l’aide de `grepl()`.
- Filtrage des données en supprimant des utilisateurs spécifiques à l’aide de `subset()`.

## Nettoyage des colonnes :
- Conversion de la durée (`duration`) en numérique après suppression des guillemets avec `gsub()` et `as.numeric()`.
- Transformation des dates (`publication_date`) en format Date et extraction de l’année avec `format()`.

---

# SHAKIRA : Web Scraping des Paroles de Chansons
📌 **Objectif** : Extraire les paroles des chansons de Shakira depuis un site web et les sauvegarder dans un fichier CSV pour exploitation sur le logiciel Iramuteq.

## Installation et chargement des bibliothèques :
- Utilisation de `rvest` pour le scraping, `stringr` pour la manipulation des chaînes de texte, et `dplyr` pour le traitement des données.

## Récupération des URLs :
- Création d'une liste contenant les chemins des chansons à extraire.

## Web scraping :
- Utilisation de `read_html()` pour lire le contenu HTML des pages web.
- Extraction des informations avec `html_node()`.
- Nettoyage des données textuelles avec `str_remove()`, `str_trim()`, `str_squish()`, et `str_replace_all()`.

## Création d'un tableau de données :
- Organisation des informations dans un tibble avec `bind_rows()`.

---

# 📌 Compétences acquises :
- Exploration et nettoyage des données (imputation, transformation, suppression de doublons).
- Analyse statistique (régression linéaire, Analyse Factorielle, modélisation causale).
- Visualisation des données (ggplot2, graphique 3D, séries temporelles).
- Manipulation des données avec `dplyr`, `tidyr`, `stringr`.
- Clustering et segmentation (classification hiérarchique, ACM).
- Web scraping (`rvest`, extraction de données).
- Exportation et gestion des données (fichiers CSV).
```
