/*
A few words on variables.
1) Lowercase letters represent global variables (eg. a, b...).
2) Declare long-named global variables using the tilde.
3) Declare local variables (within functions) with the var keyword.
*/

// Functions return the result of their last line of code!

(
f = {
	"Function Evaluated".postln;
};
f.value;     // Evaluate the function.
~sum;
~sum = {
	"Evaluating...".postln;
	2 + 3;
};
~sum.value;
)

(
f = 3;
f.value;
)

(
f = {
	3.0.rand;
};
f.value;
)

(
~printNumber = {
	arg number;
	number.value;
};
~printNumber.value(5);
)

(
~add = {
	arg number1, number2;
	number1 + number2;
};
~add.value(5, 6);
)

// Something not that readable
// SC has no operator precendence. Use parentheses!
~function = {arg a, b, c, d; (a + b) * d - c;};
~function.value(a:5, b:6, d:43, c: 3);

(
var newFunction;
newFunction = {
	arg input1, input2;
	var variable1, variable2;

	variable1 = input1 * input2;
	variable2 = variable1 + input2;
	variable1;    // Functions return the result of their last line of code. This won't show up on our returned value.
	variable2;
};
newFunction.value(5, 3);
)
