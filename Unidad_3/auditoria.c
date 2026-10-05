#include <stdio.h>

void auditoria_memoria(void);

int main(void) {
    printf("[USER SPACE] Iniciando proceso principal...\n");
    auditoria_memoria();
    return 0;
}