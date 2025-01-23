# Functional Programming

## [A Tour of OCaml](https://ocaml.org/docs/tour-of-ocaml)
- values, expressions, lists, functions, pattern matching, ... 

### Expressions and Definitions

- everything has a value, and every value has a type

```
  1 + 2;;      (* expression *)
  3;;          (* value *)
  let x = 2;;  (* definition *)
  let x = 1 in let y = 2 in x + y;;  (* let expression *)
```

- some basic types: int, float, bool (true/false), char, string

- some operators
```  
  + - * / versus +. -. *. /.
  < <= > >= = <>
  @ list concatenation
  ^ string concatenation
  ```

- type inference: automatically determines the type of an expression
- double semicolon ;; at the end tells the toplevel (utop) to evaluate and print the result of the given phrase

- empty list is just []

```
# let u = [1; 2; 3; 4];;
val u : int list = [1; 2; 3; 4]

# ["this"; "is"; "mambo"];;
- : string list = ["this"; "is"; "mambo"]

# [];; 
- : 'a list = []

# 9 :: u;;
- : int list = [9; 1; 2; 3; 4]
```

- if … then … else … is not a statement; it is an expression! It means it has value so it can be used in other expression.

```
utop # 2 * if "hello" = "world" then 3 else 5;;
```

- When entering let x = 50;;, OCaml responds with val x : int = 50,

```
# let x = 50;;
val x : int = 50

# x * x;;
- : int = 2500	  
```

Bindings in OCaml are immutable, 
meaning that the value assigned to a name never changes. 
Although x is often called a variable, it is not the case. It is in fact a constant. 

- Again, reference
all variables are immutable in OCaml. 
It is possible to give names to values that can be updated. In OCaml, this is called a reference.

- No dashes in names

- Names can be defined locally, within an expression, using the let … = … in … syntax:
Note that y is only defined in the expression following the in keyword.

- In OCaml, the equality symbol has two meanings. It is used in definitions and equality tests.

- equality (structial(=), physically(==))
- The operator <> is the negation of =, while != is the negation of ==.

- "not" only act on bool
- not;;

### fuctions are value

```
# let square x = x * x;;
val square : int -> int = <fun>

# square 50;;
- : int = 2500
```

- There is no “return” keyword in OCaml.

- anonymous functions
```
# (fun x -> x * x) 50;;
- : int = 2500
```

- Type parameters and higher-order functions
```
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>

# List.map (fun x -> x * x) [0; 1; 2; 3; 4; 5];;
- : int list = [0; 1; 4; 9; 16; 25]
```

Function List.map has two parameters: the second is a list, and the first is a function that can be applied to the list's elements, whatever they may be.

### polymorphism
The function List.map can be applied on any kind of list. Here it is given a list of integers, but it could be a list of floats, strings, or anything. This is known as polymorphism. 


The List.map function is polymorphic, meaning it has two implicit type variables: 'a and 'b (pronounced “alpha” and “beta”). They both can be anything; however, in regard to the function passed to List.map:

1. Input list elements have the same type of its input.
2. Output list elements have the same type of its output.


### side-effects and the unit type

```
utop # print_endline;;
- : string -> unit = <fun>
─( 22:24:25 )─< command 38 >──────────{ counter: 0 }─
utop # print_endline "도넛 최고";;
도넛 최고
- : unit = ()
```

The function read_line doesn't need any data to proceed, 
and the function print_endline doesn't have any meaningful data to return.

Indicating this absence of data is the role of the unit type, which appears in their signature. 
The type unit has a single value, written () and pronounced “unit.” 

It is used as a placeholder when no data is passed or returned, but some token still has to be passed to start processing or indicate processing has terminated.

Input-output is an example of something taking place when executing a function but which does not appear in the function type. 
ex) print()

This is called a side-effect and does not stop at I/O. 
The unit type is often used to indicate the presence of side-effects, although it's not always the case.


### Recursive functions

A recursive function calls itself in its own body. 

For iterative computation on OCaml: Loops (for, while) are available, but they are meant to be used when writing imperative OCaml in conjunction with mutable data. 
Otherwise, recursive functions should be preferred.


```
let rec … = … 

# let rec range lo hi =
    if lo > hi then
      []
    else
      lo :: range (lo + 1) hi;;
val range : int -> int -> int list = <fun>

# range 2 5;;
- : int list = [2; 3; 4; 5]
```

 Prepending is achieved using ::, the cons operator in OCaml. 

 ### data and typing

OCaml has floating-point values of type float. To add floats, one must use +. instead of +


In many programming languages, values can be automatically converted from one type into another. This includes implicit type conversion and promotion. For example, in such a language, if you write 1 + 2.5, the first argument (an integer) is promoted to a floating point number, making the result a floating point number, too.

OCaml never implicitly converts values from one type to another. It is not possible to perform the addition of a float and integer. Both examples below throw an error.

In OCaml you need to explicitly convert the integer to a floating point number using the float_of_int function. 

- why OCaml requires explicit conversions? 
Most importantly, it enables types to be worked out automatically. 
OCaml's type inference algorithm computes a type for each expression and requires very little annotation, in comparison to other languages. 
Arguably, this saves more time than we lose by being more explicit.


### polymorphic functions on Lists
Ordered collections of values having the same type.
list can contain list, empty, int, bool, and so on...

```
[1; 2] = 1 :: 2
```

In OCaml, pattern matching provides a means to inspect data of any kind, except functions. 
Here is how pattern matching can be used to define a recursive function that computes the sum of a list of integers:
```
# let rec sum u =
    match u with
    | [] -> 0
    | x :: v -> x + sum v;;
val sum : int list -> int = <fun>

# sum [1; 4; 3; 2; 5];;
- : int = 15
```

```
let rec length l =
 match l with
 | [] -> 0
 | _ :: xs -> 1 + length xs;; (* recursion call caution length xs *)
val length : 'a list -> int = <fun>
```

### defining a higher-order function

 Functions having other functions as parameters are called higher-order functions.

```
utop # let rec map f l =
 match l with
 | [] -> []
 | x :: l -> f x :: map f l;; 

 (* list of x :: l -> call the function (x) x for the first element,
  and then recursion call for same function and rest of the list *)

val map : ('a -> 'b) -> 'a list -> 'b list = <fun>

map square [1; 2; 3; 4];;
```

### pattern matching, cont'd

Patterns are expressions that are compared to an inspected value. 
It can inspect any data, except functions.

```
# let g x =
  if x = "foo" then 1
  else if x = "bar" then 2
  else if x = "baz" then 3
  else if x = "qux" then 4
  else 0;;
val g : string -> int = <fun>

# let g' x = match x with
    | "foo" -> 1
    | "bar" -> 2
    | "baz" -> 3
    | "qux" -> 4
    | _ -> 0;;
val g' : string -> int = <fun>
```

### pairs and tuples
Access to the components of tuples

note: list uses ; and tupple uses , to seperate elements

```
# let snd p =
    match p with
    | (_, y) -> y;;
val snd : 'a * 'b -> 'b = <fun>

# snd (42, "apple");;
- : string = "apple"
```

### variant types

pattern matching generalises switch statements
variant types generalise enumerated and union types

```
# type primary_colour = Red | Green | Blue;;
type primary_colour = Red | Green | Blue

# [Red; Blue; Red];;
- : primary_colour list = [Red; Blue; Red]
```

```
# type page_range =
    | All
    | Current
    | Range of int * int;;
type page_range = All | Current | Range of int * int
```

the capitalised identifiers are called constructors. They allow the creation of variant values. This is unrelated to object-oriented programming.

```
# type page_range = 
 | All
 | Current
 | Range of int * int;;
type page_range = All | Current | Range of int * int

# let is_printable page_count cur range = 
 match range with
 | All -> true
 | Current -> 0 <= cur && cur < page_count
 | Range (lo, hi) -> 0 <= lo && lo <= hi && hi < page_count;;
val is_printable : int -> int -> page_range -> bool =
  <fun>

 # is_printable 50 3 (Range(3, 7));;
- : bool = true
```

### record type

```
utop # type cat = {
 first_name: string;
 family_name: string;
 age: int;
};;
type cat = {
  first_name : string;
  family_name : string;
  age : int;
}


utop # let domingo = {
 first_name= "Domingo";
 family_name= "Mun";
 age= 11
};;
val domingo : cat =
  {first_name = "Domingo"; family_name = "Mun";
   age = 11}
```

- type checker will search for a record which has exactly three fields with matching names and types.
Note that there are no typing relationships between records. 
- not possible to declare a record type that extends another by adding fields. 
Record type search will succeed if it finds an exact match and fails in any other case.

```
utop # let client01 = domingo.family_name;;
val client01 : string = "Mun"

─( 12:16:32 )─< command 84 >───────────{ counter: 0 }─
utop # let is_teenager cat = 
 match cat with 
 | { age = x; _} -> 13 <= x && x <= 19;;
val is_teenager : cat -> bool = <fun>

─( 12:16:39 )─< command 85 >───────────{ counter: 0 }─
utop # is_teenager domingo;;
- : bool = false

```

### dealing with errors

Exceptions are raised using the raise function.
Note that exceptions do not appear in function types.

```
let id_42 n = if n <> 42 then raise (Denied "Wrong pass code entered") else n;;
Error: This variant expression is expected to have type
         exn
       There is no constructor Denied within type exn

(* Failure is keyword! *)
 
let id_42 n = if n <> 42 then raise (Failure "Wrong pass code entered") else n;;
val id_42 : int -> int = <fun>

utop # id_42 42;;
- : int = 42

utop # id_42 0;;
Exception: Failure "Wrong pass code entered".

# try id_42 0 with Failure _ -> 404;;
- : int = 404
```

The standard library provides several predefined exceptions. It is possible to define exceptions.


### using the result type

```
# let id_42_res n = if n <> 42 then Error "Wrong code" else Ok n;;
val id_42_res : int -> (int, string) result = <fun>

# id_42_res 42;;
- : (int, string) result = Ok 42

# id_42_res 0;;
- : (int, string) result = Error "Wrong code"

# match id_42_res 0 with
  | Ok n -> n
  | Error _ -> 0;;
- : int = 0
```


### workig with mutable state
OCaml supports imperative programming. 
Usually, the let … = … syntax does not define variables, it defines constants. 
However, mutable variables exist in OCaml, which called references. 

```
# let r = ref 0;;
val r : int ref = {contents = 0}

# !r;;
- : int = 0


# r := 42;;
- : unit = ()

# !r;;
- : int = 42

# let text = ref "hello ";;
val text : string ref = {contents = "hello "}

# print_string !text; text := "world!"; print_endline !text;;
hello world!
- : unit = ()

(* final result of hello world! is combinded both the outputs of
 print_string and print_endline. 
 since printing has a side-effect. *)

```
It is syntactically impossible to create an uninitialised or null reference. 
The r reference is initialised with the integer zero. Accessing a reference's content is done using the ! de-reference operator.

Note that !r and r have different types: int and int ref, respectively. Just like it is not possible to perform multiplication of an integer and a float, it is not possible to update an integer or multiply a reference.

To update the content of r, := is the assignment operator(receives).
This returns () because changing the content of a reference is a side-effect.

Execute an expression after another with the ; operator. Writing a; b means: execute a. Once done, execute b, only returns the value of b.
However, although ; is not defined as a function, it behaves as if it were a function of type unit -> unit -> unit.


### modules and the standard library

Organising source code in OCaml is done using something called modules. A module is a group of definitions. 
The standard library is a set of modules available to all OCaml programs. (ex. Option, List, etc. ..)

```
# #show Option;;
module Option :
  sig
    type 'a t = 'a option = None | Some of 'a
    val none : 'a t
    val some : 'a -> 'a t
    val value : 'a t -> default:'a -> 'a
    val get : 'a t -> 'a
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val join : 'a t t -> 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
    val iter : ('a -> unit) -> 'a t -> unit
    val is_none : 'a t -> bool
    val is_some : 'a t -> bool
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val to_result : none:'e -> 'a t -> ('a, 'e) result
    val to_list : 'a t -> 'a list
    val to_seq : 'a t -> 'a Seq.t
  end
```

To find the definitions:
```
#Option.map;;
```

- Option type can have or don't have values.
Some x -> value exist
None -> value doesn't exist

``` 
type 'a option = 
  | None          (* 값이 없음 *)
  | Some of 'a    (* 값이 있음 *)

```

Option is a type that represents a situation where there may or may not be a value, and Some is used to enclose a value when it exists. Option.map is a useful way to apply a function to an option type.

- module sysstem can prevent name clashes

### and so on

- ('a -> 'b)

'a and 'b is type variables, generic type. It doesn't specify which type, but shows various types (list, int, float, string, ...) can be assigned.

In OCaml, type variables are always start with ' and following with alphabet.

('a -> 'b) means the function that receives whatever the type 'a var and returns type 'b var.

Generic type expression helps functions to have flexability and reusability.

```
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>
(* List.map function receives: 
	a function and a list as arguments, and
	returns a list. *)

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>
```


### no main function
A compiled OCaml file behaves as though that file were entered line by line into the toplevel. In other words, an executable OCaml file's entry point is its first line.

Double semicolons aren't needed in source files like they are in the toplevel. Statements are just processed in order from top to bottom, each triggering the side effects it may have. Definitions are added to the environment. Values resulting from nameless expressions are ignored. Side effects from all those will take place in the same order. That's OCaml main.























