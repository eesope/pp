package main

import (
  "fmt"
  "os"
)

func greet(lang string) {
  switch lang {
  case "en":
    fmt.Println("hello")
  case "fr":
     fmt.Println("bonjour")
  case "ja":
     fmt.Println("こんにちは")
  default:
    fmt.Println("goodbye")
  }
}

func main() {
  if len(os.Args) == 1 {
    greet("en")
  } else {
    greet(os.Args[1])
  }
}

