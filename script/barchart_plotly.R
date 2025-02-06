library(plotly)

# Charger les données à partir d'un fichier CSV
data <- read.csv("data/csv/age_public_barchart.csv")

# Extraire la catégorie principale des âges (avant les parenthèses)
data$age_category <- gsub("\\s\\(.*\\)", "", data$age)  # Supprimer tout après un espace et une parenthèse

# Vérifier si les catégories sont correctement extraites
print(unique(data$age_category))  # Affiche les catégories extraites

# Assurer que la variable 'age_category' est un facteur avec un ordre spécifique
data$age_category <- factor(data$age_category, levels = c("enfants", "jeunes", "adultes", "seniors"))

# Créer le graphique avec plotly
fig <- plot_ly(data, x = ~année, y = ~pourcentage, color = ~age_category, type = 'bar', 
               text = ~paste(age_category, ": ", pourcentage, "%"), 
               hoverinfo = 'text', 
               name = ~age_category) %>%
  layout(
    barmode = 'stack', 
    xaxis = list(title = 'Année', tickmode = 'array', tickvals = unique(data$année)), 
    yaxis = list(title = 'Pourcentage'),
    title = 'Public en France des films français de 2018 à 2023 en fonction des âges',
    legend = list(title = list(text = "Catégories d'âge"))
  )

# Afficher le graphique
fig
