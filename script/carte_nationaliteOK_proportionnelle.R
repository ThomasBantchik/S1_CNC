# Charger les bibliothèques nécessaires
library(leaflet)
library(sp)
library(sf)

# Charger le shapefile pour les pays
carte <- st_read('data/shp/fond_carte_nationalite/fond_carte_nationalite.shp')

# Charger le fichier CSV pour les pays
pays <- read.csv("data/csv/noeuds_nationalite.csv")

# Charger le shapefile pour les liens entre les pays
liens <- st_read('data/shp/liens_nationaliteOK/liens_nationaliteOK.shp')

# Vérifier la structure des données avant d'ajouter une colonne
head(pays)  # Vérifiez si la colonne 'name' et 'weight' existent
head(liens)  # Vérifiez si les colonnes comme 'from_country' et 'to_country' existent

# Créer la colonne popup_message dans le dataframe pays
pays$popup_message <- ifelse(pays$name == "France", 
                             paste("<b>", pays$weight, "</b>", " films produits en ", "<b>", pays$name, "</b>", " ont été exploités en ", "<b>", pays$name, "</b>", " en 2023"),
                             paste("<b>", pays$name, "</b>", " a exporté ", "<b>", pays$weight, "</b>", " films en France en 2023"))

# Créer la colonne popup_message dans le dataframe liens
liens$popup_message <- paste("Nombre de films exportés par ", "<b>", liens$from, "</b>", "<br>en France en 2023 : ", "<b>", liens$weight,"</b>")

# Vérifiez les données du lien et assurez-vous qu'il y a des valeurs dans 'weight'
head(liens)

# Créer la colonne 'line_weight' en fonction du poids (weight)
# Nous allons ici définir la plage des valeurs de poids entre 1 et 10 (vous pouvez ajuster cette plage si nécessaire)
max_weight <- max(liens$weight, na.rm = TRUE)  # Trouver la valeur maximale de weight
min_weight <- min(liens$weight, na.rm = TRUE)  # Trouver la valeur minimale de weight

# Normaliser les poids et ajuster l'épaisseur entre 1 et 10
liens$line_weight <- 1 + (liens$weight - min_weight) / (max_weight - min_weight) * 99  # Plage entre 1 et 10

# Vérifiez les données pour vous assurer que 'line_weight' a bien été ajoutée
head(liens)

# Convertir les objets sf en Spatial (si nécessaire)
carte_spatial <- as_Spatial(carte)
liens_spatial <- as_Spatial(liens)

# Initialiser la carte leaflet avec les données des pays et des liens
nationalite <- leaflet() %>%
  ## Ajouter la couche de base
  addProviderTiles(providers$OpenStreetMap)  %>%
  
  ## Définir la vue initiale de la carte
  setView(lng = 2.320041, 
          lat = 48.8588897, 
          zoom = 2) %>%
  
  ## Ajouter les marqueurs pour chaque ville avec popup personnalisé
  addMarkers(data = pays,
             lng = ~lng, 
             lat = ~lat,
             group = "Pays",  # Nom de la couche pour les villes
             popup = ~popup_message) %>%
  
  ## Ajouter la couche des pays avec remplissage orange
  addPolygons(data = carte_spatial,
              fillColor = "orange",  # Couleur de remplissage des pays
              weight = 1,  # Poids des bordures
              opacity = 1,
              color = "black",  # Couleur de la bordure
              fillOpacity = 0.7,
              group = "Frontières") %>%
  
  ## Ajouter la couche des liens entre les pays (polygones) avec popup personnalisé
  addPolygons(data = liens_spatial,  # Si les liens sont des polygones
              color = "blue",  # Couleur des liens
              weight = ~line_weight,  # Proportionalité de l'épaisseur avec la colonne 'line_weight'
              opacity = 0.7,
              popup = ~popup_message,  # Popup spécifique pour les liens
              group = "Liens") %>%
  
  ## Ajouter une légende
  addLegend("topright", 
            colors = c("transparent"), 
            labels = c("Parce qu'il n'y a pas qu'Hollywood dans la vie"),
            title = "Films en exploitation dans les salles françaises en 2023 selon leur nationalité") %>%
  
  ## Ajouter une mini carte
  addMiniMap("bottomleft") %>%
  
  ## Ajouter un contrôle de couches pour basculer entre les groupes "Villes", "Pays" et "Liens"
  addLayersControl(overlayGroups = c("Pays", "Liens", "Frontières"),
                   options = layersControlOptions(collapsed = TRUE))

# Rendre la carte
nationalite
