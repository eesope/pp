use std::io::{self};
use std::collections::HashSet;

enum Range {
    Single(usize),
    From(usize),
    Between(usize, usize),
    UpTo(usize)
}

impl Range {

    // which Range is?
    fn parse(s: &str) -> Option<Self> {
        if s.contains('-') {
            let parts: Vec<&str> = s.split('-').collect();
            match parts.as_slice() {
                [""] => None,
                ["", m] => {
                    let m = m.parse().ok()?;
                    Some(Range::UpTo(m))
                }
                [n, ""] => {
                    let n = n.parse().ok()?;
                    Some(Range::From(n))
                }
                [n, m] => {
                    let n = n.parse().ok()?;
                    let m = m.parse().ok()?;
                    Some(Range::Between(n, m))
                }
                _ => None
            }
        } else {
            let n = s.parse().ok()?;
            Some(Range::Single(n))
        }
    }

    // contains specific #?
    fn contains(&self, n: usize) -> bool {
        match self {
            Range::Single(x) => n == *x,
            Range::From(x) => n >= *x,
            Range::Between(x, y) => n >= *x && n <= *y,
            Range::UpTo(y) => n <= *y,
        }
    }
}

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

fn cut_by_char(line: &str, ranges: &[Range]) -> String {
    let mut result = String::new();
    let mut included_indices = HashSet::new(); 

    for range in ranges {
        match range {
            Range::Single(n) => {
                if *n <= line.len() {
                    included_indices.insert(*n - 1);
                }
            }

            Range::From(n) => {
                for i in (*n - 1)..line.len() {
                    included_indices.insert(i);
                }
            }

            Range::Between(n, m) => {
                for i in (*n - 1)..(*m) {
                    if i < line.len() {
                        included_indices.insert(i);
                    }
                }
            }

            Range::UpTo(m) => {
                for i in 0..(*m) {
                    if i < line.len() {
                        included_indices.insert(i);
                    }
                }
            }
        }
    }

    let mut sorted_indices: Vec<usize> = included_indices.into_iter().collect();
    sorted_indices.sort();
    for i in sorted_indices {
        result.push(line.chars().nth(i).expect("REASON"));
    }
    result
}

fn cut_by_field(line: &str, ranges: &[Range], delimiter: &str) -> String {
    let fields: Vec<&str> = line.split(delimiter).collect(); 
    let mut result = Vec::new();

    for (i, field) in fields.iter().enumerate() {
        let position = i + 1; 
        if ranges.iter().any(|r| r.contains(position)) {
            result.push(*field);
        }
    }
    result.join(delimiter)
}

fn parse_ranges(s: &str) -> Vec<Range> {
    s.split(',')
        .filter_map(|part| Range::parse(part.trim()))
        .collect()
}

pub fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} -c<ranges> or -f<ranges>", args[0]);
        return;
    }

    let arg1 = &args[1];
    if arg1.len() < 2 {
        eprintln!("Invalid argument: {}", arg1);
        return;
    }

    let flag = &arg1[1..2];
    let ranges_str = &arg1[2..];
    let ranges = parse_ranges(ranges_str);

    let data = read_lines().unwrap();
    if data.is_empty() {
        println!("Empty file");
        return;
    } else if flag.is_empty() {
        println!("Flag not entered")
    } else {
        println!("------------------- RESULT ----------------------------");
        for line in data {
            let result = match flag {
                "c" => cut_by_char(&line, &ranges),
                "f" => cut_by_field(&line, &ranges, "\t"),
                _ => {
                    eprintln!("Invalid flag: {}", flag);
                    continue;
                }
            };
            println!("{}", result);
        }
        println!("-------------------------------------------------------");
    }
}