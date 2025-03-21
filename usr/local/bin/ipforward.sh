#!/bin/bash

# Función principal
ipforward() {
    sysctl -w net.ipv4.ip_forward=1
}

# Verificar permisos usando case
case "$EUID" in
    0)  # Usuario ya es root: ejecutar sin sudo
        ipforward
        ;;
    *)  # Usuario no es root: intentar con sudo
        if command -v sudo &> /dev/null; then
            sudo --validate 2> /dev/null  # ¿Tiene permisos sudo?
            if [ $? -eq 0 ]; then
                sudo sysctl -w net.ipv4.ip_forward=1
            else
                echo "[ERROR] Necesitas ser root o tener permisos sudo."
                exit 1
            fi
        else
            echo "[ERROR] 'sudo' no está instalado. Ejecuta como root."
            exit 1
        fi
        ;;
esac
