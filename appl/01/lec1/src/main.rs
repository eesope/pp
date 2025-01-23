mod arrays;
mod numbers;
mod slices;
mod vectors;

mod tuples {
    pub fn run() {
        println!("TUPLES");
        let t = (1, 3.14);
        println!("{} {}", t.0, t.1);
        let t = (1, vec![2]);
        let (x, y) = t;
        // println!("{} {:?}", t.0, t.1);
    }
}

fn main() {
    numbers::run();
    arrays::run();
    vectors::run();
    slices::run();
    tuples::run();
}

fn double(s: &mut [i32]) {
    for x in s {
        *x *= 2;
    }
}
