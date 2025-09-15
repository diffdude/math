#!/usr/bin/env bash
# non-number error
nonnum="Please use only numeric inputs"
start() {
# determine user intent to add or subtract
# printf allows line breaks more consistently than echo
# line can be broken with \n or a line break in the quote
	printf "What would you like to do?\n[add] [subtract] [divide] [multiply] [exponent]\n"
	read intent
	code
}
# reassigns initial input to result of operation 
operator_reassign() {
	num1=$result
}
# main body of code; interprets intent input, allows math operations
code() {
# subtract operation
if
	[[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "subtract" ]]; then
# input funcion definitions
		input2() {
		echo "Enter a number to subtract"
		read num2
	}
		input1() {
		echo "Enter a number to reduce"
		read num1
		input2
	}
# checks if num1 is defined and defines empty variable
	if
		[[ -z "$num1" ]]; then
			input1
	else
		input2
	fi
# makes sure inputs are numeric, exits if not
	if
		[[ $num1 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num2 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
# creates result variable as num1 - num2 and pipes it into basic calculator to allow floats
	else
		result=$(echo "$num1 - $num2" | bc)
	fi
# prints result and offers to continue operations on result
	printf "The difference is $result
Would you like to perform an operation on $result? [y/n]
	"
	read continue
# if continue is chosen, start script again
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			operator_reassign
			start
	else
		exit
	fi
# if intent is to add, accept inputs for addition operation
elif
	[[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "add" ]]; then
		input2() {
		echo "Enter a number to add"
		read num2
		}
		input1() {
			echo "Enter a number to increase"
			read num1
			input2
		}
	if
		[[ -z "$num1" ]]; then
			input1
	else
		input2
	fi
	if
		[[ $num1 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num2 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
# creates result variable as num1 + num2 and pipes it into basic calculator to allow floats
	else
		result=$(echo "$num1 + $num2" | bc)
	fi
	printf "The sum is $result
Would you like to perform an operation on $result? [y/n]
	"
	read continue
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			operator_reassign
			start
	else
		exit
	fi
# if intent is to divide, run code to divide
elif
	[[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "divide" ]]; then
		input2() {
			echo "Enter a denominator to divide by"
			read num2
		}
		input1() {
			echo "Enter a numerator to divide"
			read num1
			input2
		}
	if
		[[ -z "$num1" ]]; then
		input1
	else
		input2
	fi
	if
		[[ $num1 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num2 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
# if denominator input is 0, print cannot divide by zero and exit script
	elif
		[[ $num2 = 0 ]]; then
			echo "Cannot divide by zero"
			exit
# creates quotient variable as num1 / num2 and pipes it into basic calculator to allow division
# scale=13 to allow 13 decimal places
	else
		quotient_13=$(echo "scale=13; $num1 / $num2" | bc)
# creates integer quotient variable with no scale to force an integer result
		quotient_integer=$(echo "$num1 / $num2" | bc)
	fi
# if quotient_13=quotient_integer with 13 trailing zeros, result is integer
	if
		[[ $quotient_13 = $quotient_integer.0000000000000 ]]; then
			result=$quotient_integer
# if quotient_13 is indeed a float, result is scale13 quotient without trailing zeros
	else
		result=$(echo "$quotient_13" | sed 's/0$//')
	fi
	printf "The quotient is $result
Would you like to perform an operation on $result? [y/n]
	"
	read continue
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			operator_reassign
			start
	else
		exit
	fi
# if intent is to multiply, run multiplication code
elif [[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "multiply" ]]; then
	input2() {
		echo "Enter another number to multiply"
		read num2
		}
	input1() {
		echo "Enter a number to multiply"
		read num1
		input2
	}
# check if $num1 is defined
	if
		[[ -z "$num1" ]]; then
			input1
	else
		input2
	fi
	if
		[[ $num1 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num2 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
# creates a product variable
	else
		result=$(echo "$num1 * $num2" | bc)
	fi
# returns the product
	printf "The product is $result
Would you like to perform an operation on $result? [y/n]
	"
	read continue
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			operator_reassign
			start
	else
		exit
	fi
# if intent is exponent, run exponent code
elif
	[[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "exponent" ]]; then
		input2() {
			echo "Enter an exponent"
			read num2
		}
		input1() {
			echo "Enter a base to be exponentiated"
			read num1
			input2
		}
# check if $num1 is defined
	if
		[[ -z "$num1" ]]; then
			input1
	else
		input2
	fi
	if
		[[ $num1 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num2 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num1 = 0 ]]; then
			printf "The power is 0\n"
			exit
	elif
		[[ $num2 = 0 ]]; then
			printf "The power is 1\n"
			exit
#	power=$(echo "$num1 ^ $num2" | bc) does not accept floats as exponents
# constant e ^ (num2 * natural log(num1)) = num1 ^ num2; -l for complicated math
	elif
		[[ $(echo "$num1 + $num2" | bc) =~ \.[0-9]+ ]]; then
			result=$(echo "e($num2 * l($num1))" | bc -l)
	else
		result=$(echo "$num1 ^ $num2" | bc)	
	fi
	printf "The power is $result
Would you like to perform an operation on $result? [y/n]
	"
	read continue
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			operator_reassign
			start
	else
		exit
	fi
# if intent is not supported, promise future functionality
else
	echo "More functionality coming soon."
	exit
#end of if/else statement
fi
}
#end of functions
start
exit
