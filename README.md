# Config-Flutter
Configuracion Flutter Windows

Script automatizado (Batch) para montar el entorno de desarrollo completo en `C:\dev` a base de descargas directas por cURL. Cero bloatware, cero Android Studio, cero Winget.

## Qué instala
Descarga los ZIPs oficiales, los extrae y configura:
- Java JDK 21
- Gradle 8.6
- Flutter SDK (3.41.2)
- Android SDK (Command Line Tools, API 35, Build-Tools, ADB)

## Uso
1. Haz clic derecho sobre el `.bat` y selecciona **Ejecutar como administrador** (obligatorio).
2. Sigue las opciones del menú numérico en la consola.
3. El script creará `C:\dev` automáticamente si no existe.
4. Si utilizas la opción para configurar las variables de entorno, **debes reiniciar la PC** al finalizar.

## Advertencia
La opción 6 inyecta rutas directamente en la variable `PATH` global de Windows usando `setx`. Si tu `PATH` ya estaba cerca del límite de 1024 caracteres, Windows podría truncarlo. Úsalo bajo tu propio riesgo.
