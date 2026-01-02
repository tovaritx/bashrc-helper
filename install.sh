#!/bin/bash
#############################################################################################
# DEFINICIONES
#############################################################################################
VERSION="0.7"
BASE_URL="https://raw.githubusercontent.com/tovaritx/bashrc-helper/main/contenido" 
BASE_REPO="tovaritx/bashrc-helper"
PATH_HELPERS="contenido"
HELPERS_DIR="/usr/local/share/bash-helpers"
TMP_DIR="/tmp/bashrc-helper"

echo "Preparando entorno..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
mkdir -p "$HELPERS_DIR"

echo "Descargando archivos..."
curl -fsSL "$BASE_URL/vimrc"  -o "$TMP_DIR/vimrc"
curl -fsSL "$BASE_URL/bashrc" -o "$TMP_DIR/bashrc"
curl -fsSL "$BASE_URL/ssh"    -o "$TMP_DIR/ssh"

#############################################################################################
# MENÚS (SOLO TEXTOS)
#############################################################################################
MENU_PRINCIPAL=(
  "➤ Personalizar vim                            "
  "➤ Personalizar entorno bash                   "
  "➤ Permitir SSH root                           "
  "➤ Permitir sudo a tovaritx sin contraseña     "
  "➤ Instalar programas consola                  "
  "➤ Instalar ayudantes consola                  "
  "➤ Instalar ProxMenux                          "
  "➤➤ Submenú programas                         "
  "➤➤ Submenú ayudantes comandos comunes        "
  "↩ Salir                                       "
)
# Colores
COLOR_SEL_PRINCIPAL="\e[1;44m"   # azul selección
COLOR_NORM_PRINCIPAL="\e[100m"  # gris oscuro no seleccionada

###############################################################################################

MENU_SISTEMA=(
  "▶ Ejecutar ProxMenux                           "
  "▶ Ejecutar btop                                "
  "↩ Volver                                       "
)
# Colores
COLOR_SEL_SISTEMA="\e[1;45m"    # magenta selección
COLOR_NORM_SISTEMA="\e[100m"  # gris oscuro no seleccionada

#############################################################################################
# ACCIONES ASOCIADAS A MENÚS
#############################################################################################
ACCIONES_PRINCIPAL=(
  _vim
  _bash
  _ssh
  _sudo
  _instalar
  _instalar_ayudantes
  _proxmenux
  _menu_programas
  _menu_ayudantes_auto
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
_sudo(){
  echo "tovaritx ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/tovaritx && sudo chmod 440 /etc/sudoers.d/tovaritx
  pause
}
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

_instalar_ayudantes(){
  clear
  # Crear directorio si no existe
  mkdir -p "$HELPERS_DIR"
  # Descargar helpers desde GitHub si no existen
  #if [[ $(ls "$HELPERS_DIR"/*-help.sh 2>/dev/null | wc -l) -eq 0 ]]; then
      echo "Descargando helpers..."
      curl -fsSL "https://api.github.com/repos/$REPO/contents/$PATH_HELPERS" \
          | grep '"name":' \
          | cut -d '"' -f4 \
          | grep '\-help\.sh$' \
          | while read -r f; do
              echo "  $f"
              curl -fsSL "https://raw.githubusercontent.com/$REPO/main/$PATH_HELPERS/$f" \
                  -o "$HELPERS_DIR/$f"
          done
  #fi
  añadir_archivo "$TMP_DIR/bashrc" "/root/.bashrc" "#"
  añadir_archivo "$TMP_DIR/bashrc" "/home/tovaritx/.bashrc" "#"
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
    apt install -y vim git btop tmux
    vim +PlugInstall +qa
    cd /root
    wget https://github.com/arsham/figurine/releases/download/v1.3.0/figurine_linux_amd64_v1.3.0.tar.gz -O /root/figurine.tar.gz
    tar xzvf /root/figurine.tar.gz
    cp /root/deploy/figurine /usr/local/bin/
    echo "#!/bin/sh" > /etc/update-motd.d/99-figurine
    echo "figurine -f Star\ Wars.flf '$(hostname)'" >> /etc/update-motd.d/99-figurine
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

################################################################################
# Comprobar si se está ejecutando como root
################################################################################
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[1;31m✖ Este script debe ejecutarse como root. Saliendo...\e[0m"
    exit 1
fi

#############################################################################################
# COLORES (ALTO CONTRASTE)
#############################################################################################
RESET="\e[0m"
BLANCO="\e[97m"
FSELEC="\e[44m"
FNORMAL="\e[40m"


# Colores normales
NEGRO="\e[30m"
ROJO="\e[31m"
VERDE="\e[32m"
AMARILLO="\e[33m"
AZUL="\e[34m"
MAGENTA="\e[35m"
CIAN="\e[36m"
BLANCO="\e[37m"

# Colores con brillo (bold)
BNEGRO="\e[1;30m"
BROJO="\e[1;31m"
BVERDE="\e[1;32m"
BAMARILLO="\e[1;33m"
BAZUL="\e[1;34m"
BMAGENTA="\e[1;35m"
BCIAN="\e[1;36m"
BBLANCO="\e[1;37m"
#############################################################################################
# PAUSA
#############################################################################################
pause() {
    echo
    read -rp "Pulsa Enter para continuar..."
}

#############################################################################################
# SUBMENU DE AYUDANTES
#############################################################################################
_menu_ayudantes_auto() {
    local helpers=()
    local acciones=()

    shopt -s nullglob

    for f in "$HELPERS_DIR"/*-help.sh; do
        local base nombre funcion

        base=$(basename "$f" .sh)
        nombre="${base%-help}"
        funcion="$base"

        helpers+=( "Ayuda $nombre" )
        acciones+=( "_run_helper_$funcion" )

        eval "
        _run_helper_$funcion() {
            source \"$f\"
            $funcion
        }
        "
    done

    shopt -u nullglob

    helpers+=( "Volver" )
    acciones+=( "_volver" )

    menu_loop helpers acciones "$COLOR_SEL_SISTEMA" "$COLOR_NORM_SISTEMA"
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

    if grep -Fxq "$ini" "$destino" 2>/dev/null; then
        # Eliminar bloque existente
        sed -i.bak "/^$(printf '%s' "$ini" | sed 's/[\/&]/\\&/g')$/,/^$(printf '%s' "$fin" | sed 's/[\/&]/\\&/g')$/d" "$destino"
        echo "Reescrito contenido de $origen en $destino"
    else
        echo "Añadiendo $origen en $destino"
    fi

    {
        echo
        echo "$ini"
        cat "$origen"
        echo "$fin"
    } >> "$destino"
}


#############################################################################################
# QUITAR UN ARCHIVO A OTRO
#############################################################################################
quitar_archivo() {
    local origen="$1"
    local destino="$2"
    local com="$3"

    local ini="${com} ===== Inicio de $origen ====="
    local fin="${com} ===== Fin de $origen ====="

    if ! grep -Fxq "$ini" "$destino" 2>/dev/null; then
        echo "No existe $origen en $destino"
        return
    fi

    sed -i.bak "/^$(printf '%s' "$ini" | sed 's/[\/&]/\\&/g')$/,/^$(printf '%s' "$fin" | sed 's/[\/&]/\\&/g')$/d" "$destino"

    echo "Eliminado $origen de $destino"
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
        echo -e "${BBLANCO}  CONFIGURADOR Y PROGRAMAS TERMINAL ${VERSION}"
        echo -e          "  ────────────────────────────────────────"
        echo -e "${BVERDE} ℹ Una vez ejecutado por 1ª vez, este menu es accesible con el comando 'tvx'${RESET}"
        echo

        for i in "${!_opciones[@]}"; do
          if [[ $i -eq $seleccion ]]; then
              printf "  ${COLOR_SEL}${BLANCO} >> %-40s ${RESET}\n" "${_opciones[i]}"
          else
              printf "  ${COLOR_NORM}${BLANCO}   %-40s ${RESET}\n" "${_opciones[i]}"
          fi
        done

        echo
        echo -e "${BBLANCO}  ↑ ↓ mover   ${BAMARILLO}Enter seleccionar${RESET}"

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

