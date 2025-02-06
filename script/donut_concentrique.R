# Charger la librairie nécessaire
library(ggplot2)

# Charger tes données depuis un fichier CSV
data <- read.csv("data/csv/age_public_donut.csv") 

# Renommer les colonnes pour éviter toute confusion
colnames(data)[colnames(data) == "count1"] <- "2023"
colnames(data)[colnames(data) == "count2"] <- "2022"
colnames(data)[colnames(data) == "count3"] <- "2021"
colnames(data)[colnames(data) == "count4"] <- "2020"

# Calculer les pourcentages pour chaque donut
data$fraction1 <- data$'2023' / sum(data$'2023')
data$fraction2 <- data$'2022' / sum(data$'2022')
data$fraction3 <- data$'2021' / sum(data$'2021')
data$fraction4 <- data$'2020' / sum(data$'2020')

# Calculer les pourcentages cumulés pour 2023 chaque donut
data$ymax1 <- cumsum(data$fraction1)
data$ymax2 <- cumsum(data$fraction2)
data$ymax3 <- cumsum(data$fraction3)
data$ymax4 <- cumsum(data$fraction4)

# Calculer les pourcentages cumulés inversés pour chaque donut
data$ymin1 <- c(0, head(data$ymax1, n=-1))
data$ymin2 <- c(0, head(data$ymax2, n=-1))
data$ymin3 <- c(0, head(data$ymax3, n=-1))
data$ymin4 <- c(0, head(data$ymax4, n=-1))

# Créer la position des labels pour chaque donut
data$labelPosition1 <- (data$ymax1 + data$ymin1) / 2
data$labelPosition2 <- (data$ymax2 + data$ymin2) / 2
data$labelPosition3 <- (data$ymax3 + data$ymin3) / 2
data$labelPosition4 <- (data$ymax4 + data$ymin4) / 2

# Créer un label lisible pour chaque donut
data$label1 <- paste0("Pourcentage de\n", data$age, " en ", '2023', " : ", data$'2023')
data$label2 <- paste0("Pourcentage de\n", data$age, " en ", '2022', " : ", data$'2022')
data$label3 <- paste0("Pourcentage de\n", data$age, " en ", '2021', " : ", data$'2021')
data$label4 <- paste0("Pourcentage de\n", data$age, " en ", '2020', " : ", data$'2020')

# Créer le graphique avec quatre donuts concentriques (avec plus d'espace entre eux)
ggplot() +
  # Tracer le premier donut (les données '2023') dans une plage plus petite
  geom_rect(data=data, aes(xmin=2, xmax=3, ymin=ymin1, ymax=ymax1, fill=age)) +
  
  # Tracer le deuxième donut autour du premier donut (les données '2022') dans une plage plus large
  geom_rect(data=data, aes(xmin=3.3, xmax=4.3, ymin=ymin2, ymax=ymax2, fill=age)) +
  
  # Tracer le troisième donut autour du deuxième donut (les données '2021') dans une plage encore plus large
  geom_rect(data=data, aes(xmin=4.6, xmax=5.6, ymin=ymin3, ymax=ymax3, fill=age)) +
  
  # Tracer le quatrième donut autour du troisième donut (les données '2020') dans une plage encore plus large
  geom_rect(data=data, aes(xmin=5.9, xmax=6.9, ymin=ymin4, ymax=ymax4, fill=age)) +
  
  # Ajouter les labels pour le premier donut (avec taille réduite)
  geom_label(data=data, aes(x=2.5, y=labelPosition1, label=label1), size=3, fontface="plain") +
  
  # Ajouter les labels pour le deuxième donut (avec taille réduite)
  geom_label(data=data, aes(x=3.8, y=labelPosition2, label=label2), size=3, fontface="plain") +
  
  # Ajouter les labels pour le troisième donut (avec taille réduite)
  geom_label(data=data, aes(x=4.9, y=labelPosition3, label=label3), size=3, fontface="plain") +
  
  # Ajouter les labels pour le quatrième donut (avec taille réduite)
  geom_label(data=data, aes(x=6.3, y=labelPosition4, label=label4), size=3, fontface="plain") +
  
  # Palette de couleurs
  scale_fill_brewer(palette=4) +
  
  # Coordonnées polaires pour l'effet donut
  coord_polar(theta="y") +
  
  # Ajuster les limites pour afficher les quatre donuts
  xlim(c(1, 7)) +  # Agrandir la plage pour tenir compte de l'espace supplémentaire
  ylim(c(0, 1)) +  # Maintenir la hauteur normale pour éviter les étirements verticaux
  
  # Supprimer l'arrière-plan et les axes
  theme_void() +
  
  # Supprimer la légende
  theme(legend.position = "none") +
  
  # Ajouter un titre
  ggtitle("Public en France des films français en fonction des âges de 2020 à 2023)") +  # Titre du graphique
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"))  # Centrer et personnaliser le titre
