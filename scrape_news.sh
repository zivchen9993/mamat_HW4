#!/bin/bash

#download the site HTML file, b = base address, l = link beggining
b=$(wget https://www.ynetnews.com/category/3082 -q -O -) 
l=https://www.ynetnews.com/article/
results=""

#making b (var) the correct list: search the file for l (var)
#and the right suffix, remove the last character (" or #) and duplicated lines
#loop, running through all the addresses in b (var) 
#counting the appearences of names in each address.
#eventualy adds the names and amount to each address in the variable.
while IFS= read -r line; do
	article=$(wget $line -q -O -)
	N=`echo $article|grep -o "Netanyahu" | wc -l `
	G=`echo $article|grep -o "Gantz"| wc -l`
	results+="\n"
	if (($N==0 && $G==0));then
		results+=`echo $line, "-"`
	else
		results+=`echo $line, "Netanyahu", $N, "Gantz", $G`
	fi
done <<< `echo $b|grep -o -P "$l.{0,9}[\"#]" | uniq | sed 's/.$//'` 

#puting the var data into the desired file
echo -e $results > results.csv

#adding the amount of articles to the beggining of the list 
#(decreasing the first line).
x=`wc -l < results.csv`
wc -l < results.csv | sed -i "1c$((--x))" results.csv
