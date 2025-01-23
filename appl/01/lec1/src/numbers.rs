pub fn run() {
    println!("NUMBERS");
    let x = 1;
    // println!("{}", x + 256);
    println!("{}", x + 1u8); // x has type u8

    let x = 42;
    println!("{}", square(x));
    println!("{}", x + &1);
    // println!("{}", x + &&1);

    let mut x = 12;
    println!("{}", square2(&x));
    triple(&mut x);
    println!("{}", x);
    println!("{}", &x);
    println!("{}", &&x);
    println!("{}", &&&x);

    let r = &x;
    // x = 1;   // cannot mutate as there's a borrow
    println!("{}", x);
    println!("{}", r);

    let mut x = 10;
    let r = &mut x;
    // println!("{}", x);
    println!("{}", r);
}

fn square(x: i32) -> i32 {
    x * x
}

fn square2(x: &i32) -> i32 {
    x * x
}

fn triple(x: &mut i32) {
    // mutable borrow
    *x *= 3;
}
