# sonicwall-privoxy

Creation du docker:
```
docker volume create config
docker build -t sonicwall-privoxy .
rem docker scan sonicwall-privoxy
docker run --restart always --detach --privileged -p 8118:8118 --name sonicwall-privoxy -v config:/config sonicwall-privoxy
```
Suppression du docker:
```
docker stop sonicwall-privoxy
docker rm sonicwall-privoxy
docker rmi sonicwall-privoxy
docker volume rm config
```

Fichier de configuration:
/config/nxbender
```
server = <Controleur VPN>
username = <login VPN>
password = <pass VPN>
domain = <domain VPN>
```

/config/route.txt (falcultatif)
```
10.10.110.132
192.168.5.0/24
```
Usage:
peut etre utilisé avec un produit tel que Proxifier (le meilleur) ou equivalent, pour pouvoir utilisé la connection VPN.

testé sous :
- docker Linux Debian amd64 et arm64 (Freebox le top des FAI Français)
- docker Windows WLS2 natif et debian amd64 
