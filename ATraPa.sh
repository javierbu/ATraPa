#!/bin/bash

#Varibles globales
# ATraPa by Javierbu javierbu@gmail.com mayo/2015

function Opcion2()      { 

        clear
        echo
        echo -n "Por favor, introduce el nombre del .cap que quieres analizar. Debe estar en la carpeta \"datos\": "
        read FILENAME2  

                 if [ -f capturas/${FILENAME2}.cap ] 2>/dev/null  ;then

                        echo

                else

                        echo
                        echo "No se encuentra el archivo ${FILENAME}.cap .Revise la carpeta \"capturas\".Pulse enter para comenzar de nuevo"
                        read
                        Opcion2
                fi

        Sacar_IPs1
        Seleccionar_IP
        Investigar_IP
}




function Sacar_IPs1()    {       ## procesamos la captura para sacar las ips implicadas en todo el trafico
                        
        echo
                if [ -d datos ] ;then

                        echo

                else
                        mkdir datos     


                fi
        clear
        echo
        echo "Extrayendo IPs destino y origen de $FILENAME2..."
	sleep 3
        echo
        tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsOrigen.dat
	echo
	echo
	tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsDestino.dat
        echo
        cat datos/${FILENAME2}IPsDestino.dat datos/${FILENAME2}IPsOrigen.dat > datos/${FILENAME2}IPsSegundaCaptura.dat
        echo "Hecho"
        echo
        echo "Procesando IPs"
        cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c > datos/${FILENAME2}IPsCon2Captura.dat
        echo
	cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/Unicas.dat
	Seleccionar_IP
	Investigar_IP
        echo
        echo ""
        echo ""

}



function Nombre_Captura_Unica()  {            #asignamos un nombre a la segunda captura comprobando que no exista un archivo con el mismo nombre
  
          echo
          echo -n "Por favor, escribe un nombre para la captura que vas a realizar. Se guardara en \"capturas\" en este mismo directorio: "
          read FILENAME2
  
                  if [ -d capturas ] ;then
  
                          echo
  
                  else    

                          mkdir capturas

                  fi     


                  if [ -f capturas/$FILENAME2 ] ;then

                           echo "Ya existe una captura llamada \"$FILENAME2\". Por favor, elije otro nombre" ;echo
                           Nombre_Captura_Unica
  
                   else
  
                           echo
		  fi
                	          } 



function Opcion1()      {       ## opcion 1 del menu principal. HACER 1 CAPTURA PARA ANALIZARLA

                echo
                echo
                echo "Vamos a realizar la captura"
		echo
                echo "Una vez realizada, podremos investigas las IPs que hayan causado trafico"
                echo -n "pulsa enter para continuar"
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
                echo
                echo "Ahora extraeremos de la captura las IPs que hayan causado trafico"
                echo 
                echo 
                echo "Pulsa enter para continuar" ;read
                echo
                Sacar_IPs1
                Seleccionar_IP
		IP=`uniq datos/Unicas.dat | cat -n | sed -e 's/^ *//g' |  grep ^$Seleccion | awk '{print $2}'`
                Investigar_IP

                }

clear

function Seleccionar_IP()	{
	NumIPs=`uniq datos/Unicas.dat | cat -n | tail -1 | awk '{print $1}'`
	clear
	echo
	echo
	echo "Por favor, selecciona una de las siguientes IPs para estudiarla"
	echo
	echo 
	echo
	uniq datos/Unicas.dat | cat -n
	echo
	echo "    999 Si quieres ver todas consultas DNS que se han hecho desde durante la captura"
	echo "    0 Si quieres salir"
	echo
	echo -n "Opcion: "
	read Seleccion

	if [ $Seleccion = 999 ] ;then
	
		 clear
                        echo
                        echo
                        tcpdump -r capturas/${FILENAME2}.cap -nn | grep "A?"  > datos/${FILENAME2}PeticionDns.dat
                        sleep 3
                        echo
                        echo
			echo "    N. Consultas   Direccion"
			echo
                        cat datos/${FILENAME2}PeticionDns.dat | awk '{print "           "$8}' | sort | uniq -c | sort
                        echo
                        echo "Pulsa enter para volver"
                        read
                        Seleccionar_IP
	
	elif [ $Seleccion = 0 ] ;then

		echo ""
		echo "Adios!!"
		sleep 0.25
		exit
	
	else
		echo -n

	fi
	
	
		until [[ $Seleccion = *[1-9]* ]] && [[ $NumIPs -ge $Seleccion ]]  ;do
			
			echo -n "$Seleccion no es una opcion permitida. Prueba de nuevo: "
			read Seleccion
		done

			echo 

	IP=`uniq datos/Unicas.dat | cat -n | sed -e 's/^ *//g' |  grep -w ^$Seleccion | awk '{print $2}'`
	Investigar_IP
	
	}

function Investigar_IP() {

clear
	echo
	echo "La IP seleccionada es $IP"
	echo
	echo
	echo
	echo "Elije una de las siguientes opciones"
	echo
	echo
	echo
	echo	
	echo "		1  numero de paquetes generados con $IP implicada "
	echo
	echo "		2  resolucion de dominio"
	echo
	echo "		99 Volver y elegir otra IP"
	echo
	echo "		0  salir"
	echo
	echo
	echo "Investiga esta IP en la red:"
	echo
	echo "	Geolocalizacion, whois, nslookup y mas: http://${IP}.ipaddress.com/"
	echo "	Reputacion y mas: https://www.senderbase.org/lookup/?search_string=${IP}"
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
			echo
			echo
			nslookup $IP > datos/${IP}nslookup.dat 
			sleep 5
			cat datos/${IP}nslookup.dat
			echo
			echo "Pulsa enter para volver"
			read
			Investigar_IP
		

	elif [ $Respuesta = 99 ] ;then

			clear
			Seleccionar_IP

	elif [ $Respuesta = 0 ] ;then

			clear
			exit
	
	else
		
		echo "Opcion incorrecta. Pulsa enter para intentarlo de nuevo"
		read
		Investigar_IP

	fi
		}
function Opcion3()	{
clear
echo
echo "Introduce el nombre del .cap de la primera captura. Debe estar en la carpeta \"capturas\" ."
echo -n "Ingresa el nombre sin extension : "
read FILENAME
	
	if [ -f capturas/${FILENAME}.cap ] 2>/dev/null  ;then
	
		echo
	
	else
	
		echo
		echo "No se encuentra el archivo ${FILENAME}.cap .Revise la carpeta \"capturas\". Pulse enter para comenzar de nuevo"
		read
		Opcion3
	fi

clear
echo
echo "Introduce el nombre del .cap de la segunda captura. Debe estar en la carpeta \"capturas\" ."
echo -n "Ingrese el nombre sin extension : "
read FILENAME2

	if [ -f capturas/${FILENAME2}.cap ] 2>/dev/null  ;then

                echo

        else

                echo
                echo "No se encuentra el archivo ${FILENAME}.cap .Revise la carpeta \"capturas\".Pulse enter para comenzar de nuevo"
		read
                Opcion3
        fi

	clear
	echo
		if [ -d datos ] ;then

			echo
		
		else
			mkdir datos	
		
		
		fi
	
	rm datos/${FILENAME}* datos/${FILENAME2}* 2>/dev/null
	echo
	echo "	Extrayendo IPs destino y origen de primera captura..."
	echo
	tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<]  > datos/${FILENAME}IPsOrigen.dat
	echo
	echo
	tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME}IPsDestino.dat
	echo
	cat datos/${FILENAME}IPsDestino.dat datos/${FILENAME}IPsOrigen.dat > datos/${FILENAME}IPsPrimeraCaptura.dat
	echo "Hecho"
	echo
	echo "procesando IPs primera captura"
	cat datos/${FILENAME}IPsPrimeraCaptura.dat | sort | uniq -c > datos/${FILENAME}IPsCon1Captura.dat
	echo
	echo "Hecho"
	sleep 3
	clear
	echo
	echo "Extrayendo IPs destino y origen de segunda captura..."
	echo
	tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsOrigen.dat
	echo
	echo
	tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsDestino.dat
	echo
	cat datos/${FILENAME2}IPsDestino.dat datos/${FILENAME2}IPsOrigen.dat > datos/${FILENAME2}IPsSegundaCaptura.dat
	echo "Hecho"
	echo
	echo "Procesando IPs segunda captura"
	cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c > datos/${FILENAME2}IPsCon2Captura.dat
	echo
	if [ -e datos/IPsLimpias.dat ] ;then 
	
        	                rm datos/IPsLimpias.dat
        fi

	if [ -e datos/Unicas.dat ] ;then 

                                rm datos/Unicas.dat
        fi

	cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/IPsLimpias.dat
	NumIPs=`cat -n datos/IPsLimpias.dat | tail -1 | awk '{print $1}'`
	echo
	echo
	echo "Vamos a comparar  $NumIPs IPs en las 2 capturas. Paciencia...."
	echo
	echo
	((NumIPs = NumIPs + 1))

	echo 

	while [ "$NumIPs" -gt "0" ] ; do

			IP=` head -${NumIPs} datos/IPsLimpias.dat | tail -1`
			echo $IP
			echo	
					
				if grep -s "$IP" datos/${FILENAME}IPsPrimeraCaptura.dat &>/dev/null ;then 
				
					echo
					echo
				else
					echo  "$IP" >> datos/Unicas.dat
					echo
					echo 

        	                	
				fi

				((NumIPs--))
	done
			
	clear
	echo""
	echo "Pulsa enter para ver y seleccionar las IPs que solo provocaron trafico durante la segunda captura"
	read
	Seleccionar_IP
	

	Investigar_IP

	}



function Comienzo()	{		## menu principal
	
	clear
	echo 
	echo 
	echo
	echo
	echo "ATraPa"
	echo "by Javierbu"
	echo
	echo "Analizador de Trafico Pasivo"
	echo
	echo ""
	echo "Por favor, elije una de las siguientes opciones"
	echo ""
	echo ""
	echo ""
	echo "		1 ) Quiero capturar trafico para analizarlo"
	echo "		2 ) Quiero analizar una captura que ya tengo"
	echo "		3 ) Quiero comparar capturas que ya tengo"
	echo "		4 ) Quiero hacer 2 capturas y compararlas"
	echo "		0 ) Quiero salir"
	echo "		99 ) Quiero borrar todos los datos de anteriores capturas"
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
		
		echo
		echo "Adios!!"
		echo
                exit

	elif [ $RESPUESTA1 = 99 ] ;then

		echo 

			if [ -d capturas ] || [ -d datos ] ;then 
        			
				 echo
				 rm -r datos/ capturas/
       				 echo "	Borrando datos de capturas anteriores..."
        		         sleep 1
				 Comienzo
			else
				 echo	
			         echo "	No existen capturas anteriores en este directorio"
				 sleep 1
                		 Comienzo
			fi
        else
		echo
		echo "opcion no valida, intenta otra vez"
		Comienzo

			
	fi

	}

function Opcion4()	{ 	## opcion 4 del menu principal. HACER 2 CAPTURAS PARA COMPARARLAS

		echo
		echo
		echo "Vamos a realizar la primera captura"
		echo "Esta captura la tomaremos para luego comparar con ella el trafico despues de ejecutar el posible malware"
		echo "pulsa enter para continuar"
		read
		clear
		echo
		Pedir_Tiempo  
		echo
		Interfaz
		clear
		echo
		Nombre_Captura_Limpia
		clear echo
		Lanzar_Tcpdump
		clear
		echo
		echo "Ya tenemos nuestra primera captura"
		echo
		echo "Si quieres comparar capturas despues de ejecutar posible malware,"
		echo
		echo "comienza la captura y enseguida ejecuta el posible malware."
		echo
		echo "Pulsa enter para comenzar con la segunda captura" 
		read
		clear
		echo
		Pedir_Tiempo
		echo
		Interfaz
		clear
		Nombre_Captura_Malware
		clear
		echo
		Lanzar_Tcpdump2
		echo
		echo "Ahora compararemos las IPs que cuasaron trafico en la segunda"
		echo
		echo "captura pero que no lo hicieron en la primera"
		echo
		echo "Pulsa una enter para continuar" ;read
		echo
		Sacar_IPs
		Seleccionar_IP
		IP=`uniq datos/Unicas.dat | cat -n | sed -e 's/^ *//g' |  grep ^$Seleccion | awk '{print $2}'`
		Investigar_IP
			
		}

function Sacar_IPs()	{	## procesamos las 2 capturas para extraer las ips que hayan causado trafico en las 2 capturas, tanto como 
			## origen como destino. Guardamos todos los archivos resultantes en la carpeta datos
	echo
		if [ -d datos ] ;then

			echo
		
		else
			mkdir datos	
		
		
		fi

	echo "	Extrayendo IPs destino y origen de primera captura..."
	echo
	tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/IPsLimpias.dat://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<]  > datos/${FILENAME}IPsOrigen.dat
	echo
	echo
	tcpdump -r capturas/${FILENAME}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME}IPsDestino.dat
	echo
	cat datos/${FILENAME}IPsDestino.dat datos/${FILENAME}IPsOrigen.dat > datos/${FILENAME}IPsPrimeraCaptura.dat
	echo "Hecho"
	echo
	echo "procesando IPs primera captura"
	cat datos/${FILENAME}IPsPrimeraCaptura.dat | sort | uniq -c > datos/${FILENAME}IPsCon1Captura.dat
	echo
	echo "Hecho"
	sleep 3
	clear
	echo
	echo "Extrayendo IPs destino y origen de segunda captura..."
	echo
	tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $3}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsOrigen.dat
	echo
	echo
	tcpdump -r capturas/${FILENAME2}.cap -nn | sed -e 's/://g' | awk '{print $5}' | cut -d '.' -f 1,2,3,4 | grep -v [a-z,A-Z,\>,\<] > datos/${FILENAME2}IPsDestino.dat
	echo
	cat datos/${FILENAME2}IPsDestino.dat datos/${FILENAME2}IPsOrigen.dat > datos/${FILENAME2}IPsSegundaCaptura.dat
	echo "Hecho"
	echo
	echo "Procesando IPs segunda captura"
	cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c > datos/${FILENAME2}IPsCon2Captura.dat
	echo
	echo "Hecho"
	Despejar_IPs
	echo
	echo ""
	echo ""

}

function Despejar_IPs()	{  ############ ya teniendo los datos de todas las IPs que han generado trafico en las 2 capturas, pasamos
			########## a despejar las que hicieron trafico en la segunda, pero no en la primera
	if [ -e datos/IPsLimpias.dat ] ;then 
	
        	                rm datos/IPsLimpias.dat
        fi

	if [ -e datos/Unicas.dat ] ;then 

                                rm datos/Unicas.dat
        fi

	cat datos/${FILENAME2}IPsSegundaCaptura.dat | sort | uniq -c | sed -e 's/^ *//g' -e 's/\://g' | awk '{print $2}' > datos/IPsLimpias.dat
	NumIPs=`cat -n datos/IPsLimpias.dat | tail -1 | awk '{print $1}'`
	echo
	echo
	echo "Vamos a comparar  $NumIPs IPs en las 2 capturas. Paciencia...."
	echo
	echo
	((NumIPs = NumIPs + 1))

	echo $NumIPs ############
	sleep 2

	while [ "$NumIPs" -gt "0" ] ; do

			IP=` head -${NumIPs} datos/IPsLimpias.dat | tail -1`
			echo $IP
			echo	
					
				if grep -s "$IP" datos/${FILENAME}IPsPrimeraCaptura.dat ;then 
				
					echo "$IP encontrada en ambas capturas. Descartando..."
					echo
				else
					echo  "$IP" >> datos/Unicas.dat
					echo "$IP Encontrada solo en la segunda captura, archivando..."
					echo 

        	                	
				fi

				((NumIPs--))
	done
			
	clear
	echo""
	echo "Pulsa enter para ver las IPs que solo provocaron trafico durante la segunda captura"
	read
	echo
	cat datos/Unicas.dat | sort | uniq
	echo
	echo
	echo "Pulsa una enter para continuar"
}

function Lanzar_Tcpdump()	{	## lanzamos tcpdump para hacer la primera captura
	
	echo
	echo	
	echo "Se realizara una primera captura de $TIEMPO segundos"
        echo
        echo "que se guardara con el nombre de \"$FILENAME\""
        echo
        echo "con la interfaz $INTERFAZ"
        echo
        echo "por favor, pulsa enter para confirmar" ; read
        clear

	tcpdump -A -nn -i $INTERFAZ -w capturas/${FILENAME}.cap 2>/dev/null &
	PID=$!

	while [ $TIEMPO -gt 0 ] ;do
 
		((TIEMPO--))
       		sleep 1
        	clear
		echo
      	  	echo "Tiempo restante para terminar la captura $TIEMPO"
                done
		kill $PID


}

function Lanzar_Tcpdump2()        {	## lanzamos tcpdump para hacer la segunda captura

	echo "Se realizara una segunda captura de $TIEMPO segundos"
        echo
        echo "que se guardara con el nombre de \"$FILENAME2\""
        echo
        echo "con la interfaz $INTERFAZ"
        echo
        echo "por favor, pulsa enter para confirmar" ; read
        clear
        tcpdump -A -nn -i $INTERFAZ -w capturas/${FILENAME2}.cap 2>/dev/null &
        PID=$!
 
        while [ $TIEMPO -gt 0 ] ;do
  
                  ((TIEMPO--))
                  sleep 1
                  clear
		  echo
                  echo "Tiempo restante para terminar la captura $TIEMPO"
                  done
                  kill $PID
  
  
  }



function Interfaz()      {					##Seleccion de la interfaz con la que snifar

	echo
        echo "Detectando interfaces de red, paciencia...." 
        echo
                if [ -e /tmp/interfaces ] ;then                ### borramos el archivo /tmp/interfaces en caso de que exista

                        rm /tmp/interfaces
                fi

        ifconfig | grep  direcci | awk '{print $1}' > /tmp/interfaces		 ###creamos archivo interfaces
        sleep 5			 ##esperamos 5 segundos para que se genere el archivo interfaces, si no esperamos no se llega a generar.
	cat /tmp/interfaces ;echo      ## si no lo generara, puede ser por la velocidad de procesamiento de la computadora, se recomienda
						## darle un valor mas alto al sleep
		echo""
		echo -n "Elije la interfaz con la que quieres capturar el trafico. Nombre de la interfaz completo: " 
		read INTERFAZ
		clear
		sleep 3  
		grep $INTERFAZ /tmp/interfaces > /dev/null 2>&1                ##comprobamos que la interfaz es real
			
		        if [ $? -eq 0 ] ; then                                                 ##
		
				echo  
		
			else
		
				echo;echo $INTERFAZ "interfaz no reconocida o no valida, vuelve a intentarlo" ;echo
				Interfaz	

			fi
		
			}
	


function Pedir_Tiempo()      { 		# pedimos tiempo de captura en segundos
		echo
		echo
		echo -n "Cuanto tiempo quieres capturar? Introduce un valor en segundos: " 
       	        read TIEMPO ;
		clear
		echo

	TEST_TIEMPO=1

		        if [ $TIEMPO -ge $TEST_TIEMPO ] 2>/dev/null ;then  

				  echo

                        else

				  echo
                                  echo  "\"$TIEMPO\" No es un valor aceptado"
                                  echo 
			          echo "Debes introducir un tiempo valido, recuerda que es en segundos" 
                                  echo
				  Pedir_Tiempo

                         fi


                            }


function Nombre_Captura_Limpia()  {	#asignamos un nombre a la primera captura comprobando que no exista un archivo con el mismo nombre
	
	echo
	echo -n "Por favor, escribe el nombre de la primera captura. Se guardara en la carpeta \"capturas\" dentro de este mismo directorio: "
	read FILENAME ;clear

		if [ -d capturas ] ;then
			
			echo

		else 

			mkdir capturas
		
		fi
	
			
		if [ -f capturas/$FILENAME ] ;then

			 echo "Ya existe una captura llamada \"$FILENAME\". Por favor, elije otro nombre" ;echo
			 Nombre_Captura_Limpia
		
             	 else 

			 echo
		 fi
			} 	
        
function Nombre_Captura_Malware()  {		#asignamos un nombre a la segunda captura comprobando que no exista un archivo con el mismo nombre
  
	  echo
          echo -n "Por favor, escribe el nombre de la segunda captura. Se guardara en la carpeta \"capturas\" dentro de este mismo directorio: "
          read FILENAME2
  
                  if [ -d capturas ] ;then
  
                          echo
  
                  else    
                  
                          mkdir capturas
                  
                  fi     
                          
                          
                  if [ -f capturas/$FILENAME2 ] ;then
                  
                           echo "Ya existe una captura llamada \"$FILENAME2\". Por favor, elije otro nombre" ;echo
                           Nombre_Captura_Malware
  
                   else
  
                           echo
                  
                   fi
                          } 

Comienzo


