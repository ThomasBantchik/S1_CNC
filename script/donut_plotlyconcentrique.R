library(plotly)
library(dplyr)

# Charger les données depuis un fichier CSV
data <- read.csv("data/csv/age_public_donut.csv")

# Renommer la colonne 'count1' en '2023' et 'count2' en '2022'
colnames(data)[colnames(data) == "count1"] <- "2023"
colnames(data)[colnames(data) == "count2"] <- "2022"

# Calculer les pourcentages pour chaque donut
data$fraction1 <- data$'2023' / sum(data$'2023')
data$fraction2 <- data$'2022' / sum(data$'2022')

# Créer un graphique avec Plotly
fig <- plot_ly()

# Tracer le donut de 2023 (donut central)
fig <- fig %>%
  add_trace(
    type = 'pie',
    labels = data$age,
    values = data$'2023',
    hole = 0.4,  # Trou au centre du donut
    name = '2023',
    textinfo = 'name+label+percent',  # Ajouter les labels et pourcentages
    hoverinfo = 'name+label+percent',
    textposition = 'inside',
    domain = list(x = c(0.25, 0.75), y = c(0.25, 0.75))  # Domaine central pour 2023
  )

# Tracer le donut de 2022 (autour du donut de 2023 avec espace vide)
fig <- fig %>%
  add_trace(
    type = 'pie',
    labels = data$age,
    values = data$'2022',
    hole = 0.7,  # Trou plus grand pour l'année 2022 pour créer de l'espace
    name = '2022',
    textinfo = 'name+label+percent',
    hoverinfo = 'name+label+percent',
    textposition = 'inside',
    domain = list(x = c(0.1, 0.9), y = c(0.1, 0.9))  # Domaine plus large pour 2022, créant un espace vide
  )

# Personnaliser le layout
fig <- fig %>%
  layout(
    title = "Public en France des films français en 2022 et 2023 en fonction des âges",
    showlegend = FALSE,  # Masquer la légende
    annotations = list(
      list(x = 0.5, y = 0.5, text = "2023", showarrow = FALSE, font = list(size = 14)),  # Titre du donut 2023
      list(x = 0.5, y = 0.79, text = "2022", showarrow = FALSE, font = list(size = 14))  # Titre du donut 2022
    )
  )

# Afficher le graphique
fig
