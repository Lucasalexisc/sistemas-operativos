#include <stdio.h>
#include <string.h>

#define CANT_HUECOS 5
#define CANT_PROCESOS 4

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s [F|B] (F: First-Fit, B: Best-Fit)\n", argv[0]);
        return 1;
    }

    char modo = argv[1][0];
    if (modo != 'F' && modo != 'f' && modo != 'B' && modo != 'b') {
        printf("Algoritmo no valido. Use F o B.\n");
        return 1;
    }

    // Tamaños iniciales de los huecos de memoria libre (en KB)
    int huecos[CANT_HUECOS] = {100, 500, 200, 300, 600};
    // Tamaños requeridos por los procesos entrantes (en KB)
    int procesos[CANT_PROCESOS] = {212, 417, 112, 426};
    // Arreglo para guardar qué hueco se le asignó a cada proceso (-1 = no asignado)
    int asignacion[CANT_PROCESOS];

    for (int i = 0; i < CANT_PROCESOS; i++) {
        asignacion[i] = -1;
    }

    printf("============================================================\n");
    if (modo == 'F' || modo == 'f') {
        printf(" SIMULACION: PRIMER AJUSTE (FIRST-FIT)\n");
        printf(" Logica: Se asigna el PRIMER hueco con capacidad suficiente.\n");
    } else {
        printf(" SIMULACION: MEJOR AJUSTE (BEST-FIT)\n");
        printf(" Logica: Se busca el hueco mas ajustado para reducir el sobrante.\n");
    }
    printf("============================================================\n");

    // 1. Mostrar estado inicial de los huecos y procesos antes de empezar
    printf("\n[ESTADO INICIAL DE LA MEMORIA LIBRE]\n");
    int memoria_inicial = 0;
    for (int j = 0; j < CANT_HUECOS; j++) {
        printf("Hueco %d: %d KB disponibles\n", j + 1, huecos[j]);
        memoria_inicial += huecos[j];
    }
    printf("Capacidad total inicial disponible: %d KB\n", memoria_inicial);

    printf("\n[PROCESOS QUE SOLICITAN MEMORIA CONTIGUA]\n");
    int memoria_solicitada = 0;
    for (int i = 0; i < CANT_PROCESOS; i++) {
        printf("Proceso P%d: %d KB requeridos\n", i + 1, procesos[i]);
        memoria_solicitada += procesos[i];
    }
    printf("Memoria total requerida: %d KB\n", memoria_solicitada);
    printf("------------------------------------------------------------\n");

    // 2. Ejecución del algoritmo seleccionado
    if (modo == 'F' || modo == 'f') {
        for (int i = 0; i < CANT_PROCESOS; i++) {
            for (int j = 0; j < CANT_HUECOS; j++) {
                if (huecos[j] >= procesos[i]) {
                    asignacion[i] = j;
                    huecos[j] -= procesos[i]; // El hueco se reduce
                    break; // Al encontrar el primero, corta la búsqueda
                }
            }
        }
    } else {
        for (int i = 0; i < CANT_PROCESOS; i++) {
            int mejor_idx = -1;
            for (int j = 0; j < CANT_HUECOS; j++) {
                if (huecos[j] >= procesos[i]) {
                    if (mejor_idx == -1 || huecos[j] < huecos[mejor_idx]) {
                        mejor_idx = j;
                    }
                }
            }
            if (mejor_idx != -1) {
                asignacion[i] = mejor_idx;
                huecos[mejor_idx] -= procesos[i];
            }
        }
    }

    // 3. Reporte de resultados de asignación
    printf("\n[RESULTADO DE LA ASIGNACION]\n");
    printf("Proceso\tTamano\tHueco Asignado\tEstado\n");
    for (int i = 0; i < CANT_PROCESOS; i++) {
        printf("P%d\t%d KB\t", i + 1, procesos[i]);
        if (asignacion[i] != -1) {
            printf("Hueco %d\t\tASIGNADO\n", asignacion[i] + 1);
        } else {
            printf("Ninguno\t\tRECHAZADO (Sin espacio contiguo)\n");
        }
    }

    // 4. Estado final de los huecos libres y fragmentación externa
    printf("\n[ESTADO FINAL DE LOS HUECOS LIBRES]\n");
    int memoria_desperdiciada = 0;
    for (int j = 0; j < CANT_HUECOS; j++) {
        printf("Hueco %d: %d KB disponibles\n", j + 1, huecos[j]);
        memoria_desperdiciada += huecos[j];
    }
    printf("Memoria total libre no contigua remanente: %d KB\n", memoria_desperdiciada);

    return 0;
}