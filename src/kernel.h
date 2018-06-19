#include <cuda_runtime.h>
#include <device_launch_parameters.h>
extern __global__ void kernel();  
extern void gpuPrintf();
extern cudaError_t cudaAdd(int* c, const int* a, const int* b, const unsigned int size);
