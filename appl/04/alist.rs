// association list
struct Alist<K, V>(Vec<(K, V)>);

impl<K, V> Alist<K, V> {
    fn new() -> Self {
        Self(Vec::new())
    }

    fn len(&self) -> usize {
        self.0.len()
    }

    fn add(&mut self, key: K, value: V) {
        self.0.push((key, value));
    }

    fn into_iter(self) -> std::vec::IntoIter<(K, V)> {
        self.0.into_iter()
    }

    fn iter(&self) -> std::slice::Iter<(K, V)> {
        self.0.iter()
    }

    fn iter_mut(&mut self) -> std::slice::IterMut<(K, V)> {
        self.0.iter_mut()
    }
}

impl<K, V> IntoIterator for Alist<K, V> {
    type Item = (K, V);
    type IntoIter = std::vec::IntoIter<(K, V)>;

    fn into_iter(self) -> Self::IntoIter {
        Alist::into_iter(self)
    }
}

impl<'a, K, V> IntoIterator for &'a Alist<K, V> {
    type Item = &'a (K, V);
    type IntoIter = std::slice::Iter<'a, (K, V)>;

    fn into_iter(self) -> Self::IntoIter {
        self.iter()
    }
}
    

/* We can implement our own iterators but it's complicated
 * it's simpler to use the iterators of the internal Vec
struct AlistIter<K, V> {
    l: Alist<K, V>,
    i: usize,
}

impl<K: Clone, V: Clone> Iterator for AlistIter<K, V> {
    type Item = (K, V);

    fn next(&mut self) -> Option<(K, V)> {
        if self.i >= self.l.len() {
            None
        } else {
            let result = self.l.0[self.i].clone();
            self.i += 1;
            Some(result)
        }
    }
}
*/

fn main() {
    let mut l = Alist::new();
    l.add(1, "hello");
    l.add(2, "world");

    // following commented line moves l
    // l.into_iter().for_each(|(k, v)| { println!("{}: {}", k, v); });
    
    l.iter().for_each(|(k, v)| { println!("{}: {}", k, v); });

    for (k, v) in &l {
        println!("{}: {}", k, v);
    }
}

