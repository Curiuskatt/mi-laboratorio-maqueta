# Laboratorio de Simulación de Ataque y Detección (IDS + LocalStack)

Este laboratorio es una maqueta de pruebas diseñada para simular tráfico no autorizado orientado a servicios expuestos en la nube y evaluar la capacidad de detección en tiempo real utilizando un IDS (Suricata).

## 🏗️ Arquitectura de la Maqueta

* **Entorno del Atacante / Monitor:** Kali Linux.
* **Infraestructura Simulada:** Contenedor Docker ejecutando **LocalStack** (simulando servicios AWS como S3 en el puerto `4566`).
* **Sistema de Detección (IDS):** **Suricata**, inspeccionando el tráfico de red de la interfaz del contenedor.
---

## 🔄 Flujo de Trabajo y Funcionamiento

1. **Despliegue del Servicio:** Se levanta un entorno emulado en la nube con `docker-compose` ejecutando LocalStack.
2. **Monitoreo en Tiempo Real:** Suricata analiza los paquetes que pasan por la interfaz de red (`docker0` o `lo`) evaluando las reglas personalizadas cargadas en `local.rules`.
3. **Simulación del Ataque:** Se realiza una petición HTTP hacia un punto de acceso sensible o panel simulado (`/admin_panel`).
4. **Detección y Registro:** Suricata identifica el patrón en la Capa 7 (HTTP URI), hace coincidir la firma y genera una entrada de alerta inmediata en `/var/log/suricata/fast.log` y `eve.json`.

---

## 🚀 Instrucciones de Ejecución

### 1. Iniciar el entorno emulado
```bash
cd maqueta-nube
sudo docker-compose up -d

Iniciar la inspección con Suricata
sudo suricata -c /etc/suricata/suricata.yaml -i docker0 -k none

Ejecutar la prueba de intrusión

curl -i "http://localhost:4566/admin_panel"


---

### Parte 3: Verificación de Alertas

```markdown
---

## 📊 Verificación de Alertas

Para comprobar la correcta detección del evento, monitorea los logs del IDS:

```bash
sudo tail -f /var/log/suricata/fast.log

---

Resultado esperado:
[**] [1:1000001:1] ALERTA LABORAL: Intento de acceso a panel administrativo [**] [Classification: Unknown Traffic] [Priority: 3] {HTTP} 127.0.0.1:XXXXX -> 127.0.0.1:4566
