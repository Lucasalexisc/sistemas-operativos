#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

// MODO RAPIDO (CON BUFER): Junta 4000 letras en memoria y escribe en bloque.
// En vez de 100.000 viajes al Kernel, hace solo 25 viajes (25 x 4000 = 100.000).

int main() {
    int fd = open("salida_rapida.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) return 1; // Validamos que el archivo se abrio correctamente

    char bufer[4000];
    memset(bufer, 'A', 4000); // Llenamos el bufer con 4000 letras 'A'

    printf("[CON BUFER]: Escribiendo 100.000 letras en bloques de 4000 bytes...\n");
    for (int i = 0; i < 25; i++) {
        write(fd, bufer, 4000); // 1 sola llamada escribe 4000 letras juntas
    }

    close(fd);
    printf("[CON BUFER]: Terminado (Solo 25 llamadas a write!).\n");
    return 0;
}
