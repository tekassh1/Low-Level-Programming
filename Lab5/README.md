# Assignment: Sepia filter in C and Assembly

Lab Assignment: Sepia filter in C and Assembly using SIMD instructions

## Task

In this assignment, you are required to implement a sepia filter in both C and Assembly languages.
- The Assembly implementation should utilize the SSE vector instructions of the processor, aiming for acceleration compared to the C implementation.
- The task is considered completed only if there is a noticeable speedup in the filter's performance.
- You need to write a test that compares the execution time of both implementations.
- For image processing, use the BMP file manipulation library that you implemented in the third lab assignment.

### Project result
```
Realization Iters Result 

"SIMD"      500   6.59s 
"NATIVE C"  500   19.34s 

Total perfomance boost: 2.94
```
