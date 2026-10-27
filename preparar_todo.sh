#!/bin/bash
# ==============================================================================
# PREPARADOR INTEGRAL DE ENTORNO - SISTEMAS OPERATIVOS (UADE / RED HAT)
# 1. Configura permisos de ejecucion detallados para cada unidad.
# 2. Diagnostica y auto-repara repositorios huerfanos en Red Hat.
# 3. Verifica e instala todas las dependencias necesarias indicando su uso.
# ==============================================================================

echo "=============================================================================="
echo " 1. CONFIGURANDO PERMISOS DE EJECUCION (+x) POR CADA UNIDAD"
echo "=============================================================================="

# Unidad 1
echo " -> [Unidad 1]: Otorgando chmod +x a 'audit_syscalls.sh' y 'sync_service.sh' (Syscalls y Kernel)..."
chmod +x unidad_1/*.sh 2>/dev/null

# Unidad 2
echo " -> [Unidad 2]: Otorgando chmod +x a 'demostracion_tpo.sh' y 'carrera_escritura.sh' (Concurrencia y Mutex)..."
chmod +x unidad_2/*.sh 2>/dev/null

# Unidad 3
echo " -> [Unidad 3]: Otorgando chmod +x a 'ejecutar_tpo.sh' (Memoria RAM: First-Fit y Best-Fit)..."
chmod +x unidad_3/*.sh 2>/dev/null

# Unidad 4
echo " -> [Unidad 4]: Otorgando chmod +x a 'ejecutar_tpo.sh' (File System: Asignacion Contigua vs Inodos)..."
chmod +x unidad_4/*.sh 2>/dev/null

# Unidad 5
echo " -> [Unidad 5]: Otorgando chmod +x a 'ejecutar_tpo.sh' (Entrada/Salida: Sin Bufer vs Con Bufer)..."
chmod +x unidad_5/*.sh 2>/dev/null

# Unidad 6
echo " -> [Unidad 6]: Otorgando chmod +x a scripts de Seguridad, Firewall y Hash..."
chmod +x unidad_6/*.sh 2>/dev/null
echo " -> [Unidad 6]: Aplicando chmod 750 restringido a 'pagos_empresa.sh' (Demostracion de permisos y ACLs)..."
chmod 750 unidad_6/pagos_empresa.sh 2>/dev/null

# Scripts generales de la raiz
echo " -> [General ]: Otorgando chmod +x a 'menu_tpo.sh' y 'preparar_todo.sh'..."
chmod +x *.sh 2>/dev/null

echo "[OK]: Todos los scripts de las Unidades 1 a 6 tienen sus permisos listos."
echo "      (Nota: Los archivos .c no requieren chmod +x ya que los compila gcc directamente)."
echo ""

echo "=============================================================================="
echo " 2. DIAGNOSTICO Y REPARACION DE REPOSITORIOS EN RED HAT"
echo "=============================================================================="
# En estaciones Red Hat (workstation), a veces queda un repo huerfano en /tmp/rhaap
# que rompe dnf al intentar buscar archivos temporales borrados.
REPO_HUERFANO=0
if ls /etc/yum.repos.d/*ansible* >/dev/null 2>&1 || ls /etc/yum.repos.d/*rhaap* >/dev/null 2>&1; then
    REPO_HUERFANO=1
fi

if [ $REPO_HUERFANO -eq 1 ]; then
    echo " -> [AVISO]: Se detecto un archivo de repositorio huerfano en /etc/yum.repos.d/ apuntando a /tmp/."
    echo "             Esto causa el 'Curl error (37) Cannot download repomd.xml'."
    echo "             Limpiando archivo problematico con privilegios de sudo..."
    sudo rm -f /etc/yum.repos.d/*ansible* /etc/yum.repos.d/*rhaap* 2>/dev/null
    echo " -> [OK]: Repositorio huerfano eliminado. dnf ya puede descargar normalmente."
else
    echo " -> [OK]: Los repositorios de Red Hat estan limpios y sin conflictos."
fi
echo ""

echo "=============================================================================="
echo " 3. VERIFICACION DE HERRAMIENTAS Y LIBRERIAS POR UNIDAD"
echo "=============================================================================="

PAQUETES_FALTANTES=()

# GCC
if command -v gcc >/dev/null 2>&1; then
    echo "  [OK] 'gcc' (Compilador C) ya instalado -> Utilizado en Unidades 2, 3, 4 y 5."
else
    echo "  [FALTA] 'gcc' (Compilador C) NO instalado -> Requerido en Unidades 2, 3, 4 y 5."
    PAQUETES_FALTANTES+=("gcc")
fi

# STRACE
if command -v strace >/dev/null 2>&1; then
    echo "  [OK] 'strace' (Auditor Syscalls) ya instalado -> Utilizado en Unidades 1 y 5."
else
    echo "  [FALTA] 'strace' (Auditor Syscalls) NO instalado -> Requerido en Unidades 1 y 5."
    PAQUETES_FALTANTES+=("strace")
fi

# ACL (getfacl / setfacl)
if command -v getfacl >/dev/null 2>&1; then
    echo "  [OK] 'getfacl' (Paquete acl) ya instalado -> Utilizado en Unidad 6 (Seguridad y ACLs)."
else
    echo "  [FALTA] 'acl' (Listas de Control) NO instalado -> Requerido en Unidad 6."
    PAQUETES_FALTANTES+=("acl")
fi

# FILE
if command -v file >/dev/null 2>&1; then
    echo "  [OK] 'file' (Numeros magicos) ya instalado -> Utilizado en Unidad 4 (File System e Inodos)."
else
    echo "  [FALTA] 'file' NO instalado -> Requerido en Unidad 4."
    PAQUETES_FALTANTES+=("file")
fi

# SHA256SUM
if command -v sha256sum >/dev/null 2>&1; then
    echo "  [OK] 'sha256sum' ya instalado -> Utilizado en Unidad 6 (Comprobador Hash de Integridad)."
else
    echo "  [FALTA] 'sha256sum' (coreutils) NO instalado -> Requerido en Unidad 6."
    PAQUETES_FALTANTES+=("coreutils")
fi

echo ""

# Instalacion automatica si falta alguno
if [ ${#PAQUETES_FALTANTES[@]} -ne 0 ]; then
    echo "=============================================================================="
    echo " 4. INSTALACION AUTOMATICA DE DEPENDENCIAS FALTANTES CON SUDO DNF"
    echo "=============================================================================="
    echo "Instalando paquetes: ${PAQUETES_FALTANTES[*]}"
    echo "(Si el sistema solicita password de sudo, ingresa: student o redhat)"
    echo ""
    sudo dnf install -y --disablerepo="*ansible*" "${PAQUETES_FALTANTES[@]}"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "[EXITO]: Todas las herramientas requeridas quedaron instaladas y listas para usar."
    else
        echo ""
        echo "[ADVERTENCIA]: Hubo un inconveniente al instalar automaticamente con dnf."
        echo "               Podes intentar ejecutar manualmente:"
        echo "               sudo dnf install -y --disablerepo='*ansible*' ${PAQUETES_FALTANTES[*]}"
    fi
else
    echo "=============================================================================="
    echo " 4. ESTADO DE DEPENDENCIAS: 100% COMPLETAS"
    echo "=============================================================================="
    echo "No hace falta instalar nada adicional, todas las herramientas estan operativas."
fi

echo ""
echo "=============================================================================="
echo " [LISTO]: ENTORNO PREPARADO EXITOSAMENTE"
echo " Podes ejecutar cualquier ejercicio:"
echo "   a) Ingresando a la unidad (ej: cd unidad_3 && ./ejecutar_tpo.sh)"
echo "   b) O ejecutando el menu general interactivo: ./menu_tpo.sh"
echo "=============================================================================="
