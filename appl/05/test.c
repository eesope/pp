#include <stdio.h>

#define CHECK(pred)  printf("%s ... %s\n", #pred, pred ? "passed" : "FAILED")

int main() {
  CHECK(1 + 1 == 2);
  CHECK(1 + 2 == 2);
  return 0;
}

