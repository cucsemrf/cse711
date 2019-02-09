
# uCML (uhh-KaM-əl)) 
####      - a strictly typed static functional programming language. 

A baby programming language for learning principles and theories of undergrad/grad level Computer Science courses on Compilers and Priciples of Programming Languages. The compiler for the uCAML is implemented using FLEX, BISON and LLVM.

### CFG
```
program -> stmts 
		
stmts   -> stmt  | stmts stmt;

stmt    -> var_decl | func_decl | extern_decl  | expr   
        | if ( expr ) block  | if ( expr ) block else block 
        | for (  id :  id in expr to expr ) block  | for (  id :  id in expr to expr by expr ) block  
        | return expr  
        
block  -> { stmts } | { }  
 
var_decl ->  id :  id  |  id :  id = expr   

extern_decl -> extern  id ( func_decl_args ) :  id 

func_decl -> def  id ( func_decl_args ) :  id => block   | (func_decl_args) :  id => block  
	 
func_decl_args :  epsilon  | var_decl    | func_decl_args , var_decl  

expr ->  id = expr   |  id ( call_args )  | (call_args )   |  id  | expr % expr   | expr * expr  
     | expr / expr   | expr +  expr   |  expr comparison expr   | expr - expr   | ( expr )   | numeric 

numeric -> int | double  

call_args  -> epsilon  | expr   | call_args , expr    

comparison -> == | != | < | <= | > | >=
```

### Sample Codes


#### Variable Declaration 
```
 x:int 
 y:double = 1.0
```
#### Single Statement

```
 x:int = a * 5 + 5 / 5 + (100 * 7)
```
### Function Declartion

```
def square(x: int):int =>  { return x * x }
def sumOfSquares(x: int, y: int):int => {
   return square(x) + square(y)
}
echo(sumOfSquares(4,5)) 
```
### Anonymous Function Declaration

```
(x: int, y:int, z:double):int => { return x * y * z }

 echo((4,5,6.0) + (3,5,4.0))
```

### Logical Operators
```
def comparison_test(x: int, y: int): int => { 
     printi( x == y)
     printi( x != y)
     printi( x >= y)
     printi( x <= y)
     printi( x > y)
     printi( x < y)
     return x < y
}


echo(comparison_test(10,10)) 
```

## If-else Branching
   if(expression) { statements } else {statements}
```
if(x > y) 
      { foo(x)}
   else   
      { bar(y) }
    
```
## For Loop 
    for( identifier in start to end [by step]) { statements}

```
 p:int = 1
for(i:int in 1 to n) {   
    echo(p) 
    p = p +1
 }
```

```
 p:int = 1
for(i:int in 1 to n by 2) {   
    echo(p) 
    p = p +1
 }
```
### Sample Output from some fragments of uCML

```
 extern  printi(val:int):void   

x:int
x = 5+6-5/5+9
echo(x)

def do_math(a: int) : int => { 
    x:int = a * 5 + 5 / 5 + (100 * 7)
    return x
}

echo(do_math(do_math(10)))
echo(do_math(10))


def square(x: int):int =>  { return x * x }

def sumOfSquares(x: int, y: int):int => {
   return square(x) + square(y)
}
echo(sumOfSquares(4,5)) 



(x: int, y:int, z:double):int => { return x * y * z }

 echo((4,5,6.0) + (3,5,4.0))



def comparison_test(x: int, y: int): int => { 
     printi( x == y)
     printi( x != y)
     printi( x >= y)
     printi( x <= y)
     printi( x > y)
     printi( x < y)
     return x < y
}


echo(comparison_test(10,10)) 


def f(): int =>{
      x:int  = 10
     return x
 }
 ```
### Output in a target machine (OS X)
```
Running code...
19
4456
751
41
0
1
0
1
1
0
0
0
Code was run.
```

### Loop Test
```
 extern  printi(val:int):int   
 
def printstart(n:int): void => { 
   p:int = 1
 for(i:int in 1 to n) {   
    echo(p) 
    p = p + 1
 }
   
} 

printstart(4)
```
### IR for the loop 

```
 define internal void @printstart(i64 %n1) {
entry:
  %n = alloca i64, addrspace(1)
  store i64 %n1, i64 addrspace(1)* %n
  %p = alloca i64, addrspace(1)
  store i64 1, i64 addrspace(1)* %p
  %i = alloca i64, addrspace(1)
  store i64 1, i64 addrspace(1)* %i
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i2 = phi i64 [ 1, %entry ], [ %nextvar, %loop ]
  %0 = load i64, i64 addrspace(1)* %p
  call void @echo(i64 %0)
  %1 = load i64, i64 addrspace(1)* %p
  %2 = add i64 %1, 1
  store i64 %2, i64 addrspace(1)* %p
  %nextvar = add i64 %i2, 1
  %3 = load i64, i64 addrspace(1)* %n
  %loopcond = icmp ule i64 %nextvar, %3
  %tmpbool = icmp ne i1 %loopcond, false
  br i1 %tmpbool, label %loop, label %afterloop

afterloop:                                        ; preds = %loop
  ret void
}
Running code...
1
2
3
4
Code was run.
```

### IF-ELSE branching

```
extern  printi(val:int):int   
 
 def foo(i:int): int => { printi(i) return 0}
 def bar(i:int): int => { printi(i) return 1}
 
  def baz(x:int, y:int): int => {
   if(x > y) 
      { foo(x)}
   else   
      { bar(y) }
   
   return 0
} 

baz(30,10)
```
### IR for the if-else branch (only baz function)

```
  define internal i64 @baz(i64 %x1, i64 %y2) {
entry:
  %x = alloca i64, addrspace(1)
  store i64 %x1, i64 addrspace(1)* %x
  %y = alloca i64, addrspace(1)
  store i64 %y2, i64 addrspace(1)* %y
  %0 = load i64, i64 addrspace(1)* %x
  %1 = load i64, i64 addrspace(1)* %y
  %2 = icmp ugt i64 %0, %1
  %3 = icmp ne i1 %2, false
  br i1 %3, label %then, label %else

then:                                             ; preds = %entry
  %4 = load i64, i64 addrspace(1)* %x
  %5 = call i64 @foo(i64 %4)
  br label %ifcont

else:                                             ; preds = %entry
  %6 = load i64, i64 addrspace(1)* %y
  %7 = call i64 @bar(i64 %6)
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %iftmp = phi i64 [ %5, %then ], [ %7, %else ]
  ret i64 0
}
Running code...
30
Code was run.
```
### Compilation and Running

```
make (in src dir)
./parser.out < ../examples/loop.txt
```

 