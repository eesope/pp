package main

import "fmt"

var a, b int  // contain zero value

func main() {
  fmt.Println(a, b)
  var c = 1
  d := "hello"  // short declaration
  e, f := 2, "world"
  fmt.Println(c, d, e, f)
  e, g := 3, 4
  fmt.Println(e, g)

  arrays()
  slices()
  maps()
}

func arrays() {
  fmt.Println("ARRAYS")
  var a [5]int   // uninitialized; contains zero values
  fmt.Println(a)
  a = [5]int{3, 2, 7, 6, 8}  // arrays are values
  b := [5]int{1, 2, 3, 4, 5}
  c := [...]int{5, 4, 3, 2, 1}  // compiler counts # of elements
  fmt.Println(a, b, c)
  a = b
  fmt.Println(a, b, c)
  fmt.Println(sum5(a))
  double(&a)
  fmt.Println(a)
}

func slices() {  // descriptor of contiguous segment of underlying array
  var x []int    // nil slice
  y := []int{}   // empty slice
  fmt.Println(x, y)
  fmt.Println(x == nil)  // true; can only compare a slice to nil
  fmt.Println(y == nil)  // false
  a := []int{1, 2, 3, 4, 5}  // address + len + cap
  fmt.Println(a, len(a), cap(a))
  b := [...]int{1, 2, 3, 4, 5, 6, 7}
  s := b[1:4]  // lo:hi; half-open
  fmt.Println(s, len(s), cap(s))
  s[0] = -2
  fmt.Println(b, s)
  t := append(s, -5)  // append returns new slice
  fmt.Println(b, s, t)
  t = append(t, -6, -7, -8)
  fmt.Println(b, t)
  fmt.Println(sum_slice(b[:]))
  t = append(t, s...)  // spread operator
  x = append(x, 1)  // OK; can append to a nil slice
  fmt.Println(x)
}

func maps() {
  fmt.Println("MAPS")
  var x map[string]int  // nil
  fmt.Println(x)
  // x["homer"] = 25  // panics
  y := map[string]int{}  // empty map
  y["homer"] = 25
  fmt.Println(y["homer"], y["bart"])  // note: zero value
  a := y["homer"]
  fmt.Println(a)
  a, ok := y["monty"]
  if ok {
    fmt.Println(a)
  }
  if b, ok := y["homer"]; ok {
    fmt.Println(b)
  }
  x = make(map[string]int)
  x["bart"] = 55

  z := map[string]int {
    "homer": 55,
    "bart": 76,
    "monty": 99,
  }

  for k, v := range z {
    fmt.Println(k, ":", v)
  }

  delete(z, "monty")
  fmt.Println(z)
}

func sum_slice(s []int) int {
  sum := 0
  for _, x := range s {  // index, copy of element
    sum += x
  }
  return sum
}

func sum5(a [5]int) int {
  sum := 0

  for i := 0; i < 5; i++ {  // no ++i
    sum += a[i]
  }  
  return sum
}

func double(a *[5]int) {
  for i := 0; i < 5; i++ {
    a[i] *= 2
  }
}
