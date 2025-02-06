library(leaflet)
library(sf)
library(dplyr)
library(readr)  # Pour lire les fichiers CSV
library(htmltools)  # Pour personnaliser le contrôle du titre

# Charger les données géographiques des départements et des régions
regions <- st_read("data/shp/region/region_france.shp")
departements <- st_read("data/shp/departement/departement_france.shp")

# Lire les données de population depuis le fichier CSV
entree_france <- read_csv("data/csv/entrees_region_departement.csv")

# Séparer les données de population pour les départements et les régions
entree_region <- entree_france %>%
  filter(type == "Région")
entree_departement <- entree_france %>%
  filter(type == "Département")

# Nettoyer la colonne 'entrees' pour s'assurer qu'elle est numérique
entree_region$entrees <- as.numeric(gsub(",", ".", entree_region$entrees))  # Remplacer les virgules par des points
entree_departement$entrees <- as.numeric(gsub(",", ".", entree_departement$entrees))

# Fusionner les données de population avec les géométries des région et des départements
region_pop <- regions %>%
  left_join(entree_region, by = c("NAME_1" = "nom"))
departement_pop <- departements %>%
  left_join(entree_departement, by = c("NAME_2" = "nom"))

# Créer la carte leaflet
mymap <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%  # Choisir un fond de carte
  
  # Ajouter les régions avec un fond coloré basé sur la population
  addPolygons(data = regions, 
              color = "red", 
              weight = 2, 
              fillOpacity = 0.7, 
              label = ~paste("Région:", NAME_1),
              group = "Région") %>%  # L'ajouter à un groupe "Région"
  
  # Ajouter les cercles des entrées pour les régions, liés à la région
  addCircleMarkers(data = entree_region, 
                   ~lng, ~lat,  # Utiliser les colonnes latitude et longitude
                   radius = ~sqrt(entrees) * 2,  # Taille des points proportionnelle aux entrées
                   color = "blue", 
                   fill = TRUE, 
                   fillColor = "blue", 
                   fillOpacity = 1,
                   popup = ~paste("<strong>Région:</strong>", nom,
                                  "<br><strong>Entrées:</strong>", entrees, "millions"),
                   label = ~paste("Entrées:", entrees, "millions"), # Ajouter l'étiquette avec les entrées
                   group = "Entrées Région") %>%  # L'ajouter à un groupe "Entrées Région"
  
  # Ajouter les départements avec un fond coloré basé sur la population
  addPolygons(data = departements,  # Utiliser 'departements' pour les départements
              color = "green", 
              weight = 2, 
              fillOpacity = 0.7, 
              label = ~paste("Département:", NAME_2),
              group = "Département") %>%  # L'ajouter à un groupe "Département"
  
  # Ajouter les cercles des entrées pour les départements, liés au département
  addCircleMarkers(data = entree_departement, 
                   ~lng, ~lat,  # Utiliser les colonnes latitude et longitude
                   radius = ~sqrt(entrees) * 2,  # Taille des points proportionnelle aux entrées
                   color = "yellow", 
                   fill = TRUE, 
                   fillColor = "yellow", 
                   fillOpacity = 1,
                   popup = ~paste("<strong>Département:</strong>", nom,
                                  "<br><strong>Entrées:</strong>", entrees, "millions"),
                   label = ~paste("Entrées:", entrees, "millions"), # Ajouter l'étiquette avec les entrées
                   group = "Entrées Département") %>%  # L'ajouter à un groupe "Entrées Département"  
  
  ## Ajouter une légende
  addLegend("topright", 
            colors = c("transparent"), 
            labels = c("Chiffres CNC"),
            title = "Entrées dans les salles françaises en 2023 par région et département") %>%
  
  ## Ajouter une mini carte
  addMiniMap("bottomleft") %>%
  
  # Ajouter le contrôle des couches pour afficher ou masquer les groupes
  addLayersControl(
    overlayGroups = c("Région", "Entrées Région", "Département", "Entrées Département"),  # Définir les groupes à contrôler
    options = layersControlOptions(collapsed = FALSE),  # Ne pas réduire le contrôle
    position = "topright"
  )

# Afficher la carte
mymap
