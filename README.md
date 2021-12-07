# Linux

Nolan GLOUX
Maxime MINGUELLA
Lucas TESSON

Ce wiki contient une installation verbeuse et détaillée d'une VM Debian sous Virtual Box. Il devrait être possible de le dérouler pour obtenir les mêmes résultats annoncé au fur et à mesure.

Le choix de la verbosité est fait pour qu'une personne qui découvre le sujet puisse comprendre les étapes et leurs implications.

Il sera fait le choix d'appliquer au plus possibles les recommandations de l'ANSSI pour augmenter le niveau de sécurité du système.

## Glossaire

Voir le [glossaire](docs/glossary.md) pour les termes techniques nécessitant une explication ou un rappel.

## Création de la VM sous Virtual Box

Télécharger la [dernière image iso de Debian en mode netinst pour une architecture amd64](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso).

```bash
cd <my_workdir>
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso
```

Pour la création d'une VM, se référer à [la documentation](docs/new-vbox.md).

## Configuration et installation de Debian

Une fois la VM lancée, il va y avoir une capture de la souris et du clavier.
En cas de nécessité de quitter la capture de la VM, il est écrit en bas à droite de la fenêtre la touche permettant cela. Le plus souvent, c'est le bouton `Ctrl` à droite du clavier.

Nous allons désormais naviguer avec le clavier uniquement. Pour cela, lorsqu'il faudra cocher/décocher un élément d'une liste ou un sélecteur type switch (visible par un `[ ]` ou `[X]`), cela se fera via la barre `Espace`. Pour continuer à l'étape suivante ou cliquer sur un bouton, cela se fera via la touche `Entrée`. La navigation se fera via les touches directionnelles et la touche `Tab`.

Se référer à [la documentation d'installation de Debian](docs/debian.md) pour installer la VM.

Une fois cela réalisé, on va arrêter la VM pour en faire un instantané (ou _snapshot_). Cela nous permettra de la relancer en l'état si jamais on le désire.
Pour cela, on commence par exécuter `su` pour passer en administrateur, on tape le mot de passe du compte root, et on exécute `systemctl poweroff`, comme écrit dans la [documentation Debian au chapitre 8 section 1](https://www.debian.org/releases/buster/amd64/ch08s01.en.html). Cette élévation de privilège est nécessaire car l'action d'arrêter la machine est sensible (dans le sens où il ne faut pas que n'importe qui puisse décider d'arrêter selon sa propre volonté la machine).

Pour faire un instantané, voir [la documentation](docs/snapshot-vbox.md).

## Audit de l'état du système avant la mise à jour

De nombreux outils sont disponibles afin d'évaluer le niveau de sécurité et de protection d'un système, ces outils analysent les applications et services installés puis en déduisent une liste d'améliorations possibles, et annoncent le niveau de maturité du système audité.

On commence avec [Debescan](docs/debescan.md), et on continuera sur [Lynis](docs/lynis.md).

## Mise à jour du système

On commence par mettre à jour le système selon [la documentation](docs/update.md).

Cela ne prodigue aucune mise à jour, ce qui est compréhensible puisque le système est neuf.

On profite de cette étape pour effectuer un instantané de la VM.

## Sécurisation de l'environnement

La sécurisation de l'environnement se fera par plusieurs étapes et selon plusieurs guides.
Il est choisit de procéder en deux temps majeurs :
 1. Augmentation à un score d'au moins 80 par Lynis
 2. Validation selon les ressources et en particulier les guides de l'ANSSI

### Augmentation à une score d'au moins 80 par Lynis

#### Mise en place d'un mot de passe BIOS

Se référer à [la documentation sur la mise en place d'un mdp BIOS](docs/mdp-bios.md).

#### Hardening

On va corriger `HRDN-7230` qui correspond à `Hardening` > `Installed malware scanner`.
Pour cela, Lynis nous suggère `rkhunter`, `chkrootkit` et `OSSEC`.
Nous allons choisir d'utiliser ce premier car très connu en utilisant [la documentation](docs/rkhunter.md).
Cela va avoir pour effet d'ajouter des compilateurs que nous allons supprimer grâce au script [del-compils.sh](scripts/del-compils.sh).

Cela va avoir pour effet de relever le score Lynis.

#### Dossiers personnels

On va corriger `HOME-9304` (qui soit dit en passant n'est plus à jour pour cette référence donnée).
Pour cela, on va s'assurer que seul les utilisateurs des dossiers dans `/home` ont accès à leurs dossiers. On va donc se connecter en tant que `tartiflette` et exécuter `chmod o-rx /home/tartiflette`.

On va pouvoir scripter cela pour effectuer la manipulation dans le cas où il y aurait plusieurs comptes utilisateurs via le script [fix-home-perms.sh](scripts/fix-home-perms.sh).

#### Cryptographie

On va tenter de corriger `CRYP-8004`.
Pour cela, on va suivre la [procédure](docs/rngd.md).
Il est à noter que dans tous les cas, puisque nous sommes sur un VM, cela ne va pas changer l'état de la détection.
En effet, en observant le [test effectué par Lynis](https://github.com/CISOfy/lynis/blob/master/include/tests_crypto#L247), on observe que Lynis va chercher le fichier `/sys/class/misc/hw_random/rng_current`. Celui-ci n'existe pas car il n'existe aucun module physique et qu'on ne va pas chercher à forcer le système pour qu'il en trouve un.

Cette mesure ne pourra donc pas aboutir, mais nous pouvons désormais utiliser le service `rng-tools-debian` pour accéder à une génération de random qui possède une entropie que l'on a basiquement validé.

#### SSH

Pour cela, on va suivre la [documentation sur la sécurisation SSH](docs/ssh.md).

#### Installation des binaires divers

Pour diverses raisons, nous allons installer les paquets suivants.

| Paquet              | Raison |
|---------------------|---|
| `apt-listbugs`      | lève des alertes lors de l'installation d'un paquet comprenant des bugs répertoriés |
| `needrestart`       | lève des alertes lorsque le système a besoin de redémarrer |
| `debsums`           | permet d'effectuer une vérification de la checksum des paquets téléchargés pour s'assurer qu'ils ne sont pas corrompus voir compromis |
| `fail2ban`          | bannir les comptes utilisateurs qui possèdent trop d'erreurs de login |
| `apt-show-versions` | averti en cas de patch de paquet |

```bash
su
apt install apt-listbugs needrestart debsums fail2ban apt-show-versions -y
exit
```

On configure `fail2ban` selon [la documentation](docs/fail2ban.md).

Cela va avoir pour effet de relever le score Lynis.

#### Installation de PAM (Pluggable Authentication Modules)

On va commencer par installer `libpam-tmpdir`.

```bash
su
apt install libpam-tmpdir -y
exit
```

Les fonctionnalités apportées par PAM sont présentées [ici](docs/pam.md).

### Bilan Lynis

Avec l'ensemble de ces mesures, on dépasse le seuil Lynis de 80 en Hardening.

---

## Validation selon les ressource et en particulier les guides de l'ANSSI

### Recommandations de configuration d'un système GNU/Linux - ANSSI v1.2

Les guides de l'ANSSI étant construit de telle sorte que l'ordre importe, nous allons pouvoir chercher à appliquer chaque mesure une à une.
Nous partirons du principe que les étapes de sécurisation diverses précédentes ont été réalisées en amont.

On choisit d'interpréter le sigle "R" comme une règle plutôt qu'une recommendation pour appuyer le caractère nécessaire d'une grande majorité de celles-ci.

#### R1 - Minimisation des services installés

Pour minimiser les services installés, on va supprimer les paquets inutilisés et des fichiers que nous n'utiliserons pas, comme ceux liés à l'IPv6.
On va se baser sur la [doc de ReduceDebian](https://wiki.debian.org/ReduceDebian), et scripter cela dans [r01.sh](scripts/anssi/r01.sh).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R1    | Appliqué |

#### R2 - Minimisation de la configuration

Cette règle rappelle des pricipes clés qui tiennent au simple fait qu'un service installé ne doit avoir accès qu'à ce dont il a réellement besoin, sans plus.
La bonne pratique avec le temps est donc, lors de l'installation, la modification ou la suppression d'un service d'analyser les effets via :
 - `systemctl list-units`
 - `systemctl status     <service>`
 - `systemctl disable    <service>`
 - `systemctl stop       <service>`
 - `systemctl start      <service>`

Dans un état d'installation initial sans presque aucune modification, on se retrouve dans une situation d'applomb.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R2    | Appliqué |

#### R3 - Principe de moindre privilège

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R3    |        |

#### R4 - Utilisation des fonctionnalités de contrôle d'accès


Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R4    |        |

#### R5 - Principe de défense en profondeur

Cette règle rappelle des principes clés :
 - authentification nécessaire avant d'effectuer des opérations et notamment quand elles sont privilégiés
 - journalisation centralisée d'évènements au niveau systèmes et services
 - utilisation préférentielle de services qui implémentent des mécanismes de cloisonnement ou de séparation de privilèges
 - utilisation de mécanismes de prévention d'exploitation

L'OS Debian implémente par défaut l'ensemble de ces mécanismes au travers de sa gestion des comptes (et son `sudo`), les logs (`/var/logs` notamment), `chroot`...etc.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R5    | Appliqué |

#### R6 - Cloisonnement des services réseau

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R6    |        |

#### R7 - Journalisation de l'activité des services

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R7    |        |

#### R8 - Mises à jour régulières

À défaut de proposer un mode réactif se basant sur des listes de diffusion ou des API comme [celle du NVD](https://nvd.nist.gov/general/News/New-NVD-CVE-CPE-API-and-SOAP-Retirement), nous allons utiliser un mécanisme de mise à jour automatisé.
On part du principe pour cela que nous n'aurons pas de système extrêmement sensible qui pourrait souffrir de ces mises à jour, auquel cas celles-ci pourraient poser problème.
On utilise le mécanisme d'_unattended update_, et on script cela dans [r08.sh](scripts/anssi/r08.sh).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R8    | Appliqué |

#### R9 - Configuration matérielle

Les règles/recommandations de la note technique liée à cela ne sont soit pas intéressantes dans le cadre de labo ou simplement impossibles sur une VM.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R9    | Appliqué |

#### R10 - Architecture 32 et 64 bits

L'image Debian utilisée a pour architecture du x86-64.
Cela peut se vérifier par l'exécution de la commande `uname -a`.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R10   | Appliqué |

#### R11 - Directive de configuration de l'IOMMU

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R11   |        |

#### R12 - Partitionnement type

Dans le contexte d'un labo, nous avons fait le choix de ne faire qu'une unique partition chiffrée LVM.
Il est rappelé que cela n'est pas la meilleure pratique puisque séparer les divers points de montage apporte plusieurs possibilités (et notamment de sécurité).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R12   | Appliqué |

#### R13 - Restrictions d'accès sur le dossier /boot

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R13   |        |

#### R14 - Installation de paquets réduite au strict nécessaire

Lors de l'application de la R1, on a déjà réduit au strict nécessaire les paquets en accord avec ReduceDebian.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R14   | Appliqué |

#### R15 - Choix des dépôts de paquets

Lors de l'installation, on a utilisé le mirroir `deb.debian.org` et nous n'en avons rajouté aucun. Cela peut se vérifier en observant le contenu du fichier `/etc/apt/sources.list`.
Il faudra garder à l'esprit à l'avenir qu'en cas d'ajout d'une source il faudra revenir sur cette règle/recommendation.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R15   | Appliqué |

#### R16 - Dépôts de paquets durcis

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R16   |        |

#### R17 - Mot de passe du chargeur de démarrage

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R17   |        |

#### R18 - Robustesse du mot de passe administrateur

Le mot de passe administrateur a été généré via `pwgen -y 16`, puis sélectionné au hasard par l'administrateur, en accord avec les recommandations de sécurité relatives aux mots de passe.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R18   | Appliqué |

#### R19 - Imputabilité des opérations d'administration

On vient créer un compte pour un administrateur `admin`, pour ne pas avoir à utiliser le compte `root`.
Ce compte devra posséder un mdp respectant les règles/recommandations émises par l'ANSSI, comme par exemple `aecha{s,u)e7taeP`.
On n'oublie pas de l'ajouter au groupe sudo pour qu'il puisse accéder à des droits d'administration.

```bash
adduser admin
usermod -aG sudo admin
```

Les actions d'`admin` lui seront désormais imputable.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R19   | Appliqué |

#### R20 - Installation d'éléments secrets ou de confiance

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R20   |        |

#### R21 - Durcissement et surveillance des services soumis à des flux arbitraires

L'ensemble des éléments que nous avons installé sur la machine ne sont pas soumis à des flux extérieurs arbitraires, à l'exception de SSH.
Un travail de durcissement est documenté dans [ssh.md](docs/ssh.md).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R21   | Appliqué |

#### R22 - Paramétrage des sysctl réseau

Dans le contexte de labo, la machine n'a pas vocation à effectuer du routage. Nous allons donc la configurer ainsi.
De plus, nous n'utilisons pas IPv6, nous allons donc le désactiver.

On script ces actions dans [r22.sh](scripts/anssi/r22.sh).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R22   | Appliqué |

#### R23 - Paramétrage des sysctl système

On applique la configuration de base donnée. Il est à noter que dans le contexte d'expérimentation du labo, nous n'allons pas restreindre l'ajout de modules au travers d'une systctl.

On script ces actions dans [r23.sh](scripts/anssi/r23.sh).

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R23   |        |

#### R24 - Désactivation du chargement des modules noyau

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R24   |        |

#### R25 - Configuration sysctl du module Yama

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R25   |        |

#### R26 - Désactivation des comptes utilisateurs unitulisés

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R26   |        |

#### R27 - Désactivation des comptes de services

Dans le contexte du labo, il n'existe que 3 comptes au total :
 - root
 - admin
 - tartiflette

Il n'existe donc pas la problématique de comptes de services en l'état.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R27   | Appliqué |

#### R28 - Unicité et exclusivité des comptes de services

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R28   |        |

#### R29 - Délais d'expiration de sessions utilisateurs

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R29   |        |

#### R30 - Applications utilisant PAM

La granularité de configuration de PAM ne permet pas d'assurer d'un niveau minimal de sécurité au contour bien définit.
Toutefois on peut s'appuyer sur de nombreuses ressources en ligne (de Red Hat ou encore du MIT) pour en confectionner une de base permettant de restreindre un minimum les applications utilisant PAM.

On script cela dans [r30.sh](scripts/anssi/r30.sh).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R30   | Appliqué |

#### R31 - Sécurisation des services réseau d'authentification PAM

Dans le contexte du labo, il n'y a pas d'authentification se faisant au travers du réseau.

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R31   | N/A    |

#### R32 - Protection des mots de passe stockés

On va configurer PAM et Debian pour utiliser SHA512 comme primitive de hash avec un seul et une nombre de tours de 65536.

On script cela dans [r32.sh](scripts/anssi/r32.sh).

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
| MIRE   | R32   |        |

#### R33 - Sécurisation des accès aux bases utilisateurs distantes

Dans le contexte du labo, il n'y a pas d'authentification se faisant au travers du réseau.

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R33   | N/A    |

#### R34 - Séparation des comptes système et d'administrateur de l'annuaire

Dans le contexte du labo, il n'y a pas d'authentification se faisant au travers du réseau.

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R34   | N/A    |

#### R35 - Valeur de umask

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R35   |        |

#### R36 - Droit d'accès aux fichier de contenu sensible

De nombreux fichiers peuvent être connotés sensibles sur un environnement Linux.
On délègue la charge à Lynis d'avoir surveillé cela, et étant donné que des mesures ont été prises pour sécuriser si besoin les fichiers, on assume qu'une majorité de ces fichiers les plus sensibles sont protégés.

Bilan de la règle:
| Niveau | Règle | État      |
|--------|-------|-----------|
|  IRE   | R36   | Apppliqué |

#### R37 - Exécutables avec bits setuid et setgid

On commence par dresser la liste des binaires qui possèdent un bit setuid ou setgid via la commande `find / -type f -perm /6000 -ls 2>/dev/null`.
On vient dresser le tableau suivant pour prendre une décision sur les binaires.

| Binaire                                       | Type | Commentaire | Action |
|-----------------------------------------------|------|---|---|
| `/usr/sbin/unix_chkpwd`                       | GUID | Utilisé dans le cas d'une vérification de mdp pour un binaire ne disposant pas des droits root | Suppression |
| `/usr/bin/gpasswd`                            | SUID | Utilisé pour les authentifications de groupes | Suppression |
| `/usr/bin/dotlockfile`                        | GUID | Utilisé pour gérer les fichiers protégés | Suppression |
| `/usr/bin/crontab`                            | GUID | Utilisé dans les tâches cron | Suppression |
| `/usr/bin/passwd`                             | SUID | Utilisé dans le cas où un utilisateur doit pouvoir changer de mdp | Conserver |
| `/usr/bin/umount`                             | SUID | Utilisé pour démonter un volume | Suppression |
| `/usr/bin/chage`                              | GUID | Utilisé pour changer les informations d'expiration d'un mdp | Suppression |
| `/usr/bin/chfn`                               | SUID | Utilisé pour changer les informations et le nom d'un utilisateur | Suppression |
| `/usr/bin/chsh`                               | SUID | Utilisé pour changer de shell | Suppression |
| `/usr/bin/newgrp`                             | SUID | Utilisé pour créer un groupe | Suppression |
| `/usr/bin/expiry`                             | GUID | Utilisé pour gérer les règles d'expiration de mdp | Suppression |
| `/usr/bin/su`                                 | SUID | Utilisé pour exécuter des commandes en tant qu'un autre utilisateur | Suppression |
| `/usr/bin/wall`                               | GUID | Utilisé pour envoyer un message à tous les utilisateurs | Suppression |
| `/usr/bin/mount`                              | SUID | Utilisé pour monter un volume | Suppression |
| `/usr/bin/write.ul`                           | GUID | Utilisé pour envoyer un message à un autre utilisateur | Suppression |
| `/usr/lib/dbus-1.0/dbus-daemon-launch-helper` | SUID | Utilisé dans le contexte de DBUS | Suppression |

On script les actions à effectuer dans [r37.sh](scripts/anssi/r37.sh).

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
| MIRE   | R37   | Appliqué partiellement (exception pour `/usr/bin/passwd` car on laisse à l'utilisateur la possibilité de changer son mdp sans avoir à passer par l'administrateur) |

#### R38 - Exécutables setuid root

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R38   |        |

#### R39 - Répertoire temporaires dédiés aux comptes

Pour que chaque compte utilisateur possède un répertoire temporaire qui lui soit propre, on utilise une règle PAM comme décrite dans [cet article](https://debathena.mit.edu/pam_mktemp/).
On script cela dans [r39.sh](scripts/anssi/r39.sh).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R39   | Appliqué |

#### R40 - Sticky bit et droits d'accès en écriture

Cette règle/recommendation nous fait armer le sticky-bit de l'ensemble des dossiers accessibles en écriture à tous sur le système.
On script cela dans [r40.sh](scripts/anssi/r40.sh).

Il est à noter que le cas où un fichier serait modifiable par tout le monde n'est pas traité car n'est lui-même pas très explicité.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R40   | Appliqué |

#### R41 - Sécurisation des accès pour les sockets et pipes nommées

En listant les sockets et pipes via les commandes `ss -xp` et `ipcs`, on ne remarque aucune anomalie (les répertoires les protégeants possèdent des droits appropriés).
Cela reste à surveiller dans le contexte où le labo viendrait à grossir.

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R41   | Appliqué |

#### R42 - Services et démons résidents en mémoire

On établit une liste exhaustive de services qui ne sont pas nécessaires à notre cas d'usage, grâce aux commandes `systemctl list-units`, `ps aux` et `netstat -aelonptu` :
 - dbus (démon `dbus.service` et socket `dbus.socket`)

On décide de l'arrêter, et pour cela on script nos actions dans [r42.sh](scripts/anssi/r42.sh).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R42   | Appliqué |

#### R43 - Durcissement et configuration du service syslog

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R43   |        |

#### R44 - Cloisonnement du service syslog par chroot

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R44   |        |

#### R45 - Cloisonnement du service syslog par un conteneur

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R45   |        |

#### R46 - Journaux d'activité de service

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R46   |        |

#### R47 - Partition dédiée pour les journaux

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R47   |        |

#### R48 - Configuration du service local de messagerie

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R48   |        |

#### R49 - Alias de messagerie des comptes de service

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R49   |        |

#### R50 - Journalisation de l'activité par auditd

Le fonctionnement du service auditd dépend entièrement du contenu de son fichier de configuration. Un exemple est fourni dans [exemple de configuration auditd](docs/auditd.md).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|   RE   | R50   | Appliqué |

#### R51 - Scellement et intégrité des fichiers

Nous utilisons l'outil d'audit AIDE afin de veiller à l'intégrité des fichiers du système, cet outil est présenté dans [présentation de AIDE](docs/aide.md).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|    E   | R51   | Appliqué |

#### R52 - Protection de la base de données des scellés

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R52   |        |

#### R53 - Restriction des accès des services déployés

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R53   |        |

#### R54 - Durcissement des composants de virtualisation

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R54   |        |

#### R55 - Cage chroot et pribilèges d'accès du service cloisonné

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R55   |        |

#### R56 - Activation et utilisation de chroot par un service

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R56   |        |

#### R57 - Groupe dédié à l'usage de sudo

sudo est un utilitaire installé lorsqu’il y a un besoin de déléguer des droits et privilèges à différents utilisateurs.
Afin de pouvoir réaliser cela, sudo est un exécutable setuid root. Il est donc important de se préoccuper de sa sécurité.
On peut mettre en place un groupe dédié à son usage en suivant cette [documentation groupe dédié sudo](docs/groupesudo.md).

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
|  IRE   | R57   | Appliqué |

#### R58 - Directives de configuration sudo

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R58   |        |

#### R59 - Authentification des utilisateurs exécutant sudo

On vérifie que la configuration de sudo requiert un mot de passe, c'est-à-dire que `NOPASSWD` n'est pas présent dans le fichier. Il est à noter que cela peut requérir l'installation de sudo (`apt install sudo -y`).

De plus, on vérifie que le fichier comprend bien les deux lignes suivantes dans le même état :
```
root    ALL=(ALL:ALL) ALL
%sudo   ALL=(ALL:ALL) ALL
```

Bilan de la règle:
| Niveau | Règle | État     |
|--------|-------|----------|
| MIRE   | R59   | Appliqué |

#### R60 - Privilèges des utilisateurs cibles pour une commande sudo

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R60   |        |

#### R61 - Limitation du nombre de commandes nécessitant l'option EXEC

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|   RE   | R61   |        |

#### R62 - Du bon usage de la négation dans une spécification sudo

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R62   |        |

#### R63 - Arguments explicites dans les spécifications sudo

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R63   |        |

#### R64 - Du bon usage de sudoedit

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|  IRE   | R64   |        |

#### R65 - Activation des profils de sécurité AppArmor

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R65   |        |

#### R66 - Activation de SELinux avec la politique targeted

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R66   |        |

#### R67 - Paramétrage des booléens SELinux

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R67   |        |

#### R68 - Désinstallation des outils de débogage de politique SELinux

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R68   |        |

#### R69 - Confinement des utilisateurs interactifs non-privilégiés

Bilan de la règle:
| Niveau | Règle | État   |
|--------|-------|--------|
|    E   | R69   |        |

#### Bilan

Toutes les mesures MIRE ont été mises en application à une restriction prêt sur R37.
Les mesures IRE ne sont pas toutes mises en application, certaines sont encore à traiter et on des chances d'avoir déjà des solutions.
Les mesures RE et E n'ont pas été traitées par manque de temps.

#### Sources

https://www.debian.org/doc/manuals/securing-debian-manual/index.en.html
https://www.ssi.gouv.fr/guide/recommandations-de-securite-relatives-a-un-systeme-gnulinux/
https://www.debian.org/doc/manuals/securing-debian-manual/rpc.en.html
https://tldp.org/HOWTO/Security-Quickstart-HOWTO/services.html
https://www.cert.ssi.gouv.fr/
http://pwet.fr/man/linux/commandes/pwgen/
https://opensource.com/article/20/5/linux-security-lynis 
