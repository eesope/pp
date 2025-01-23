pub fn run() {
    println!("VECTORS");
    let v = vec![3, 2, 7, 6, 8];
    println!("{v:?}");
    println!("{}", sum(v));
    // println!("{v:?}");  can't use v since it's been moved

    let v = vec![1, 2, 3];
    println!("{}", sum2(&v));
    println!("{v:?}");
    println!("{}", super::slices::sum(&v));

    let mut v = vec![3, 2, 1];
    super::double(&mut v);
    println!("{v:?}");
}

fn sum(v: Vec<i32>) -> i32 {
    let mut sum = 0;

    for x in v {
        sum += x;
    }
    sum
}

fn sum2(v: &Vec<i32>) -> i32 {
    let mut sum = 0;

    for x in v {
        sum += x;
    }
    sum
}
