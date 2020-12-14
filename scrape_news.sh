#!/bin/bash

#download the site HTML file
base=$(wget https://www.ynetnews.com/category/3082 -q -O -) 
link=https://www.ynetnews.com/article/
results=""
n_name="Netanyahu"
g_name="Gantz"

#making base the correct list: search the file for relevant links and the right
#suffix, remove the last character (" or #) and duplicated lines
#loop: running through all the addresses in base.
#counting the appearences of names in each address.
#eventualy adds the names and amount to each address in the variable.
while IFS= read -r line; do
	article=$(wget $line -q -O -)
	num_n=`echo $article|grep -o "$n_name" | wc -l`
	num_g=`echo $article|grep -o "$g_name"| wc -l`
	results+="\n"
	if (($num_n==0 && $num_g==0));then
		results+=`echo $line, "-"`
	else
		results+=`echo $line, "$n_name", $num_n, "$g_name", $num_g`
	fi
done <<< `echo $base|grep -o -P "$link.{0,9}[\"#]" | uniq | sed 's/.$//'` 

#puting the results data into a desired file
echo -e $results > results.csv

#adding the amount of articles to the beggining of the list 
#(decreasing the first line which is blank).
temp=`wc -l < results.csv`
wc -l < results.csv | sed -i "1c$((--temp))" results.csv
