from bs4 import BeautifulSoup
from string import ascii_lowercase
import urllib 
import re
import csv
hotellinks_file=open("hotellinks_file.csv","wb")
#print (hotellinks)
x=[]
for i in range(0,301,30):
	if i==0:
		link="http://www.tripadvisor.com.sg/Hotels-g294265-Singapore-Hotels.html"
	else:
		link ="http://www.tripadvisor.com.sg/Hotels-g294265-oa"+str(i)+"-Singapore-Hotels.html"
	urlHandle = urllib.urlopen(link)
	html = urlHandle.read()
	soup = BeautifulSoup(html)
	hotellinks = soup.find_all('div',attrs={'class':'metaLocationInfo'})
	for hotels in hotellinks:
		hotel=hotels.find("a")
		if hotel:
			hotellinks_file.write(hotel['href'])
			hotellinks_file.write("\n")
			
			 
