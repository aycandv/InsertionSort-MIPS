# KU COMP 303 - Assignment 2

## Introduction
The goal of this project is to implement an *Insertion Sort Algorithm* which takes arguments from user (i.e. array size), then applies reduction and duplicate removal for simplification. [MARS (MIPS Assembler and Runtime Simulator)](https://courses.missouristate.edu/KenVollmar/MARS/) is used to implement the *Insertion Sort Algorithm*.
## How It Works
### Checking Argument for Initialization
User must type the specific argument as follows to initialize the program:

    -n

The argument that is taken as input is processed at **_Get_Argument_** section of the code. By considering input byte by byte, there will be an output to indicate if it is correct of not. Output will be like this if the input argument is not equal to "-n":

    Argument error

or the input passed the control and following output will be:

    CORRECT COMMAND...Indicate Array Size:

At this point, we are still in **_Get_Argument_** section and the program will be waiting for next input which is quantity of numbers (array size). By limiting with a constant value, user cannot enter a value greater than 100 as array size. If a value greater than 100 is entered, an error message will be displayed and user will be asked to enter that array size again until getting the correct value.

When a proper array size value is entered, following will be the output:
    
    Enter Integers:
    
If this output is seen, we are in the **_Data_Input_** section. 

### Getting Numbers to Sort

Now, we are in **_Data_Input_** section. Input array size is stored in a register and **_Data_Input_** can reach it by **stack pointer**. At this stage, there is a loop to get user's input for __"array size"__ times. For instance, "6" is typed to prompt as array size. After that, the user is supposed to enter 6 integers otherwise there will be an error. By entering integer values, the loop runs till it reaches __"array size"__ amount of integers.

    Enter Integers:
    2
    3
    5
    1
    5
    3

These integer numbers are stored in an array named as *input_data()*. At any part of code has access to it by using *lw* or *sw* commands of MIPS. By getting the requested array from user with no errors, program is ready for **Insertion Sort**.

### Applying Insertion Sort

In this section **_sort_data_**, program needs to access the *array size* by using stack pointer in this code. After accessing it, **_input_data_** array is accessed and *Insertion Sort Algorithm* runs. In the algorithm, array elements are selected in a *for loop* from *0th* element to the *i th* element. When *i th* element is selected, another *for loop* nested to previous one runs and controls all previous elements of the array with variable j (*0<j<i*) whether *array[j]>array[i]*. If it is, *j th* and *i th* elements swap. After this part of code runs, **_print_w_dup_** is called and the output will be as below:

    Sorted List
    [ 1 2 3 3 5 5 ]
   
### Removing Duplicates
In this section **_remove_duplicates_**, creates another array which has a smaller size from **_input_data_** in case of any duplication of numbers as we did above. By using a loop, which is incremented but upper-limited by size of the input array, all numbers except duplicated ones are stored in another array. In this way, a new array is created with no duplication. After running this, **_print_w_dup_** will be called and the output will be as following:

    Sorted List without Duplicates
    [ 1 2 3 5 ]

### Reduction
In this stage, output will be:

    List Sum
    11
    
In previous stage, when an integer is stored in new array(no duplicates), register *$t3* is incremented by the value of that integer. At the end of the loop, *$t3* has the value of *5 + 3 + 2 + 1*. In that stage, sum is printed as above and the program end message appears as below:

    Program Finished
    
## Author
- [ ] Aycan Deniz Vit
