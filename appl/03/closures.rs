fn main() {
    let v = vec![1, 2, 3, 4];
    let c = || println!("{v:?}");  // borrow v; impl Fn
    println!("{v:?}");
    c();
    c();

    let mut v = vec![1, 2, 3, 4];
    let mut c = || v.push(-1);  // mutably borrow v; impl FnMut
    // println!("{v:?}");  // can't borrow v again
    c();
    c();
    println!("{v:?}");

    let s = "hello".to_string();
    let c = || s;   // s moved; impl FnOnce only
    // println!("{s}");  // s has moved
    c();
    // c();  // cannot call a second time
}

