# Mise en place d'un mot de passe BIOS

Cette pratique correspond à l'indicateur Lynis `BOOT-5122`.
Pour réaliser cela, on va mettre un mot de passe au GRUB pour éviter qu'un utilisateur non authentifié puisse choisir sur quel système lancer la machine.
Cela vient déjà s'ajouter au chiffrement du disque et la politique de compte avec mot de passe de Debian, et constitue donc de la défense en profondeur.

Toujours en accord avec cette politique de mot de passe et de défense en profondeur, on va choisir un nouveau mot de passe, comme par exemple `@h que coukou B0b!`.

```bash
su
grub-mkpasswd-pbkdf2
```

On conserve alors le hackage PBKDF2 du mot de passe et on l'ajoute au fichier `/etc/grub.d/40_custom` comme suit.
```
set superusers="root"
password_pbkdf2 root grub.pbkdf2.sha512.10000.2C8AB343EA95AD879779E86D2C63363C57078916F53E14D887E558EC2F6F6E0E7175FC97C71D952287D39FACD44D7135E409BC00DCFEDCA6363B89933740EDD1.9F79BDB53F0A04230E615AAFD759B1203AC976FCC576523DB632FC55AF3C7658238C570B21EA39AA74F7EDF0D8E8F2959CA113343588DA2B846A63CAC8A52870
```

```bash
export PATH="$PATH:/usr/sbin"
update-grub
exit
```

Attention, cette manipulation est très risqué et peut amener à une impossibilité d'exploiter la machine par la suite ! Il faut absoluement être sûr que le hash de la clé a bien été entré.
