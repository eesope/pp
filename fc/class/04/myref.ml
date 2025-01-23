type 'a ref = {mutable contents: 'a}

let ref v = {contents = v}

let ( ! ) r = r.contents

let ( := ) r v = r.contents <- v

let incr r = r.contents <- !r + 1

let decr r = r.contents <- !r - 1
