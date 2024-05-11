all: ball_samp-cpu ball_samp-cuda

ball_samp-cpu: sequential.cpp
	g++ sequential.cpp -o ball_samp-cpu -ggdb -Wall -Wextra -pedantic -O3

ball_samp-cuda: parallel.cu
	nvcc parallel.cu -o ball_samp-cuda

clean:
	rm ball_samp-cpu ball_samp-cuda
