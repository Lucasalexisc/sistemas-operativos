#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CANT_HUECOS 5
#define CANT_ARCHIVOS 4

// Estructura para representar un archivo en el sistema de archivos simulado
typedef struct {
    char nombre[32];
    int bloques_requeridos;
    int asignado;           // 1 si fue asignado, 0 si fue rechazado
    int hueco_asignado;     // Índice del hueco contiguo asignado (-1 si rechazado)
    int bloques_indexados[CANT_HUECOS]; // Bloques tomados de cada hueco en Asignación Indexada
} ArchivoFS;

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s [F|B|I]\n", argv[0]);
        printf("  F: Asignacion Contigua con Primer Ajuste (First-Fit)\n");
        printf("  B: Asignacion Contigua con Mejor Ajuste (Best-Fit)\n");
        printf("  I: Asignacion Indexada con Nodos-i (Esquema Red Hat ext4)\n");
        return 1;
    }

    char modo = argv[1][0];
    if (modo != 'F' && modo != 'f' && modo != 'B' && modo != 'b' && modo != 'I' && modo != 'i') {
        printf("[ERROR]: Modo no valido. Seleccione F, B o I.\n");
        return 1;
    }

    // Huecos de bloques libres disponibles en la particion de almacenamiento (en bloques / KB)
    int huecos[CANT_HUECOS] = {100, 500, 200, 300, 600};

    // Definición de archivos corporativos entrantes
    ArchivoFS archivos[CANT_ARCHIVOS] = {
        {"catalogo_productos.db", 212, 0, -1, {0}},
        {"multimedia_assets.tar", 417, 0, -1, {0}},
        {"auditoria_sistema.log", 112, 0, -1, {0}},
        {"backup_transaccional.iso", 426, 0, -1, {0}}
    };

    printf("========================================================================\n");
    printf("   SIMULADOR DE SISTEMA DE ARCHIVOS - ASIGNACION DE BLOQUES EN DISCO    \n");
    printf("========================================================================\n");

    if (modo == 'F' || modo == 'f') {
        printf(" MODO: ASIGNACION CONTIGUA - PRIMER AJUSTE (FIRST-FIT)\n");
        printf(" Logica: Se exige un segmento de bloques continuos. Se toma el PRIMERO.\n");
    } else if (modo == 'B' || modo == 'b') {
        printf(" MODO: ASIGNACION CONTIGUA - MEJOR AJUSTE (BEST-FIT)\n");
        printf(" Logica: Se exige bloques continuos. Se toma el hueco mas ajustado.\n");
    } else {
        printf(" MODO: ASIGNACION INDEXADA CON NODOS-I (INODES - RED HAT LINUX ext4)\n");
        printf(" Logica: No exige contigüidad. El Inodo mapea bloques libres dispersos.\n");
    }
    printf("========================================================================\n\n");

    // 1. Mostrar estado inicial de los bloques libres en disco
    int espacio_libre_inicial = 0;
    printf("[MAPA DE ESPACIO LIBRE EN DISCO - ESTADO INICIAL]\n");
    for (int j = 0; j < CANT_HUECOS; j++) {
        printf("  Segmento Libre %d: %4d bloques consecutivos disponibles\n", j + 1, huecos[j]);
        espacio_libre_inicial += huecos[j];
    }
    printf("  Capacidad total disponible en particion: %d bloques (o KB)\n\n", espacio_libre_inicial);

    // 2. Mostrar archivos a persistir
    int espacio_solicitado = 0;
    printf("[COLA DE ARCHIVOS CORPORATIVOS A ALMACENAR]\n");
    for (int i = 0; i < CANT_ARCHIVOS; i++) {
        printf("  Archivo F%d [%-24s]: %4d bloques requeridos\n", 
               i + 1, archivos[i].nombre, archivos[i].bloques_requeridos);
        espacio_solicitado += archivos[i].bloques_requeridos;
    }
    printf("  Espacio total requerido por archivos:    %d bloques\n", espacio_solicitado);
    printf("------------------------------------------------------------------------\n\n");

    // 3. Ejecución del Algoritmo Seleccionado
    if (modo == 'F' || modo == 'f') {
        // Asignación Contigua First-Fit
        for (int i = 0; i < CANT_ARCHIVOS; i++) {
            for (int j = 0; j < CANT_HUECOS; j++) {
                if (huecos[j] >= archivos[i].bloques_requeridos) {
                    archivos[i].asignado = 1;
                    archivos[i].hueco_asignado = j;
                    huecos[j] -= archivos[i].bloques_requeridos;
                    break; // Corta en el primero que encuentra
                }
            }
        }
    } else if (modo == 'B' || modo == 'b') {
        // Asignación Contigua Best-Fit
        for (int i = 0; i < CANT_ARCHIVOS; i++) {
            int mejor_idx = -1;
            for (int j = 0; j < CANT_HUECOS; j++) {
                if (huecos[j] >= archivos[i].bloques_requeridos) {
                    if (mejor_idx == -1 || huecos[j] < huecos[mejor_idx]) {
                        mejor_idx = j;
                    }
                }
            }
            if (mejor_idx != -1) {
                archivos[i].asignado = 1;
                archivos[i].hueco_asignado = mejor_idx;
                huecos[mejor_idx] -= archivos[i].bloques_requeridos;
            }
        }
    } else {
        // Asignación Indexada con Nodos-i (Inodes)
        // Cada archivo puede tomar bloques de cualquier hueco libre del bitmap
        for (int i = 0; i < CANT_ARCHIVOS; i++) {
            int pendientes = archivos[i].bloques_requeridos;
            for (int j = 0; j < CANT_HUECOS && pendientes > 0; j++) {
                if (huecos[j] > 0) {
                    int tomar = (huecos[j] >= pendientes) ? pendientes : huecos[j];
                    archivos[i].bloques_indexados[j] = tomar;
                    huecos[j] -= tomar;
                    pendientes -= tomar;
                }
            }
            if (pendientes == 0) {
                archivos[i].asignado = 1;
            }
        }
    }

    // 4. Reporte de Resultados de Asignación de Archivos
    printf("[REPORTE DE ASIGNACION EN EL SISTEMA DE ARCHIVOS]\n");
    printf("%-4s %-25s %-10s %-23s %s\n", "ID", "Nombre Archivo", "Tamano", "Ubicacion", "Estado");
    printf("----------------------------------------------------------------------------------------\n");
    for (int i = 0; i < CANT_ARCHIVOS; i++) {
        printf("F%d   %-25s %4d blk   ", i + 1, archivos[i].nombre, archivos[i].bloques_requeridos);
        if (archivos[i].asignado) {
            if (modo == 'I' || modo == 'i') {
                printf("Inodo #%04d (Indexado)    EXITO: Bloques dispersos\n", 1000 + i);
            } else {
                printf("Segmento %d (Contiguo)    EXITO: Bloques reservados\n", archivos[i].hueco_asignado + 1);
            }
        } else {
            printf("Ninguno                  FALLO: ENOSPC (Frag. Externa)\n");
        }
    }

    // 5. Análisis del Estado Final de los Bloques Libres en Disco
    printf("\n[ESTADO FINAL DE LOS BLOQUES LIBRES EN PARTICION]\n");
    int espacio_libre_remanente = 0;
    for (int j = 0; j < CANT_HUECOS; j++) {
        printf("  Segmento %d: %4d bloques libres restantes\n", j + 1, huecos[j]);
        espacio_libre_remanente += huecos[j];
    }
    printf("  Total de bloques libres remanentes en disco: %d bloques\n", espacio_libre_remanente);
    printf("----------------------------------------------------------------------------------------\n");

    // 6. Conclusión de Diagnóstico Forense
    if ((modo == 'F' || modo == 'f') && archivos[3].asignado == 0) {
        printf("\n[EVIDENCIA CIENTIFICA DE FRAGMENTACION EXTERNA EN DISCO]:\n");
        printf("  - El archivo 'backup_transaccional.iso' requeria 426 bloques contiguos.\n");
        printf("  - El disco poseia un total de %d bloques libres (mas del doble).\n", espacio_libre_remanente);
        printf("  - Falla: El hueco contiguo mas grande remanente mide solo 300 bloques.\n");
        printf("  - Conclusion: La Asignacion Contigua sufre de Fragmentacion Externa.\n");
    } else if (modo == 'B' || modo == 'b') {
        printf("\n[ANALISIS BEST-FIT Y LIMITACION DE CRECIMIENTO DINAMICO]:\n");
        printf("  - Best-Fit logro alojar a F4 seleccionando huecos mas ajustados.\n");
        printf("  - Sin embargo, si un archivo como 'auditoria_sistema.log' intenta crecer (append),\n");
        printf("    falla porque los bloques contiguos adyacentes estan ocupados.\n");
    } else if (modo == 'I' || modo == 'i') {
        printf("\n[DEMOSTRACION DEL ESQUEMA INDEXADO EXT4 DE RED HAT LINUX]:\n");
        printf("  - El Inodo recolecto 426 bloques dispersos entre los distintos huecos libres:\n");
        for (int j = 0; j < CANT_HUECOS; j++) {
            if (archivos[3].bloques_indexados[j] > 0) {
                printf("    * Tomo %d bloques del Segmento %d\n", archivos[3].bloques_indexados[j], j + 1);
            }
        }
        printf("  - Resultado: 100%% de archivos persistidos sin compactar el disco.\n");
        printf("  - Soporte de Crecimiento: Admite anexar bloques adicionales sin reubicacion.\n");
    }

    return 0;
}
