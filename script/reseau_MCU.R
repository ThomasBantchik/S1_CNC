library(visNetwork)
library(tidyverse)

# Charger les données à partir des fichiers CSV
noeuds <- read_csv("data/csv/noeuds_MCU.csv")
liens <- read_csv("data/csv/liens_MCU_R.csv")

# Nettoyage des données des liens pour s'assurer qu'il n'y a pas de labels
liens <- liens %>% mutate(label = NULL)  # Supprimer les labels dans les liens

# Associer les ID des noeuds aux labels correspondants dans le data frame "noeuds"
noeuds_label <- noeuds %>%
  rename(from_label = label)  # Créer une colonne "from_label" avec le label des noeuds pour "from"

noeuds_label_to <- noeuds %>%
  rename(to_label = label)  # Créer une colonne "to_label" avec le label des noeuds pour "to"

# Joindre les labels et les groupes aux liens
liens <- liens %>%
  left_join(noeuds_label, by = c("from" = "id")) %>%
  left_join(noeuds_label_to, by = c("to" = "id")) %>%
  left_join(noeuds %>% select(id, group), by = c("from" = "id")) %>%
  rename(group_from = group)  # Renommer la colonne group pour "group_from" afin d'identifier le groupe de "from"

# Ajouter une colonne pour les flèches dans les liens
liens <- liens %>%
  mutate(arrows = ifelse(type == "Direct", "to", ""))  # Appliquer des flèches uniquement aux liens directs

# Ajouter une colonne de "title" pour la légende des liens
liens <- liens %>%
  mutate(title = ifelse(type == "Direct", 
                        ifelse(group_from == "acteur", 
                               paste(from_label, "a joué dans", to_label),
                               ifelse(group_from == "réalisateur", 
                                      paste(from_label, "a réalisé", to_label), 
                                      paste(from_label, "a joué dans", to_label))),
                        ifelse(value == 1,
                               paste(from_label, "a partagé au moins une scène avec", to_label, "dans", value, "seul film :", films),
                               paste(from_label, "a partagé au moins une scène avec", to_label, "dans", value, "films différents :", films)
                        )
  ))

# Ajouter une colonne "title" aux noeuds pour afficher un tooltip avec une image
noeuds <- noeuds %>%
  mutate(title = paste("<div style='text-align: center;'><img src='", image, "' width='100' height='150'><br>", label, "</div>"))

# Simple interactive plot, with node labels displayed and edge labels hidden
visNetwork(noeuds, liens, width = "100%", height = "800px") %>%
  
  # Customizing the node groups
  visGroups(groupname = "acteur", color = list(background = "blue", border = "darkred")) %>%
  visGroups(groupname = "réalisateur", color = list(background = "lightgreen", border = "blue")) %>%
  visGroups(groupname = "film", color = list(background = "yellow", border = "darkorange")) %>%
  
  # Customizing node appearance (size, font)
  visNodes(size = 20, font = list(size = 20, face = "arial", color = "black"), 
           color = list(highlight = list(background = "red", border = "black"))) %>%
  
  # Customizing edges and ensuring edge labels are disabled
  visEdges(
    width = ~value,  # Utilise la colonne "value" pour définir la largeur des liens
    color = list(color = "gray", highlight = "red"),  # Edge color
    smooth = FALSE,  # Disable edge smoothing
    label = NULL,  # Explicitly hide edge labels
    title = ~title,  # Utilise la colonne 'title' pour la légende des liens
    arrows = ~arrows  # Utilise la colonne 'arrows' pour activer/désactiver les flèches
  ) %>%
  
  # Adding the legend
  visLegend(
    width = 0.1, 
    position = "right", 
    main = "Group",
    useGroups = TRUE  # Show groups in the legend
  ) %>%
  
  # Adding options for interactivity
  visOptions(
    autoResize = TRUE,   # Automatically resize the graph
    manipulation = TRUE, # Enable manipulation (dragging nodes)
    selectedBy = "group", # Allow filtering by group
    highlightNearest = list(enabled = TRUE, degree = 1), # Highlight connected nodes when hovering
    nodesIdSelection = TRUE  # Allow selecting nodes by ID
  ) %>%
  
  # Customizing the physics to create even more space between the nodes
  visPhysics(
    enabled = TRUE,
    barnesHut = list(
      gravitationalConstant = -2000,   # Augmente l'espacement en diminuant l'attraction gravitationnelle
      centralGravity = 0.01,            # Réduit encore la force vers le centre pour plus de dispersion
      springLength = 600               # Allonge la longueur des ressorts pour encore plus d'espace
    ),
    forceAtlas2Based = list(
      gravitationalConstant = -5000,   # Augmente encore la force de répulsion entre les nœuds
      centralGravity = 0.25,           # Permet une plus grande dispersion des nœuds
      springLength = 500               # Allonge la longueur des ressorts
    )
  )
