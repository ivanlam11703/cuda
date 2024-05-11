#include <iostream>
#include <curand.h>
#include <curand_kernel.h>

const int NUM_SAMPLES = 10000000; // 10 million
const int NUM_THREADS = 1000;

__global__ void compute_histogram(int dim, int* histogram, int* size, curandState* states) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    curand_init(clock64() + idx, idx, 0, &states[idx]);

    float sum = 0;
    for (int j = 0; j < dim; j++) {
        float val = curand_uniform(&states[idx]) * 2 - 1;
        sum += val * val;
    }
    if (sqrt(sum) <= 1.0) {
        float dist_to_surface = 1 - sqrt(sum);
        atomicAdd(&histogram[int(dist_to_surface / 0.01)], 1);
        atomicAdd(size, 1);
    }
}


int main() {
    curandState* states;
    cudaMalloc((void**)&states, NUM_SAMPLES * sizeof(curandState));

    for (int dim = 2; dim <= 16; dim++) {
        int* histogram;
        int* size;

        cudaMallocManaged(&histogram, 100 * sizeof(int));
        cudaMemset(histogram, 0, 100 * sizeof(int));

        cudaMallocManaged(&size, sizeof(int));
        cudaMemset(size, 0, sizeof(int));

        compute_histogram<<<(NUM_SAMPLES / NUM_THREADS), NUM_THREADS>>>(dim, histogram, size, states);

        cudaDeviceSynchronize();

        std::cout << "Histogram for D = " << dim << ":\n";
        for (int i = 0; i < 100; i++) {
            std::cout << i * 0.01 << " - " << (i + 1) * 0.01 << " : " << (double)histogram[i] / *size << "\n";
        }
        std::cout << "\n";

        cudaFree(histogram);
        cudaFree(size);
    }

    cudaFree(states);

    return 0;
}
