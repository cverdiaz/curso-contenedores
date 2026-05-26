# Plan: Configurar Ingress de Jenkins para acceder por jenkins.local

## TL;DR
Jenkins está instalado en Kubernetes (namespace `jenkins`) con Ingress configurado en los charts de Helm para `jenkins.local`, pero actualmente no funciona (necesitas port-forward). El problema está en que el Ingress del chart podría no estar correctamente expuesto o no estar sincronizado con el nginx-ingress controller. La solución es:
1. Verificar el estado del Ingress actual de Jenkins en el cluster
2. Si es necesario, agregar/actualizar un Ingress explícito en kubernates.yaml que exponga Jenkins en port 80 bajo el hostname `jenkins.local`
3. Configurar correctamente el Service de Jenkins para que sea accesible internamente desde los contenedores
4. Validar que desde dentro de un Pod se pueda acceder a `http://jenkins.local/`

## Información Recopilada
- **Namespace de Jenkins**: `jenkins`
- **IP de Minikube**: `192.168.49.2`
- **Archivo /etc/hosts**: ✅ Ya configurado (`jenkins.local` → `192.168.49.2`)
- **Acceso actual**: ✅ Funciona via port-forward (`http://127.0.0.1:18080/`)
- **Acceso deseado**: ❌ No funciona via Ingress (`http://jenkins.local/`)
- **Ingress Class**: nginx (ya disponible en el cluster)
- **Puerto del Pod Jenkins**: 8080
- **Servicio Jenkins**: Tipo ClusterIP (por defecto del chart)
- **Chart de Jenkins**: Ubicado en `curso-contenedores-charts/jenkins/`
- **Hostname en chart**: `jenkins.local`

## Pasos

### Fase 1: Diagnosticar (Paralelizable)
1. **Investigar recursos actuales de Jenkins**
   - Ejecutar: `kubectl get svc -n jenkins` → Identificar nombre del Service y puerto
   - Ejecutar: `kubectl get ingress -n jenkins` → Verificar si existe Ingress
   - Ejecutar: `kubectl describe ingress -n jenkins` (si existe) → Ver configuración y status
   - Ejecutar: `kubectl get pods -n jenkins` → Verificar que Jenkins está corriendo

2. **Revisar chart values de Jenkins**
   - Leer: `curso-contenedores-charts/jenkins/values.yaml`
   - Buscar: configuración de `ingress`, `service.type`, `controller.servicePort`
   - Verificar: nombre del service, puerto, clase de ingress

### Fase 2: Agregar/Actualizar Ingress en kubernates.yaml
3. **Agregar Ingress para Jenkins en kubernates.yaml**
   - Ubicación: Al final del archivo (después de postgres), antes del comentario de fin si existe
   - Contenido: Nuevo recurso Ingress que:
     - Nombre: `jenkins`
     - Namespace: `jenkins`
     - Clase: `nginx`
     - Hostname: `jenkins.local`
     - Path: `/`
     - Backend Service: `{service-name-jenkins}` en namespace `jenkins`
     - Puerto del backend: `{puerto-http-jenkins}` (probablemente 8080)
   - **Dependencia**: Necesita resultado de Fase 1 (paso 1) para saber nombre exacto del Service y puerto

4. **Aplicar cambios**
   - Ejecutar: `kubectl apply -f kubernates.yaml`
   - Esperar: Unos segundos a que Ingress se cree/actualice

### Fase 3: Validar y Ajustar
5. **Verificar que Ingress está activo**
   - Ejecutar: `kubectl get ingress -n jenkins`
   - Ejecutar: `kubectl describe ingress jenkins -n jenkins`
   - Verificar: que el status muestre la IP correcta (192.168.49.2) y las reglas estén configuradas

6. **Probar acceso desde localhost (anfitrión)**
   - En tu máquina (Windows/WSL): `curl http://jenkins.local/ -v` o abrir navegador en `http://jenkins.local/`
   - Resultado esperado: Acceso exitoso a Jenkins

7. **Probar acceso desde dentro de un Pod en el cluster**
   - Ejecutar: `kubectl run test-pod --image=alpine --rm -it --restart=Never -- sh`
   - Dentro del pod: `wget http://jenkins.local/ -O -` o `curl http://jenkins.local/`
   - Resultado esperado: Acceso exitoso a Jenkins desde dentro del cluster
   - Esto valida que el JNLP command funcionará

## Relevant Files
- `kubernates.yaml` — Agregar nuevo Ingress para Jenkins (al final del archivo)
- `curso-contenedores-charts/jenkins/values.yaml` — Referencia para obtener nombre del Service y puerto exacto

## Verification
1. **Verificar Ingress**: `kubectl get ingress -n jenkins` → debe mostrar ingress `jenkins` con status "True"
2. **Verificar acceso externo**: `curl -I http://jenkins.local/` → debe retornar HTTP 200 o 403 (no DNS error)
3. **Verificar acceso desde Pod**: Ejecutar alpine pod y hacer curl a `http://jenkins.local/` → debe funcionar
4. **Validar endpoint del agent**: Desde un Pod de prueba ejecutar:
   ```bash
   curl -sO http://jenkins.local/jnlpJars/agent.jar
   ```
   Debe descargar el archivo sin errores

## Decisions & Assumptions
- Se asume que `jenkins.local` ya está en `/etc/hosts` apuntando a 192.168.49.2 ✅ (confirmado por el usuario)
- Se asume que nginx-ingress-controller está instalado y funcionando (confirmado por el nombre de clase `nginx`)
- Se NO modificará la configuración de Jenkins (valores, plugins, credenciales) — solo se arreglará el Ingress
- El archivo que se modificará es solo `kubernates.yaml` como indicó el usuario
- Se asume que Jenkins fue instalado via Helm chart con nombre de release estándar (probablemente "jenkins")

## Further Considerations
1. **¿Cuál es el nombre exacto del Service de Jenkins?**
   - Opción A: `jenkins` (nombre del chart por defecto)
   - Opción B: `jenkins-controller` (algunos charts lo nombran así)
   - Opción C: `{release-name}` (dependiendo de cómo se instaló)
   - **Recomendación**: Ejecutar `kubectl get svc -n jenkins` en Fase 1 para confirmarlo

2. **¿Cuál es el puerto HTTP exacto del Service?**
   - Usualmente es 8080, pero algunos charts pueden exponerlo en 80
   - **Recomendación**: Verificar en `kubectl get svc -n jenkins -o yaml` durante Fase 1

3. **¿El Ingress del chart ya existe pero no funciona?**
   - Si existe, podría necesitar ser eliminado para evitar conflictos
   - Si no existe, el nuevo Ingress en kubernates.yaml lo solucionará
   - **Recomendación**: Revisar en Fase 1
