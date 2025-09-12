#!/usr/bin/env bash
# determine user intent to add or subtract
echo "Would you like to [add], [subtract] or [divide]?"
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
# creates result variable as num1 / num2 and pipes it into basic calculator to allow division
# scale=13 to allow 13 decimal places
	result13=$(echo "scale=13; $num1 / $num2" | bc)
# creates [resultInt]eger variable with no scale to force an integer result
	resultInt=$(echo "$num1 / $num2" | bc)
# checks if $result is trailed by 13 zeros
	if [ $result13 == $resultInt.0000000000000 ]; then
# if so, [quot]ient is integer returned by bc division
		quot=$resultInt
# If result is not integer, quot is the 13 decimal place result without trailing zeros
	else
		quot=$(echo "$result13" | sed 's/0*$//')
	fi
	echo "The quotient is $quot"
# if intent is not supported, promise future functionality
else
	echo "More functionality coming soon."
#end of if/else statement
fi
exit 0

#test comment