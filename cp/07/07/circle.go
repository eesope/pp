package main

import "fmt"

type Circle struct {
  x, y, r int
}

func (c Circle) Draw() {  // value receiver
  fmt.Printf("(%d, %d), %d\n", c.x, c.y, c.r)
}

func (c *Circle) Scale(factor int) {  // pointer receiver
  c.r *= factor
}

func main() {
  c1 := Circle{0, 0, 1}
  c2 := Circle{
    x: 1,
    y: 2,
    r: 3,
  }

  c1.Draw()
  c2.Scale(5)
  c2.Draw()
}
