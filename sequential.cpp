#include <iostream>
#include <vector>
#include <cmath>
#include <random>

const int NUM_SAMPLES = 10000000; // 10 million

std::vector<int> create_histogram(int dimension) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<double> dist(-1.0, 1.0);

    std::vector<int> histogram(100, 0);

    for (int i = 0; i < NUM_SAMPLES; i++) {
        double sum = 0;

        for (int dim = 0; dim < dimension; dim++) {
            double point = dist(gen);
            sum += point * point;
        }

        if (sqrt(sum) <= 1.0) {
            double distance_to_surface = 1.0 - sqrt(sum);
            histogram[int(distance_to_surface / 0.01)]++;
        }
    }

    return histogram;
}

int main() {
    for (int dim = 2; dim <= 16; dim++) {
        std::vector<int> histogram = create_histogram(dim);
        // ensure we don't divide by 0
        int num_points = std::max(1, std::accumulate(histogram.begin(), histogram.end(), 0));

        std::cout << "Histogram for D = " << dim << ":" << std::endl;
        for (int i = 0; i < 100; i++) {
            std::cout << i * 0.01 << " - " << (i + 1) * 0.01 << " : " << (double)histogram[i] / num_points << "\n";
        }
        std::cout << "\n";
    }
    return 0;
}
