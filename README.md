# AONFP (Architecture Oriented Non-standard Floating Point)

## Description
AONFP is a header only C++ library for floating point data compression.
It decomposes a IEEE standard floating point to two bitstrings, one is sign and exponent and the other one is mantissa.

AONFP restricts the type of these bitstrings to `uint8/16/32/64` to reduce complexity.

![aonfp-format](docs/aonfp_format.svg)

## Supported data format

### Standard floating point

- `float` (IEEE 754 Binary32)
- `double` (IEEE 754 Binary64)

### Decomposed data type
Data types for `sign_exponent` and `mantissa` are

- `uint64_t`
- `uint32_t`
- `uint16_t`
- `uint8_t`


## Supported operations
- [x] `mul`
- [x] `add`
- [x] `sub`

respectively.

### Sample code
```cpp
const auto v0 = static_cast<double>(1.234);
const auto v1 = static_cast<double>(5.55);
const auto v2 = static_cast<double>(3.333);
uint8_t se0, se1, se2, se3, se4;
uint64_t m0, m1, m2, m3, m4;

// decompose
aonfp::decompose(se0, m0, v0);
aonfp::decompose(se1, m1, v1);
aonfp::decompose(se2, m2, v2);

// compute
aonfp::mul(se3, m3, se0, m0, se1, m1);
aonfp::add(se4, m4, se2, m2, se3, m3);

// compose
const auto v3 = aonfp::compose<double>(se4, m4);
```

## CUDA extension
AONFP has a function which copies an AONFP format array in host memory to device memory while converting to IEEE format.
And also it has a reverse function.

![cuda-copy](docs/aonfp_cuda_copy.svg)

To use this feature, you need to build a static library and link it to your application.


### Supported GPUs

NVIDIA Pascal or later architecture

### Build
```bash
make
```

### Sample code
```cpp
#include <aonfp/cuda_copy.hpp>

aonfp::cuda::copy_to_device(device_array, src_s_exp_array, src_mantissa_array, N);
aonfp::cuda::copy_to_host(dst_s_exp_array, dst_mantissa_array, device_array, N);
```

### Link
```bash
nvcc ... -L/path/to/lib_dir -laonfp_cuda_copy
```

#### More detail

![cuda-copy-detail](./docs/aonfp_cuda_copy_detail.svg)

This functions also set cpu affinity.

## AONFP Q - AONFP for Quantum Computer Simulation

See [AONFP Q](./docs/q.md)
