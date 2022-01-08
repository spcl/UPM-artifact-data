#include <sys/mman.h>
#include <stdio.h>
#include <time.h>

#define SIZE (20 * 1024 * 1024)
#define PageSize 4096
int main()
{
    char *buffer;
    FILE *f;
    int finish;
    buffer = (char *)malloc(SIZE);
    unsigned long buffer_aligned;
    f = fopen("random_data.txt", "r");
    fread(buffer, SIZE, 1, f);
    buffer_aligned = (unsigned long)buffer & (~(PageSize - 1));

    clock_t begin = clock()
    madvise((void *)buffer_aligned, SIZE, 20);
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    scanf("finish? %d", &finish);
    return 0;
}