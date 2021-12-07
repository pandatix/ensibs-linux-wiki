# RNGD

rngd est un service permettant de générer des aléatoires en se basant sur des composantes logicelles et physiques.
Dans le cas d'une VM, le critère qualité de cette génération ne peut être assurée que par une nouvelle cryptanalyse.

## Installation

On commence par installer le paquet `rng-tools`.

```bash
su
apt install rng-tools -y
```

## Redirection vers /dev/random dans le cadre d'une VM

On va alors afficher l'état du service créé pour cela, qu'on aura trouvé via la commande `systemctl list-units --no-page | grep rng-tools | awk '{print $1}'`.

```bash
systemctl status rng-tools-debian.service
```

On peut alors observer que dans le cadre d'une VM, il ne trouve pas de module physique pour la génération d'un aléatoire.
Pour cela, on va rediriger la génération sur `/dev/random` **bien que cela ne soit pas une bonne pratique**. Cette manipulation n'est là que pour montrer cette possibilité.

On vient ainsi régler la variable `HRNGDEVICE` sur `/dev/random` dans le fichier `/etc/default/rng-tools-debian`.
Il faut alors relancer le service via la commande suivante.

```bash
systemctl restart rng-tools-debian.service
```

## Test du random

Grâce au paquet que nous avons installé, on va pouvoir tester la qualité de l'aléa généré par `/dev/random`.
On va exécuter la commande suivante.

```bash
cat /dev/random | rngtest -c 1000
```

S'il y a un haut taux d'erreurs, cela signifie qu'il ne faut surtout pas utiliser cette source comme générateur d'aléa.
