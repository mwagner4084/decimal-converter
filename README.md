# A2: Decimal to Base

You are to write simple MSP430 assembly functions for a program that will take a decimal number and a base as input and output the value in that specified base. For example:

    > 236709 8
    116245
    > 13 2
    1101
    > 29708 2 
    111010000001100
    > 58152 3
    2221202210
    > 48435 4
    23310303
    > 34567 6
    424011
    > 51006 6
    1032050
    > 51566 9
    77655
    > 37608 20
    4E08
    > 59156 30
    25LQ
    > 2440 37
    1SZ
    > 2441 37
    1Sa
    > 2442 37
    1T0
    > 28374 64
    6xM
    > 40080 256
    156.144
    > 45600 256
    178.32
    > 29038 65
    0
    > 123 1
    0
    > 67890 2
    100100110010

_This is just example output, you should test against as many possible inputs as you can._

1.  Your program should be able to handle all bases from 2 to 64 and 256.
2.  It must have 6 completed assembly functions:  
    * `unsigned convert(unsigned decimal, unsigned base)` 
    * `unsigned other_base(unsigned decimal, unsigned base)`
    * `unsigned power2_base(unsigned decimal, unsigned base)`
    * `unsigned base_256(unsigned decimal, unsigned base)`
    * `unsigned log_2(unsigned value)`
    * `unsigned rshift(unsigned value, unsigned amount)`
3.  The call graph of a possible solution program looks like:

```
    convert
    ┣━ power2_base
    ┃  ┣━ log_2
    ┃  ┗━ rshift
    ┣━ other_base ━┓
    ┃  ┣━ umod     ┃
    ┃  ┗━ udiv     ┃
    ┗━ base_256    ┃
       ┣━ log_2    ┃
       ┗━ other_base
```

4.  Submit only the modifications to the files in the `func` folder
5.  When unexpected input is given, a 0 should be output to minicom (see above)
6.  Don't worry about overflow

### Converting Integers to Characters

Think about how to use this character array:

`char *ascii = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/";`

The character `1` is _not the same_ as the **value 1**. If you need to know which numeric values correspond to which on screen characters, look at `man ascii` in your terminal.

### Division & Modulo

This algorithm is suitable for any base that is _not a power of two_ and is not **base 256** (`other_base()` function).

Let's see an example of converting the decimal number 29 into base 5. How many different values are there for base 5: 0, 1, 2, 3 and 4. So you should expect all of our digits to be one of those numbers. Get the first digit by calculating the remainder of 29 / 5:
```
      __5  
    5| 29  
       25  
      ___  
        4
```
The result of 29 / 5 is 5 with a remainder of 4.

There is a special operator for this in almost all programming languages: `%` (**modulo**) operator. This will give the remainder instead of the quotient.
```
    29 % 5 = 4
```
This is the first digit (ones digit) of the base 5 number. To continue, you start from the quotient of this operation. Division in C is integer division (just like in Python3 using `//`), so the remainder is discarded when you do:
```
    29 / 5 = 5
```
Now, continue with the algorithm:
```
      __1  
    5|  5  
        5  
      ___  
        0
```
The result of 5 / 5 is 1 with a remainder of 0.
```
    5 % 5 = 0
```
This is the second digit (fives digit) of the base 5 number.
```
    5 / 5 = 1
```
The algorithm continue until this division results in 0:
```
      __0  
    5|  1  
        0  
      ___  
        1
```
Now we have a remainder of 1 and the result of the integer division is 0. 

The number 29 in base 5 is **104**.

### Mask & Shift

This algorithm is suitable for any base that _is a power of two_ and is not **base 256** (`power2_base()` function).

What if you are trying to convert the number 7 into base 4? How many bit patterns are there for base 4?

1. `00`
2. `01`
3. `10`
4. `11`

which is 0, 1, 2 and 3. Let's see how masking works:

```
      0111 = 7  
    & 0011 = 3  
    __________  
      0011 = 3
```
You've "masked off" the first digit, which is 3, by using the `&` (**bitwise AND**) operator. Now you can shift those bits to the right using the `>>` (**bitwise RIGHT SHIFT**) operator like so:
```
      7 >> 2 = 01
```
And continue with the algorithm:
```
      01 = 1  
    & 11 = 3  
    ________  
      01 = 1
```
The number 7 in base 4 is **13**.

### Base 256

This algorithm will only be used for **base 256** (`base_256()` function).

It will involve using both previous algorithms. Since this is a power of 2, **mask & shift** must be utilized. However, the values you get will be numbers between 0 and 255. The ascii character array doesn't have that many different characters in it, so instead you will represent base 256 numbers in the same format as IP addresses:
```
    172.16.1.255
```
Each place value is separated by a `.` character. The **division & modulo** algorithm will be used to calculate each digit of the decimal number for each place value.

In the above example, the ones place shows the number 255 which would have been calculated using **mask & shift** from the input number. Then that value needs to be placed in the buffer as a three digit decimal number by using the **division & modulo** algorithm.

