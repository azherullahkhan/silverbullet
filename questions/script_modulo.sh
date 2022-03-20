

Code:
Write a short program that prints each number from 1 to 100 on a new line.
For each multiple of 3, print "AVA" instead of the number.
For each multiple of 5, print "AMO" instead of the number.
For numbers which are multiples of

i=1
while [ $i -le 100 ]
do
  if [ `expr $i % 3` -eq 0 ]; then
    #echo $i
    echo "----"
    echo "AVA"
  elif [ `expr $i % 5` -eq 0 ]; then
    #echo $i
    echo "----"
    echo "AMO"
  else
    echo "----"
    echo "$i"
  fi
  i=$(($i+1))
done
