#!/bin/bash
#############################################################################################
# definiciones
#############################################################################################
BASE_URL="https://raw.githubusercontent.com/tovaritx/bashrc-helper/main/contenido"
TMP_DIR="/tmp/bashrc-helper"

#############################################################################################
# MENÚ (solo textos)
#############################################################################################
opciones=(
  "0) Instalar vim / git y personalizar entorno"
  "1) Personalizar entorno bash"
  "2) Permitir ssh root"
  "3) Instalar utilidades btop / "
  "4) Salir"
)

###############################################################################################
# ACCIONES DEL MENÚ
###############################################################################################

accion0() {
    rm /root/.vimrc; rm /home/tovaritx/.vimrc;
    añadir_archivo "$TMP_DIR/vimrc" "/home/tovaritx/.vimrc" "\""
    añadir_archivo "$TMP_DIR/vimrc" "/root/.vimrc" "\""
    apt install vim git; pause
    vim +PlugInstall +qa; pause
}

accion1() {
    añadir_archivo "$TMP_DIR/bashrc" "/root/.bashrc" "#"
    añadir_archivo "$TMP_DIR/bashrc" "/home/tovaritx/.bashrc" "#"
	pause
}

accion2() {
    añadir_archivo "$TMP_DIR/ssh" "/etc/ssh/sshd_config" "#"
	pause
}
accion3() {
    apt install vim btop
	pause
}
accion4() {
    exit 0
}

#####################################################################
# INSTALACION DESDE GITHUB
#####################################################################
install() {
	echo "Borrando archivos instalaciones anteriores..."
	rm -rf "$TMP_DIR"
	mkdir -p "$TMP_DIR"
	cd "$TMP_DIR"
	
	echo "Descargando archivos..."
	curl -fsSL "$BASE_URL/vimrc" -o vimrc
	curl -fsSL "$BASE_URL/bashrc" -o bashrc
	curl -fsSL "$BASE_URL/ssh" -o ssh
}

############################
# COLORES (alto contraste)
############################
RESET="\e[0m"
BLANCO="\e[97m"
NEGRO="\e[30m"
FSELEC="\e[44m"   # Azul
FNORMAL="\e[40m"  # Negro

############################
# Pulsa una tecla
############################
pause() {
    echo
    read -rp "Pulsa Enter para continuar..."
}


############################
# añade un archivo a otro archivo y comprueba si ya lo hizo antes
############################
añadir_archivo() {
    local origen="$1"
    local destino="$2"
    local com="$3"

    local ini="${com} ===== Inicio de $origen ====="
    local fin="${com} ===== Fin de $origen ====="

    [[ ! -f "$origen" ]] && echo "No existe $origen" && return

    if ! grep -Fxq "$ini" "$destino"; then
        {
            echo
            echo "$ini"
            cat "$origen"
            echo "$fin"
        } >> "$destino"
        echo "Añadido correctamente."
    else
        echo "Ya existe en $destino."
    fi
}



############################
# DIBUJO DEL MENÚ
############################
dibujar_menu() {
    clear
    echo
    echo "  CONFIGURADOR Y PROGRAMAS TERMINAL"
    echo "  ─────────────────────────────────"
    echo

    for i in "${!opciones[@]}"; do
        if [[ $i -eq $seleccion ]]; then
            printf "  ${FSELEC}${BLANCO} ▶ %-30s ${RESET}\n" "${opciones[i]}"
        else
            printf "  ${FNORMAL}${BLANCO}   %-30s ${RESET}\n" "${opciones[i]}"
        fi
    done

    echo
    echo "  ↑ ↓ mover   Enter seleccionar"
}

############################
# LOOP PRINCIPAL
############################
seleccion=0
total=${#opciones[@]}

install

while true; do
    dibujar_menu
    read -rsn1 tecla

    if [[ $tecla == $'\x1b' ]]; then
        read -rsn2 tecla
        [[ $tecla == "[A" ]] && ((seleccion--))
        [[ $tecla == "[B" ]] && ((seleccion++))
        ((seleccion<0)) && seleccion=$((total-1))
        ((seleccion>=total)) && seleccion=0

    elif [[ $tecla == "" ]]; then
        clear
##################################################################################################################
        case $seleccion in
            0) accion0;;
            1) accion1;;
            2) accion2;;
	        3) accion3;;
            4) accion4;;
            5) accion5;;
            6) accion6;;
            7) accion7;;
            8) accion8;;
            9) accion9;;
            10) accion10;;
            11) accion11;;
            12) accion12;;
            13) accion13;;
        esac
####################################################################################################################
    fi
done
