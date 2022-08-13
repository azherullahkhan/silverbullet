## Quick Intro to Bash Scripting

This article will help you being writing a bash script and make you aware of the scripting structure

### Bash Scripting Basics

The Shebang (below) goes on the first line of every Bash script
```
#!/bin/bash
```

`#` is	used to make comments, text that comes after it will not be executed
```
# This line is a comment
```

Give test-script.sh executable permissions and execute it
```
chmod +x test-script.sh && ./test-script.sh
```
Stores the number of arguments passed to the Bash script
```
$#
```
Variables that store the values passed as arguments to the Bash script
```
$1, $2, $3
```
Exit from the Bash script, optionally add an error code
```
exit
```
Keyboard combination to stop Bash script in the middle of execution
```
Ctrl + C
```
Execute a command inside of a subshell
```
$( )
```
Pause for a specified number of seconds, minutes, hours, or days
```
sleep
```

#### Special Variables
```
$0        The program or script name
$1-$9     The first nine parameters
$$        The PID for the current process.
$#        The number of passed parameters
$* or $@  List all the passed parameters
$?        most recent foreground pipeline exit status
$!        PID of the most recent background command
$-        current options set for the shell.
```

#### Set Options
```
set -eux        (-e fail if any subcommands fail | -u fail if unknown variables referenced | -x debug)
set -o pipefail (fail if any part of pipe command fails)
```

#### Conditional statements

We use `if` or `case` to allow us to check if a certain condition is true or false. The logical flow of script will depend on the answer.

Test a condition and execute the then clause if it is true
```
if then fi
```
Execute the then clause if the condition is true, otherwise execute the else clause
```
if then else fi
```
Test multiple conditions and execute whichever clause is true
```
if then elif else fi
```

#### Script for `case` statement:

```
#!/bin/bash

day=$(date +"%A")

case $day in

  Monday | Tuesday | Wednesday | Thursday | Friday)
    echo "Today is a Weekday :)"
    ;;

  Saturday | Sunday)
    echo "Today is the Weekend :D"
    ;;

  *)
    echo "date not Recognised"
    ;;
esac
```

#### Script for `if` `then` `else`:

```
#!/bin/bash
if [ $1 -gt 0 ]; then
  FAILURE=true
  echo "STATUS:  FAIL"
else
  echo "STATUS:  PASS"
fi
```


#### Bash Loops
Loops in bash, allow the script to continue executing a set of instructions as long as a condition is said to be `true`.

Continue to loop `for` a defined number of range, lines, files, etc
```
for do done
```
Continue to loop `until` a certain condition is met
```
until do done
```
Continue to loop as long as certain condition is `true`
```
while do done
```
Exit the loop and continue to the next part of the Bash script
```
break
```
Exit the current iteration of the loop but `continue` to run the loop
```
continue
```

#### Read User Input
Prompt the user for information to enter by using read command:
```
#!/bin/bash
read -p "Please Enter your name: " person
echo "Hello $person, hope you're having a great day!"
```

#### Arithmetic Operators
You can perform addition, subtraction, multiplication, division, and other basic arithmetic inside of a Bash script.
```
+       	Addition
-       	Subtraction
*       	Multiplication
/       	Division
%       	Modulus
**      	Raise to a power
((i++)) 	Increment a variable
((i--)) 	Decrement a variable
```
#### Arithmetic Conditional Operators
You can evaluate if a certain condition is true or false by using two numbers.
```
[ $1 -lt $2 ]   	[[ $1 < $2 ]]
[ $1 -gt $2 ]   	[[ $1 > $2 ]]
[ $1 -le $2 ]   	[[ $1 <= $2 ]]
[ $1 -ge $2 ]   	[[ $1 >= $2 ]]
[ $1 -eq $2 ]   	[[ $1 == $2 ]]
[ $1 -ne $2 ]   	[[ $1 != $2 ]]
```

#### String Comparison Operators
This operator is used to evaluate a string. empty or not, and to check if a string is equal, less, or greater in length to another string.

Strings are equal
```
[ $str1 =	$str2 ]
```
String are not equal
```
[ $str1 != $str2 ]
```
String1 less then String2
```
[ $str1 <	$str2 ] less then
```
String1 greater then String2
```
[ $str1 >	$str2 ]
```
String1 is not empty
```
[ -n $str1 ]
```
String1 is empty
```
[ -z $str1 ]
```



#### Boolean Operators
Boolean operators include and operator `&&`, or operator `||` and not equal to `!`. These operators allow us to test if two or more conditions are true or not.
```
&&	Logical AND operator
||	    Logical OR operator
!	    NOT equal to operator
```


#### Bash File Evaluation
We can evaluate different characteristics about a file or directory.

```
-f filename	Check for regular file existence not a directory
-e filename	Check for file existence
-r filename	Check if file is a readable
-w filename	Check if file is writable
-x filename	Check if file is executable
-s filename	Check if file is nonzero size
-b filename	Block special file
-c filename	Special character file
-d dirname	Check for directory existence
-g filename	true if file exists and is set-group-id.
-k filename	Sticky bit
-L filename	Symbolic link
-u filename	Check if file set-ser-id bit is set
```

