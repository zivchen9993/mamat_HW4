#!/bin/bash

#download the site HTML file
wget https://www.ynetnews.com/category/3082

#search the file for relevant sites and save them on a temp file
cat 3082 | grep -o -P 'https://www.ynetnews.com/article/.{0,9}["#]' >res_p.csv 

#remove the last character (" or #) and remove any duplicated lines
uniq res_p.csv | sed 's/.$//' > results_pre.csv 

#loop, running through all the addresses and counting the appearences of names.
#eventualy adds the names and amount to each address to the file.
while IFS= read -r line; do
	article=$(wget $line -q -O -)
	N=`echo $article|grep -o "Netanyahu" | wc -l `
	G=`echo $article|grep -o "Gantz"| wc -l`
	if (($N==0 && $G==0));then
		echo $line, "-">> results.csv
	else
		echo $line, "Netanyahu", $N, "Gantz", $G>> results.csv
	fi
done<results_pre.csv

#adding the amount of articles to the beggining of the list.
x=`wc -l < results.csv`
sed -i "1i $x" results.csv
