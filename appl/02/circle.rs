use std::fmt;

struct Point(f32, f32);  // tuple struct

struct Vector(f32, f32);

struct Circle {
    center: Point,
    radius: f32,
}

impl Circle {
    fn new(center: Point, radius: f32) -> Self {
        Self {
            center,
            radius,
        }
    }

    fn scale(&mut self, factor: f32) {
        self.radius *= factor;
    }

    fn translate(&mut self, v: Vector) {
        self.center.0 += v.0;
        self.center.1 += v.1;
    }

    fn area(&self) -> f32 {
        std::f32::consts::PI * self.radius * self.radius
    }
}

impl fmt::Display for Circle {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.center, self.radius)
    }
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.0, self.1)
    }
}

fn main() {
    let mut c = Circle::new(Point(0.0, 0.0), 1.0);
    println!("{}", c.area());
    println!("{}", Circle::area(&c));

    c.scale(2.0);
    println!("{}", c.area());

    Circle::scale(&mut c, 0.5);
    println!("{}", Circle::area(&c));

    println!("{c}");
}
