# Lynis

On va tester l'état du système via [Lynis](https://cisofy.com/documentation/lynis/get-started/).

## Installation via le gestionnaire de paquet apt

Sachant que `lynis` va s'installer dans `/usr/sbin` on va l'ajouter à la variable d'environnement `PATH` responsable de la liste des binaires auxquels on a accès.
Cette simple solution ne va pas perdurer puisque à la fermeture de la session `PATH` va être réinitialisée.
Étant donné que nous n'avons pas la nécessité de faire persister l'accès à Lynis nous ne procéderons pas à la mise en place d'une stratégie pour l'ajouter au `PATH`.

Afin de lire plus facilement nos rapports Lynix, on va utiliser `ansi2html`. Celui-ci n'étant pas disponible comme paquet, on utiliser `colorized-logs` comme décrit par [command-not-found.com](https://command-not-found.com/ansi2html).

```bash
su
apt update && apt install lynis colorized-logs -y
exit
export PATH="$PATH:/usr/sbin"
lynis audit system > report.txt
su
lynis audit system > report-root.txt
exit
```

On va désormais pouvoir parcourir les rapports avec `nano` ou `vi`. Si on souhaite les parcourir en CLI lorsqu'on lance la commande, on va pouvoir utiliser `lynis audit system | less -R`.

Étant donné qu'on a installé le système en CLI, on va chercher à extraire nos fichiers HTML. Pour cela, on pourrait utiliser un tunnel SSH, mais on va préférer utiliser un système externe pour le fun, comme l'extraire via beeceptor.com.

```bash
su
apt install curl -y
exit
lynis audit system | ansi2html -l > report.html
curl -F "image=@/home/tartiflette/report.html" https://apt56.free.beeceptor.com
```

Nous obtenons à l'issu de cette étape les fichiers [report.html](../lynis/report.html) et [report-root.html](../lynis/report-root.html).

On remarque que dans le cas d'un audit non-root, le `Hardening index` est à **58** alors que dans le cas contraire on se retrouve à **62**.

## Installation depuis le repository Github

Étant donné que la version publiée auprès du gestionnaire de paquet n'est pas la dernière (c'est rarement le cas sur un projet de niche), on va directement utiliser celle disponible sur la branche `master` (branche par défaut) du repository Github.

```bash
su
rm /usr/sbin/lynis
cd /usr/local
apt install git -y
git clone https://github.com/CISOfy/lynis.git
ln -s /usr/local/lynis/lynis /usr/sbin/lynis
exit
```
