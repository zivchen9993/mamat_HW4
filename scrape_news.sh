#!/bin/bash

#download the site HTML file
base=$(wget https://www.ynetnews.com/category/3082 -q -O -) 
link=https://www.ynetnews.com/article/
results=""
net="Netanyahu"
gan="Gantz"
#making b (var) the correct list: search the file for l (var)
#and the right suffix, remove the last character (" or #) and duplicated lines
#loop, running through all the addresses in b (var) 
#counting the appearences of names in each address.
#eventualy adds the names and amount to each address in the variable.
while IFS= read -r line; do
	article=$(wget $line -q -O -)
	n=`echo $article|grep -o "$net" | wc -l `
	g=`echo $article|grep -o "$gan"| wc -l`
	results+="\n"
	if (($n==0 && $g==0));then
		results+=`echo $line, "-"`
	else
		results+=`echo $line, "$net", $n, "$gan", $g`
	fi
done <<< `echo $base|grep -o -P "$link.{0,9}[\"#]" | uniq | sed 's/.$//'` 

#puting the var data into the desired file
echo -e $results > results.csv

#adding the amount of articles to the beggining of the list 
#(decreasing the first line).
temp=`wc -l < results.csv`
wc -l < results.csv | sed -i "1c$((--temp))" results.csv
