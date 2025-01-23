pub fn run() {
    println!("ARRAYS");

    let a = [3, 2, 7, 6, 8];
    println!("{a:?}");
    print(&a);
    print2(&a);

    let mut a = [1, 2, 3, 4, 5];
    a[0] = -1;
    double(&mut a);
    println!("{a:?}");
}

fn print(a: &[i32; 5]) {
    for i in 0..5 {
        println!("{}", a[i]);
    }
}

fn print2(a: &[i32; 5]) {
    for x in a {
        println!("{x}");
    }
}

fn double(a: &mut [i32; 5]) {
    for x in a {  // x has type &mut i32
        *x *= 2;
    }
}
