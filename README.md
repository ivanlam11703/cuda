### Overview
This was an introductory project for me into CUDA. With my code, I am looking to estimate the function f~D~(l), where f~D~(l) is the fraction of the volume of a *D*-dimensional unit hypersphere that is within distance *l* of the surface. The outputs of distance are then sorted into a histogram of intervals 0.01, from 0 to 1. 

To compute this function, I am sampling uniformly distributed points within the hypersphere. To choose my points, I am using the rejection method for sampling points. This simply means, I can generate random points within the *D*-dimensional hypercube, and reject all points that do not fall within the *D*-dimensional hypersphere. This is probably the easiest way to sample uniformly distributed points.

I have two versions, one version in C++ that computes this without parallelization, and a CUDA program that computes with paralellization (just to see how much faster it really is).

Code running on the GPU runs faster (obviously), up to around 200x faster, when running some amount that the sequential program can calculate. The 200x speedup was done on one billion sampled points, and past that, it probably isn't even worth running the CPU on anything larger than that.

I am currently using an NVIDIA RTX 2070 as GPU and an Intel i7-8750H, both at base speed when I ran this.

### How to run
Compile the code by running ```make``` and execute using ```./ball_samp-cpu``` or ```./ball_samp-cuda```.
Neither executable takes command line arguments.

Number of samples taken and number of threads used (in ball_sampe-cuda) can be edited my changing the constants at the top of each file.
Code prints which dimension it is calculating followed by the (text) histogram.
Histogram format follows range: relative fraction. For example, 0.05-0.06: 0.05. 
This means that 0.05 of the (valid) sampled points are within 0.05-0.06 to the surface. 

### What next?
It would probably be cool to make some sort of 3D visualization of the results, since a text histogram of 100 bins is pretty ugly. Maybe using something with matplotlib.

Another thing I could probably do is try to do some more optimizations on the CPU with SIMD. I am slightly familiar with the AVX2 specifications, so maybe that? It would be cool to see how close I could get in terms of calculation times with these optimizations. As of now, my sequential program does not even make use of C++ threads, so it is probably as slow as it can get.