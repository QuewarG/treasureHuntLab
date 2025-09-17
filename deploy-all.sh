#!/usr/bin/env bash

set -e  # Detener si algo falla

NAMESPACE="treasure-hunt"

echo "🚀 Creando namespace $NAMESPACE (si no existe)..."
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

echo "📂 Explorando deployments/"
ls -l deployments

# Si hay subcarpetas (caso organizado por estudiante)
for student in deployments/*; do
  if [ -d "$student" ]; then
    echo ""
    echo "📂 Desplegando para: $(basename "$student")"

    kubectl apply -f "$student" -n $NAMESPACE
  fi
done

# Si hay archivos sueltos en deployments/
for file in deployments/*.yaml; do
  if [ -f "$file" ]; then
    echo ""
    echo "📄 Aplicando archivo: $file"
    kubectl apply -f "$file" -n $NAMESPACE
  fi
done

echo ""
echo "✅ Todos los deployments y secrets aplicados en el namespace '$NAMESPACE'"
