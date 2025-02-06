# Charger la librairie nécessaire
library(ggplot2)

# Charger les données depuis un fichier CSV
data <- read.csv("data/csv/age_public_donut.csv") 

# Renommer la colonne 'count1' en '2023', pour que ce soit plus clair pour moi
colnames(data)[colnames(data) == "count1"] <- "2023"

# Vérifier que les données ont bien été chargées
head(data)

# Calculer les pourcentages
data$fraction <- data$'2023' / sum(data$'2023')

# Calculer les pourcentages cumulés (haut de chaque rectangle)
data$ymax <- cumsum(data$fraction)

# Calculer le bas de chaque rectangle, important pour pouvoir positionner les labels correctement
data$ymin <- c(0, head(data$ymax, n=-1))

# Calculer la position des labels
data$labelPosition <- (data$ymax + data$ymin) / 2

# Créer un label 
data$label <- paste0("Pourcentage de\n", data$age," : ", data$'2023')

# Créer le graphique
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=age)) +
  geom_rect() +
  geom_label(x=3.5, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=4) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  
  # Ajouter un titre personnalisé
  ggtitle("Public en France des films français en 2023 en fonction des âges") +  # Titre de la carte
  theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"))  # Centrer et personnaliser le titre
