# RKhunter

RKHunter = Rootkit Hunter.
Cette doc se base sur [celle d'Ubuntu.fr](https://doc.ubuntu-fr.org/rkhunter).

## Installation

Sur un système Debian, ouvrir un terminal et exécuter ce qui suit.
Cette installation se fait avec le gestionnaire de paquets `apt`.

```bash
apt install rkhunter -y
```

## Configuration

Il peut être intéressant de configurer rkhunter pour envoyer des rapports par mail et effectuer une vérification journalière.
Nous ne procéderons pas à cette configuration dans notre cas de labo, mais ceci peut-être intéressant dans le cadre d'une gestion d'un petit parc informatique.
Dans le cas d'un plus grand parc informatique, il faudrait étudier une meilleure façon de faire remonter l'information pour éviter de se retrouver avec une boîte mail inutilisable.

## Utilisation

| Commande | Objectif |
|---|---|
| `rkhunter --versioncheck` | vérifier que la version de rkhunter est la dernière |
| `rkhunter --update` | mettre à jour la base de rkhunter |
| `rkhunter --list` | lister les tests effectuer par rkhunter. Cela peut remonter des [paquets Perl qu'il faut installer](#installation-des-paquets-perl-manquants) |
| `rkhunter --checkall` | effectuer une vérification. Le rapport peut être [exporté pour être traité](#export-du-rapport-de-scan). On peut ajouter le flag `--sk` pour effectuer le scan en mode non-intéractif. Voir [la gestion des warnings](#gestion-des-warnings) en cas de remontée |

Dans le cas où les deux premières commandes renvoient `Invalid WEB_CMD configuration option: Relative pathname: "/bin/false"`, effectuer les modifications suivantes :
 - mettre `UPDATE_MIRRORS` à `1`, pour faire les mises à jour en ligne plutôt qu'en mode local
 - mettre `MIRRORS_MODE` à `0`, pour utiliser tout mirroir disponible, en local ou en ligne
 - mettre `WEB_CMD` à `curl`, pour utiliser cURL afin de se mettre à jour

Cela va désormais permettre à rkhunter de se mettre à jour en utilisant `curl`.
Il serait toutefois plus intéressant de s'assurer dès que possible que le mirroir soit mis à jour via le gestionnaire de paquet, mais cela ne semble pas toujours se faire (c'est donc un moyen de forcer la procédure qui peut représenter un risque puisque le contenu téléchargé n'est pas vérifié par les auteurs du paquet).

## Installation des paquets PERL manquants

On prend le scénario suivant.
Il est à noter que cette pratique n'est pas des meilleurs puisqu'il va falloir maintenir manuellement les paquets à jour.
Toutefois, il est important de satisfaire toutes les dépendances de rkhunter pour que son travail ait un sens et une efficacité vraiment appréciable.

```bash
rkhunter --list

...
Perl module installation status:
    perl command               Installed
    File::stat                 Installed
    Getopt::Long               Installed
    Crypt::RIPEMD160            MISSING
    Digest::MD5                Installed
    Digest::SHA                Installed
    Digest::SHA1                MISSING
    Digest::SHA256              MISSING
    Digest::SHA::PurePerl       MISSING
    Digest::Whirlpool           MISSING
    LWP                         MISSING
    URI                         MISSING
    HTTP::Status                MISSING
    HTTP::Date                  MISSING
    Socket                     Installed
    Carp                       Installed
```

On va installer les paquets Perl `Crypt::RIPEMD160`, `Digest::SHA1`, `Digest::SHA256`, `Digest::SHA::PurePerl`, `Digest::Whirlpool`, `LWP`, `URI`, `HTTP::Status` et `HTTP::Date` via `dh-make-perl`.

```bash
su
apt install dh-make-perl -y
```

Cette étape d'installation a déjà installé quelques-un de ces paquets, à savoir `LWP`, `URI`, `HTTP::Status` et `HTTP::Date`.
On va choisir de laisser CPAN en auto-configuré.

```bash
dh-make-perl -install -cpan Crypt::RIPEMD160
dh-make-perl -install -cpan Digest::SHA1
dh-make-perl -install -cpan Digest::SHA256
dh-make-perl -install -cpan Digest::SHA::PurePerl
```

Dans le cas de `Digest::Whirlpool`, nous aurions aussi besoin d'installer `inc::Module::Install`. Cette surprise est due à la pratique hors d'un gestionnaire de paquet qui résout automatiquement les dépendances.

Il faut dans son cas utiliser `cpan Digest::Whirlpool` pour forcer l'installation.

Au final, on vérifie qu'on a bien installé l'ensemble des dépendances Perl nécessaires au scan.

```bash
rkhunter --list

...
Perl module installation status:
    perl command               Installed
    File::stat                 Installed
    Getopt::Long               Installed
    Crypt::RIPEMD160           Installed
    Digest::MD5                Installed
    Digest::SHA                Installed
    Digest::SHA1               Installed
    Digest::SHA256             Installed
    Digest::SHA::PurePerl      Installed
    Digest::Whirlpool          Installed
    LWP                        Installed
    URI                        Installed
    HTTP::Status               Installed
    HTTP::Date                 Installed
    Socket                     Installed
    Carp                       Installed
```

## Export du rapport de scan

Pour simplifier le traitement du scan rkhunter, on va pouvoir utiliser `ansi2html`. Pour cela, on peut lancer ce qui suit.

```bash
su
apt install ansi2html -y
rkhunter --checkall --sk | ansi2html -l > report-rkhunter-root.html
```

Un exemple de scan est disponible [ici](../rkhunter/report-root.html).

## Gestion des warnings

RKHunter peut remonter par mal de faux-positif, il est donc important de vérifier manuellement ces Warnings.

Supposons qu'il y a une remontée sur :
 - `/usr/bin/GET`
 - `/usr/bin/lwp-request`
 - `Checking if SSH root access is allowed`

Dans le cas du premier, c'est en fait un lien symbolique vers le second. Le second nous est expliqué sur [StackExchange](https://unix.stackexchange.com/questions/373718/rkhunter-gives-me-a-warning-for-usr-bin-lwp-request-what-should-i-do-debi).
Nous allons donc régler la variable `PKGMGR` sur `DPKG` dans le fichier `/etc/rkhunter.conf`. Il faut ensuite exécuter `rkhunter --propupd`.
Une fois cela exécuté, on va relancer le scan et observer que les deux premières remontées ont disparues dans [ce rapport de scan](../rkhunter/report-root-handled.html).

La dernière remontée sera traitée lors de la sécurisation OpenSSH.

Le cas où un rootkit est détecté n'est pas abordé car nécessiterait, sur un SI réel, la création d'une cellule de crise pour confirmer puis traiter l'incident dans le cas où celui-ci serait avéré (notamment via ses IOC).
Dans notre cas d'une VM labo, cela ne devrait pas se produire.
