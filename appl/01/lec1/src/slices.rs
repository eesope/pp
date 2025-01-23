pub fn run() {
    println!("SLICES");
    let s = &[1, 2, 3];
    println!("{}", sum(s));

    let v = vec![3, 2, 7, 6, 8];

    fn is_even(x: i32) -> bool {
        x % 2 == 0
    }

    if let Some(x) = find(&v, is_even) {
        println!("First even integer is {}", x);
    } else {
        println!("No even integers");
    }
}

pub fn sum(s: &[i32]) -> i32 {
    let mut sum = 0;
    for x in s {
        sum += x;
    }
    sum
}

pub fn find(s: &[i32], f: fn(i32) -> bool) -> Option<i32> {
    for x in s {  // x has type &i32
        if f(*x) {
            return Some(*x);
        }
    }
    None
}
