# Configuration minimale
## Configuration de PAM

PAM va fournir le service de gestion de comptes, c’est-à-dire permettre l’authentification de l’utilisateur, la création de sa session et éventuellement toute opération qui doit se dérouler lors de la tentative d’accès : création d’environnement, récupération de tickets ou de données, droits d’accès, changement de mot de passe, etc.
Les fichiers de configuration des modules PAM se situent dans /etc/pam.d/

- Il faut limiter le nombre d'applications utilisant PAM, pour savoir si une application a été écrite pour utiliser PAM on utilise la commande "ldd". Exemple : ldd /etc/sbin/sshd, le résultat contient bien "libpam.so".

- Authentication par un serice distant : on s'assure de que le protocole d'authentification utilisé par PAM soit sécurisé, on pourra par exemple implémenter le module "pam_krb5" pour utiliser le protocole Kerberos (https://www.eyrie.org/~eagle/software/pam-krb5/)

- Exemples de modifications possibles avec les modules : bloquage de l'accès root à certains groupes/utilisateurs (/etc/pam.d/sudo), réglage de la complexité des mots de passe (/etc/pam.d/passwd)...

- Il faut appliquer une solution de hashage de mdp jugée sûre : /etc/pam.d/common-password et /etc/login.defs

## Sécurisation de SSH

## Gestion des mots de passe et comptes dédiés

Mot de passe root : doit répondre aux recommandations sur les mots de passe et doit être unique pour chaque machine
Le compte root ne doit pas être utilisé pour toutes les actions d'administration : on utilisera différents comptes pour les différents usages nécessaires, cette séparation aide aussi à la tracabilité des actions.
Les administrateurs doivent posséder leur propre compte utilisateur dédié afin de ne pas utiliser leurs comptes à privilèges quand il y n'en ont pas le besoin.
-> protocole de création de compte

## Limiter les services réseau

## Protocoles de mise à jour

# Configuration intermédiaire

## Gestion et Configuration d'un pare-feu

-> iptables/ufw?

## Configuration sécurisée des services

## Journalisation et archivage

###1) Syslog

Appliquer une configuration sécurisée au serveur syslog, on suivra, par exemple, les recommandations de l'ANSSI à ce propos : https://www.ssi.gouv.fr/journalisation.

Cloisonner le service syslog dans un environnement chroot : il faut bien penser à configurer syslogd pour qu'il bien les différents autres services qui pourraient être chrootés (on utilisera la commande suivante syslogd -a /chroot/SERVICE/dev/log)

Utiliser une partition séparée du reste du système : le volume des journaux à traiter peut être difficile à évaluer en amont, il vaut donc mieux isoler les journaux du reste des volumes sur une partition dédiée afin d’éviter que le remplissage d’une partition ne puisse entraver la gestion des journaux ou qu'une saturation due aux journaux bloque le système.

###2) Auditd

auditd est un service de journalisation qui permet d’enregistrer des opérations système spécifiques, voire d’alerter un administrateur lorsque des opérations privilégiées non prévues ont lieu, le fonctionnement du service dépend entièrement de son fichier de configuration :

*png exemple*

###3) Surveillance du système de fichiers : AIDE

AIDE est un logiciel open source qui aide l'administrateur à controler l'évolution du système de fichiers un « instantané » de l'état du système (sans les fichieres temporaires), enregistre les fragmentations, les moments liés à des modifications et toute autre donnée concernant les fichiers définis par l'administrateur. Cet « instantané » est utilisé pour générer une base de données qui est enregistrée qui va servir de base de comparaison.

Lorsque l'administrateur souhaite exécuter un test d'intégrité, l'administrateur place la base de données précédemment générée en un lieu accessible et commande AIDE afin de comparer la base de données avec l'état réel du système. Toute modification qui se serait produite sur l'ordinateur entre la création de l'instantané et le test sera détectée par AIDE et sera signalée à l'administrateur.

Documentation de AIDE : https://aide.github.io/

## Confinement des droits par sudo

sudo est un utilitaire installé lorsqu’il y a un besoin de déléguer des droits et privilèges à différents utilisateurs.
Afin de pouvoir réaliser cela, sudo est un exécutable setuid root. Il est donc important de se préoccuper de sa sécurité.

On peut créer un groupe dédié à l’usage de sudo doit être créé (/usr/bin/sudo). Seuls les utilisateurs membres de ce groupe pourront avoir le droit d’exécuter sudo.

Inconvénient : cette modification peut être écrasée par les scripts d'installation lors des mises à jour.

# Configuration renforcée

## Configuration sécurisée du système

## Blocage du chargement dynamique de module

## Suppression des programmes inutiles

## chroot systématique de tous les services

## Ecriture de scripts d'audit spécialisés
