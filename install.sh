#!/bin/bash
#############################################################################################
# DEFINICIONES
#############################################################################################
BASE_URL="https://raw.githubusercontent.com/tovaritx/bashrc-helper/main/contenido"
TMP_DIR="/tmp/bashrc-helper"
echo "Preparando entorno..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
echo "Descargando archivos..."
curl -fsSL "$BASE_URL/vimrc"  -o "$TMP_DIR/vimrc"
curl -fsSL "$BASE_URL/bashrc" -o "$TMP_DIR/bashrc"
curl -fsSL "$BASE_URL/ssh"    -o "$TMP_DIR/ssh"



#############################################################################################
# MENÚS (SOLO TEXTOS)
#############################################################################################
MENU_PRINCIPAL=(
  "Personalizar vim"
  "Personalizar entorno bash"
  "Permitir SSH root"
  "Instalar programas consola"
  "Instalar ProxMenux"
  "Submenú programas"
  "Salir"
)
# Colores
COLOR_SEL_PRINCIPAL="\e[44m"   # azul selección
COLOR_NORM_PRINCIPAL="\e[100m"  # gris oscuro no seleccionada

MENU_SISTEMA=(
  "Ejecutar btop"
  "Volver"
)
# Colores
COLOR_SEL_SISTEMA="\e[45m"    # magenta selección
COLOR_NORM_SISTEMA="\e[100m"  # gris oscuro no seleccionada

#############################################################################################
# ACCIONES ASOCIADAS A MENÚS
#############################################################################################
ACCIONES_PRINCIPAL=(
  _vim
  _bash
  _ssh
  _instalar
  _proxmenux
  _menu_programas
  _salir
)

ACCIONES_SISTEMA=(
  _eproxmenux
  _btop
  _volver
)

#############################################################################################
# ACCIONES
#############################################################################################
_eproxmenux() {
  menu
}
_proxmenux() {
  bash -c "$(wget -qLO - https://raw.githubusercontent.com/MacRimi/ProxMenux/main/install_proxmenux.sh)"
  pause
}
_vim() {
    clear
    rm -f /root/.vimrc /home/tovaritx/.vimrc
    añadir_archivo "$TMP_DIR/vimrc" "/home/tovaritx/.vimrc" "\""
    añadir_archivo "$TMP_DIR/vimrc" "/root/.vimrc" "\""
    pause
}

_bash() {
    clear
    añadir_archivo "$TMP_DIR/bashrc" "/root/.bashrc" "#"
    añadir_archivo "$TMP_DIR/bashrc" "/home/tovaritx/.bashrc" "#"
    pause
}

_ssh() {
    clear
    añadir_archivo "$TMP_DIR/ssh" "/etc/ssh/sshd_config" "#"
    systemctl restart ssh
    pause
}

_instalar() {
    clear
    apt install -y vim git btop
    vim +PlugInstall +qa
    pause
}

_btop() {
  btop
}

_salir() {
    clear
    exit 0
}

_volver() {
    return 1
}

_menu_programas() {
    menu_loop MENU_SISTEMA ACCIONES_SISTEMA "$COLOR_SEL_SISTEMA" "$COLOR_NORM_SISTEMA"
}


#############################################################################################
# COLORES (ALTO CONTRASTE)
#############################################################################################
RESET="\e[0m"
BLANCO="\e[97m"
FSELEC="\e[44m"
FNORMAL="\e[40m"

#############################################################################################
# PAUSA
#############################################################################################
pause() {
    echo
    read -rp "Pulsa Enter para continuar..."
}

#############################################################################################
# AÑADIR ARCHIVO A OTRO (CON ETIQUETAS)
#############################################################################################
añadir_archivo() {
    local origen="$1"
    local destino="$2"
    local com="$3"

    local ini="${com} ===== Inicio de $origen ====="
    local fin="${com} ===== Fin de $origen ====="

    [[ ! -f "$origen" ]] && echo "No existe $origen" && return

    if ! grep -Fxq "$ini" "$destino" 2>/dev/null; then
        {
            echo
            echo "$ini"
            cat "$origen"
            echo "$fin"
        } >> "$destino"
        echo "Añadido correctamente en $destino"
    else
        echo "Ya existe en $destino"
    fi
}




#############################################################################################
# MOTOR DE MENÚ (GENÉRICO)
#############################################################################################
menu_loop() {
    local -n _opciones=$1
    local -n _acciones=$2
    local COLOR_SEL=${3:-$FSELEC}   # color selección, por defecto azul
    local COLOR_NORM=${4:-$FNORMAL} # color normal, por defecto negro
    local seleccion=0
    local total=${#_opciones[@]}

    while true; do
        clear
        echo
        echo "  CONFIGURADOR Y PROGRAMAS TERMINAL 3"
        echo "  ────────────────────────────────────"
        echo

        for i in "${!_opciones[@]}"; do
          if [[ $i -eq $seleccion ]]; then
              printf "  ${COLOR_SEL}${BLANCO} >> %-40s ${RESET}\n" "${_opciones[i]}"
          else
              printf "  ${COLOR_NORM}${BLANCO}   %-40s ${RESET}\n" "${_opciones[i]}"
          fi
        done

        echo
        echo "  ↑ ↓ mover   Enter seleccionar"

        read -rsn1 tecla

        if [[ $tecla == $'\x1b' ]]; then
            read -rsn1 -t 0.1 siguiente_tecla 2>/dev/null || siguiente_tecla=""
            if [[ $siguiente_tecla == "[" ]]; then
                read -rsn1 tecla  # flechas
                [[ $tecla == "A" ]] && ((seleccion--))
                [[ $tecla == "B" ]] && ((seleccion++))
                ((seleccion<0)) && seleccion=$((total-1))
                ((seleccion>=total)) && seleccion=0
            else
                # ESC solo → salir del menú/submenú
                return
            fi
        elif [[ $tecla == "" ]]; then
            if declare -f "${_acciones[$seleccion]}" >/dev/null; then
                "${_acciones[$seleccion]}"
                [[ $? -eq 1 ]] && return
            else
                echo "Acción no definida"
                pause
            fi
        fi
    done
}


#############################################################################################
# ARRANQUE
#############################################################################################
menu_loop MENU_PRINCIPAL ACCIONES_PRINCIPAL "$COLOR_SEL_PRINCIPAL" "$COLOR_NORM_PRINCIPAL"

