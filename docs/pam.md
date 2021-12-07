# Fonctionnalités de PAM

`PAM` va fournir le service de gestion de comptes, c’est-à-dire permettre l’authentification de l’utilisateur, la création de sa session et éventuellement toute opération qui doit se dérouler lors de la tentative d’accès : création d’environnement, récupération de tickets ou de données, droits d’accès, changement de mot de passe, etc.
Les fichiers de configuration des modules PAM se situent dans /etc/pam.d/

- Il faut limiter le nombre d'applications utilisant PAM, pour savoir si une application a été écrite pour utiliser PAM on utilise la commande `ldd`. 
Exemple : 

```bash
su
ldd /etc/sbin/sshd
```

Le résultat contient bien `libpam.so`.

- Authentication par un serice distant : on s'assure de que le protocole d'authentification utilisé par PAM soit sécurisé, on pourra par exemple implémenter le module `pam_krb5` pour utiliser le protocole Kerberos (https://www.eyrie.org/~eagle/software/pam-krb5/)

- Exemples de modifications possibles avec les modules : bloquage de l'accès root à certains groupes/utilisateurs (`/etc/pam.d/sudo`), réglage de la complexité des mots de passe (`/etc/pam.d/passwd`)...

- Il faut appliquer une solution de hashage de mdp jugée sûre : `/etc/pam.d/common-password` et `/etc/login.defs`
