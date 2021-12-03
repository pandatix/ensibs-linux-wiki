# WIKI SECU LINUX	
Ce rapport présente certaines mesures de sécurité Linux Debian à appliquer, les mesures de sécurité sont divisées en différentes configurations : minimale, recommandée et renforcée.
Toutes les sources sont disponibles en fin de rapport

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

## Limiter les services au minimum requis

Une bonne façon de protéger son système contre les vulnérabilités est de désactiver tous les services non nécessaires au fonctionnement visé du système.
Désactiver un service temporairement : sudo systemctl stop [service]
Supprimer un service : sudo rm /etc/systemd/system/[service]

Liste non exhaustive des services pouvant être désactivés/supprimés car inutiles sur un serveur :
1. (Serveur non NFS) Services RPC : portmap, rpc.statd, rpcbind...
2. Service facilitant le partage des imprimantes, fichiers et autres : avahi 
3. Système de fenêtrage qui gère l'écran, la souris et le clavier : xorg
4. Services inetd : xinetd, openbsd-inetd
5. Services réseaux peu communs : DCCP, SCTP, RDS, TIPC...
6. etc...


## Protocoles de mise à jour

# Configuration intermédiaire

## Gestion et Configuration d'un pare-feu

-> iptables/ufw?

## Configuration sécurisée des services

## Journalisation et archivage

### 1) Syslog

Appliquer une configuration sécurisée au serveur syslog, on suivra, par exemple, les recommandations de l'ANSSI à ce propos : https://www.ssi.gouv.fr/journalisation.

Cloisonner le service syslog dans un environnement chroot : il faut bien penser à configurer syslogd pour qu'il bien les différents autres services qui pourraient être chrootés (on utilisera la commande suivante syslogd -a /chroot/SERVICE/dev/log)

Utiliser une partition séparée du reste du système : le volume des journaux à traiter peut être difficile à évaluer en amont, il vaut donc mieux isoler les journaux du reste des volumes sur une partition dédiée afin d’éviter que le remplissage d’une partition ne puisse entraver la gestion des journaux ou qu'une saturation due aux journaux bloque le système.

### 2) Auditd

auditd est un service de journalisation qui permet d’enregistrer des opérations système spécifiques, voire d’alerter un administrateur lorsque des opérations privilégiées non prévues ont lieu, le fonctionnement du service dépend entièrement de son fichier de configuration :

![Exemple de configuration auditd](./images/auditd.png)

### 3) Surveillance du système de fichiers : AIDE

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

# Sources

https://www.debian.org/doc/manuals/securing-debian-manual/index.en.html
https://www.ssi.gouv.fr/guide/recommandations-de-securite-relatives-a-un-systeme-gnulinux/
https://www.debian.org/doc/manuals/securing-debian-manual/rpc.en.html
https://tldp.org/HOWTO/Security-Quickstart-HOWTO/services.html
