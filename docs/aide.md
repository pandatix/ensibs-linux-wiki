# Service AIDE pour la surveillance du système de fichiers

`AIDE` est un outil open source qui aide l'administrateur à controler l'évolution du système de fichiers un « instantané » de l'état du système (sans les fichieres temporaires), enregistre les fragmentations, les moments liés à des modifications et toute autre donnée concernant les fichiers définis par l'administrateur. Cet « instantané » est utilisé pour générer une base de données qui est enregistrée qui va servir de base de comparaison.

Lorsque l'administrateur souhaite exécuter un test d'intégrité, l'administrateur place la base de données précédemment générée en un lieu accessible et commande `AIDE` afin de comparer la base de données avec l'état réel du système. Toute modification qui se serait produite sur l'ordinateur entre la création de l'instantané et le test sera détectée par `AIDE` et sera signalée à l'administrateur.

Documentation en ligne de `AIDE` : https://aide.github.io/
