# Install and load necessary packages
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("sf")
install.packages("ggplot2")
install.packages("dplyr")

library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(ggplot2)
library(dplyr)

# Load EU's map
europe_map <- ne_countries(scale = "medium", continent = "Europe", returnclass = "sf")


# Creating a correspondence vector: code ISO -> name in french
# AT THE END I REALIZED THAT THIS WAS NOT NECESSARY BECAUSE THEY HAVE A COLUMN WITH 
# ALL COUNTRIES IN ALL LANGUAGES

country_names <- c(
  "BE" = "Belgique", "BG" = "Bulgarie", "CZ" = "Tchéquie", "DK" = "Danemark",
  "DE" = "Allemagne", "EE" = "Estonie", "IE" = "Irlande", "EL" = "Grèce",
  "ES" = "Espagne", "FR" = "France", "HR" = "Croatie", "IT" = "Italie",
  "CY" = "Chypre", "LV" = "Lettonie", "LT" = "Lituanie", "LU" = "Luxembourg",
  "HU" = "Hongrie", "MT" = "Malte", "NL" = "Pays-Bas", "PL" = "Pologne",
  "PT" = "Portugal", "RO" = "Roumanie", "SI" = "Slovénie", "FI" = "Finlande",
  "SE" = "Suède", "IS" = "Islande", "LI" = "Liechtenstein", "NO" = "Norvège",
  "CH" = "Suisse", "UK" = "United Kingdom", "ME" = "Monténégro",
  "MK" = "Macédonie du Nord", "AL" = "Albanie", "RS" = "Serbie",
  "TR" = "Turquie", "AT" = "Autriche", "SK" = "Slovaquie"
)

# Creating a new column with the names in french
voyages_ISO <- voyages_nuits %>%
  rename(country = `geo\\TIME_PERIOD`) %>%
  select(-(1:4), -(6:9)) %>%
  mutate(country_fr = recode(country, !!!country_names)) 

# Replace any occurrence of ":" (used for missing data) with NA
voyages_ISO <- replace(voyages_ISO, voyages_ISO == ":", NA)

# Removing all unwanted characters from columns et transforming them in numeric
voyages_ISO <- voyages_ISO %>%
  mutate(across(`2016`:`2023`, ~ as.numeric(gsub("[A-Za-z ]", "", .))))

# Remove rows with any missing values (NA), keeping only complete rows for analysis

voyages_ISO <- voyages_ISO[complete.cases(voyages_ISO[ , !(names(voyages_ISO) %in% "2023")]) | 
                             (is.na(voyages_ISO$`2023`) & complete.cases(voyages_ISO[ , !(names(voyages_ISO) %in% "2023")])), ]


# Reshape the data from wide to long format, creating two new columns: 'year' and 'percentage'
# 'year' will contain the years from 2012 to 2023, and 'percentage' will contain corresponding values
voyages_ISO <- voyages_ISO %>%
  pivot_longer(
    cols = c('2016':'2023'),  # Columns representing years to be reshaped
    names_to = "year",        # New column name for year
    values_to = "percentage"  # New column name for the values
  )

# Convert the 'year' column from character to integer for proper numeric representation
voyages_ISO$year <- as.integer(voyages_ISO$year)

# Calculate the mean 'percentage' for each country
voyages_ISO_mean <- voyages_ISO %>%
  group_by(country_fr) %>%
  summarise(mean_percentage = mean(percentage, na.rm = TRUE)) %>%  # Calculate mean percentage
  arrange(desc(mean_percentage))

# Put together the geographic data and the travel data
europe_data <- europe_map %>%
  left_join(voyages_ISO_mean, by = c("name_fr" = "country_fr"))

# Create the map
ggplot(data = europe_data) +
  geom_sf(aes(fill = mean_percentage), color = "black", size = 0.2) + # Determinate the column to be used as reference and choosing the color and size for contours
  geom_sf_label(aes(label = name_fr), size = 2.5, fill = "white", color = "black")+ # Creating tags with the ame of each country
  scale_fill_gradient(low = "lightblue", high = "darkblue", na.value = "grey90", 
                      name = "Moyenne des voyages %",
                      ) +  # Color scale and name
  labs(
    title = "Nombre moyen de voyages par pays entre 2016 et 2023",
    subtitle = "Selon la pourcentage de la population de chaque pays",
    caption = "Source: Eurostat, 2024"
  ) +
  coord_sf(xlim = c(-10, 35), ylim = c(35, 70), expand = FALSE) + # Reducing the visualization to only "main land Europe"
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )





