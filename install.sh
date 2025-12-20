#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/tovaritx/bashrc-helper/main/contenido"
TMP_DIR="/tmp/bashrc-helper"

mkdir -p "$TMP_DIR"
cd "$TMP_DIR"

curl -fsSL "$BASE_URL/vimrc" -o vimrc
curl -fsSL "$BASE_URL/bashrc" -o bashrc
curl -fsSL "$BASE_URL/ssh" -o ssh



############################
# COLORES (alto contraste)
############################
RESET="\e[0m"
BLANCO="\e[97m"
NEGRO="\e[30m"
FSELEC="\e[44m"   # Azul
FNORMAL="\e[40m"  # Negro

pause() {
    echo
    read -rp "Pulsa Enter para continuar..."
}


############################
# FUNCIÓN ÚNICA
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
# MENÚ (solo textos)
#############################################################################################
opciones=(
  "Instalar vim / git y personalizar entorno"
  "Personalizar entorno bash"
  "Permitir ssh root"
  "Instalar utilidades btop / "
  "Salir"
)

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
            0) rm /root/.vimrc;rm /home/tovaritx/.vimrc;
               añadir_archivo "$BASE_URL/vimrc" "/home/tovaritx/.vimrc" "\""
               añadir_archivo "$BASE_URL/vimrc" "/root/.vimrc" "\""
               apt install vim git;pause
               vim +PlugInstall +qa;pause;;
            1) añadir_archivo "$BASE_URL/bashrc" "/root/.bashrc" "#"
               añadir_archivo "$BASE_URL/bashrc" "/home/tovaritx/.bashrc" "#"
	       pause
	       ;;
            2) añadir_archivo "$BASE_URL/ssh" "/etc/ssh/sshd_config" "#"
	       pause
	       ;;
	    3) apt install vim btop;pause
	       pause
	       ;;
            4) exit 0 ;;
        esac
####################################################################################################################
    fi
done
