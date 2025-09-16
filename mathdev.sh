#!/usr/bin/env bash
nonnum="Please use only numeric inputs"
start() {
	printf "What would you like to do?\n[add] [subtract] [divide] [multiply] [exponent]\n"
	read intent
	intent_lower=$(echo "$intent" | tr '[:upper:]' '[:lower:]')
	code
}
continoo_check(){
	if
		[[ -z "$num1" ]]; then
			input1
	else
		input2
	fi
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
result_normalize(){
	result=$(echo "$result" | sed 's/0*$//' | sed 's/\.$//')
}
continoo(){
	printf "Would you like to perform an operation on $result? [Y/N]
"
	read continue
	if
		[[ "$(echo "$continue" | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
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
case $intent_lower in
	subtract)
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
		result_normalize
		printf "The difference is $result \n"
		continoo
		;;
	add)
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
		result_normalize
		printf "The sum is $result \n"
		continoo
		;;
	divide)
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
			result=$(echo "scale=13; $num1 / $num2" | bc)
		fi
		result_normalize
		printf "The quotient is $result \n"
		continoo
		;;
	multiply)
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
		result_normalize
		printf "The product is $result \n"
		continoo
		;;
	exponent)
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
		elif
			[[ $(echo "$num1 + $num2" | bc) =~ \.[0-9]+ ]]; then
				result=$(echo "e($num2 * l($num1))" | bc -l)
		else
			result=$(echo "$num1 ^ $num2" | bc)	
		fi
		result_normalize
		printf "The power is $result \n"
		continoo
		;;
	*)
		echo "More functionality coming soon."
		exit
		;;
esac
}
start
exit
