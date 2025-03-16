package main

import (
  "fmt"
  "math"
)

type Shape interface {
  Area() float64
}

type Circle struct {
  x, y, r float64
}

func (c Circle) Area() float64 {
  return c.r * c.r * math.Pi
}

type Rectangle struct {
  x1, y1, x2, y2 float64
}

func (r Rectangle) Area() float64 {
  return math.Abs((r.x1 - r.x2) * (r.y1 - r.y2))
}

func totalArea(shapes []Shape) float64 {
  total := 0.0

  for _, s := range shapes {
    total += s.Area()
  }

  return total
}

func main() {
  shapes := []Shape {
    &Circle{0.0, 0.0, 1.0},
    &Rectangle{1.0, 2.0, 3.0, 4.0},
    &Circle{1.0, 1.0, 2.0},
  }
  fmt.Println(totalArea(shapes))
}

