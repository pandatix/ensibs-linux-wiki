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
