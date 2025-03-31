# Load necessary libraries 
library(readr)
install.packages("tidyverse")
library(tidyverse)
install.packages("skimr")
library(skimr)
library(scales)
library(forcats)  # Pour reclasser les facteurs
install.packages("viridis")
library(viridis)  # Palette de couleurs

# TITRE DU ARCHIVE: Voyages par moyen de transport principal
# https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/tour_dem_tttr/?format=TSV&compressed=true


# Importing the data set
estat_tour_dem_tttr <- read_csv("estat_tour_dem_tttr.csv")

#Keeps only rows relative to travel of one night or more and removing the value
#TOTAL from the purpose column to not impact the calculus
bus <- estat_tour_dem_tttr %>%
  filter(duration == "N_GE1") %>%
  filter(purpose == "TOTAL") %>%
  filter(c_dest == "DOM" | c_dest == "FOR" ) %>%
  filter(tra_mode == "BUS") 


# Renaming and removing unnecessary columns
bus_columns <- bus %>%
  rename(country = `geo\\TIME_PERIOD`) %>%
  select(-1, -(3:6), -(8:11))


# Adding a new columns with the countries names
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

bus_columns <- bus_columns %>%
  mutate(country_fr = recode(country, !!!country_names)) 


# Replace any occurrence of ":" (used for missing data) with NA
bus_na <- replace(bus_columns, bus_columns == ":" | bus_columns == ": u", NA)

# Removing all unwanted characters from columns et transforming them in numeric
bus_numeric <- bus_na %>%
  mutate(across(`2016`:`2023`, ~ as.numeric(gsub("[A-Za-z ]", "", .))))

# Remove rows with any missing values (NA), keeping only complete rows for analysis
bus_clean <- bus_numeric[complete.cases(bus_numeric[ , !(names(bus_numeric) %in% "2023")]) | 
                             (is.na(bus_numeric$`2023`) & complete.cases(bus_numeric[ , !(names(bus_numeric) %in% "2023")])), ]

# Reshape the data from wide to long format, creating two new columns: 'year' and 'percentage'
# 'year' will contain the years from 2012 to 2023, and 'percentage' will contain corresponding values
bus_long <- bus_clean %>%
  pivot_longer(
    cols = c('2016':'2023'),  # Columns representing years to be reshaped
    names_to = "year",        # New column name for year
    values_to = "number"  # New column name for the values
  )


# Convert the 'year' column from character to integer for proper numeric representation
bus_long$year <- as.integer(bus_long$year)


# Calculate the mean of flights for each country based in each transport
mean_by_bus <- bus_long %>%
  group_by(country_fr) %>%                        # Group by both country and tra_mode
  summarise(mean_bus = mean(number, na.rm = TRUE)) %>%
  arrange(desc(mean_bus)) %>%                         # Sort by mean_number in descending order
  filter(!(country_fr %in% c("EU27_2020", "EA20")))        # Excluding the data from EU regions as an unit


# BY RAIL ------------------

# Filter top 10 countries
top_10_bus <- mean_by_bus %>%
  arrange(desc(mean_bus)) %>%            # Sort by mean_number
  head(n=10)


# Plot Top 10 countries by bus

top_10_bus %>%
  ggplot(aes(x = reorder(country_fr, -mean_bus), y = mean_bus, fill = country_fr)) +
  geom_col(show.legend = FALSE) +  # Masquer la légende des couleurs
  scale_fill_viridis_d(option = "plasma") +  # Choix de palette esthétique
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Échelle en millions
  labs(
    title = "Nombre moyen de voyages en BUS par pays entre 2016 et 2023",
    subtitle = "Top 10 en Europe",
    x = "Pays",
    y = "Nombre de voyages (en millions)"
  ) +  
  theme_minimal(base_size = 14) +  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


# BY RAIL BY COUNTRY ----------

# Filter the original data to include only relevant rows for plotting (top10)
bus_filtered <- bus_long %>%
  filter(country_fr %in% top_10_bus$country_fr)  # Only top 10 countries


# Reordering the countries by the mean number of travels

bus_filtered <- bus_filtered %>%
  group_by(country_fr) %>%
  mutate(mean_number = mean(number, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(country_fr = reorder(country_fr, -mean_number))

# Plot using geom_col

bus_filtered %>%
  ggplot(aes(x = year, y = number, fill = c_dest)) + 
  geom_col() +
  scale_fill_viridis_d(option = "plasma", labels = c("DOM" = "Nationaux", "FOR" = "Internationaux")) +  # Choix de palette esthétique
  scale_x_continuous(limits = c(2015, 2024), breaks = seq(2016, 2023, by = 1)) + 
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Aplica escala de mil
  labs(
    title = "Voyages en BUS entre 2016 et 2024 par destination",
    x = "Année",
    y = "Nombre de voyages (en millions)",
    fill = "Destination"
  ) +  
  theme_minimal(base_size = 14) +  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),  
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +  
  facet_wrap(~ country_fr)


# Plot using geom_line


bus_filtered %>%
  ggplot(aes(x = year, y = number, color = c_dest)) + 
  geom_line() +
  scale_color_brewer(palette = "Set1", labels = c("DOM" = "Nationaux", "FOR" = "Internationaux")) +  # Palette harmonieuse
  scale_x_continuous(limits = c(2016, 2023), breaks = seq(2016, 2023, by = 1)) + 
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Aplica escala de mil
  labs(
    title = "Voyages en BUS entre 2016 et 2024 par destination",
    x = "Année",
    y = "Nombre de voyages (en millions)",
    color = "Destination"
  ) +  
  theme_minimal(base_size = 14) +  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),  
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +  
  facet_wrap(~ country_fr)

