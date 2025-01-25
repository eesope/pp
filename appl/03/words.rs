use std::io;

fn words() -> io::Result<Vec<String>> {
    Ok(io::read_to_string(io::stdin())?
        .split_whitespace()
        .map(|s| s.to_string())
        .collect())
}

fn main() {
    let words = words().unwrap();
    println!("{words:?}");
}
