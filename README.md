# DESPLIEGUE EN VERCEL

## Descripcion general

No he creado los archivos en una segunda rama porque pensaba que no necesitaría solo esos archivos y ya.
Primeramente, he desplegado el proyecto tal cual con esos archivos en vercel y me ha saltado un error de que la version del runtime no era correcta. He tenido que cambiar la version de lo siguiente:
```json
"api/index.php": { "runtime": "vercel-php@0.7.1" }
```
Del archivo `vercel.json`. 
Luego he ido a las configuraciones del proyecto en vercel y he cambiado la version del node.js a una compatible.

[![Image from Gyazo](https://i.gyazo.com/f5357452b3e461acee8fbe73aa7a98b8.png)](https://gyazo.com/f5357452b3e461acee8fbe73aa7a98b8)

He seguido el despliegue de la aplicación con la guia proporcionada y al colocar las variables de entorno que uso en render se ha levantado correctamente y muestra la página principal de la aplicación.

laravel-players-7d4tfc3tx-josegrcias-projects.vercel.app
**Copia la url en el navegador que github hace algo raro y te abre un archivo de github y da error.**

Con mucho love, jose ❤️.
