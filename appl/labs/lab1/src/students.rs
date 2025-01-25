use std::io::{self};
use std::collections::BTreeMap;

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

fn to_format(list: Vec<String>) {
    let mut record_map: BTreeMap<i32, Vec<(String, String)>> = BTreeMap::new();

    for record in list {
        let parts: Vec<String> = record.split_whitespace().map(|s| s.to_string()).collect();
        let fname = parts[0].clone();
        let lname = parts[1].clone();
        let score = parts[2].parse::<i32>().unwrap();

        record_map.entry(score).or_insert_with(Vec::new).push((fname, lname));
    }
    let total: i32 = record_map.keys().map(|&key| key).sum();
    let average: f32 = total as f32 / record_map.len() as f32;
    println!("average: {:.1}", average);

    if let Some((min_score, min_students)) = record_map.first_key_value() {
        if let Some((max_score, max_students)) = record_map.last_key_value() {
            if min_score == max_score {
                println!("minimum & maximum score is same = {}", min_score);
                for (fname, lname) in min_students {
                println!("- {}, {}", lname, fname);
                }
            } else {
                println!("minimum score = {}", min_score);
                for (fname, lname) in min_students {
                    println!("- {}, {}", lname, fname);
                }

                println!("maximum score = {}", max_score);
                for (fname, lname) in max_students {
                    println!("- {}, {}", lname, fname);
                }
            }
        }
    }
}

pub fn main() {
    let student_list: Vec<String> = read_lines().unwrap();

    if student_list.len() == 0 {
        let msg = "Empty student list. Please check the file.";
        println!("{}", msg);
    } else {
        println!("-----------------------------------------------");
        println!("number of students: {:#?}", student_list.len());
        to_format(student_list.clone());
        println!("-----------------------------------------------");
    }
}