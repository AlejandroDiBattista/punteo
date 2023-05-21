# construir sitio web
Write-Host "Construyendo sitio web..."

# flutter clean
flutter build web #--no-tree-shake-icons 
# flutter run -d chrome --web-renderer html
# flutter build web --web-renderer canvaskit --no-tree-shake-icons 
# flutter build web --web-renderer html --no-tree-shake-icons 


# copiar archivos generados a carpeta de repositorio
Write-Host "Copiando datos al repositorio..."
Copy-Item -Path "build\web\*.*" -Destination "C:\Users\administrator\Documents\GitHub\contactos" -Recurse -Force

# cambiar directorio de trabajo al repositorio
Set-Location "C:\Users\administrator\Documents\GitHub\contactos"

# agregar archivos al commit de Git
Write-Host "Publicando sitio..."
git add .

# hacer el commit con un mensaje
git commit -m "Agregando archivos generados por flutter build web"

# publicar los cambios en el repositorio remoto
git push

# volver al directorio de trabajo original
Set-Location $PSScriptRoot

Write-Host "Arrancamos el sitio..."
# ejecutar el sitio web en el navegador
# flutter run -d chrome

