netstat-help() {
    cat <<'EOF' | less -X

NETSTAT — RECORDATORIO RÁPIDO
============================

BÁSICO
------
netstat -tuln            puertos TCP/UDP escuchando
netstat -tulnp           igual + proceso (root)
netstat -an              todas las conexiones
netstat -rn              tabla de rutas

TCP
---
netstat -tan             conexiones TCP
netstat -tanp            TCP + proceso
netstat -ant | grep ESTABLISHED   conexiones activas

UDP
---
netstat -uan             conexiones UDP
netstat -uanp            UDP + proceso

PUERTOS
-------
netstat -tuln | grep :80        ver puerto 80
netstat -tulnp | grep LISTEN    servicios escuchando

ESTADOS TCP
-----------
LISTEN        esperando conexiones
ESTABLISHED   conexión activa
TIME_WAIT    esperando cierre
CLOSE_WAIT   cierre remoto
SYN_SENT     conexión iniciada
SYN_RECV     conexión recibida

ALTERNATIVAS
------------
ss -tuln             (reemplazo moderno de netstat)
ss -tulnp            ss + proceso

EOF
}
