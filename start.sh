#!/bin/sh

proxy_start()
{
    # squid &
    echo "$(date +"%Y-%m-%d %T")" Start Proxy
    privoxy --no-daemon /etc/privoxy/config &
}

vpn_start()
{
    echo "$(date +"%Y-%m-%d %T")" Connect VPN
	fingerprint=$(openssl s_client -connect dt.interway.fr:443 2> /dev/null | openssl x509 -noout -fingerprint | cut -d'=' -f 2)
	cp /config/nxbender /etc/nxbender
	echo "fingerprint=$fingerprint" >> /etc/nxbender
	nxBender &
}

route_start()
{
    echo "$(date +"%Y-%m-%d %T")" Add additional Route
	# sleep 10
	input_file=/config/route.txt
	tail "$input_file" | while read ip ;
	do
		route="ip route add $ip dev ppp0"
		$route
	done
	ip route ;
    # /usr/sbin/add-route.sh &
    sleep 1
}

route_is_present()
{
	FILE=/config/route.txt
	if [ ! -f "$FILE" ]; then
		echo ""
		echo "le fichier des routes additionnel n'est pas présent!"
		echo " - ce fichier est facultatif"
		echo ""
		echo "le fichier des routes (route.txt) doit contenir les IP des routes suplémentaires."
		echo "le fichier est composé d'une IP par ligne."
		echo "exemple:"
		echo "192.168.0.0\24"
		echo "172.16.16.200"
		echo ""
		touch /config/route.txt
	fi
}

config_is_present()
{
	FILE=/config/nxbender
	if [ ! -f "$FILE" ]; then
		echo ""
		echo "le fichier de configuration n'est pas présent!"
		echo ""
		echo "contenu du fichier de configuration (nxbender):"
		echo "server = vpn.exemple"
		echo "username = vpnlogin"
		echo "password = vpnpadd"
		echo "domain = vpndomain"
		echo ""
		exit 0
	fi
}

main()
{
	config_is_present
	route_is_present
    proxy_start
	# route_start
    while true; do 
        error=0
        error=$(ps | grep -c ' [p]ppd')
        if [ 0 == $error ]; then 
            vpn_start 
            sleep 10
			route_start
            error=0; 
        fi;

        netstat -an | grep 8118 > /dev/null; 
        if [ 0 != $? ]; then 
            proxy_start 
            sleep 10
        fi;
        sleep 5
    done
}

route=0
main

