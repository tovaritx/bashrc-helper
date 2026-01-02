docker-help() {
    cat <<'EOF' | less -X
DOCKER — RECORDATORIO RÁPIDO
============================

IMÁGENES
--------
docker pull <imagen>          descargar imagen
docker build -t nombre .      construir imagen desde Dockerfile
docker images                 listar imágenes
docker rmi <imagen>           eliminar imagen

CONTENEDORES
------------
docker run -it --name nombre imagen   crear y ejecutar contenedor interactivo
docker ps [-a]                        listar contenedores activos / todos
docker stop <contenedor>              detener contenedor
docker start <contenedor>             iniciar contenedor detenido
docker restart <contenedor>           reiniciar contenedor
docker rm <contenedor>                eliminar contenedor

CONEXIÓN
--------
docker exec -it <contenedor> bash     abrir shell dentro del contenedor
docker logs <contenedor>              ver logs del contenedor

REDES Y VOLUMENES
-----------------
docker network ls                     listar redes
docker network rm <red>               eliminar red
docker volume ls                      listar volúmenes
docker volume rm <volumen>            eliminar volumen

OTROS
-----
docker system prune -a                limpiar contenedores, imágenes y redes no usados
docker info                           información del sistema Docker

EOF
}
