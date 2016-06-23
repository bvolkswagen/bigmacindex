#!/bin/bash
echo " _______________________________"
echo "|                               |"
echo "| Global big mac index for $(tput setaf 1)XVC$(tput sgr0 ). |"
echo "|_______________________________|"
echo ""
echo NOTE: The big mac index is recalculated every hour.
echo NOTE: The XVC price is calculated using the latest price on bittrex.
echo ""

#Make user aware of the hourly recalculation of the big mac index.
read -rsp $'Press any key to continue.\n' -n1

#Make bigmacindex directory.
mkdir -p bigmacindex

#Change directory.
cd bigmacindex

#Download the latest data on the big mac index.
echo -en '\n'
echo "Downloading price lists into text files for editing:"
echo "----------------------------------------------------"
curl http://bitcoinppi.com/v1.1/spot.csv > spot.csv
curl https://bittrex.com/api/v1.1/public/getticker?market=btc-xvc > ticker.csv

#Manipulate the data for calculation of the big mac index.
head -n+2 spot.csv | tail -n+2 | cut -c21-29 > spot.price
cut -c63-72 ticker.csv > ticker.price

#Create variables for price calculation.
spot=$(cat spot.price)
ticker=$(cat ticker.price)

#Multiply the two variables and show output.
bigmacs=$(echo "$spot * $ticker" | bc)

#Ask user for total ammount of XVC.
echo -en '\n'
read -p $'Enter the amount of XVC:\n' xvc

#Multiply by total amount of XVC.
echo "$xvc * $bigmacs" | bc > total.csv
cut -c1-8 total.csv > total.price
total=$(cat total.price)

echo " _________________________________________________"
echo "|                                                 |"
echo "|                                                 |"
echo "| You have a whopping total of $(tput setaf 1)"$total"$(tput sgr0) big macs. |"
echo "|                                                 |"
echo "|_________________________________________________|"
