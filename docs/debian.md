# Debian

On part du principe que la configuration de la VM a déjà été réalisée.

## Installation

Une fois la VM lancée, sélectionner l'installation en CLI via l'élément `Install`.
On va choisir `French - Français` comme langue de notre système, dans le pays `France`, pour une disposition de clavier `Français`, c'est-à-dire AZERTY (dans le cas d'un clavier QWERTY, choisir une disposition `Anglais`). Si on le désire, cela pourra se changer une fois l'installation terminée en changeant une variable d'environnement, quelques configurations dans des fichiers du système et en installant les packages de langues adaptés.

La suite de la configuration se fait étape après étape :
 - Choisir un nom de machine, comme par exemple `ensibs-linux-debian`
 - Nous ne procédons pas à une installation dans un domaine. On continue donc sans entrer de domaine
 - On entre un mot de passe pour le superutilisateur `root`, et on le confirme. Il est à noter que selon les dernières recommandations de l'ANSSI il n'est pas jugé nécessaire de le changer fréquemment, tant qu'il possède les caractéristiques d'un mot de passe complexe (minuscules, majuscules, nombres, caractères spéciaux et même phrase de passe qui ne soit pas déjà réputé comme facilement craquable comme `Azerty123!` ou autres largement présents dans les bases de mots de passe). On en génère un ensemble via la commande `pwgen -y 16`, et on en choisit un. Pour notre cas de simple labo local, on va choisir `Jah!B7foh5hei6ba` qui remplit les critères d'un bon mot de passe. Il est à noter que dans un environnement plus sensible, comme un simple ordinateur personnel ou professionnel, il ne faut en aucun cas le noter sur la machine ou même sur un post-it sur l'écran (ou sous le clavier et autres variantes) car en cas d'intrusion sur le site cela ouvre une porte béante sur le SI. Il ne faut pas non plus utiliser le même mot de passe sur plusieurs machines
 - On entre un nom pour le nouvel utilisateur, comme par exemple `tartiflette`, que l'on utilise aussi comme identifiant
 - On choisit un mot de passe pour ce nouvel utilisateur, en se rappelant du commentaire fait 2 étapes auparavent, comme par exemple `piem6Fe0mee~s2mu`
 - On sélectionne la méthode de partitionnement `Assisté - utiliser tout un disque avec LVM chiffré`, conformément à l'énoncé et comme bonne pratique de sécurité lorsque cela est possible, et on sélectionne le seul disque que l'on a donné à la VM. On va choisir le schéma de partitionnement `Tout dans une seule partition (recommandé pour les débutants)` car notre présent objectif n'est pas de monter une VM Linux en parfait état de l'art. Une installation comme nous allons le faire est déjà largement suffisante pour nos besoins et n'entravera pas la sécurité ou la capacité opérationnelle. Cette étape, une fois lancée, peut prendre plusieurs minutes. C'est donc l'heure pour sortir voir la lumière du soleil une dernière fois avant un long moment à parcourir les documents de l'ANSSI.
 - Lors du partitionnement, il est demandé une phrase de passe. Il faut de préférence en choisir une un peu longue histoire de conserver une bonne sécurité, comme par exemple `APT56 c'est mieux que GCC`. Une fois entrée, on la confirme et on conserve la quantité d'espace choisie par défaut, qui représente la totalité du volume accordé à la VM.

Une fois cela effectué, on va passer à l'installation du système de base, c'est-à-dire au téléchargement et à l'installation des paquets nécessaires au noyau. Ce fonctionnement est en accord avec le principe KISS.
 - Passer l'étape (c'est-à-dire choisir `<Non>`) pour l'analyse d'autres supports d'installation
 - On choisit le mirroir Debian `France` pour télécharger nos paquets le plus efficacement possible, et spécifiquement `deb.debian.org`. On laisse vide le mandataire HTTP puisque nous n'utilisons pas une infrastructure sous proxy
 - On va choisir de ne pas participer (c'est-à-dire choisir `<Non>`) à l'étude statistique sur l'utilisation des paquets puisqu'on est dans le cadre d'un labo qui n'a aucune porté à être un système réel avec un usage opérationnel
 - Choisir uniquement les logiciels `serveur SSH` et `utilitaires usuels du système` et lancer l'installation
 - Choisir d'installer le programme de démarrage GRUB sur le disque principal (c'est-à-dire choisir `<Oui>`), sur le périphérique commençant par `/dev/sda`
 - Terminer l'installation en choisissant `<Continuer>`

La VM va alors redémarrer automatiquement et au bout de quelques instants, la phrase de passe du disque chiffré LVM va être demandée. Cela se fera lorsqu'en début de ligne va apparaître `Please unlock disk sda5_crypt:`.
Toujours quelques instants plus tard, on va pouvoir ouvrir une session pour le compte utilisateur créé précédemment.
