# Groupe dédié à sudo

`sudo` est un utilitaire installé lorsqu’il y a un besoin de déléguer des droits et privilèges à différents utilisateurs.
Afin de pouvoir réaliser cela, sudo est un exécutable setuid root. Il est donc important de se préoccuper de sa sécurité.

On peut créer un groupe dédié à l’usage de sudo doit être créé (`/usr/bin/sudo`). Seuls les utilisateurs membres de ce groupe pourront avoir le droit d’exécuter `sudo`.

/!\ Inconvénient : cette modification peut être écrasée par les scripts d'installation lors des mises à jour.
