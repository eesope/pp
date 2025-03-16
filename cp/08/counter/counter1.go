// version with race condition
package main

import (
  "fmt"
  "time"
)

var count = 0

func inc() {
  for i := 0; i < 100_000; i++ {
    count++
  }
}

func main() {
  go inc()
  go inc()

  time.Sleep(2 * time.Second)
  fmt.Println(count)
  // note: when main returns, all goroutines are killed
}

