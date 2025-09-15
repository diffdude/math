#math

Math.sh is a bash shell script to take numeric inputs and perform
intended operations

This started out as subtract.sh, which would take two numbers from user
input and pass them into variables to subtract num2 from num1. I added
addition and division functionality, and ran into some difficulty with
correctly using git, which led to a new name and new repository.

So far, the script asks for user intent: add, subtract, multiply, divide
or exponent. For each intent, the script will take two numeric inputs.
At the end of the operation, the user is asked if they want to continue
with an operation on the output. If so, the first number is reassigned
as the output, and the user is asked which operation they would like to
perform and to input another number. This can be repeated until the user
chooses to exit the script or inputs something that returns an error.

This is meant to be a shell scripting learning exercise. If there is
something useful for you here, you are free to copy, paste, fork, clone
and modify any section of code.
