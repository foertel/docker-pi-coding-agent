#!/bin/bash

IMAGE_NAME=pi-agent
CONTAINER_NAME="pi-agent-$(basename "$(pwd)")"
USER_NAME=node

ACTION="${1:-attach}"

# Check if image exists, build via upgrade if not
ensure_image() {
    if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
        echo "Image '$IMAGE_NAME' not found. Building it first..."
        "$0" upgrade
    fi
}

case "$ACTION" in
    start)
        ensure_image

        # if you want to mount rootless docker.sock, add this
        # -v /var/run/docker.sock:/var/run/docker.sock:ro \
        docker run --rm -d \
            --net host \
            --env-file ~/.pi/.env \
            -v "$(pwd)":"$(pwd)" \
            -v ~/.pi:/home/$USER_NAME/.pi \
            -w "$(pwd)" \
            --name "$CONTAINER_NAME" \
            "$IMAGE_NAME"
        ;;

    attach)
        if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
            echo "Container not running. Starting it first..."
            "$0" start
        fi
        docker exec -it "$CONTAINER_NAME" bash
        ;;

    upgrade)
        docker stop "$CONTAINER_NAME" 2>/dev/null
        docker rm "$CONTAINER_NAME" 2>/dev/null
        docker build --pull --no-cache -t "$IMAGE_NAME" .
        ;;

    stop)
        docker stop "$CONTAINER_NAME" 2>/dev/null
        docker rm "$CONTAINER_NAME" 2>/dev/null
        ;;

    *)
        echo "Usage: $0 {start|attach|stop|upgrade}"
        exit 1
        ;;
esac
