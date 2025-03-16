package util

import (
  "sync"
)

type Counter struct {
  mutex sync.Mutex
  Value int
}

func NewCounter(value int) *Counter {
  c := new(Counter)
  c.mutex = sync.Mutex{}
  c.Value = value
  return c
}

func (c *Counter) Inc() {
  c.mutex.Lock()
  c.Value++
  c.mutex.Unlock()
}

