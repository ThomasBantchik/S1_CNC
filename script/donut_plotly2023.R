library(plotly)
library(dplyr)

# Charger les données depuis un fichier CSV
data <- read.csv("data/csv/age_public_donut.csv")

# Renommer la colonne 'count1' en '2023'
colnames(data)[colnames(data) == "count1"] <- "2023"

# Calculer les pourcentages
data$fraction <- data$'2023' / sum(data$'2023')

# Calculer les pourcentages cumulés
data$ymax <- cumsum(data$fraction)

# Calculer le bas de chaque rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Calculer la position des labels
data$labelPosition <- (data$ymax + data$ymin) / 2

# Créer un label pour chaque segment
data$label <- paste0("Pourcentage de\n", data$age, " : ", data$'2023')

# Créer le graphique avec Plotly
fig <- plot_ly()

# Tracer le donut (les données '2023')
fig <- fig %>%
  add_trace(
    type = 'pie',
    labels = data$age,
    values = data$'2023',
    hole = 0.4,  # Trou au centre du donut
    textinfo = 'label+percent',
    hoverinfo = 'label+percent',
    textposition = 'inside',
    name = '2023'
  )

# Personnaliser le layout
fig <- fig %>%
  layout(
    title = "Public en France des films français en 2023 en fonction des âges",
    showlegend = FALSE,  # Masquer la légende
    annotations = list(
      list(x = 0.5, y = 0.5, text = "2023", showarrow = FALSE, font = list(size = 14))  # Titre du donut
    )
  )

# Afficher le graphique
fig
