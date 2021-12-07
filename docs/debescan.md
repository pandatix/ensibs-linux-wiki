# Debescan

Avant de lancer la procédure de sécurisation de la VM et la mise à jour, on va en amont tester les CVE affectant notre système Debian pour savoir d'où nous partons. Pour cela, nous allons exécuter un scan via `debsecan`.

## Installation

```bash
su
apt update && apt install debsecan -y
exit
```

## Utilisation

```bash
debsecan --suite $(lsb_release --codename --short) --only-fixed --format detail
```

Il est rappelé que `--format packages` permet même de récupérer la liste des paquets à mettre à jour via apt ; `--only-fixed` va nous permettre de récupérer la liste des CVEs qui ont un correctif proposé, que l'on va donc pouvoir appliquer.

La commande ne nous retourne rien, ce qui signifie qu'il n'existe pas de tels paquets sur le système.
Cela ne semble pas étrange puisqu'on vient tout juste d'installer le système et qu'un tel paquet correctif serait déjà implémenté dans l'ensemble de base de Debian. Toutefois cette commande peut-être intéressante à exécuter régulièrement pour voir si une mise à jour de sécurité ne s'imposerait pas.

Par curiosité, on peut quand même exécuter sans le flag `--only-fixed` et on se rendra compte qu'il existe un grand nombre de CVE affectant notre système pourtant fraichement installé. On peut toutefois remarquer que certains ont des correctifs à proposer, mais toujours dans une phase instable, qui n'est donc pas jugée sûr par défaut sous Debian.
