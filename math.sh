#!/usr/bin/env bash
nonnum="Please use only numeric inputs"
start() {
	printf "What would you like to do?\n[add] [subtract] [divide] [multiply] [exponent]\n"
	read intent
	code
}
validate_numeric() {
	if
		[[ $num1 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	elif
		[[ $num2 =~ [a-zA-Z] ]]; then
			echo $nonnum
			exit
	fi
}
continoo(){
	printf "Would you like to perform an operation on $result? [Y/N]
"
	read continue
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			operator_reassign
			start
	else
		exit
	fi
}
operator_reassign() {
	num1=$result
}
continoo_check(){
	if
		[[ -z "$num1" ]]; then
			input1
	else
		input2
	fi
}
code() {
if
	[[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "subtract" ]]; then
		input2() {
			echo "Enter a number to subtract"
			read num2
		}
		input1() {
			echo "Enter a number to reduce"
			read num1
			input2
		}
	continoo_check
	validate_numeric
	result=$(echo "$num1 - $num2" | bc)
	printf "The difference is $result \n"
	continoo
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
	continoo_check
	validate_numeric
	result=$(echo "$num1 + $num2" | bc)
	printf "The sum is $result \n"
	continoo
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
	continoo_check
	validate_numeric
	if
		[[ $num2 = 0 ]]; then
			echo "Cannot divide by zero"
			exit
	else
		quotient_13=$(echo "scale=13; $num1 / $num2" | bc)
		quotient_integer=$(echo "$num1 / $num2" | bc)
	fi
	if
		[[ $quotient_13 = $quotient_integer.0000000000000 ]]; then
			result=$quotient_integer
	else
		result=$(echo "$quotient_13" | sed 's/0*$//')
	fi
	printf "The quotient is $result \n"
	continoo
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
	continoo_check
	validate_numeric
	result=$(echo "$num1 * $num2" | bc)
	printf "The product is $result \n"
	continoo
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
	continoo_check
	validate_numeric
	if
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
	printf "The power is $result \n"
	continoo
else
	echo "More functionality coming soon."
	exit
fi
}
start
exit
