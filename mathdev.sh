#!/usr/bin/env bash
nonnum="Please use only numeric inputs"
start() {
	printf "What would you like to do?\n[add] [subtract] [divide] [multiply] [exponent]\n"
	read intent
	code
}
continoo_check(){
	case "$num1" in
		"")
			input1
		;;
		*)
			input2
		;;
	esac
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
	read contin
	if
		[[ "$(echo "$contin" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
			reassign
			start
	else
		exit
	fi
}
reassign() {
	num1=$result
}
code() {
if
	[[ "$(echo "$intent" | tr '[:upper:]' '[:lower:]')" = "subtract" ]]; then
		input2() {
			echo "Enter a number to subtract from $num1"
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
			echo "Enter a number to add to $num1"
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
			echo "Enter a denominator to divide $num1 by"
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
		echo "Enter a number to multiply $num1 by"
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
			echo "Enter an exponent for $num1"
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
	elif
		[[ $(echo "$num1 + $num2" | bc) =~ \.[0-9]+ ]]; then
			result=$(echo "e($num2 * l($num1))" | bc -l)
	else
		result=$(echo "$num1 ^ $num2" | bc -l)	
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
