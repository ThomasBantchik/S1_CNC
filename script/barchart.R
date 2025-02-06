library(ggplot2)

# Charger les données à partir d'un fichier CSV
data <- read.csv("data/csv/age_public_barchart.csv") 

# Assurez-vous que 'année' est un facteur pour qu'elle apparaisse correctement
data$année <- as.factor(data$année)

# Graphique empilé avec un titre et toutes les années en abscisse
ggplot(data, aes(fill=age, y=pourcentage, x=année)) + 
  geom_bar(position="stack", stat="identity") +
  ggtitle("Public en France des films français de 2020 à 2023 en fonction des âges") +  # Ajout du titre
  scale_x_discrete(breaks = unique(data$année))  # Forcer l'affichage de toutes les années
