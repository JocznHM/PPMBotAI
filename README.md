# PPMBotAI
# 🤖 Bot Automatizado para WhatsApp con n8n, LLaMA 3 y EvolutionAPI

Bot automatizado para WhatsApp basado en **n8n**, **LLaMA 3** y **EvolutionAPI**, usando contenedores Docker.  
Este proyecto permite crear flujos automatizados de atención, responder preguntas frecuentes, y escalar consultas a un modelo de lenguaje avanzado (**LLaMA 3**) cuando no se encuentra una coincidencia directa.

Incluye un entorno listo para producción con soporte para **Ngrok**, lo que permite exponer servicios locales para pruebas desde dispositivos móviles.

---

## 🧰 Tecnologías utilizadas

- **EvolutionAPI**: Conexión con WhatsApp Web.
- **n8n**: Motor de flujos automatizados sin código.
- **LLaMA 3**: Modelo de lenguaje para respuestas dinámicas e inteligentes.
- **Ngrok**: Exposición de APIs locales para desarrollo y pruebas externas.
- **Docker + Docker Compose**: Orquestación y despliegue de servicios.

---

## 🐳 Arquitectura

Todo el sistema se ejecuta mediante contenedores usando `docker-compose`, lo que permite una instalación rápida, modular y portable.

