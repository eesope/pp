// into_iter(), iter(), iter_mut()
// IntoIterator trait has into_iter method
fn main() {
    let v = vec![1, 2, 3];

    // this consumes v
    v.into_iter().for_each(|x| { println!("{x}"); });
    // println!("{v:?}");

    let v = vec![1, 2, 3];
    v.iter().for_each(|x| { println!("{x}"); });  // x: &i32
    println!("{v:?}");

    let mut v = vec![1, 2, 3];
    v.iter_mut().for_each(|x| { *x += 1; });  // x: &mut i32
    println!("{v:?}");
}

