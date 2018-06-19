#include <stdio.h>
#include "kernel.h"  
__global__ void kernel()
{  
    printf("hello world from gpu!\n");  
}
__global__ void addKernel(int* c, const int* a, const int* b)
{
	int i = threadIdx.x;
	c[i] = a[i] + b[i];
}
cudaError_t cudaAdd(int* c,const int* a, const int* b, const unsigned int size)
{
    int* dev_a = 0;
    int* dev_b = 0;
    int* dev_c = 0;
    cudaError_t cudaStatus;

    cudaStatus = cudaSetDevice(0);
    if(cudaStatus != cudaSuccess) {
		printf("set divice failed\n");
		goto ERROR;
    }
    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if(cudaStatus != cudaSuccess) {
		printf("cuda malloc a failed\n");
		goto ERROR;
	}
	cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if(cudaStatus != cudaSuccess) {
		printf("cuda malloc b failed\n");
		goto ERROR;
	}
	cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
	if(cudaStatus != cudaSuccess) {
		printf("cuda malloc c failed\n");
		goto ERROR;
	}

	cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
	if(cudaStatus != cudaSuccess) {
		printf("cuda memcpy a failed\n");
		goto ERROR;
	}
	cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
	if(cudaStatus != cudaSuccess) {
		printf("cuda memcpy b failed\n");
		goto ERROR;
	}
	addKernel<<<1,size>>>(dev_c, dev_a, dev_b);
	
	cudaStatus = cudaGetLastError();
	if(cudaStatus != cudaSuccess) {
		printf("addKernel failed: %s\n", cudaGetErrorString(cudaStatus));
		goto ERROR;
	}
	cudaStatus = cudaDeviceSynchronize();
	if(cudaStatus != cudaSuccess) {
		printf("device syn failed\n");
		goto ERROR;
	}
	cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
	if(cudaStatus != cudaSuccess) {
		printf("cuda memcpy c failed\n");
		goto ERROR;
	}
ERROR:
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	return cudaStatus;
}
void gpuPrintf()
{
	kernel<<<1,10>>>();
	cudaDeviceSynchronize();
}
