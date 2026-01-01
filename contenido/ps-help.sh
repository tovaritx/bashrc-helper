ps-help() {
    cat <<'EOF' | less

PS — RECORDATORIO RÁPIDO
=======================

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
