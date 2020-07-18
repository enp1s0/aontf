#include <iostream>
#include <random>
#include <aonfp/aonfp.hpp>
#include <aonfp/cuda_copy.hpp>

using DEVICE_T = double;
using S_EXP_T = uint32_t;
using MANTISSA_T = uint32_t;

constexpr std::size_t N = 1lu << 20;

int main() {
	std::mt19937 mt(std::random_device{}());
	std::uniform_real_distribution<DEVICE_T> dist(-1000.0, 1000.0);

	DEVICE_T* device_array;
	S_EXP_T* s_exp_array;
	MANTISSA_T* mantissa_array;

	cudaMalloc(&device_array, sizeof(DEVICE_T) * N);
	cudaMallocHost(&s_exp_array, sizeof(S_EXP_T) * N);
	cudaMallocHost(&mantissa_array, sizeof(MANTISSA_T) * N);

	for (std::size_t i = 0; i < N; i++) {
		aonfp::decompose(s_exp_array[i], mantissa_array[i], dist(mt));
	}

	aonfp::cuda::copy_to_device(device_array, s_exp_array, mantissa_array, N);

	cudaFreeHost(s_exp_array);
	cudaFreeHost(mantissa_array);
}
