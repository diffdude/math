#!/usr/bin/env bash
nonnum="Please use only numeric inputs"
start() {
	printf "What would you like to do?\n[add] [subtract] [divide] [multiply] [exponent]\n"
	read intent
	intent=$(echo "$intent" | tr '[:upper:]' '[:lower:]')
	code
}
continoo_check(){
	[ -z "$num1" ] && input1
	input2
}
validate_numeric() {
	case $num1 in
		*[a-zZ-A]*)
			echo $nonnum && exit ;;
	esac
	case $num2 in
		*[a-zZ-A]*)
			echo $nonnum && exit ;;
	esac
}
result_normalize(){
	result=$(echo "$result" | sed 's/\.0*$//' | sed 's/\.$//')
}
continoo(){
	printf "Would you like to perform an operation on $result? [Y/N] \n"
	read contin
	contin=$(echo "$contin" | tr '[:upper:]' '[:lower:]')
	case $contin in
		"y")
			reassign && start ;;
		*)
			exit ;;
	esac
}
reassign() {
	num1=$result
}
code() {
	case $intent in
		"add")
			input2() {
				echo "Enter a number to add to $num1"
				read num2
			}
			input1() {
				echo "Enter a number to increase"
				read num1
			}
				continoo_check
				validate_numeric
				result=$(echo "$num1 + $num2" | bc)
				result_normalize
				printf "The sum is $result \n"
				continoo
		;;
		"subtract")
			input2() {
				echo "Enter a number to subtract from $num1"
				read num2
			}
			input1() {
				echo "Enter a number to reduce"
				read num1
			}
			continoo_check
			validate_numeric
			result=$(echo "$num1 - $num2" | bc)
			result_normalize
			printf "The difference is $result \n"
			continoo
		;;
		"multiply")
			input2() {
				echo "Enter a number to multiply $num1 by"
				read num2
			}
			input1() {
				echo "Enter a number to multiply"
				read num1
			}
			continoo_check
			validate_numeric
			result=$(echo "$num1 * $num2" | bc)
			result_normalize
			printf "The product is $result \n"
			continoo
		;;
		"divide")
			input2() {
				echo "Enter a denominator to divide $num1 by"
				read num2
			}
			input1() {
				echo "Enter a numerator to divide"
				read num1
			}
			continoo_check
			validate_numeric
			if [[ $num2 = 0 ]]; then
				echo "Cannot divide by zero"
				exit
			else
				quotient_13=$(echo "scale=13; $num1 / $num2" | bc)
				quotient_integer=$(echo "$num1 / $num2" | bc)
			fi
			if [[ $quotient_13 = $quotient_integer.0000000000000 ]]; then
				result=$quotient_integer
			else
				result=$(echo "$quotient_13")
			fi
			result_normalize
			printf "The quotient is $result \n"
			continoo
		;;
		"exponent")
			input2() {
				echo "Enter an exponent for $num1"
				read num2
			}
			input1() {
				echo "Enter a base to be exponentiated"
				read num1
			}
			continoo_check
			validate_numeric
			case 0 in
				$num1)
					printf "The power is 0\n" && continoo
				;;
				$num2)
					printf "The power is 1\n" && continoo
				;;
			esac
#			if [[ $num1 = 0 ]]; then
#				printf "The power is 0\n"
#				exit
#			elif [[ $num2 = 0 ]]; then
#				printf "The power is 1\n"
#				exit
#			fi
## Does not work ##
			result=$(echo "$num1 + $num2" | bc -l)
			case $result in
				*.*) result=$(echo "e($num2 * l($num1))" | bc -l) ;;
				*) result=$(echo "$num1 ^ $num2" | bc -l) ;;
			esac
##
#			if [[ $(echo "$num1 + $num2" | bc) =~ \.[0-9]+ ]]; then
#				result=$(echo "e($num2 * l($num1))" | bc -l)
#			else
#				result=$(echo "$num1 ^ $num2" | bc -l)	
#			fi
			result_normalize
			printf "The power is $result \n"
			continoo
		;;
		*)
			echo "More functionality coming soon."
			exit
	esac
}
start
exit
