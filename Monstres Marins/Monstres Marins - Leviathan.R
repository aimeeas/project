library(readr)
monstres_marin_finale <- read_csv("monstres_marin_finale.csv")
View(monstres_marin_finale)

leviathan <- "leviat"
données_leviathan <- monstres_marin_finale[apply(monstres_marin_finale, 1, function(row) any(grepl(leviathan, row, ignore.case = TRUE))), ]


# Save the data to a CSV file
write.csv(données_leviathan, "leviathan.csv", row.names = FALSE)


leviathan_clean <- subset(données_leviathan, !user %in% c("FightinCowboy", "Power Jumper", "LOCKLEAR", "Auron", "E.M.B", "Dynamo Gaming", "Dynamo Gaming New", "The CW Television", "The CW Network", "TheGuill84", "40k WARGAMER", "Wayward Winchester"))

leviathan_clean2 <- subset(données_leviathan, !user %in% c("40k WARGAMERS Tv", "The CW Television Network", "FightinCowboy", "Power Jumper", "LOCKLEAR", "Auron", "E.M.B", "Dynamo Gaming", "Dynamo Gaming New", "The CW Television", "The CW Network", "TheGuill84", "40k WARGAMER", "Wayward Winchester"))


write.csv(leviathan_clean, "leviathan.csv", row.names = FALSE)
write.csv(leviathan_clean2, "leviathan2.csv", row.names = FALSE)



# Convertion ---------------------------------------------

# Choisir les colonnes

leviathan_iramuteq <- leviathan_clean %>%
  select(7, 15, 14)

leviathan_iramuteq2 <- leviathan_clean2 %>%
  select(7, 15, 14)

dataframe2iramuteq <- function(data, filename) {
  data %>% 
    rename_with(~str_replace_all(str_to_lower(.), "[\\W_]+", "")) %>% # clean column names
    drop_na() %>%
    mutate(across(1:ncol(.)-1, ~str_replace_all(., "[\\W_]+", "")), row = 1:n()) %>% # clean values
    pivot_longer(-row, names_to = "coln", values_to = "value") %>%
    group_by(row) %>%
    summarise(text = str_c("**** ", str_c("*", coln[-n()], "_", value[-n()], collapse = " "), "\n", last(value))) %>% 
    summarise(text = str_c(text, collapse = "\n")) %>% 
    pull(1) %>% 
    write_file(filename)
}



dataframe2iramuteq(leviathan_iramuteq, "leviathan_FINALE.txt")
dataframe2iramuteq(leviathan_iramuteq2, "leviathan_FINALE2.txt")

skim(leviathan_iramuteq2)
