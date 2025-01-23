fn square_root(x: f32) -> Option<f32> {
    if x >= 0.0 {
        Some(x.sqrt())
    } else {
        None
    }
}

fn f(x: f32) -> Option<f32> {
    /*
    if let Some(y) = square_root(x) {
        Some(y.ln())
    } else {
        None
    }
    */
    Some(square_root(x)?.exp())
}

fn main() {
    let x = square_root(2.0).unwrap();  // unwrap() may panic
    println!("{x}");

    // also may panic
    let x = square_root(2.0).expect("arg must be non-negative");
    println!("{x}");

    let x = f(-1.0);
    println!("{x:?}");
}

