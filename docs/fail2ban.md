# Fail2ban

## Installation

```bash
su
apt install fail2ban -y
exit
```

## Configuration hors jail.conf

```bash
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
nano /etc/fail2ban/jail.local
```

On va ensuite configurer la section `[DEFAULT]`.

| Variable   | Valeur            | Justification |
|------------|-------------------|---------------|
| `ignoreip` | `127.0.0.1/8 ::1` | permet de tenter autant de connexion possible depuis localhost |
| `bantime`  | `10m`             | bannit une IP pour 10 minutes |
| `maxretry` | `5`               | bannit une IP au bout de 5 tentatives infructueuses |
| `findtime` | `10m`             | fenêtre sur laquelle le compteur `maxretry` est pris en considération pour le ban |

## Relancer le service

```bash
su
systemctl restart $(systemctl list-units | grep fail2ban | awk '{print $1}')
exit
```