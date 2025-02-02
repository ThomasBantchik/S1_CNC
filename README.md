# S1_CNC
j'espère que ça vous plaira Mr Vitali

Bonjour Monsieur, voici les résultats que j'ai pu produire en me basant sur des bases de données du Centre National du Cinéma et de l'Image Animée (CNC)

## Graph

En me basant sur les données des catégories d'âges du public des films français, j'ai pu réaliser un premier graph en "donut" en me concentrant uniquement sur l'année 2023.
![Rplot](https://github.com/user-attachments/assets/1d64e691-1453-4ce4-9edb-5aca08563582)

J'ai ensuite voulu réaliser des graphs en "donuts concentriques" pour ainsi représenter l'évolution sur plusieurs années de ces catégories d'âges.
![Rplot02](https://github.com/user-attachments/assets/baff37d5-2882-4387-8b56-3ad23072f55c)

Peu convaincu par l'aspect visuel de ce genre de graph sous ggplot, j'ai décidé de passer en plot ly, d'abord juste sur l'année 2023.
[Graph Donut Plot ly 2023](https://ThomasBantchik.github.io/S1_CNC/donut_plotly2023.html)

Encouragé par ce résultat, j'ai voulu réaliser de nouveau un graph avec des donuts concentriques en plot ly. Mais j'ai découvert que plot ly ne pouvais pas gérer plus de deux donuts à la fois, alors voici mon résultat.
[Graph Donut Concentrique Plot ly](https://ThomasBantchik.github.io/S1_CNC/donut_plotlyconcentrique2023.html)

Peu convaincu par ce résultat, j'ai décidé de passé sur un plus classique Barchart en ggplot. J'en ai profité pour ajouter les années 2018 et 2019 à mes datas pour avoir des données pré et post-Covid.
![Rplot](https://github.com/user-attachments/assets/ff1e3938-e715-4c5c-83f3-11c0d5f644a3)

J'ai ensuite passé ce code en plot ly pour qu'il soit plus agréable à l'oeil.
[Barchart Plot ly](https://ThomasBantchik.github.io/S1_CNC/barchart_plotly.html)

## Carte

En me basant cette fois sur les données des entrées dans les différentes régions et départements du pays, j'ai décidé de faire une carte représentants ces valeurs sur l'année 2023. J'ai d'abord réalisé une carte me concentrant uniquement sur les régions.
[Carte Région](https://github.com/ThomasBantchik/S1_CNC/main/code_region.html)

Après ce résultat satisfaisant, j'ai pu facilement ajouter les départements. La carte est modifiable en utilisant le Layers Control.
[Carte Région et Département](https://ThomasBantchik.github.io/S1_CNC/code_region_departement.html)

## Carte + réseau

Fichier trop lourd pour être intégré dans Github malheureusement, je le montre en détail dans la vidéo.

## Réseau

[Reseau MCU](https://ThomasBantchik.github.io/S1_CNC/reseau_MCU.html)


