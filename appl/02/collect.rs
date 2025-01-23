use std::collections::HashMap;

fn main() {
    let a = [1, 2, 3];
    let v: Vec<_> = a.into_iter().collect();
    println!("{v:?}");
    assert_eq!(v, vec![1, 2, 3]);

    let v: Vec<_> = a.iter().collect();
    assert_eq!(v, vec![&1, &2, &3]);

    let v = vec![('a', 1), ('b', 2), ('c', 3)];
    let map: HashMap<_, _> = v.into_iter().collect();
    println!("{map:?}");

    let v: Vec<_> = "नमस्ते".chars().collect();
    println!("{v:?}");
}
