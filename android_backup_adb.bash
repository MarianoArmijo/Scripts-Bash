#!/bin/bash

#######################################
###  Android Backup -- ADB Android  ###
#######################################

# Athor: Mariano
# Email: armijo.mariano@gmail.com

DEVICE=($(adb get-state))
ALMACENAMIENTO=/mnt/sdcard/

function obtenerDirectorios {

	echo -e && echo -e "Se está accediendo al directorio $ALMACENAMIENTO"
	echo -e && echo -e "Este proceso puede demorar algunos segundos"
	echo -e && echo -e "Por favor espere..."
	echo -e && echo -e "\a"

	# Creo un array con todos los elementos que se encuentran
	# en la ruta /mnt/sdcard
	array_directorios=($(adb shell ls -R $ALMACENAMIENTO))

	num_ficheros=0

	# Recupero la lista de directorios y ficheros
	# de la ruta /mnt/sdcard/ y sus subdirectorios
	for i in ${array_directorios[*]}
	do
	num_ficheros=$((num_ficheros+1))
	echo -e "$num_ficheros $i"
	done
}

function seleccionarContenidos {

	echo -e && echo -e "¿Desea hacer un backup completo? <S/n> \a"
	read respuesta

	if [ $respuesta = S ] || [ $respuesta = s ]

		then
		clear

		else
		if [ $respuesta = N ] || [ $respuesta = n ]

			then
			seleccionFicheros

			else
			echo -e && echo -e "Respuesta '$respuesta' incorrecta \a"
			echo -e && echo -e "Pulse una tecla para salir."
			read
			clear
			exit 0
		fi
	fi
}

# TO-DO
# En pruebas
function seleccionFicheros {

	echo -e && echo -e "Selecciona los ficheros que quieras guardar." && echo -e "\a"

	array_ficheros=($(adb shell ls $ALMACENAMIENTO))

	num_ficheros_1=0

	# Recupero la lista de directorios y ficheros
	# de la ruta /mnt/sdcard
	for i in ${array_ficheros[*]}
	do
	num_ficheros_1=$((num_ficheros_1++))
	echo -e "$num_ficheros_1 $i"
	done

	read fichero

	if [ $fichero -le $num_ficheros_1 ] && [ $fichero -gt 0 ]

		then
		echo -e "Fichero $fichero"

		else
		echo -e && echo -e "Selección '$fichero' incorrecta \a"
		echo -e && echo -e "Pulse una tecla para salir."
		read
		clear
		exit 0
	fi
}


function crearDirectorioBackup {

	RUTA=$(pwd)

	# Obtengo la fecha actual con el formato
	# Año, mes, día, horas, minutos y segundos
	NOMBRE_DIR=$(date +%Y_%m_%d_%H%M%S)

	# Designo una variable indicando dónde y con que nombre
	# se va a crear el directorio donde se almacenara el backup
	directorio_bak=$RUTA$NOMBRE_DIR
	echo -e "Creando directorio $directorio_bak"
	mkdir $directorio_bak
}

function copiarContenidos {

	echo -e "El tamaño del backup es de `adb shell du -sh $ALMACENAMIENTO`"
	echo -e "Copiando ficheros al directorio $directorio_bak\n"
	adb pull -p $ALMACENAMIENTO $directorio_bak

	echo -e "\n\nEl número de elementos copiados es de $num_ficheros"
	echo -e "\nOK, backup finalizado.\n"
}

if [ $DEVICE = device ]

	then
	clear
	obtenerDirectorios
	seleccionarContenidos
	crearDirectorioBackup
	copiarContenidos
	echo -e "FIN. \a"

	else
	echo -e "Ups algo falla..."
	echo -e "Instala los drivers del dispositivo, activa el modo de depuración, conéctalo y desbloquealo."
fi

exit 0
