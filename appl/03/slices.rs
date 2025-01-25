use std::ops::AddAssign;

/*
fn sum(s: &[i32]) -> i32 {
    let mut sum = 0;

    for x in s {
        sum += *x;
    }

    sum
}
*/

fn sum<T: AddAssign + Copy>(s: &[T]) -> T {
    let mut sum = s[0];

    for x in s.into_iter().skip(1) {
        sum += *x;
    }

    sum
}

fn find<T>(s: &[T], f: fn(&T) -> bool) -> Option<&T> {
    for x in s {
        if f(x) {
            return Some(x);
        }
    }
    None
}

fn find2<T, F>(s: &[T], f: F) -> Option<&T>
    where F: Fn(&T) -> bool {
    for x in s {
        if f(x) {
            return Some(x);
        }
    }
    None
}

fn main() {
    let a = [1.1, 2.2];
    println!("{}", sum(&a));

    let v = vec![3, 2, 7, 6, 8];
    println!("{}", sum(&v));
    
    fn is_even(x: &i32) -> bool { x % 2 == 0 }
    if let Some(x) = find(&v, is_even) {
        println!("{x}");
    }

    let n = 3;
    // the following doesn't compile because a fn cannot capture
    // outside objects
    // fn is_divisble(x: &i32) -> bool { x % n == 0 }

    let is_divisible = |x: &i32| *x % n == 0;  // OK, closure
    // let _ = find(&v, is_divisible);  // find doesn't take a closure
    if let Some(x) = find2(&v, is_divisible) {
        println!("{x}");
    }

    // also works with regular fn
    if let Some(x) = find2(&v, is_even) {
        println!("{x}");
    }
}
