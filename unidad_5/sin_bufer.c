#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

// MODO LENTO (SIN BUFER): Escribe 100.000 letras de a 1 por vez.
// Cada write() hace un cambio de contexto al Kernel (100.000 viajes).

int main() {
    int fd = open("salida_lenta.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);

    printf("[SIN BUFER]: Escribiendo 100.000 letras de a 1 byte por vez...\n");
    for (int i = 0; i < 100000; i++) {
        write(fd, "A", 1); // 1 llamada al sistema por cada letra
    }

    close(fd);
    printf("[SIN BUFER]: Terminado (100.000 llamadas a write).\n");
    return 0;
}
