tmux-help() {
    cat <<'EOF'

TMUX — RECORDATORIO RÁPIDO
=========================

SESIONES
--------
tmux new -s nombre        crear sesión
tmux ls                   listar sesiones
tmux attach -t nombre     entrar en sesión
tmux kill-session -t nom  cerrar sesión

VENTANAS (prefix = Ctrl-b)
--------------------------
c       nueva ventana
,       renombrar ventana
n / p   siguiente / anterior
&       cerrar ventana

PANELES
-------
%       split vertical
"       split horizontal
o       cambiar panel
x       cerrar panel
z       zoom panel

BÁSICO
------
d       detach
?       ver todas las teclas

EOF
}
