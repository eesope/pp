package main

import (
	"fmt"
	"sort"
	"strconv"
)

// get prime numbers between m <= p < n
func primes(m, n int) []int { // precondition: 0 <= m < n
	pSlice := sieve(m, n)
	var result []int

	for _, p := range pSlice { // need only value p, not index
		if p >= m && p < n {
			result = append(result, p)
		}
	}
	return result
}

// helper function: filter only prime numbers
func sieve(m, n int) []int {
	isPrime := make([]bool, n+1)
	for i := 2; i <= n; i++ {
		isPrime[i] = true
	}
	for i := 2; i*i <= n; i++ {
		if isPrime[i] {
			for j := i*i; j <= n; j += i {
				isPrime[j] = false
			}
		}
	}
	var primes []int
	for i := 2; i <= n; i++ {
		if isPrime[i] {
			primes = append(primes, i)
		}
	}
	return primes
}

// group prime numbers with same numbers -> get largest group
func largestPGroup (primes []int) int {
	
	// key: index of each prime number, value: one letter of number 
	groups := make(map[string][]int)

	for _, p := range primes {
		str := strconv.Itoa(p)
		sortedStr := sortedStr(str)
		groups[sortedStr] = append(groups[sortedStr], p)
	}

	maxSize := 0
	for _, group := range groups {
		if len(group) > maxSize {
			maxSize = len(group)
		}
	}
	return maxSize
}

func sortedStr(str string) string {	
	strSlice := []rune(str)
	sort.Slice(strSlice, func (i, j int) bool {
		return strSlice[i] < strSlice[j]	
	})
	return string(strSlice)
}

func main() {
	m, n := 100000, 1000000
	pSlice := primes(m, n)
	lGroup := largestPGroup(pSlice)

	fmt.Printf("size of the set of all 6-digit primes: %d\n", len(pSlice))
	fmt.Printf("size of the largest set of 6-digit primes that are permutations of one another: %d\n", lGroup)
}
