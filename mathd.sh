#!/usr/bin/env bash
# determine user intent to add or subtract
# printf allows line breaks more consistently than echo
# line can be broken with \n or a line break in the quote
printf "What would you like to do?
[add] [subtract] [divide] [multiply] [exponent]\n"
# takes input as variable called "intent"
read intent
# if intent is to subtract, run core subtract code
# pipes intent variable into a command to force input into lowercase
if [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "subtract" ]; then
	echo "Enter a number to reduce"
		read num1
	echo "Enter a number to subtract"
		read num2
# creates [diff]erence variable as num1 - num2 and pipes it into basic calculator to allow floats
	diff=$(echo "$num1 - $num2" | bc)
	echo "The difference is $diff"
# if intent is to add, run add code
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "add" ]; then
	echo "Enter a number to increase"
		read num1
	echo "Enter a number to add"
		read num2
# creates sum variable as num1 + num2 and pipes it into basic calculator to allow floats
	sum=$(echo "$num1 + $num2" | bc)
	echo "The sum is $sum"
# if intent is to divide, run code to divide
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "divide" ]; then
	echo "Enter a numerator to divide"
		read num1
	echo "Enter a denominator to divide by"
		read num2
# if denominator input is 0, print cannot divide by zero and exit script
	if [ $num2 = 0 ];then
		echo "Cannot divide by zero"
		exit
	else
# creates result variable as num1 / num2 and pipes it into basic calculator to allow division
# scale=13 to allow 13 decimal places
		result13=$(echo "scale=13; $num1 / $num2" | bc)
# creates [resultInt]eger variable with no scale to force an integer result
		result_int=$(echo "$num1 / $num2" | bc)
	fi
# checks if $result is trailed by 13 zeros
	if [ $result13 = $result_int.0000000000000 ]; then
# if so, [quot]ient is integer returned by bc division
		quot=$result_int
# if result is not integer, quot is the 13 decimal place result without trailing zeros
	else
		quot=$(echo "$result13" | sed 's/0$//')
	fi
	echo "The quotient is $quot"
# if intent is to multiply, run multiplication code
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "multiply" ]; then
	echo "Enter a number to multiply"
		read num1
	echo "Enter another number to multiply"
		read num2
# creates a product variable
	product=$(echo "$num1 * $num2" | bc)
# returns the product
	echo "The product is $product"
# if intent is exponent, run exponent code
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "exponent" ]; then
	echo "Enter a base to be exponentiated"
		read num1
	echo "Enter an exponent"
		read num2
#	power=$(echo "$num1 ^ $num2" | bc) does not accept floats as exponents
# constant e ^ (num2 * natural log(num1)) = num1 ^ num2; -l for complicated math
	power=$(echo "e($num2 * l($num1))" | bc -l)
	echo "The power is $power"
# if intent is not supported, promise future functionality
else echo "More functionality coming soon."
#end of if/else statement
fi
exit