package main

import (
  "fmt"
  "sync"

  "elixir/lec8/util"
)

func inc(c *util.Counter, wg *sync.WaitGroup) {
  defer wg.Done()

  for i := 0; i < 100_000; i++ {
    c.Inc()
  }
}

func main() {
  util.Hello()

  wg := sync.WaitGroup{}
  wg.Add(2)
  c := util.NewCounter(0)
  go inc(c, &wg)
  go inc(c, &wg)

  wg.Wait()
  fmt.Println(c.Value)
  // note: when main returns, all goroutines are killed
}

