journal-help() {
    cat <<'EOF' | less

JOURNALCTL — RECORDATORIO RÁPIDO
===============================

BÁSICO
------
journalctl                     ver todos los logs
journalctl -xe                 últimos errores importantes
journalctl -f                  seguir logs en tiempo real

POR SERVICIO
------------
journalctl -u servicio         logs de un servicio
journalctl -u servicio -f      logs en tiempo real del servicio
journalctl -u servicio --since today

POR TIEMPO
----------
journalctl --since today
journalctl --since yesterday
journalctl --since "2024-01-01"
journalctl --since "1 hour ago"

ARRANQUE
--------
journalctl -b                  logs del arranque actual
journalctl -b -1               arranque anterior
journalctl --list-boots        listar arranques

FILTRAR
-------
journalctl | grep texto
journalctl -p err              solo errores
journalctl -p warning          warnings y errores
journalctl -p info             info, warning y errores

USUARIO / KERNEL
----------------
journalctl _UID=1000           logs de un usuario
journalctl -k                  logs del kernel
journalctl -k -b               kernel del arranque actual

LIMPIEZA
--------
journalctl --disk-usage        uso de disco
journalctl --vacuum-time=7d    borrar logs > 7 días
journalctl --vacuum-size=500M  limitar tamaño del journal

EOF
}
