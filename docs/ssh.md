# Sécurisation de SSH

Une question intéressante avant de débuter la sécurisation du service SSH est qu'entre le premier scan et les suivants (même pour des VM neuves), les relevés pour SSH ont intégralement disparus.
Nous allons donc nous baser sur la sortie sauvegardée pour effectuer les modifications en bonne et due forme.
Nous ne pourrons toutefois tester la bonne application de cela.

La configuration du service SSH se fait en plusieurs parties : `ssh` et `sshd`.

## Configuration de /etc/ssh/ssh_config

On commence par configurer le fichier `/etc/ssh/ssh_config`.
La liste des paramètres étant déjà présente le plus souvent sous forme de commentaire, on va pouvoir procéder à une checklist des paramètres à régler.

| Variable                | Valeur                                  | Justification |
|-------------------------|-----------------------------------------|---|
| `StrictHostKeyChecking` | `ask`                                   | assure qu'on valide une connection si l'identité ne semble pas être la bonne |
| `Ciphers`               | `aes256-ctr,aes192-ctr,aes256-ctr`      | on retire `aes128-cbc` et `3des-cbc` de la liste des primitives cryptographiques utilisables car ne sont plus réputées suffisament sûres |
| `MACs`                  | `hmac-sha2-512,hmac-sha2-256,hmac-sha1` | on remplace les primitives de hash par d'autres réputées plus sûres |
| `SendEnv`               | `LANG LC_*`                             | déjà réglé par défaut |
| `HashKnownHosts`        | `yes`                                   | déjà réglé par défaut |
| `GSSAPIAuthentication`  | `yes`                                   | déjà réglé par défaut |

Ces configurations ne sont pas directement recommandées par Lynis, mais sont des bonnes pratiques dans le cadre d'une installation et configuration de SSH.

## Configuration de /etc/sshd/sshd_config

On continue par configurer le fichier `/etc/sshd/sshd_config`.

| Variable               | Valeur | Justification |
|------------------------|---|---|
| `AllowTcpForwarding`   | `no` | évite les rebonds sur d'autres serveur |
| `ClientAliveInterval`  | `300` | bien que n'étant pas pointé par Lynis, cela va permettre de configurer l'interval entre deux message de vérification de l'état |
| `ClientAliveCountMax`  | `3` | clos la connection dans le cas où le client ne répond pas au bout de 3 requêtes de vérification de l'état |
| `Compression`          | `yes` | active le support de la compression pour les connections SSH |
| `LogLevel`             | `VERBOSE` | règle le niveau de logs en mode verbeux, permettant au besoin d'analyser correctement les interactions faites via SSH |
| `MaxAuthTries`         | `3` | on interrompt les tentatives de connexion au bout de 3 tentatives infructueuses |
| `MaxSessions`          | `1` | règle le nombre de connections SSH parallèles pour un même compte à une unique session |
| `Port`                 | `222` | change le port d'écoute pour troubler les cartographies réseaux et troubler de potentielles attaques |
| `TCPKeepAlive`         | `no` | désactive l'envoie de paquets TCP ACK qui peut être fréquemment filtré par les pare-feu |
| `X11Forwarding`        | `no` | évite les rebonds sur d'autres serveurs |
| `AllowAgentForwarding` | `yes` | permet d'utiliser un forward d'agent, permettant de ne pas envoyer ses clés privées au travers du réseau |


#### Paramètres de sécurité

##### L'utilisation X11Forwarding

Le retour SSH sur le client peut être davantage exposé à une attaque lorsque le trafic X11 est transféré. Si la redirection du trafic X11 n'est pas nécessaire, désactivez-la :

> X11Forwarding no

Pourquoi désactiver X11Forwarding est si important : le protocole X11 n'a jamais été conçu dans un souci de sécurité. Comme il ouvre un canal de retour vers le client, le serveur pourrait renvoyer des commandes malveillantes au client. Pour protéger les clients, désactivez X11Forwarding lorsqu'il n'est pas nécessaire.

##### Désactiver rhosts

Bien qu'elle ne soit plus courante, la méthode rhosts était une méthode faible d'authentification des systèmes. Elle définit un moyen de faire confiance à un autre système simplement par son adresse IP. Par défaut, l'utilisation de rhosts est déjà désactivée. Assurez-vous de vérifier si elle l'est vraiment.

> IgnoreRhosts yes

#####  Vérification du nom d'hôte DNS

Par défaut, le serveur SSH peut vérifier si le client qui se connecte renvoie à la même combinaison de nom d'hôte et d'adresse IP. Utilisez l'option UseDNS pour effectuer cette vérification de base comme garantie supplémentaire.

> UseDNS yes

Remarque : cette option peut ne pas fonctionner correctement dans toutes les situations. Elle peut entraîner un délai supplémentaire, car le démon attend un délai d'attente lors de la connexion au serveur DNS. N'utilisez cette option que si vous êtes sûr que votre DNS interne est correctement configuré.

##### Désactiver les mots de passe vides

Les comptes doivent être protégés et les utilisateurs doivent être responsables. Pour cette raison, l'utilisation de mots de passe vides ne doit pas être autorisée. Ceci peut être désactivé avec l'option PermitEmptyPasswords, qui est la valeur par défaut.

> PermitEmptyPasswords no


##### Tentatives d'authentification maximales

Pour se protéger contre les attaques par force brute sur le mot de passe d'un utilisateur, limitez le nombre de tentatives. Cela peut être fait avec le paramètre MaxAuthTries.

> MaxAuthTries 3

##### Déscativer l'authentication root

La meilleure pratique consiste à ne pas se connecter en tant qu'utilisateur root. Utilisez plutôt un compte utilisateur normal pour initier votre connexion, ainsi que sudo. Les connexions directes de l'utilisateur root peuvent entraîner une mauvaise comptabilisation des actions effectuées par ce compte utilisateur.

> PermitRootLogin no

Les versions plus récentes d'OpenSSH supportent également la valeur `without-password`. Cette valeur fait référence à des méthodes telles que l'authentification par clé publique. Si votre installation est fournie avec cette valeur, il n'y a aucune raison de la modifier.


##### SSH protocole

Si vous utilisez un système plus ancien, la version 1 du protocole SSH est peut-être encore disponible. Cette version présente des faiblesses et ne devrait plus être utilisée. Depuis la version 7.0 d'OpenSSH, le protocole 1 est automatiquement désactivé lors de la compilation. Si votre version est plus ancienne que cela, appliquez la version du protocole :

> Protocol 2

##### Utilisation de AllowUsers et DenyUsers

Lorsque tous les utilisateurs ne doivent pas avoir accès au système, limitez le nombre de personnes qui peuvent effectivement se connecter. Une façon de procéder consiste à créer un groupe (par exemple, sshusers) et à ajouter des personnes à ce groupe. Ensuite, définissez l'option AllowGroups pour que seuls ces utilisateurs puissent se connecter.

D'autres possibilités consistent à n'autoriser que quelques utilisateurs avec l'option AllowUsers, ou à refuser spécifiquement des utilisateurs et des groupes avec les options DenyUsers ou DenyGroups. Il est généralement préférable d'établir une liste blanche des accès, en utilisant le principe du "refus par défaut". Donc, lorsque cela est possible, utilisez l'option AllowUsers ou AllowGroups.

Bon à savoir : SSH applique l'ordre suivant pour déterminer si une personne peut se connecter : DenyUsers, AllowUsers, DenyGroups, enfin AllowGroups.
