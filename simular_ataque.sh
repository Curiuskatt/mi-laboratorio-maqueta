#!/bin/bash
TARGET_IP="127.0.0.1" 
PORT="4566"
echo "=================================================="
echo "🚀 LANZANDO SIMULACIÓN DE ATAQUE DESDE KALI LINUX"
echo "=================================================="
echo -e "\n[+] 1. Enviando petición maliciosa (admin_panel)..."
curl -i -H "User-Agent: Kali-Attack-Simulation" "http://$TARGET_IP:$PORT/admin_panel"
echo -e "\n[+] 2. Ejecutando escaneo rápido con Nmap..."
sudo nmap -sS -F $TARGET_IP
echo "=================================================="
echo "✅ SIMULACIÓN COMPLETADA."
echo "=================================================="
