systemctl-help() {
    cat <<'EOF' | less -X

SYSTEMCTL — RECORDATORIO RÁPIDO
==============================

SERVICIOS
---------
systemctl status servicio        estado del servicio
systemctl start servicio         iniciar servicio
systemctl stop servicio          detener servicio
systemctl restart servicio       reiniciar servicio
systemctl reload servicio        recargar configuración
systemctl enable servicio        activar al arranque
systemctl disable servicio       desactivar al arranque

ESTADO GENERAL
--------------
systemctl list-units --type=service
systemctl list-units --type=service --state=running
systemctl list-unit-files --type=service

LOGS (journal)
--------------
journalctl -u servicio           logs del servicio
journalctl -u servicio -f        logs en tiempo real
journalctl -xe                  últimos errores
journalctl --since today         logs de hoy

ARRANQUE
--------
systemctl is-enabled servicio    comprobar si arranca
systemctl is-active servicio     comprobar si está activo
systemctl daemon-reexec          reiniciar systemd
systemctl daemon-reload          recargar unidades

APAGADO / REINICIO
------------------
systemctl reboot                 reiniciar sistema
systemctl poweroff               apagar sistema
systemctl suspend                suspender

TIEMPOS DE ARRANQUE
-------------------
systemd-analyze time
systemd-analyze blame
systemd-analyze critical-chain

EOF
}
