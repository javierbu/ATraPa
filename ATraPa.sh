#!/bin/bash
 
# ATraPa by Javierbu javierbu@gmail.com mayo/2015
# y su ayudante Ivanuco

function Nombre2_Opcion3()	{
clear
banner
echo " Introduce el nombre del .cap de la segunda captura. Debe estar en la carpeta \"capturas\""
echo 
echo " y con extension .cap o .pcap"
echo
echo " O pulsa 99 para volver"
echo
echo -n " Opcion : "
read FILENAME2

        if [ $FILENAME2 = 99 ] ;then

                Comienzo
        else
                
                echo

        fi

        if [ -f capturas/${FILENAME2}.cap ] 2>/dev/null  ;then
 
                echo
 
        else
 
                clear
		banner
                echo " No se encuentra el archivo ${FILENAME2}.cap .Revise la carpeta \"capturas\".Pulse enter para volver a intentarlo"
                read
                Nombre2_Opcion3
        fi
 
        clear
        echo
                if [ -d datos ] ;then
 
                        echo
               
                else
                        mkdir datos    
               
               
                fi
       
        rm datos/${FILENAME}* datos/${FILENAME2}* 2>/dev/null

		}

function Trafico()	{

	recibidos=`tcpdump -v -n -r  capturas/${FILENAME2}.cap  | grep $IP | grep ${IP}'.*''>' | grep -o length'...*' | awk '{print $2}' | awk '{ sum+=$1 } END {print sum}'`
	enviados=`tcpdump -v -n -r  capturas/${FILENAME2}.cap  | grep $IP | grep '> '${IP} | grep -o length'...*' | awk '{print $2}' | awk '{ sum+=$1 } END {print sum}'`
	
	if [[ $recibidos = *[1-9]* ]] ;then

		echo
	else
	
		recibidos=0
	
	fi

	if [[ $enviados = *[1-9]* ]] ;then

		echo
		
	else
		
		enviados=0

	fi
	clear
	banner
	
	if [ -z $enviados ] ;then

		clear
		banner
			
			if [ -z $recibidos ] 2>/dev/null ;then
		
				echo " No se ha podido registrar ningun dato enviado ni recibido con $IP implicada"
				echo
				echo " Esto puede ser debido a que sea trafico interno de tu propia red"
				echo
				echo " Podemos imprimir en pantalla todas las conexiones generadas con $IP implicada"
				echo
				echo " Es posible que te saque de dudas, o te genere alguna mas"
				echo
				echo -n " Pulsa 1 para ver las conexiones , o enter para volver: "
				read respuesta
			
				if [ $respuesta = 1 ] ;then
		
					clear
					banner
					tcpdump -v -n -r  capturas/${FILENAME2}.cap  | grep $IP
					echo
					echo "Pulsa enter para volver"
					read
					Investigar_IP
			
				elif [ $respuesta = "" ] ;then

					Investigar_IP
				else
			
				echo 
				Investigar_IP
		
				fi

			else
		
				clear
				banner
				Ekilo=$(($enviados / 10**3)) 2>/dev/null
				Emega=$(($enviados / 10**6)) 2>/dev/null
				echo " Trafico desde $IP      $dominio"
				echo
        			echo
        			echo " No se ha encontrado trafico recibido"
        			echo
        			echo " Enviado"
        			echo
        			echo " Bytes        "$enviados" Bytes"
        			echo " Kilobytes    "$Ekilo" Kl"
        			echo " Megabytes    "$Emega" Mb"
	
			fi

	elif [ -z $recibidos ] ;then

		clear
		banner
			
			if [ -z $enviados ] 2>/dev/null ;then
		
				echo " No se ha podido registrar ningun dato enviado ni recibido con $IP implicada"
				echo
				echo " Esto puede ser debido a que sea trafico interno de tu propia red"
				echo
				echo " Podemos imprimir en pantalla todas las conexiones generadas con $IP implicada"
				echo
				echo " Es posible que te saque de dudas, o te genere alguna mas"
				echo
				echo -n " Pulsa 1 para ver las conexiones , o enter para volver: "
				read respuesta
			
				if [ $respuesta = 1 ] ;then
		
					clear
					banner
					tcpdump -v -n -r  capturas/${FILENAME2}.cap  | grep $IP
					echo
					echo " Pulsa enter para volver"
					read
					Investigar_IP
			
				elif [ $respuesta = "" ] ;then

					Investigar_IP
				else
			
				echo 
				Investigar_IP
		
				fi

			else
		
				clear
				banner
				Ekilo=$(($enviados / 10**3)) 2>/dev/null
				Emega=$(($enviados / 10**6)) 2>/dev/null
				echo " Trafico desde $IP      $dominio"
				echo
        			echo
        			echo " No se ha encontrado trafico enviado desde $IP"
        			echo
        			echo " Recibido"
        			echo
        			echo " Bytes        "$recibido" Bytes"
        			echo " Kilobytes    "$Rkilo" Kl"
        			echo " Megabytes    "$Rmega" Mb"
	

	
			fi
	fi

	nslookup $IP > datos/${IP}nslookup.dat
	sleep 3
	dominio=`cat datos/${IP}nslookup.dat | grep name | awk '{print $4}'`
	Rkilo=$(($recibidos / 10**3)) 2>/dev/null
	Rmega=$(($recibidos / 10**6)) 2>/dev/null
	Ekilo=$(($enviados / 10**3)) 2>/dev/null
	Emega=$(($enviados / 10**6)) 2>/dev/null
	echo " Trafico desde $IP      $dominio"
	echo
	echo
	echo " Recibido"
	echo 
	echo " Bytes        "$recibidos" Bytes"
	echo " Kilobytes    "$Rkilo" Kb       "
	echo " Megabytes    "$Rmega" Mb       "
	echo
	echo
	echo " Enviado"
	echo
	echo " Bytes        "$enviados" Bytes"
        echo " Kilobytes    "$Ekilo" Kl"
        echo " Megabytes    "$Emega" Mb"

	echo 
	echo
	echo -n " Pulsa enter para volver"
	read
	Investigar_IP
			
			}

function banner() {			
			echo
			echo -e "        _  _____      _    ___        "
                        echo -e "       / \|_   _| __ / \  |  _ \ __ _ "
			echo -e "      / _ \ | || '__/ _ \ | |_) / _' |"
                        echo -e "     / ___ \| || | / ___ \|  __/ (_| |"
                        echo -e "    /_/   \_\_||_|/_/   \_\_|   \__,_|-0.8-Beta"
                        echo
                        echo

		}

function Puertos()      {

        #       Puerto=`tcpdump -r capturas/$FILENAME2.cap -nn | grep $IP | awk '{print $3}' | grep $IP | cut -d "." -f 5 | sed '/^$/d' | uniq`
		Puerto=`tcpdump -r capturas/$FILENAME2.cap -nn  | grep -o $IP'......' | awk '{print $1}' | sed -e 's/://g' |  cut -d '.' -f 5 | sort | uniq`
	#	Puerto=`tcpdump -r capturas/$FILENAME2.cap -nn |grep -v A | grep -o $IP'......' | awk '{print $1}' | sed -e 's/://g' | cut -d '.' -f 5 | sed '/^$/d' | uniq`
        #       Protocolo=`tcpdump -r capturas/$FILENAME2.cap  | grep -o $IP'......' | awk '{print $1}' | sed -e 's/://g' | cut -d '.' -f 5 | sed '/^$/d' | uniq`
		clear
		banner
		if [ `echo ${#Puerto}` -ge 20 ] 2>/dev/null ;then

                        echo " Vaya!. Ha ocurrido un error en la resulucion del puerto"
			echo
			echo " Esto puede ser debido a que sea tu propia IP o este dentro del mismo segmento"
			echo
			echo " Podemos imprimir todas las conexiones generadas con $IP"
			echo
			echo " Es posible que esto te resuelva la duda, o te genere alguna mas"
			echo 
			echo -n " Pulsa 1 para imprimir las conexiones o enter para volver: "
			read respuesta
			
				if [ $respuesta = 1 ] ;then

                                        clear
                                        banner
                                        tcpdump -v -n -r  capturas/${FILENAME2}.cap  | grep $IP
                                        echo
                                        echo "Pulsa enter para volver"
                                        read
                                        Investigar_IP

                                elif [ $respuesta = "" ] ;then

                                        Investigar_IP
                                else

                                echo 
                                Investigar_IP

                                fi

			echo
			echo
			tcpdump -r capturas/${FILENAME2}.cap -nn | grep -o $IP
			echo
			echo
			echo " Espero que te haya sacado de dudas"
			echo
			echo -n  " Pulsa enter para volver"
			read
			Investigar_IP

		else
			 echo $Puerto > /tmp/puerto
               		 echo "IP        $IP"
               		 echo 
                	 echo -n  "Puerto/s  "
			 cat /tmp/puerto | xargs -n 5
			 rm /tmp/puerto
                	 echo

		fi

		if [ -z $Puerto ] 2>/dev/null ;then 
		
			clear
			banner
			echo " Mmmmm... no se ha detectado ningun puerto. "
			echo
			echo " Puede ser debido que sea trafico interno de tu red."
			echo
			echo " Pulsa enter para imprimir una conexion."
			echo
			echo -n " Es posible que esto te saque de dudas, o te genere unas cuantas mas."
                	read
			tcpdump -r capturas/${FILENAME2}.cap -nn | grep -o $IP | tail -1 
			clear
			banner
			echo " Espero que estos datos te ayuden a saber que tipo de trafico es"
			echo -n " Pulsa enter para volver"
			read
			Investigar_IP

		else

		echo -n " Pulsa enter para volver"
                read
                Investigar_IP

		fi

        }


function Proceso()  {

        clear
	banner
        Proceso=`cat datos/netstat.dat | grep $IP -A 2 | grep "\[" | sed '/^$/d' | uniq`
        PID=`cat datos/netstat.dat | grep $IP | awk '{print $5}' | sed '/^$/d' | uniq`
        echo
        echo " IP        $IP"
	echo " Proceso  $Proceso"
	echo " PID       $PID"
        echo
        echo -n "Pulsa enter para volver"
        read
        Investigar_IP

                        }


function Opcion333()    {  

		
                        echo
                        echo " Dime la IP o parte de ella a filtrar."
			echo 
			echo " Ten en cuenta que se filtrara por IP, no por numero de IP"
			echo
			echo -n " Se filtraran todas las IPs que contengan: "
                        read ipafiltrar
	
				if [ "$ipafiltrar" = "" ] > /dev/null ;then

					echo " Tienes que introducir una IP o parte de ella. Prueba de nuevo"
					Opcion333

				else
		
                		        grep $ipafiltrar datos/Unicas.dat > /dev/null
			
		
                       				 if [ $? -ne 0 ] ;then

                               				 echo " $ipafiltrar no es un valor valido. Prueba de nuevo"
                               				 Opcion333
		

			                        else                      

                        				cat datos/Unicas.dat | grep -v "$ipafiltrar" > datos/Unicas2.dat
							mv datos/Unicas2.dat datos/Unicas.dat
                        				sleep 1
                        				echo
                        				Seleccionar_IP

                        			fi

				fi
                
                        }

 
function Opcion2()      {
 
        clear
	banner
        echo
        echo -n " Por favor, introduce el nombre del .cap que quieres analizar. Debe estar en la carpeta \"capturas\": "
        read FILENAME2  
               
                if  [ -f capturas/${FILENAME2}.pcap ] 2> /dev/null ; then
                        
			 cp capturas/${FILENAME2}.pcap  capturas/${FILENAME2}.cap
 
                elif [ -f capturas/${FILENAME2}.cap ] 2>/dev/null  ;then
 
                        echo
 
                else
 			
			clear
			banner
                        echo " No se encuentra el archivo ${FILENAME2}.cap. Revise la carpeta \"capturas\".Pulse enter para volver a intentarlo"
                        read
                        Opcion2
                fi
 
        Sacar_IPs1
        Seleccionar_IP
        Investigar_IP
}
 
 
 
function Sacar_IPs1()    {       ## procesamos la captura para sacar las ips implicadas en todo el trafico
                       
                if [ -d datos ] ;then
 
                        echo
 
                else
                        mkdir datos    
 
 
                fi
        clear
        banner
        echo " Extrayendo IPs destino y origen de $FILENAME2."
        sleep 1
	clear
	banner
	echo " Extrayendo IPs destino y origen de $FILENAME2.."
	sleep 1
	clear
	banner
        echo " Extrayendo IPs destino y origen de $FILENAME2..."
	sleep 1
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsOrigen.dat
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsDestino.dat
        cat datos/${FILENAME2}IPsDestino.dat datos/${FILENAME2}IPsOrigen.dat > datos/${FILENAME2}IPsSegundaCaptura.dat
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c > datos/${FILENAME2}IPsCon2Captura.dat
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/Unicas.dat
        Seleccionar_IP
        Investigar_IP
 
}
 
 
 
function Nombre_Captura_Unica()  {            #asignamos un nombre a la segunda captura comprobando que no exista un archivo con el mismo nombre
 
	  clear
	  banner
          echo
          echo  " Por favor, escribe el nombre de tu captura. Se guardara en la carpeta \"capturas\" dentro de este mismo directorio: "
	  echo 
          echo " O pulsa 99 para volver a empezar. "
          echo
          echo -n " Opcion: "
          read FILENAME2 

                if [ $FILENAME2 = 99 ] ;then

                        Comienzo

		elif [ -z $FILENAME2 ] ;then

			clear
			banner
			echo " Debes introducir un nombre para tu captura. Pulsa enter para volver a intentarlo"
			read
			Nombre_Captura_Unica

                else

                        echo -n

		fi
 
                  if [ -d capturas ] ;then
 
                          echo
 
                  else    
 
                          mkdir capturas
 
                  fi    
 
 
                  if [ -f capturas/${FILENAME2}.cap ] ;then
		
 			   clear
			   banner
                           echo " Ya existe una captura llamada \"$FILENAME2\". Pulsa enter para volvera intentarlo"
			   read
                           Nombre_Captura_Unica
 
                   else
 
                           echo
                  fi
                                  }
 
 
 
function Opcion1()      {       ## opcion 1 del menu principal. HACER 1 CAPTURA PARA ANALIZARLA
 		
		clear
		banner
                echo
                echo " Vamos a realizar la captura."
                echo
                echo " Una vez realizada, podremos investigar las IPs que hayan causado trafico."
		echo
                echo -n " Pulsa enter para continuar"
                read
                clear
                echo
                Pedir_Tiempo  
                echo
                clear
                Interfaz
                clear
                echo
                Nombre_Captura_Unica
                clear
                echo
                Lanzar_Tcpdump2
                clear
                banner
                echo " Ahora extraeremos de la captura las IPs que hayan causado trafico"
                echo
                echo
                echo " Pulsa enter para continuar" ;read
                echo
                Sacar_IPs1
                Seleccionar_IP
                IP=`uniq datos/Unicas.dat | cat -n | sed -e 's/^ *//g' |  grep ^$Seleccion | awk '{print $2}'`
                Investigar_IP
 
                }
 
clear
 
function Seleccionar_IP()       {

        NumIPs=`uniq datos/Unicas.dat | cat -n | tail -1 | awk '{print $1}'`
        clear
        banner
        echo " Por favor, selecciona una de las siguientes IPs para estudiarla"
        echo
        echo
        echo
        #uniq datos/Unicas.dat | cat -n
	pr -a -n --columns=3 datos/Unicas.dat | sed '/^$/d' | grep -v P
        echo
        echo
        echo
        echo "          333 Si quieres filtrar IPs de la lista"
        echo "          444 Volver a la lista sin filtrar"
        echo "          999 Si quieres ver todas consultas DNS que se han hecho durante la captura"
        echo "          0 Si quieres salir"
        echo
        echo -n " Opcion: "
        read Seleccion
 
        if [[ $Seleccion = *[1-9]* ]] && [[ $NumIPs -ge $Seleccion ]]  ;then
                clear                  
                        echo
                        echo
                        echo
                        echo
 
        IP=`uniq datos/Unicas.dat | cat -n | sed -e 's/^ *//g' |  grep -w ^$Seleccion | awk '{print $2}'`
        Investigar_IP
 
 
        elif [ $Seleccion = 333 ] 2>/dev/null ;then
                
			Opcion333
                       
        elif [ $Seleccion = 444 ] 2>/dev/null ;then
                clear
                        echo
                        if [ -f capturas/${FILENAME2}.cap ] 2>/dev/null  ;then
                                echo
                                Sacar_IPs1
                                fi
 
        elif [ $Seleccion = 999 ] 2>/dev/null ;then
       
                 clear
		 banner
                 tcpdump -r capturas/${FILENAME2}.cap -nn | grep "A?"  > datos/${FILENAME2}PeticionDns.dat
		 clear
		 banner
		 echo " Resolviendo"
		 sleep 1
		 clear
		 banner
		 echo " Resolviendo."
		 sleep 1
		 clear
		 banner
		 echo " Resolviendo.."
		 sleep 1
		 clear
		 banner
		 echo " Resolviendo..."
                 sleep 1
		 clear
		 banner
                 echo "    N. Consultas   Direccion"
                 echo
                 cat datos/${FILENAME2}PeticionDns.dat | awk '{print "           "$8}' | sort | uniq -c | sort
                 echo
                 echo " Pulsa enter para volver"
                 read
                 Seleccionar_IP
       
        elif [ $Seleccion = 0 ] 2>/dev/null ;then
 
		clear
		banner
                echo " Adios!!"
		echo
		echo
                exit
       
        else
                echo -n
                echo " $Seleccion no es una opcion permitida. Pulsa enter para intentarlo otra vez"
		read
                Seleccionar_IP 
                fi
}
 
function Investigar_IP() {
 
clear
        clear
	banner
        echo " La IP seleccionada es $IP"
        echo
        echo
        echo " Elije una de las siguientes opciones"
        echo
        echo   
        echo "          1  Numero de paquetes generados con $IP implicada "
        echo "          2  Resolucion de dominio"
	echo "          3  Resolver proceso y PID. Esta opcion necesita del archivo netstat.dat en la carpeta \"datos\""
	echo "          4  Filtrar esta IP de los resultados"
	echo "          5  Ver el puerto por el que ha generado el trafico $IP"
	echo "          6  Ver cantidad de bytes enviados y recibidos desde y hacia $IP"
	echo
	echo "          99 Volver y elegir otra IP"
        echo "          0  salir"
        echo
        echo " Investiga esta IP en la red:"
        echo
        echo "          Geolocalizacion, whois, nslookup y mas: http://${IP}.ipaddress.com/"
        echo "          Reputacion y mas: https://www.senderbase.org/lookup/?search_string=${IP}"
        echo
        echo -n "Opcion: "
        read Respuesta
 
        if [ $Respuesta = 1 ] ;then
 
                        clear
                                       
                        echo
                        echo "TRAFICO EN EL QUE SE HA VISTO INVOLUCRADA $IP"
                        echo
                        echo "Numero de paquetes transmitidos como origen en la captura:"
                        grep -w $IP datos/${FILENAME2}IPsOrigen.dat | sort | uniq -c | sed -e 's/^ *//g' | awk '{print $1}'
                        echo
                        echo "Numero de paquetes recibidos como destino en la captura:"
                        grep -w $IP datos/${FILENAME2}IPsDestino.dat | sort | uniq -c | sed -e 's/^ *//g' | awk '{print $1}'
                        echo
                        echo "Pulsa enter para volver"
                        read
                        Investigar_IP
 
        elif [ $Respuesta = 2 ] ;then
                       
                        clear
                        banner
                        nslookup $IP > datos/${IP}nslookup.dat
                        sleep 4
                        cat datos/${IP}nslookup.dat
                        echo
                        echo "Pulsa enter para volver"
                        read
                        Investigar_IP
               
	elif [ $Respuesta = 3 ] ;then

			Proceso

	elif [ $Respuesta = 4 ] ;then

			cat datos/Unicas.dat | grep -v "$IP" > datos/Unicas2.dat
                        mv datos/Unicas2.dat datos/Unicas.dat
                        sleep 1
                        echo
                        Seleccionar_IP	 

	elif [ $Respuesta = 5 ] ;then

			Puertos

	elif [ $Respuesta = 6 ] ;then

			Trafico
		
        elif [ $Respuesta = 99 ] ;then
 
                        clear
                        Seleccionar_IP
 
        elif [ $Respuesta = 0 ] ;then
 
                        clear
                        exit
       
        else
               
                echo " Opcion incorrecta. Pulsa enter para intentarlo de nuevo"
                read
                Investigar_IP
 
        fi
                }
function Opcion3()      {

	clear
	banner
	echo " Introduce el nombre del .cap de la primera captura. Debe estar en la carpeta \"capturas\""
	echo
	echo " y con extension .cap o .pcap"
	echo
	echo " O pulsa 99 para volver"
	echo
	echo -n " Opcion : "
	read FILENAME

		if [ $FILENAME = 99 ] ;then
	
			Comienzo
		else
		
			echo
	
		fi
       
      	  	if [ -f capturas/${FILENAME}.cap ] 2>/dev/null  ;then
       
                	echo
       
        	else
	
			clear
			banner       
                	echo " No se encuentra el archivo ${FILENAME}.cap .Revise la carpeta \"capturas\". Pulse enter para volver a intentarlo"
                	read
                	Opcion3
        	fi

  	Nombre2_Opcion3
 	


        clear
	banner
        echo " Extrayendo IPs destino y origen de primera captura..."
        tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<]  > datos/${FILENAME}IPsOrigen.dat
        tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME}IPsDestino.dat
        cat datos/${FILENAME}IPsDestino.dat datos/${FILENAME}IPsOrigen.dat > datos/${FILENAME}IPsPrimeraCaptura.dat
        cat datos/${FILENAME}IPsPrimeraCaptura.dat | sort | uniq -c > datos/${FILENAME}IPsCon1Captura.dat
        sleep 3
        clear
        banner
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsOrigen.dat
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsDestino.dat
        cat datos/${FILENAME2}IPsDestino.dat datos/${FILENAME2}IPsOrigen.dat > datos/${FILENAME2}IPsSegundaCaptura.dat
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c > datos/${FILENAME2}IPsCon2Captura.dat

        if [ -e datos/IPsLimpias.dat ] 2>/dev/null ;then
       
                 rm datos/IPsLimpias.dat
        fi
 
        if [ -e datos/Unicas.dat ] 2>/dev/null ;then
 
                 rm datos/Unicas.dat
        fi
 
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/IPsLimpias.dat
        NumIPs=`cat -n datos/IPsLimpias.dat | tail -1 | awk '{print $1}'`
	clear
	banner
        ((NumIPs = NumIPs + 1))
 
        while [ "$NumIPs" -gt "0" ] ; do
 
                        IP=` head -${NumIPs} datos/IPsLimpias.dat | tail -1`
                                       
                                if grep -s "$IP" datos/${FILENAME}IPsPrimeraCaptura.dat &>/dev/null ;then
                               
                                        echo
                                else
                                        echo  "$IP" >> datos/Unicas.dat
 
                                       
                                fi
 
                                ((NumIPs--))
        done
                       
        clear
	banner
        echo " Pulsa enter para ver y seleccionar las IPs que solo provocaron trafico durante la segunda captura"
        read
        Seleccionar_IP
       
 
        Investigar_IP
 
        }
 
 
 
function Comienzo()     {               ## menu principal
       
        clear
        echo
        echo ":::'###::::'########:'########:::::'###::::'########:::::'###::::"
        echo "::'## ##:::... ##..:: ##.... ##:::'## ##::: ##.... ##:::'## ##::: "              
        echo ":'##:. ##::::: ##:::: ##:::: ##::'##:. ##:: ##:::: ##::'##:. ##:: "
        echo " ##:::. ##:::: ##:::: ########::'##:::. ##: ########::'##:::. ##: "
        echo " #########:::: ##:::: ##.. ##::: #########: ##.....::: #########: "              
        echo " ##.... ##:::: ##:::: ##::. ##:: ##.... ##: ##:::::::: ##.... ##: "              
        echo " ##:::: ##:::: ##:::: ##:::. ##: ##:::: ##: ##:::::::: ##:::: ##: "  
        echo "..:::::..:::::..:::::..:::::..::..:::::..::..:::::::::..:::::..:: "
        echo " Analizador de Trafico Pasivo 0.8-Beta by Javierbu"
        Menu
}
function Menu() {
        echo
        echo ""
        echo " Por favor, elije una de las siguientes opciones"
        echo ""
        echo "          1 ) Quiero capturar trafico para analizarlo"
	echo "           \\_ 11 ) Que es esto"
        echo "          2 ) Quiero analizar una captura que ya tengo"
	echo "           \\_ 21 ) Que es esto"
        echo "          3 ) Quiero comparar 2 capturas que ya tengo"
	echo "           \\_ 31 ) Que es esto"
        echo "          4 ) Quiero hacer 2 capturas y compararlas"
	echo "           \\_ 41 ) que es esto"
	echo
        echo "          99 ) Quiero borrar todos los datos pero no las capturas"
	echo "          999) quiero borrar todos los datos y capturas"
	echo "          0  ) Quiero salir sin borrar nada"
        echo "          00 ) Quiero salir borrando solo los datos"
        echo "          000) quiero salir borrando los datos y las capturas" 
	echo
	echo " !!!!!CUANDO VAYAS A REALIZAR LAS CAPTURAS, TANTO SI LAS REALIZAS CON EL SCRIPT COMO SI NO, ES IMPORTANTE NO"
	echo " ABRIR NADA EN EL DISPOSITIVO EN EL QUE CAPTURES QUE PROVOQUE TRAFICO, COMO NAVEGADORES WEB, PROGRAMAS P2P, ETC.!!!!!"
	echo
        echo -n "Opcion: "
        read RESPUESTA1
        clear
 
        if [ $RESPUESTA1 = 1 ] ;then
               
                Opcion1
       
        elif [ $RESPUESTA1 = 2 ] ;then
 
                Opcion2
 
        elif [ $RESPUESTA1 = 3 ] ;then
 
                Opcion3
               
        elif [ $RESPUESTA1 = 4 ] ;then
               
                Opcion4
 
        elif [ $RESPUESTA1 = 0 ] ;then
               
                clear
		banner
                echo " Adios!!"
                echo
                exit

	elif [ $RESPUESTA1 = 00 ] ;then

		rm -r datos/ 2>/dev/null
		clear
		banner
		echo " Adios!!"
		exit

	elif [ $RESPUESTA1 = 000 ] ;then

                rm -r datos/ capturas/ 2>/dev/null
                clear
                banner
                echo " Adios!!"
		exit


 
        elif [ $RESPUESTA1 = 99 ] ;then
 
		rm -r datos/ 2>/dev/null
		clear
		banner
		echo " La carpeta \"datos\" y todo su contenido ha sido borrada"
		echo -n " Pulsa enter para volver"
		read
		Comienzo

	elif [ $RESPUESTA1 = 999 ] ;then
 
                rm -r datos/ capturas/ 2>/dev/null
                clear
                banner
                echo " La carpeta \"datos\" y \"capturas\" con todo su contenido han sido borradas"
                echo -n " Pulsa enter para volver"
                read
                Comienzo

	elif [ $RESPUESTA1 = 11 ] ;then
	
		clear
		banner
		echo " Todo el proceso es guiado y muy sencillo."
		echo
		echo " Se realizara una captura de trafico sobre la interfaz de red que elijas durante el tiempo que"
		echo " quieras y se guardara en la carpeta \"capturas\" dentro del directorio donde has ejecutado el script."
		echo " En caso de no existir la carpeta, se creara."
		echo " Una vez terminada la captura, se extraeran las IPs que hayan causado trafico"
		echo " y podras estudiarlas por encima de una manera rapida y sencilla."
		echo " Durante el proceso se iran creando archivos en una carpeta llamda \"datos\" en el directorio "
		echo " donde ejecutaste el script. En caso de no existir la carpeta, se creara"
		echo " Esos datos pueden servirte de ayuda si los sabes interpretar y quieres estudiar mas a fondo determinada IP"
		echo
		echo " Ayuda de netstat:"
		echo
		echo " Si el dispositivo al que le vas a realizar la captura dispone de netstat, te sugiero que antes de la captura"
		echo " y hasta despues de la misma, ejecutes lo siguiente como administrador de tu equipo: "
		echo " netstat -bon 5 > netstat.dat   "
		echo " (este comando es para sistemas windows. En linux no te servira tendras que adaptarlo o adaptar el script.)"
		echo " Esto te creara un archivo llamado \"netstat.dat\" que deberas meter luego dentro de la carpeta \"datos\""
		echo " En el directorio donde ejecutes el script. Si no existe la capeta, creala"
		echo " De esta manera tendremos tambien acceso y el proceso y PID que causo el trafico con las IPs. "
		echo " Cualquier malware sencillo puede usar procesos que parezcan legitimos, en cuyo caso no servira para nada"
		echo " pero nunca se sabe..."
		echo
		echo -n "Pulsa enter para volver"
		read
		Comienzo

	elif [ $RESPUESTA1 = 21 ] ;then

		clear
		banner
		echo " Si ya tienes una captura y quieres analizarla con ATraPa, debes colocar el archivo de la captura"
		echo " En la carpeta \"capturas\" en el directorio donde ejecutes el script."
		echo " Si no existe la carpeta, creala."
		echo " La captura se ha de poder interpretar por tcpdump, con extension .cap o .pcap."
		echo " Si tu captura no tiene esa extension, abrela con wireshark y vuelve a guardarla como .cap o .pcap"
                echo " Una vez leida la captura, se extraeran las IPs que hayan causado trafico"
                echo " y podras estudiarlas por encima de una manera rapida y sencilla."
                echo " Durante el proceso se iran creando archivos en una carpeta llamda \"datos\" en el directorio "
                echo " donde ejecutaste el script. En caso de no existir la carpeta, se creara"
                echo " Esos datos pueden servirte de ayuda si los sabes interpretar y quieres estudiar mas a fondo determinada IP"
                echo
                echo " Ayuda de netstat:"
                echo
                echo " Si el dispositivo al que le vas a realizar la captura dispone de netstat, te sugiero que antes de la captura"
                echo " y hasta despues de la misma, ejecutes lo siguiente como administrador de tu equipo: "
                echo " netstat -bon 5 > netstat.dat   "
                echo " (este comando es para sistemas windows. En linux no te servira. Tendras que adaptarlo o adaptar el script.)"
                echo " Esto te creara un archivo llamado \"netstat.dat\" que deberas meter luego dentro de la carpeta \"datos\""
                echo " En el directorio donde ejecutes el script. Si no existe la capeta, creala"
                echo " De esta manera tendremos tambien acceso y el proceso y PID que causo el trafico con las IPs. "
                echo " Cualquier malware sencillo puede usar procesos que parezcan legitimos, en cuyo caso no servira para nada"
                echo " pero nunca se sabe..."
                echo
                echo -n "Pulsa enter para volver"
                read
                Comienzo

	elif [ $RESPUESTA1 = 31 ] ;then
	       
		clear
                banner
                echo " La idea de comparar 2 capturas es la siguiente:"
		echo
		echo " Realizamos una primera captura cuando sabemos que nuestro sistema esta limpio"
		echo " y las conexiones que realiza son legitimas."
		echo " La segunda captura la haremos despues de ejecutar un posible malware o cuando tenemos sospechas"
		echo " de estar infectados."
		echo " Tomaremos para posterior estudio solo las IPs que hayan causado trafico durante la segunda captura"
		echo " pero que no lo hayan hecho durtante la primera."
		echo " los archivos de las capturas que queremos estudiar han de estar "
                echo " en la carpeta \"capturas\" en el directorio donde ejecutes el script."
                echo " Si no existe la carpeta, creala."
                echo " Las capturas se han de poder interpretar por tcpdump, con extension .cap o .pcap."
                echo " Si tus capturas no tienen esa extension, abrelas con wireshark y vuelve a guardarlas como .cap o .pcap"
                echo " Una vez leidas las capturas, se extraeran las IPs que hayan causado"
		echo " trafico en la segunda captura pero no en la primera"
                echo " y podras estudiarlas por encima de una manera rapida y sencilla."
                echo " Durante el proceso se iran creando archivos en una carpeta llamada \"datos\" en el directorio "
                echo " donde ejecutaste el script. En caso de no existir la carpeta, se creara"
                echo " Esos datos pueden servirte de ayuda si los sabes interpretar y quieres estudiar mas a fondo determinada IP"
                echo
                echo " Ayuda de netstat:"
                echo
                echo " Si el dispositivo al que le vas a realizar las capturas dispone de netstat, te sugiero en la segunda captura"
		echo " que antes comenzar y hasta despues de terminar, ejecutes lo siguiente como administrador de tu equipo:"
                echo " netstat -bon 5 > netstat.dat   "
                echo " (este comando es para sistemas windows. En linux no te servira. Tendras que adaptarlo o adaptar el script.)"
                echo " Esto te creara un archivo llamado \"netstat.dat\" que deberas meter luego dentro de la carpeta \"datos\""
                echo " En el directorio donde ejecutes el script. Si no existe la capeta, creala"
                echo " De esta manera tendremos tambien acceso y el proceso y PID que causo el trafico con las IPs. "
                echo " Cualquier malware sencillo puede usar procesos que parezcan legitimos, en cuyo caso no servira para nada"
                echo " pero nunca se sabe..."
                echo 
                echo -n "Pulsa enter para volver"
                read
                Comienzo

elif [ $RESPUESTA1 = 41 ] ;then

                clear
                banner
                echo " La idea de comparar 2 capturas es la siguiente:"
		echo
                echo " Realizamos una primera captura cuando sabemos que nuestro sistema esta limpio"
                echo " y las conexiones que realiza son legitimas."
                echo " La segunda captura la haremos despues de ejecutar un posible malware o cuando tenemos sospechas"
                echo " de estar infectados."
                echo " Tomaremos para posterior estudio solo las IPs que hayan causado trafico durante la segunda captura"
                echo " pero que no lo hayan hecho durtante la primera."
                echo " Se te guiara por un proceso muy sencillo para hacer las capturas y se guardaran"
                echo " en la carpeta \"capturas\" en el directorio donde ejecutes el script."
                echo " Si no existe la carpeta, se creara."
                echo " Una vez leidas las capturas, se extraeran las IPs que hayan causado"
                echo " trafico en la segunda captura pero no en la primera"
                echo " y podras estudiarlas por encima de una manera rapida y sencilla."
                echo " Durante el proceso se iran creando archivos en una carpeta llamada \"datos\" en el directorio "
                echo " donde ejecutaste el script. En caso de no existir la carpeta, se creara"
                echo " Esos datos pueden servirte de ayuda si los sabes interpretar y quieres estudiar mas a fondo determinada IP"
 		echo
                echo " Ayuda de netstat:"
                echo
                echo " Si el dispositivo al que le vas a realizar las capturas dispone de netstat, te sugiero en la segunda captura"
                echo " que antes comenzar y hasta despues de terminar, ejecutes lo siguiente como administrador de tu equipo:"
                echo " netstat -bon 5 > netstat.dat   "
                echo " (este comando es para sistemas windows. En linux no te servira. Tendras que adaptarlo o adaptar el script.)"
                echo " Esto te creara un archivo llamado \"netstat.dat\" que deberas meter luego dentro de la carpeta \"datos\""
                echo " En el directorio donde ejecutes el script. Si no existe la capeta, creala"
                echo " De esta manera tendremos tambien acceso y el proceso y PID que causo el trafico con las IPs. "
                echo " Cualquier malware sencillo puede usar procesos que parezcan legitimos, en cuyo caso no servira para nada"
                echo " pero nunca se sabe..."
                echo 
                echo -n "Pulsa enter para volver"
                read
                Comienzo


		
	else
                echo
                echo " Opcion no valida, intenta otra vez"
                clear
		banner
		Menu
 
                       
        fi
 
        }
 
function Nombre1_Opcion4()      {
 
		clear
		banner
                echo " 1 Tengo una captura que quiero usar como primera captura."
		echo " 2 Quiero realizar la captura"
		echo " 3 Quiero volver"
		echo
                echo -n " Opcion: "
                read respuesta

			if  [ $respuesta = 1 ] ;then

				clear
				banner
				echo " Introduce el nombre del .cap de la primera captura. Debe estar en la carpeta \"capturas\""
				echo 
				echo " y con extension .cap o .pcap"
				echo
				echo " O pulsa 99 para volver"
				echo
				echo -n " Opcion : "
				read FILENAME

       		 		if [ $FILENAME = 99 ] ;then
	
        	        		Opcion4
        			else
                
                			echo

        			fi

        			if [ -f capturas/${FILENAME}.cap ] 2>/dev/null  ;then
 
                			echo
 
        			else
 
                			clear
					banner
                			echo " No se encuentra el archivo ${FILENAME}.cap .Revise la carpeta \"capturas\".Pulse enter para volver a intentarlo"
                			read
                			Opcion4
       			 	fi
 
                
				if [ -d datos ] ;then
 
                        		echo
               
                		else
                        
					mkdir datos    
              
              		  	fi

			elif [ $respuesta = 2 ] ;then
			
				clear
				banner
				Nombre_Captura_Limpia
				Pedir_Tiempo
				Interfaz
				Lanzar_Tcpdump


			elif [ $respuesta = 3 ] ;then

				Comienzo
			else

				clear
				banner
				echo " $respuesta no es una opcion valida"
				echo
				echo -n " Pulsa enter para volver a intentarlo"			
			       	read
				Nombre1_Opcion4
			
			fi

	}


function Nombre2_Opcion4()      {
 
		clear
		banner
                echo " 1 Tengo una captura que quiero usar como segunda captura."
		echo " 2 Quiero realizar la captura"
		echo " 3 Quiero volver"
		echo
                echo -n " Opcion: "
                read respuesta

			if  [ $respuesta = 1 ] ;then

				clear
				banner
				echo " Introduce el nombre del .cap de la segunda captura. Debe estar en la carpeta \"capturas\""
				echo 
				echo " y con extension .cap o .pcap"
				echo
				echo " O pulsa 99 para volver"
				echo
				echo -n " Opcion : "
				read FILENAME2

       		 		if [ $FILENAME2 = 99 ] ;then
	
        	        		Opcion4
        			else
                
                			echo

        			fi

        			if [ -f capturas/${FILENAME2}.cap ] 2>/dev/null  ;then
 
                			echo
 
        			else
 
                			clear
					banner
                			echo " No se encuentra el archivo ${FILENAME2}.cap .Revise la carpeta \"capturas\".Pulse enter para volver a intentarlo"
                			read
                			Nombre2_Opcion4
       			 	fi
 
                
				if [ -d datos ] ;then
 
                        		echo
               
                		else
                        
					mkdir datos    
              
              		  	fi

			elif [ $respuesta = 2 ] ;then
			
				clear
				banner
				Nombre_Captura_Malware
				Pedir_Tiempo
				Interfaz
				Lanzar_Tcpdump2

			elif [ $respuesta = 3 ] ;then

				Comienzo

			else

				clear
				banner
				echo " $respuesta no es una opcion valida"
                                echo
                                echo -n " Pulsa enter para volver a intentarlo"
                                read
                                Nombre2_Opcion4
			
			fi
			
			       
	}

function Opcion4()	{

	Nombre1_Opcion4
	Nombre2_Opcion4
	clear
	banner
	echo " Ya tenemos las 2 capturas. Ahora las compararemos y extraeremos"
	echo
	echo " Las IPs que hayan causadado trafico en la segunda captura, pero no en la primera."
	echo
	echo -n " Pulsa enter para continuar"
        read
	clear
	banner
        Sacar_IPs
                Seleccionar_IP
                IP=`uniq datos/Unicas.dat | cat -n | sed -e 's/^ *//g' |  grep ^$Seleccion | awk '{print $2}'`
                Investigar_IP
                       
                }
 
function Sacar_IPs()    {       ## procesamos las 2 capturas para extraer las ips que hayan causado trafico en las 2 capturas, tanto como
                        ## origen como destino. Guardamos todos los archivos resultantes en la carpeta datos

                if [ -d datos ] ;then
 
                        echo
               
                else
                        mkdir datos    
               
               
                fi
 
	clear
	banner
        echo " Extrayendo IPs destino y origen de primera captura..."
        tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/IPsLimpias.dat://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<]  > datos/${FILENAME}IPsOrigen.dat
        tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME}IPsDestino.dat
        cat datos/${FILENAME}IPsDestino.dat datos/${FILENAME}IPsOrigen.dat > datos/${FILENAME}IPsPrimeraCaptura.dat
        cat datos/${FILENAME}IPsPrimeraCaptura.dat | sort | uniq -c > datos/${FILENAME}IPsCon1Captura.dat
        echo
        echo " Hecho"
        clear
        banner
        echo " Extrayendo IPs destino y origen de segunda captura..."
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsOrigen.dat
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsDestino.dat
        cat datos/${FILENAME2}IPsDestino.dat datos/${FILENAME2}IPsOrigen.dat > datos/${FILENAME2}IPsSegundaCaptura.dat
	echo
        echo "Hecho"
        echo "Procesando IPs segunda captura"
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c > datos/${FILENAME2}IPsCon2Captura.dat
        Despejar_IPs
 
}
 
function Despejar_IPs() {  ############ ya teniendo los datos de todas las IPs que han generado trafico en las 2 capturas, pasamos
                        ########## a despejar las que hicieron trafico en la segunda, pero no en la primera
       
	 if [ -e datos/IPsLimpias.dat ] 2>/dev/null ;then
       
		rm datos/IPsLimpias.dat
         fi
 
         if [ -e datos/Unicas.dat ] 2>/dev/null ;then
 
                rm datos/Unicas.dat
        
	 fi
 
	clear
	banner
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/IPsLimpias.dat
        NumIPs=`cat -n datos/IPsLimpias.dat | tail -1 | awk '{print $1}'`
        ((NumIPs = NumIPs + 1))
        sleep 2
 
        while [ "$NumIPs" -gt "0" ] ; do
 
                        IP=` head -${NumIPs} datos/IPsLimpias.dat | tail -1`

                        echo   
                                       
                                if grep -s "$IP" datos/${FILENAME}IPsPrimeraCaptura.dat ;then
                               
                                        echo "$IP encontrada en ambas capturas. Descartando..."
                                        echo
                                else
                                        echo  "$IP" >> datos/Unicas.dat
                                        echo
 
                                       
                                fi
 
                                ((NumIPs--))
        done
                       
        clear
	banner
        echo " Pulsa enter para ver las IPs que solo provocaron trafico durante la segunda captura"
        read
        echo
        cat datos/Unicas.dat | sort | uniq
        echo
        echo
        echo " Pulsa una enter para continuar"
}
 
function Lanzar_Tcpdump()       {       ## lanzamos tcpdump para hacer la primera captura
       
	clear
	banner
        echo " Se realizara una primera captura de $TIEMPO segundos"
        echo
        echo " que se guardara con el nombre de \"$FILENAME\""
        echo
        echo " con la interfaz $INTERFAZ"
        echo
        echo " Por favor, pulsa enter para confirmar" ; read
        clear
 
        tcpdump -A -nn -i $INTERFAZ -w capturas/${FILENAME}.cap 2>/dev/null &
        PID=$!
 
        while [ $TIEMPO -gt 0 ] ;do
 
                ((TIEMPO--))
                sleep 1
                clear
                banner
                echo " Tiempo restante para terminar la captura $TIEMPO"
                done
                kill $PID
 
 
}
 
function Lanzar_Tcpdump2()        {     ## lanzamos tcpdump para hacer la segunda captura
 
	clear
	banner
        echo " Se realizara una captura de $TIEMPO segundos"
        echo
        echo " que se guardara con el nombre de \"$FILENAME2\""
        echo
        echo " con la interfaz $INTERFAZ ."
        echo
        echo -n " Por favor, pulsa enter para confirmar" ; read
        clear
        tcpdump -A -nn -i $INTERFAZ -w capturas/${FILENAME2}.cap 2>/dev/null &
        PID=$!
 
        while [ $TIEMPO -gt 0 ] ;do
 
                  ((TIEMPO--))
                  sleep 1
                  clear
                  banner
                  echo " Tiempo restante para terminar la captura $TIEMPO"
                  done
                  kill $PID
 
 
  }
 
 
 
function Interfaz()      {                                      ##Seleccion de la interfaz con la que snifar
 
 	
	clear
	banner
        echo " Detectando interfaces de red, paciencia...."
        echo
                if [ -e /tmp/interfaces ] ;then                ### borramos el archivo /tmp/interfaces en caso de que exista
 
                        rm /tmp/interfaces
                fi

        ifconfig | grep  encap | awk '{print $1}' > /tmp/interfaces 
        sleep 5
        NumeroDeInterfaces=`cat -n /tmp/interfaces | tail -1 | sed -e 's/^ *//g' | awk '{print $1}'`
        cat -n /tmp/interfaces
        echo
        echo  " Selecciona una interfaz"
	echo 
	echo " O pulsa 99 para volver al menu principal"
	echo
	echo -n " Opcion: "
        read Seleccioninterfaz

		if [ "$Seleccioninterfaz" = "99" ] ;then
		
			Comienzo
		
		else
		
			echo

		fi
        
                if [[ $Seleccioninterfaz = *[1-9]* ]] && [[ $NumeroDeInterfaces -ge $Seleccioninterfaz ]]  ;then

                        clear
                        echo
                        echo
                        echo
                        echo
                        INTERFAZ=`uniq /tmp/interfaces | cat -n | sed -e 's/^ *//g' |  grep -w ^$Seleccioninterfaz | awk '{print $2}'`

                else

                        clear
			banner
                        echo " Seleccion incorrecta."
			echo
			echo " Pulsa enter para volver a probar"
			read
                        Interfaz

                fi
               
                        }
       
 
 
function Pedir_Tiempo()      {          # pedimos tiempo de captura en segundos
                
		clear
		banner
                echo
                echo -n " Cuanto tiempo quieres capturar? Introduce un valor en segundos: "
                read TIEMPO ;
                clear
                echo
 
        TEST_TIEMPO=1
 
                        if [ $TIEMPO -ge $TEST_TIEMPO ] 2>/dev/null ;then  
 
                                  echo
 
                        else	
 				  clear
				  banner
                                  echo
                                  echo  " \"$TIEMPO\" No es un valor aceptado"
                                  echo
                                  echo " Debes introducir un tiempo valido, recuerda que es en segundos"
                                  echo
				  echo -n " Pulsa enter para volver a intentarlo"
				  read
                                  Pedir_Tiempo
 
                         fi
 
 
                            }
 
 
function Nombre_Captura_Limpia()  {     #asignamos un nombre a la primera captura comprobando que no exista un archivo con el mismo nombre
       
	clear
	banner
        echo  " Por favor, escribe el nombre de la primera captura. Se guardara en la carpeta \"capturas\" dentro de este mismo directorio: "
	echo
	echo " O pulsa 99 para volver a empezar. "
	echo
	echo -n " Opcion: "
        read FILENAME 

		if [ $FILENAME = 99 ] ;then
	
			Comienzo

		else
	
			echo -n

		fi
 
                if [ -d capturas ] ;then
                       
                        echo
 
                else
 
                        mkdir capturas
               
                fi
       
                       
                if [ -f capturas/$FILENAME ] ;then
			
 			 clear
			 banner
                         echo " Ya existe una captura llamada \"$FILENAME\". Por favor, elije otro nombre"
			 echo
			 echo " Pulsa enter para volver a intentarlo"
			 read
                         Nombre_Captura_Limpia
               
                 else
 
                         echo
                 fi
                        }      
       
function Nombre_Captura_Malware()  {            #asignamos un nombre a la segunda captura comprobando que no exista un archivo con el mismo nombre
 
	  clear
	  banner
          echo  " Por favor, escribe el nombre de la segunda captura. Se guardara en la carpeta \"capturas\" dentro de este mismo directorio: "
          echo 
          echo " O pulsa 99 para volver al menu principal"
          echo
          echo -n " Opcion: "
          read respuesta

                if [ $respuesta = 99 ] ;then

                        Comenzar

                else

                        echo

                fi

          read FILENAME2


 
                  if [ -d capturas ] ;then
 
                          echo
 
                  else    
                 
                          mkdir capturas
                 
                  fi    
                         
                         
                  if [ -f capturas/$FILENAME2 ] ;then
		
                	   clear
			   banner 
                           echo " Ya existe una captura llamada \"$FILENAME2\". Por favor, elije otro nombre"
			   echo 
			   echo " Pulsa enter para volver a intentarlo"
			   read
                           Nombre_Captura_Malware
 
                   else
 
                           echo
                 
                   fi
                          }
 
Comienzo
