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
moyens <- estat_tour_dem_tttr %>%
  filter(duration == "N_GE1") %>%
  filter(purpose == "TOTAL") %>%
  filter(c_dest == "FOR" ) %>%
  filter(tra_mode != "LAND") %>%
  filter(tra_mode != "TOTAL")


# Renaming and removing unnecessary columns
moyens_columns <- moyens %>%
  rename(country = `geo\\TIME_PERIOD`) %>%
  select(-(1:4), -6, -(8:17))


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

moyens_columns <- moyens_columns %>%
  mutate(country_fr = recode(country, !!!country_names)) 

#Changement des noms
moyens_columns <- moyens_columns %>%
  mutate(
    tra_mode = case_when(
      tra_mode == "LAND_OTH" ~ "Transport terrestre (autres)",
      tra_mode == "AIR" ~ "Avion",
      tra_mode == "RAIL" ~ "Train",
      tra_mode == "PRDMV_PAS_X_BUS" ~ "Moteur routier privé pour passagers",
      tra_mode == "RRDMV_PAS_X_BUS" ~ "Moteur routier loué",
      tra_mode == "BUS" ~ "Bus",
      tra_mode == "BUS_REG" ~ "Bus - regular",
      tra_mode == "BUS_OCC" ~ "Bus - occasionnel",
      tra_mode == "WW" ~ "Voie d'eau",
      tra_mode == "RDMV_PAS_X_BUS" ~ "Véhicules routiers automobiles",
      TRUE ~ tra_mode # Manter o valor original caso não corresponda a nenhum dos casos acima
    )
  )



# Replace any occurrence of ":" (used for missing data) with NA
moyens_na <- replace(moyens_columns, moyens_columns == ":" | moyens_columns == ": u", NA)

# Removing all unwanted characters from columns et transforming them in numeric
moyens_numeric <- moyens_na %>%
  mutate(across(`2022`:`2023`, ~ as.numeric(gsub("[A-Za-z ]", "", .))))

# Remove rows with any missing values (NA), keeping only complete rows for analysis
moyens_clean <- moyens_numeric[complete.cases(moyens_numeric[ , !(names(moyens_numeric) %in% "2023")]) | 
                           (is.na(moyens_numeric$`2023`) & complete.cases(moyens_numeric[ , !(names(moyens_numeric) %in% "2023")])), ]

# Reshape the data from wide to long format, creating two new columns: 'year' and 'percentage'
# 'year' will contain the years from 2012 to 2023, and 'percentage' will contain corresponding values
moyens_long <- moyens_clean %>%
  pivot_longer(
    cols = c('2022':'2023'),  # Columns representing years to be reshaped
    names_to = "year",        # New column name for year
    values_to = "number"  # New column name for the values
  )


# Convert the 'year' column from character to integer for proper numeric representation
moyens_long$year <- as.integer(moyens_long$year)


# Calculate the mean each moyen
mean_by_moyens <- moyens_long %>%
  filter(!(country_fr %in% c("EU27_2020", "EA20"))) %>%        # Excluding the data from EU regions as an unit
  group_by(tra_mode) %>%                        # Group by both country and tra_mode
  summarise(mean_moyens = mean(number, na.rm = TRUE)) %>%
  arrange(desc(mean_moyens))                         # Sort by mean_number in descending order
  
library(readxl)
write.csv(mean_by_moyens, "/Users/aimeesilva/Documents/Projets R/moyens_de_transport.csv", row.names = FALSE)

write.csv(voyages_long, "/Users/aimeesilva/Documents/Projets R/arrivals_europe_percentage.csv", row.names = FALSE)


library(scales)


mean_by_moyens %>% 
  arrange(desc(mean_moyens)) %>%  # Organizar em ordem decrescente
  ggplot(aes(x = factor(tra_mode, levels = mean_by_moyens$tra_mode), 
             y = mean_moyens, fill = tra_mode)) +
  geom_col(show.legend = FALSE) +  # Remove a legenda
  labs(
    title = "Type de transport préferé pour les déplacements internationaux en Europe",
    x = "Moyen de Transport",
    y = "Moyenne",
    subtitle = "Moyenne des Années 2022 et 2023, les années de réprise",
    caption = "Source: Eurostat, 2024"
  ) +
  theme_minimal() +  # Usando o tema minimalista
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Ajuste de ângulo dos rótulos do eixo x
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12, face = "italic"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12)
  ) +
  scale_fill_viridis_d() +  # Adiciona uma paleta de cores (opcional, pode escolher outra)
  scale_y_continuous(labels = label_number(scale = 1e-3, suffix = "K"))  # Exibe valores em 'K'

# BY moyens ------------------

# Filter top 10 countries
top_10_moyens <- mean_by_moyens %>%
  arrange(desc(mean_moyens)) %>%            # Sort by mean_number
  head(n=10)


# Plot Top 10 countries by moyens

top_10_moyens %>%
  ggplot(aes(x = reorder(country_fr, -mean_moyens), y = mean_moyens, fill = country_fr)) +
  geom_col(show.legend = FALSE) +  # Masquer la légende des couleurs
  scale_fill_viridis_d(option = "plasma") +  # Choix de palette esthétique
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Échelle en millions
  labs(
    title = "Nombre moyen de voyages en AVION par pays entre 2016 et 2023",
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


# BY moyens BY COUNTRY ----------

# Filter the original data to include only relevant rows for plotting (top10)
moyens_filtered <- moyens_long %>%
  filter(country_fr %in% top_10_moyens$country_fr)  # Only top 10 countries


# Reordering the countries by the mean number of travels

moyens_filtered <- moyens_filtered %>%
  group_by(country_fr) %>%
  mutate(mean_number = mean(number, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(country_fr = reorder(country_fr, -mean_number))

# Plot using geom_col

moyens_filtered %>%
  ggplot(aes(x = year, y = number, fill = c_dest)) + 
  geom_col() +
  scale_fill_viridis_d(option = "plasma", labels = c("DOM" = "Nationaux", "FOR" = "Internationaux")) +  # Choix de palette esthétique
  scale_x_continuous(limits = c(2015, 2024), breaks = seq(2016, 2023, by = 1)) + 
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Aplica escala de mil
  labs(
    title = "Voyages en Avion entre 2016 et 2024 par destination",
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


moyens_filtered %>%
  filter(purpose == "PER") %>%
  ggplot(aes(x = year, y = number, color = c_dest)) + 
  geom_line() +
  scale_color_brewer(palette = "Set1", labels = c("DOM" = "Nationaux", "FOR" = "Internationaux")) +  # Palette harmonieuse
  scale_x_continuous(limits = c(2016, 2023), breaks = seq(2016, 2023, by = 1)) + 
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Aplica escala de mil
  labs(
    title = "Voyages en Avion pour des motifs personnels entre 2016 et 2024 par destination",
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


moyens_filtered %>%
  filter(purpose == "PROF") %>%
  ggplot(aes(x = year, y = number, color = c_dest)) + 
  geom_line() +
  scale_color_brewer(palette = "Set1", labels = c("DOM" = "Nationaux", "FOR" = "Internationaux")) +  # Palette harmonieuse
  scale_x_continuous(limits = c(2016, 2023), breaks = seq(2016, 2023, by = 1)) + 
  scale_y_continuous(labels = label_number(scale = 0.000001, suffix = "m")) +  # Aplica escala de mil
  labs(
    title = "Voyages en Avion pour des motifs professionnels entre 2016 et 2024 par destination",
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
