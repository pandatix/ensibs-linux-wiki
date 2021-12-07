# Systemd-analyze security

La commande `systemd-analyze security` permet d'avoir un aperçu de l'état de la sécurité des services systemd qui sont donc sandboxés.
En l'exécutant, on va obtenir un [tableau des services et de leur exposition](systemd-analyze-security/report.html).

À noter que le tableau en question a été obtenu via la commande `SYSTEMD_COLORS=1 systemd-analyze security | ansi2html -l`.

## Analyse d'un service en particulier

On va par exemple analyser la raison pour laquelle le service `user@1000.service` à une exposition de `9.4` et est classé comme `UNSAFE`.
Pour cela, on va exécuter la commande suivante.

```bash
SYSTEMD_COLORS=1 systemd-analyze security user@1000.service --no-pager | ansi2html -l
```

On obtient une liste détaillé de tout ce qui "pose problème" pour le service.
Il convient alors de les corriger dans le cas où cela est possible. Dans le cas contraire, il faut a minima tenter de réduire le score.
