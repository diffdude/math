#!/usr/bin/env bash
# determine user intent to add or subtract
# printf allows line breaks more consistently than echo
# line can be broken with \n or a line break in the quote
nonnum="Please use only numeric inputs"
printf "What would you like to do?
[add] [subtract] [divide] [multiply] [exponent]\n"
# takes input as variable called "intent"
read intent
# if intent is to subtract, run core subtract code
# pipes intent variable into a command to force input into lowercase
if [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "subtract" ]; then
	echo "Enter a number to reduce"
		read num1
# makes sure inputs are numeric
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	else echo "Enter a number to subtract"
	fi
		read num2
	if [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# creates [diff]erence variable as num1 - num2 and pipes it into basic calculator to allow floats
	else result=$(echo "$num1 - $num2" | bc)
	fi
	echo "The difference is $result"
# if intent is to add, run add code
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "add" ]; then
	echo "Enter a number to increase"
		read num1
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	else echo "Enter a number to add"
	fi
		read num2
	if [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# creates sum variable as num1 + num2 and pipes it into basic calculator to allow floats
	else result=$(echo "$num1 + $num2" | bc)
	fi
	echo "The sum is $result"
# if intent is to divide, run code to divide
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "divide" ]; then
	echo "Enter a numerator to divide"
		read num1
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	else echo "Enter a denominator to divide by"
	fi
		read num2
	if [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# if denominator input is 0, print cannot divide by zero and exit script
	elif [ $num2 = 0 ]; then
		echo "Cannot divide by zero"
		exit
# creates result variable as num1 / num2 and pipes it into basic calculator to allow division
# scale=13 to allow 13 decimal places
	else	quotient13=$(echo "scale=13; $num1 / $num2" | bc)
# creates [resultInt]eger variable with no scale to force an integer result
		quotient_int=$(echo "$num1 / $num2" | bc)
	fi
# checks if $result is trailed by 13 zeros
	if [ $quotient13 = $quotient_int.0000000000000 ]; then
# if so, [quot]ient is integer returned by bc division
		result=$quotient_int
# if result is not integer, quot is the 13 decimal place result without trailing zeros
	else result=$(echo "$quotient13" | sed 's/0$//')
	fi
	echo "The quotient is $result"
# if intent is to multiply, run multiplication code
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "multiply" ]; then
	echo "Enter a number to multiply"
		read num1
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	else echo "Enter another number to multiply"
	fi
		read num2
	if [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# creates a product variable
	else result=$(($num1 * $num2))
	fi
# returns the product
	echo "The product is $result"
# if intent is exponent, run exponent code
elif [ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "exponent" ]; then
	echo "Enter a base to be exponentiated"
		read num1
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	else echo "Enter an exponent"
	fi
		read num2
	if [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
#	power=$(echo "$num1 ^ $num2" | bc) does not accept floats as exponents
# constant e ^ (num2 * natural log(num1)) = num1 ^ num2; -l for complicated math
	elif [[ $(echo "$num1 + $num2" | bc) =~ \.[0-9]+ ]]; then
		result=$(echo "e($num2 * l($num1))" | bc -l)
	else result=$(echo "$num1 ^ $num2" | bc)	
	fi
	echo "The power is $result"
# if intent is not supported, promise future functionality
else echo "More functionality coming soon."
#end of if/else statement
fi
exit

#todo
#allow result to be passed into $num1 for further operation
#step1: rename resultant vars to "result"
#step2: print "Perform operations on result?"
#step3: if no, exit. If yes, jump to line 6
#step4: check if $result is defined
#step5: if yes, bypass input; $num1=$result
