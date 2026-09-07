 mi-laboratorio-maqueta

Este laboratorio práctico integra un entorno de nube simulado localmente y un **Sistema de Detección de Intrusos (IDS) con Suricata**. El objetivo es interceptar y alertar sobre patrones de tráfico sospechosos o ataques dirigidos lanzados desde entornos de prueba como **Kali Linux**.

## 🗺️ Estructura del Proyecto

El repositorio está organizado en dos componentes principales:
* `maqueta-nube/`: Contiene el despliegue de infraestructura local (LocalStack) emulando servicios de AWS.
* `maqueta-suricata/`: Aloja las configuraciones del motor IDS y el archivo de firmas de seguridad personalizadas.

[ Kali Linux / Atacante ] ──(Peticiones HTTP/Escaneos)──► [ Maqueta Nube / LocalStack ]│(Tráfico Espejado / Monitoreado)▼[ SURICATA IDS ]│(Gatilla local.rules)▼[ Alerta en eve.json ]
## 🛠️ Levantamiento del Entorno

### 1. Despliegue de la Maqueta de Nube
La infraestructura cloud emula un entorno AWS (S3) utilizando **LocalStack**. Para levantarlo de forma local en tu máquina o servidor, posiciónate en la carpeta correspondiente y ejecuta Docker:
```bash
cd maqueta-nube
docker-compose up -d
```

### 2. Inyección de Reglas en Suricata
Para que Suricata detecte el ataque de la simulación, asegúrate de que el motor de firmas incluya tu archivo local. Añade o verifica que tu regla en `maqueta-suricata/local.rules` contenga la firma de detección:
```text
alert http any any -> any any (msg:"ALERTA LABORAL: Intento de acceso a panel administrativo simulado"; content:"admin_panel"; sid:1000001; rev:1;)
```
*Asegúrate de copiar este archivo a la ruta de firmas operativas de tu Suricata (`/etc/suricata/rules/local.rules`) y reiniciar el servicio.*

## ⚔️ Levantamiento de la Simulación en Kali Linux

Para probar la efectividad de la regla implementada, utilizaremos **Kali Linux** para simular tráfico malicioso web dirigido hacia la interfaz web expuesta o los servicios de la maqueta.

### Paso 1: Crear el Script de Ataque Automatizado
Crea un script llamado `simular_ataque.sh` en tu entorno de Kali Linux para automatizar las ráfagas de prueba:

```bash
cat << 'EOF' > simular_ataque.sh
#!/bin/bash
# Reemplaza con la IP real del servidor donde corre LocalStack/Suricata
TARGET_IP="127.0.0.1" 
PORT="4566"

echo "=================================================="
echo "🚀 INICIANDO SIMULACIÓN DE ATAQUE DESDE KALI LINUX"
echo "=================================================="

echo -e "\n[+] Enviando petición maliciosa para activar firma (admin_panel)..."
curl -s -H "User-Agent: Kali-Attack-Simulation" "http://\(TARGET_IP:\)PORT/admin_panel"

echo -e "\n[+] Realizando escaneo de reconocimiento rápido..."
nmap -sS -F \$TARGET_IP

echo "=================================================="
echo "✅ SIMULACIÓN FINALIZADA. Verifica los logs de Suricata."
echo "=================================================="
EOF
chmod +x simular_ataque.sh
```

### Paso 2: Ejecutar el ataque
Corre el script desde la terminal de Kali Linux:
```bash
./simular_ataque.sh
```

## 🔬 Monitoreo de Alertas en Suricata

Mientras se ejecuta el ataque en la máquina de Kali Linux, verifica en tiempo real cómo Suricata procesa el paquete y gatilla la alerta configurada en tu repositorio.

Ejecuta el siguiente comando en la máquina que aloja Suricata:

```bash
sudo tail -f /var/log/suricata/eve.json | jq -rc '
  select(.event_type=="alert") | 
  "[\(.timestamp)] 🚨 \(.alert.signature) | Origen: \(.src_ip):\(.src_port) -> Destino: \(.dest_ip):\(.dest_port)"
'
```
