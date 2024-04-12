#include<stdio.h>

int sieve[1000];
int size = 1000;

void init_array() {
 for (int i = 0; i != size; i++) {
    sieve[i] = 1;
  }
  sieve[0] = 0;
  sieve[1] = 0;
}

void eliminate_multiples(int factor) {
    for (int i = factor + factor; i < size; i += factor) {
    sieve[i] = 0;
  }
}

int next_prime(int p) {
    for (int i = p + 1; i < size; i++) {
      if (sieve[i]) {
        return i;
      }
    }
    // should not get here, but return -1 if it happens
    return -1;
}

void print_primes() {
    // now exactly the array indices of the array that are prime will have contents of 1
    printf("Primes up to %d:\n", size);
    for (int i = 0; i != size; i++) {
        if (sieve[i]) {
            printf("%d ", i);
        }
    }
}

int main() {
    int current_prime = 2;
    init_array();
    
    do {
        eliminate_multiples(current_prime);
        current_prime = next_prime(current_prime);
    } while (current_prime * current_prime < size);
  
  print_primes();
  return 0;
}
