fn main() {
    let s = "hello";  // type &str
    // println!("{}", s[0]);  // cannot index into a string
    println!("{}", &s[0..1]);
    
    let s = "नमस्ते";
    // println!("{}", &s[0..1]);  // slicing a string can cause a
                                  // panic
    println!("{}", &s[0..3]);
    println!("{}", s.len());  // 18 bytes
    println!("{}", s.chars().count());

    let s2 = String::from("world");  // type String
    println!("{} {} {}", s2, s2.len(), s2.capacity());

    print_str(s);
    // print_string(s);
    // print_string_ref(s);

    print_str(&s2);   // deref coercion
    print_string_ref(&s2);
    print_string(s2);  // this moves s2
}

// A function that takes a &str can also accept a &String
fn print_str(s: &str) {
    println!("{s}");
}

fn print_string(s: String) {
    println!("{s}");
}

// cannot accept &str
fn print_string_ref(s: &String) {
    println!("{s}");
}
