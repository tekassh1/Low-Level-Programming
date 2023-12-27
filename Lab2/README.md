# Assignment №2:  Dictionary in assembly
---
Project: assembler dictionary

## Linked List

A linked list &mdash; is a data structure. An empty list is a null pointer; a non-empty list is a pointer to the first element of the list.
Each element contains data and a pointer to the next element.


Here is an example of a linked list (100, 200, 300). 
Its beginning can be found by the `x1` pointer:

```nasm
section .data

x1: 
dq x2
dq 100

x2: 
dq x3
dq 200

x3: 
dq 0
dq 300
```
 
Often there is a need to store a set of data in some container. With a container, we perform operations to access its elements, add an element to the beginning or end, or to an arbitrary position, and sort it.

Different containers make some of these operations easy and fast, and others &mdash; slow.
For example, it is inconvenient to add elements to an array, but you can quickly refer to an already existing one by index.
In a linked list, on the contrary, it is convenient to add elements anywhere, but accessing by index is more difficult &mdash; you have to look through the whole list from the beginning.

## Task

You need to implement a dictionary in assembly language in the form of a linked list.
Each occurrence contains the address of the next pair in the dictionary, a key and a value. 
Keys and values &mdash; addresses of null-terminated strings.

The dictionary is set statically, each new element is added to the beginning of the dictionary. 
With the help of macros we automate this process so that by specifying a new element with a new language construct it will be automatically added to the beginning of the list, and the pointer to the beginning of the list will be updated. This way we don't have to manually maintain the correctness of the links in the list. 

Create a `colon` macro with two arguments: a key and a label that will be mapped to a value.
This label cannot be generated from the value itself, as there may be characters in the string that cannot occur in labels, such as arithmetic characters, punctuation marks, etc. After using such a macro, you can directly specify the value to be mapped to the key. Example usage:

```nasm
section .data

colon "third word", third_word
db "third word explanation", 0

colon "second word", second_word
db "second word explanation", 0 

colon "first word", first_word
db "first word explanation", 0 
```

The following files need to be provided in the implementation:

- `lib.asm`
- `lib.inc`
- `colon.inc`
- `dict.asm`    
- `dict.inc`    
- `words.inc`
- `main.asm`

### Instructions


- Format the functions you implemented in the first lab as a separate `lib.o` library.


  Remember to make all function names globally labeled and list them in `lib.inc`.


- Create a file `colon.inc` and define in it a macro for creating words in the dictionary. 


  The macro takes two parameters:
    - Key (in quotes)
    - The name of the label by which the value will be located.


- In the `dict.asm` and `dict.inc` files, create the `find_word` function. It takes two arguments:
  - A pointer to a null-terminated string.
  - A pointer to the beginning of the dictionary.


  `find_word` will traverse the entire dictionary looking for a matching key. If a matching occurrence is found, it will return the address of the *beginning of the dictionary* (not the value), otherwise it will return 0. 


- The `words.inc` file should store the words defined with the `colon` macro. Include this file in `main.asm`.
- In `main.asm`, define a function `_start` that:
  
  - Reads a string of 255 characters or less into a buffer with `stdin`.
  - Tries to find a occurrence in the dictionary; if found, prints to `stdout` the value for that key. Otherwise it prints an error message.


  Remember to print error messages to `stderr`.


- Be sure to provide a `Makefile`.
- Write tests for your dictionary implementation. The tests should be run by the `test` target of the `makefile`.
