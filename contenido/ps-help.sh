#!/bin/bash

ps-help() {
    cat <<'EOF' | less -RX

PS — RECORDATORIO RÁPIDO
========================

BÁSICO
------
ps                    procesos del shell actual
ps -e                 todos los procesos
ps -ef                formato completo (estilo SysV)
ps aux                formato BSD (muy usado)

FILTRAR
-------
ps aux | grep nombre          buscar proceso
ps -ef | grep nombre
ps -C nombre                 por nombre exacto
ps -p PID                    por PID

ORDENAR
-------
ps aux --sort=-%cpu          ordenar por CPU
ps aux --sort=-%mem          ordenar por memoria
ps -eo pid,cmd,%cpu,%mem     salida personalizada

ÁRBOL
-----
ps -ef --forest              árbol de procesos
ps axjf                      árbol (BSD style)

USUARIO
-------
ps -u usuario                procesos de un usuario
ps -U usuario                procesos reales del usuario
ps -o user,pid,cmd           mostrar usuario

ESTADOS
-------
R   running
S   sleeping
D   waiting (IO)
T   stopped
Z   zombie

COMBINACIONES ÚTILES
-------------------
ps aux | less                paginar salida
ps -eo pid,ppid,cmd --forest árbol limpio
ps aux | awk '{print $2,$11}' listar PID y comando

EOF
}
