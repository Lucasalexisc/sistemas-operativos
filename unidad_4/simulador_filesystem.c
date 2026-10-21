#include <stdio.h>

#define CANT_HUECOS 5
#define CANT_ARCHIVOS 4

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s [F|B|I] (F: First-Fit Contiguo, B: Best-Fit Contiguo, I: Inodos Linux)\n", argv[0]);
        return 1;
    }

    char modo = argv[1][0];
    // Bloques libres en el disco (5 huecos separados, total = 1700 bloques)
    int huecos[CANT_HUECOS] = {100, 500, 200, 300, 600};
    // Tamano de los 4 archivos que queremos guardar en el disco (en bloques)
    int archivos[CANT_ARCHIVOS] = {212, 417, 112, 426};
    int asignacion[CANT_ARCHIVOS] = {-1, -1, -1, -1};

    printf("============================================================\n");
    if (modo == 'F' || modo == 'f') {
        printf(" MODO [F]: ASIGNACION CONTIGUA - PRIMER AJUSTE (FIRST-FIT)\n");
        printf(" Regla: Todo el archivo debe entrar junto en un solo hueco.\n");
    } else if (modo == 'B' || modo == 'b') {
        printf(" MODO [B]: ASIGNACION CONTIGUA - MEJOR AJUSTE (BEST-FIT)\n");
        printf(" Regla: Todo el archivo entra junto en el hueco mas justo.\n");
    } else {
        printf(" MODO [I]: ASIGNACION CON INODOS (COMO USA LINUX EXT4)\n");
        printf(" Regla: El archivo se puede repartir en varios huecos libres.\n");
    }
    printf("============================================================\n\n");

    // 1. Ejecucion segun el modo elegido
    if (modo == 'F' || modo == 'f') {
        for (int i = 0; i < CANT_ARCHIVOS; i++) {
            for (int j = 0; j < CANT_HUECOS; j++) {
                if (huecos[j] >= archivos[i]) {
                    asignacion[i] = j;
                    huecos[j] -= archivos[i];
                    break; // Corta en el primer hueco donde entra
                }
            }
        }
    } else if (modo == 'B' || modo == 'b') {
        for (int i = 0; i < CANT_ARCHIVOS; i++) {
            int mejor = -1;
            for (int j = 0; j < CANT_HUECOS; j++) {
                if (huecos[j] >= archivos[i]) {
                    if (mejor == -1 || huecos[j] < huecos[mejor]) {
                        mejor = j;
                    }
                }
            }
            if (mejor != -1) {
                asignacion[i] = mejor;
                huecos[mejor] -= archivos[i];
            }
        }
    } else if (modo == 'I' || modo == 'i') {
        // Modo Inodos: cada archivo toma bloques de cualquier hueco libre disponible
        for (int i = 0; i < CANT_ARCHIVOS; i++) {
            int falta_guardar = archivos[i];
            for (int j = 0; j < CANT_HUECOS && falta_guardar > 0; j++) {
                if (huecos[j] > 0) {
                    int usar = (huecos[j] >= falta_guardar) ? falta_guardar : huecos[j];
                    huecos[j] -= usar;
                    falta_guardar -= usar;
                }
            }
            if (falta_guardar == 0) {
                asignacion[i] = 99; // 99 = Guardado con exito usando un Inodo
            }
        }
    }

    // 2. Mostrar resultados
    printf("[RESULTADO AL GUARDAR LOS ARCHIVOS EN EL DISCO]\n");
    printf("Archivo\t\tTamano\t\tEstado en el Disco\n");
    for (int i = 0; i < CANT_ARCHIVOS; i++) {
        printf("Archivo %d\t%d bloques\t", i + 1, archivos[i]);
        if (asignacion[i] == 99) {
            printf("GUARDADO (Inodo repartio los bloques en huecos libres)\n");
        } else if (asignacion[i] != -1) {
            printf("GUARDADO en Hueco %d (Contiguo)\n", asignacion[i] + 1);
        } else {
            printf("ERROR: NO ENTRA (Falta espacio contiguo!)\n");
        }
    }

    // 3. Mostrar cuanto espacio libre quedo en el disco
    int total_libre = 0;
    printf("\n[ESPACIO LIBRE QUE QUEDO EN CADA HUECO DEL DISCO]\n");
    for (int j = 0; j < CANT_HUECOS; j++) {
        printf("Hueco %d: %d bloques libres\n", j + 1, huecos[j]);
        total_libre += huecos[j];
    }
    printf("-> Total de espacio libre sobrante en el disco: %d bloques\n", total_libre);

    return 0;
}
