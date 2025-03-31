# Load necessary libraries for reading 
library(readr)
install.packages("tidyverse")
library(tidyverse)


# TITRE DU ARCHIVE: Participation au tourisme pour des motifs personnels - % de la population totale
# https://ec.europa.eu/eurostat/databrowser/view/tin00186/default/table?lang=fr


# Importing the data set
estat_tin00186 <- read_csv("estat_tin00186.csv")

# Keeps only rows relative to travel of one night or more
voyages_nuits <- estat_tin00186 %>%
  filter( duration == "N_GE1")

# Renaming and removing unnecessary columns

voyages_columns <-voyages_nuits %>%
  rename(country = `geo\\TIME_PERIOD`) %>%
  select(-(1:4) , -(6:9))

# Renaming the countries names

voyages_columns[voyages_columns == "BE"] <- "Belgique"
voyages_columns[voyages_columns == "BG"] <- "Bulgarie"
voyages_columns[voyages_columns == "CZ"] <- "Tchéquie"
voyages_columns[voyages_columns == "DK"] <- "Danemark"
voyages_columns[voyages_columns == "DE"] <- "Allemagne"
voyages_columns[voyages_columns == "EE"] <- "Estonie"
voyages_columns[voyages_columns == "IE"] <- "Irlande"
voyages_columns[voyages_columns == "EL"] <- "Grèce"
voyages_columns[voyages_columns == "ES"] <- "Espagne"
voyages_columns[voyages_columns == "FR"] <- "France"
voyages_columns[voyages_columns == "HR"] <- "Croatie"
voyages_columns[voyages_columns == "IT"] <- "Italie"
voyages_columns[voyages_columns == "CY"] <- "Chypre"
voyages_columns[voyages_columns == "LV"] <- "Lettonie"
voyages_columns[voyages_columns == "LT"] <- "Lituanie"
voyages_columns[voyages_columns == "LU"] <- "Luxembourg"
voyages_columns[voyages_columns == "HU"] <- "Hongrie"
voyages_columns[voyages_columns == "MT"] <- "Malte"
voyages_columns[voyages_columns == "NL"] <- "Pays-Bas"
voyages_columns[voyages_columns == "PL"] <- "Pologne"
voyages_columns[voyages_columns == "PT"] <- "Portugal"
voyages_columns[voyages_columns == "RO"] <- "Roumanie"
voyages_columns[voyages_columns == "SI"] <- "Slovénie"
voyages_columns[voyages_columns == "FI"] <- "Finlande"
voyages_columns[voyages_columns == "SE"] <- "Suède"
voyages_columns[voyages_columns == "IS"] <- "Islande"
voyages_columns[voyages_columns == "LI"] <- "Liechtenstein"
voyages_columns[voyages_columns == "NO"] <- "Norvège"
voyages_columns[voyages_columns == "CH"] <- "Suisse"
voyages_columns[voyages_columns == "UK"] <- "United Kingdom"
voyages_columns[voyages_columns == "ME"] <- "Monténégro"
voyages_columns[voyages_columns == "MK"] <- "Macédonie du Nord"
voyages_columns[voyages_columns == "AL"] <- "Albanie"
voyages_columns[voyages_columns == "RS"] <- "Serbie"
voyages_columns[voyages_columns == "TR"] <- "Turquie"
voyages_columns[voyages_columns == "AT"] <- "Autrice"
voyages_columns[voyages_columns == "SK"] <- "Slovaquie"


# Replace any occurrence of ":" (used for missing data) with NA
voyages_na <- replace(voyages_columns, voyages_columns == ":", NA)

# Removing all unwanted characters from columns et transforming them in numeric
voyages_numeric <- voyages_na %>%
  mutate(across(`2016`:`2023`, ~ as.numeric(gsub("[A-Za-z ]", "", .))))

# Remove rows with any missing values (NA), keeping only complete rows for analysis

voyages_clean <- voyages_numeric[complete.cases(voyages_numeric[ , !(names(voyages_numeric) %in% "2023")]) | 
                           (is.na(voyages_numeric$`2023`) & complete.cases(voyages_numeric[ , !(names(voyages_numeric) %in% "2023")])), ]


# Reshape the data from wide to long format, creating two new columns: 'year' and 'percentage'
# 'year' will contain the years from 2012 to 2023, and 'percentage' will contain corresponding values
voyages_long <- voyages_clean %>%
  pivot_longer(
    cols = c('2016':'2023'),  # Columns representing years to be reshaped
    names_to = "year",        # New column name for year
    values_to = "percentage"  # New column name for the values
  )

# Convert the 'year' column from character to integer for proper numeric representation
voyages_long$year <- as.integer(voyages_long$year)

write.csv(voyages_long, "/Users/aimeesilva/Documents/Projets R/arrivals_europe_percentage.csv", row.names = FALSE)


# Step 1: Calculate the mean 'percentage' for each country
top_10_countries <- voyages_long %>%
  group_by(country) %>%                              # Group data by country
  summarise(mean_percentage = mean(percentage, na.rm = TRUE)) %>%  # Calculate mean percentage
  arrange(desc(mean_percentage)) %>%                 # Sort by mean percentage in descending order
  slice_head(n = 12)                                 # Select the top 10 countries

voyages_10 <- voyages_long %>%
  filter(country %in% top_10_countries$country)     # Filter to include only top 10 countries


# Step 2: Reordering the countries by the percentage's mean

voyages_10 <- voyages_10 %>%
  group_by(country) %>%
  mutate(mean_percentage = mean(percentage, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(country = reorder(country, -mean_percentage))

# Step 4: Create plots using the filtered data

# GEOM LINE

voyages_10 %>%
  ggplot(aes(x = year, y = percentage, color = country)) +
  geom_line(size = 1.1) + 
  geom_point(size = 2) +
  scale_x_continuous(limits = c(2016, 2023), breaks = seq(2016, 2023, by = 1)) + # Substitua por qualquer escala de cor sugerida
  labs(
    title = "Les 12 pays d'Europe qui ont le plus voyagé entre 2016 et 2023",
    x = "Année",
    y = "Pourcentage",
    color = "Pays",
    caption = "Source: Eurostat, 2024"
  ) +  # Adiciona título e rótulos dos eixos
  theme_minimal(base_size = 14) +  # Tema com texto maior
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),  # Centralize and bold title
    axis.text.x = element_text(angle = 45, hjust = 1)  # X axis text in a 45 degree angle
  )


# GEOM LINE SEPARETED BY COUNTRY

voyages_10 %>%
  ggplot(aes(x = year, y = percentage, color = country)) +
  geom_line(size = 1.1) + 
  geom_point(size = 2) +
  scale_x_continuous(limits = c(2016, 2023), breaks = seq(2016, 2023, by = 1)) +  # Substitua por qualquer escala de cor sugerida
  labs(
    title = "Les 12 pays d'Europe qui ont le plus voyagé entre 2016 et 2023",
    subtitle = "Classification basé sur la moyenne de voyages de chaque pays entre 2026 et 2023",
    x = "Année",
    y = "Pourcentage",
    color = "Pays",
    caption = "Source: Eurostat, 2024"
  ) +  # Adiciona título e rótulos dos eixos
  theme_minimal(base_size = 14) +  # Tema com texto maior
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),  # Centralize and bold title
    axis.text.x = element_text(angle = 45, hjust = 1)) +  
  facet_wrap(~ country) 


