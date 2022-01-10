#include <sys/mman.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
// #define SIZE (20 * 1024 * 1024)
#define PageSize 4096

int main(int argc, char *argv[])
{
    int size = atoi(argv[1]);
    // printf("size:%d\n", size);
    size = size * 1024 * 1024;
    char *buffer;
    FILE *f;
    int finish;
    buffer = (char *)malloc(size);
    unsigned long buffer_aligned;
    f = fopen("random_data.txt", "r");
    fread(buffer, size, 1, f);
    buffer_aligned = (unsigned long)buffer & (~(PageSize - 1));

    clock_t begin = clock();
    madvise((void *)buffer_aligned, size, 20);
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("time_spent: %f\n", time_spent);
    printf("finished?");
    scanf("%d", &finish);
    return 0;
}
