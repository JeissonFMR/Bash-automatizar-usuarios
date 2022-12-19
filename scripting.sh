#!/bin/bash
#Authores: Jeisson Montenegro-Julieth Minayo

greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
purpleColour="\e[0;35m\033[1m"
yellowColour="\e[0;33m\033[1m"


function helpPanel(){
	echo -e "\n${greenColour} [!] Uso: ./scripting.sh -u [parametro] ${endColour}"
	echo -e "\n${greenColour} [!] EJEMPLO: ./scripting.sh -u listar_usuarios ${endColour}"
	for i in $(seq 1 80); do echo -ne "${greenColour}-"; done; echo -ne "${endColour}"
	echo -e "${purpleColour}\n\tlistar_todo\t Listar todos los usuarios (etc/passwd) ${endColour}"
	echo -e "${purpleColour}\n\tlistar_usuarios\t Listar usuarios registrados del sistema ${endColour}"
	echo -e "${purpleColour}\n\tcrear_usuario\t Crear nuevo usuario en el sistema ${endColour}"
	echo -e "${purpleColour}\n\tlistar_usuarios\t Eliminar usuario del sistema ${endColour}"

	exit 1
}
function listUserAll(){
	cat /etc/passwd | more
}

function listUsers(){
	echo -ne "${yellowColour}Los usuarios de su sistema son:\n ${endColour}"
	awk -F: '{if ($3 >= 1000 && $3<65534 || $3 == 0) {print $1}}' /etc/passwd

}

function createUser(){
		if [[ $(id -u) -ne 0 ]];then
		echo -e "${redColour}ERROR! DEBES SER ROOT PARA EJECUTAR ESTA OPCIÓN ${endColour}"
			exit 1
		fi
		echo -e "${greenColour}Digite el nombre del usuario a crear${endColour}"
		read new_user
		adduser $new_user
		echo -ne "${greenColour}El usuario $new_user ha sido creado con su directorio home ${endColour}"

}


function deleteUser(){
		if [[ $(id -u) -ne 0 ]];then
		echo -e "${redColour}ERROR! DEBES SER ROOT PARA EJECUTAR ESTA OPCIÓN ${endColour}"		
			exit 1
		fi
		echo -e "${redColour} El usuario se eliminará junto con su directorio personal ${endColour}"
		echo -e "${greenColour}Digite el nombre del usuario a eliminar${endColour}"
		read delete_user
		deluser $delete_user
		rm -rf /home/$delete_user
		echo -ne "${greenColour}El usuario $delete_user ha sido eliminado con su directorio home${endColour}"

}

parameter_counter=0; while getopts "u:h:" arg; do
	case $arg in
		u) option=$OPTARG; let parameter_counter+=1;;
		h) helpPanel;;
	esac

done

if [ $parameter_counter -eq 0 ]; then
	helpPanel
else
	if [ "$(echo $option)" == "listar_usuarios" ]; then
		listUsers

	elif [ "$(echo $option)" == "crear_usuario"  ]; then
		createUser

	elif [ "$(echo $option)" == "eliminar_usuario" ]; then
		deleteUser

	elif [ "$(echo $option)" == "listar_todo" ]; then
		listUserAll
	fi
fi

