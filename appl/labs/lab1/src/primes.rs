use std::collections::HashMap;

// generate primes up to n using the Sieve of Eratosthenes
fn sieve(n: usize) -> Vec<bool> {
    let mut sieve = vec![true; n + 1];
    sieve[0] = false;
    sieve[1] = false;

    for i in 2..=((n + 1) as f64).sqrt() as usize {
        if sieve[i] {
            for j in (i * i..=n).step_by(i) {
                sieve[j] = false;
            }
        }
    }
    sieve
}

// returns a vector containing all primes p
pub fn primes(m: usize, n: usize) -> Vec<usize> {
    let sieve_result = sieve(n);
    let mut prime_list = Vec::new();

    for i in m..n {
        if sieve_result[i] {
            prime_list.push(i);
        }
    }
    prime_list
}

fn find_largest(m: usize, n: usize) {
    let prime_list = primes(m, n);
    let mut permu_map: HashMap<String, Vec<usize>> = HashMap::new();

    for prime in prime_list {
        let mut sorted = prime.to_string().chars().collect::<Vec<char>>();
        sorted.sort();
        let sorted_key = sorted.into_iter().collect::<String>();

        permu_map.entry(sorted_key).or_insert_with(Vec::new).push(prime);
    }

    let mut largest_set = Vec::new();
    for (_key, group) in permu_map {
        if group.len() > largest_set.len() {
            largest_set = group;
        }
    }

    println!("Size of largest set of permutations: {}", largest_set.len());
    println!("Largest set of permutations: {:?}", largest_set);
}

pub fn main() {
    let m = 100000; 
    let n = 1000000;

    find_largest(m, n);
}
