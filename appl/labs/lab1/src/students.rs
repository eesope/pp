use std::io::{self};

// if there is no student data in the input
fn read_lines() -> io::Result<Vec<String>> {
    let mut v = Vec::new();

    for line in io::stdin().lines() {
        match line {
            Ok(line) => v.push(line),  
            Err(e) => return Err(e),
        }
    }

    Ok(v)
}

// What if min == max score?
// 
// println!("
//     average: 00.0
//     minimum score = 00
//     - lname, fname
//     - lname, fname
//     maximum score = 00
//     - lname, fname
//     - lname, fname
// ");

// map {"score": tuple {"fname", "lname"}}


pub fn main() {
    let student_list: Vec<String> = read_lines().unwrap();


    if student_list.len() == 0 {
        let msg = "Empty student list. Please check the file.";
        println!("{}", msg);
    } else {
        println!("-----------------------------------------------");
        println!("number of students: {:#?}", student_list.len());
        println!("-----------------------------------------------");
        println!("number of students: {:#?}", student_list);
    }

}