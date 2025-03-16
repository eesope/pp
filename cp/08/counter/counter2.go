package main

import (
  "fmt"
  "sync"
)

var mutex sync.Mutex
var count = 0
var wg sync.WaitGroup

func inc() {
  defer wg.Done()
  for i := 0; i < 100_000; i++ {
    mutex.Lock()
    count++
    mutex.Unlock()
  }
}

func main() {
  wg.Add(2)
  go inc()
  go inc()

  wg.Wait()
  fmt.Println(count)
  // note: when main returns, all goroutines are killed
}

