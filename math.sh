#!/usr/bin/env bash
# determine user intent to add or subtract
# printf allows line breaks more consistently than echo
# line can be broken with \n or a line break in the quote
nonnum="Please use only numeric inputs"
function start {
	printf "What would you like to do?\n [add] [subtract] [divide] [multiply] [exponent]\n"
	read intent
	code
}
function operator_reassign {
	num1=$result
}
function code {
if [[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "subtract" ]]; then
		function input2 {
		echo "Enter a number to subtract"
		read num2
	}
	function input1 {
		echo "Enter a number to reduce"
		read num1
		input2
	}
	if [[ -z "$num1" ]]; then
		input1
	else
		input2
	fi
# makes sure inputs are numeric
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	elif [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# creates [diff]erence variable as num1 - num2 and pipes it into basic calculator to allow floats
	else result=$(echo "$num1 - $num2" | bc)
	fi
	echo "The difference is $result"
	printf "Would you like to perform an operation on $result? [y/n]\n"
	read continue
	if [[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
		operator_reassign
		start
	else
		exit
	fi
# if intent is to add, run add code
elif [[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "add" ]]; then
	function input2 {
	echo "Enter a number to add"
	read num2
	}
	function input1 {
		echo "Enter a number to increase"
		read num1
		input2
	}
# if $num1 is undefined, take input, if defined, take second input
	if [[ -z "$num1" ]]; then
		input1
	else
		input2
	fi
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	elif [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# creates sum variable as num1 + num2 and pipes it into basic calculator to allow floats
	else
		result=$(echo "$num1 + $num2" | bc)
	fi
	echo "The sum is $result"
	printf "Would you like to perform an operation on $result? [y/n]\n"
	read continue
	if [[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
		operator_reassign
		start
	else
		exit
	fi
# if intent is to divide, run code to divide
elif [[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "divide" ]]; then
	function input2 {
		echo "Enter a denominator to divide by"
		read num2
	}
	function input1 {
		echo "Enter a numerator to divide"
		read num1
		input2
	}
# check if $num1 is defined
	if [[ -z "$num1" ]]; then
		input1
	else
		input2
	fi
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	elif [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# if denominator input is 0, print cannot divide by zero and exit script
	elif [[ $num2 = 0 ]]; then
		echo "Cannot divide by zero"
		exit
# creates result variable as num1 / num2 and pipes it into basic calculator to allow division
# scale=13 to allow 13 decimal places
	else
		quotient13=$(echo "scale=13; $num1 / $num2" | bc)
# creates [resultInt]eger variable with no scale to force an integer result
		quotient_int=$(echo "$num1 / $num2" | bc)
	fi
# checks if $result is trailed by 13 zeros
	if [[ $quotient13 = $quotient_int.0000000000000 ]]; then
# if so, [quot]ient is integer returned by bc division
		result=$quotient_int
# if result is not integer, quot is the 13 decimal place result without trailing zeros
	else
		result=$(echo "$quotient13" | sed 's/0$//')
	fi
	echo "The quotient is $result"
	printf "Would you like to perform an operation on $result? [y/n]\n"
	read continue
	if [[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
		operator_reassign
		start
	else
		exit
	fi
# if intent is to multiply, run multiplication code
elif [[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "multiply" ]]; then
	function input2 {
		echo "Enter another number to multiply"
		read num2
		}
	function input1 {
		echo "Enter a number to multiply"
		read num1
		input2
	}
# check if $num1 is defined
	if [[ -z "$num1" ]]; then
		input1
	else input2
	fi
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	elif [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
# creates a product variable
	else
		result=$(echo "$num1 * $num2" | bc)
	fi
# returns the product
	echo "The product is $result"
	printf "Would you like to perform an operation on $result? [y/n]\n"
	read continue
	if [[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
		operator_reassign
		start
	else
		exit
	fi
# if intent is exponent, run exponent code
elif [[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "exponent" ]]; then
	function input2 {
		echo "Enter an exponent"
			read num2
	}
	function input1 {
		echo "Enter a base to be exponentiated"
		read num1
		input2
	}
# check if $num1 is defined
	if [[ -z "$num1" ]]; then
		input1
	else input2
	fi
	if [[ $num1 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	elif [[ $num2 =~ [a-zA-Z] ]]; then
		echo $nonnum
		exit
	elif [[ $num1 = 0 ]]; then
		printf "The power is 0\n"
		exit
	elif [[ $num2 = 0 ]]; then
		printf "The power is 1\n"
		exit
#	power=$(echo "$num1 ^ $num2" | bc) does not accept floats as exponents
# constant e ^ (num2 * natural log(num1)) = num1 ^ num2; -l for complicated math
	elif [[ $(echo "$num1 + $num2" | bc) =~ \.[0-9]+ ]]; then
		result=$(echo "e($num2 * l($num1))" | bc -l)
	else
		result=$(echo "$num1 ^ $num2" | bc)	
	fi
	echo "The power is $result"
	printf "Would you like to perform an operation on $result? [y/n]\n"
	read continue
	if [[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
	operator_reassign
	start
	else
		exit
	fi
# if intent is not supported, promise future functionality
else
	echo "More functionality coming soon."
#end of if/else statement
fi
}
start
# if intent is to subtract, run core subtract code
# pipes intent variable into a command to force input into lowercase

exit

#todo
#allow result to be passed into $num1 for further operation
#step1: rename resultant vars to "result" [done]
#step2: print "Perform operations on result?" [done]
#step3: if no, exit. If yes, perform code from question2
#step4: check if $result is defined
#step5: if yes, bypass input; $num1=$result
