// example of enum type
enum Shape {
    Circle(f32, f32, f32),  // tuple struct; x, y-coords, radius
    Square(f32),
}

impl Shape {
    fn area(&self) -> f32 {
        match self {
            Shape::Circle(_, _, r) =>
                std::f32::consts::PI * r * r,
            Shape::Square(x) =>
                x * x
        }
    }
}

fn main() {
    let a = [Shape::Circle(1.0, 1.0, 2.0), Shape::Square(1.0)];
    a.iter().for_each(|s| println!("{}", s.area()));
}
