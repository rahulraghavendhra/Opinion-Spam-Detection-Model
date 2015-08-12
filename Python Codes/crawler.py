from bs4 import BeautifulSoup
from string import ascii_lowercase
import urllib 
import re
import csv
review_file = open('reviews.csv', 'w')
with open("hotellinks_file.csv","r") as f:
	content = f.read().splitlines()
	for link in content:
		temp_array = []
#		link = "http://www.tripadvisor.com.sg"+link
		print link
		urlHandle = urllib.urlopen(link)
		html = urlHandle.read()
		soup = BeautifulSoup(html)
		hotelname = soup.find('h1', attrs={'id':'HEADING'}).text
		reviews = soup.find_all('div', attrs={'class':'reviewSelector '})
		for review in reviews:
			review_array = []
			#hotel name
			review_array.append('"' + hotelname.encode('ASCII', 'ignore').strip("\n") + '"');
			#hotel link
	                review_array.append('"' + link.encode('ASCII', 'ignore').strip("\n") + '"');
			reviewid = review['id']
			#review ID
			review_array.append('"' + reviewid.encode('ASCII', 'ignore').strip("\n") + '"')
			if review.find('div', attrs={'class':'quote'}) is not None:
				reviewlink = review.find('div', attrs={'class':'quote'})
				reviewlink = "http://www.tripadvisor.com.sg"+reviewlink.find('a')['href'] 
			#review link
				review_array.append('"' + reviewlink.encode('ASCII', 'ignore').strip("\n") + '"')
				urlHandle = urllib.urlopen(reviewlink)
				reviewhtml = urlHandle.read()
				reviewsoup = BeautifulSoup(reviewhtml)
				individual_review_div = reviewsoup.find('div', id=reviewid)
				#summary review
				review_array.append("") if individual_review_div.find('div', attrs={'property':'v:summary'}) is None else review_array.append('"' + individual_review_div.find('div', attrs={'property':'v:summary'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#detailed review
				review_array.append("") if individual_review_div.find('p', attrs={'property':'v:description'}) is None else review_array.append('"' + individual_review_div.find('p', attrs={'property':'v:description'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewername
				userdetails = individual_review_div.find('div', attrs={'class':'username'})
				review_array.append("") if userdetails.find('span') is None else review_array.append('"' + userdetails.find('span').text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewerlocation
				review_array.append("") if individual_review_div.find('div', attrs={'class':'location'}) is None else review_array.append('"' + individual_review_div.find('div', attrs={'class':'location'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewer title
			#	print individual_review_div.find('div', attrs={'class':'reviewerTitle'})
				review_array.append("") if individual_review_div.find('div', attrs={'class':'reviewerTitle'}) is None else review_array.append('"' + individual_review_div.find('div', attrs={'class':'reviewerTitle'}).string.encode('ASCII', 'ignore').strip("\n") + '"')
				#total reviewer's reviews
				review_array.append("") if individual_review_div.find('span', attrs={'class':'badgeText'}) is None else review_array.append('"' + individual_review_div.find('span', attrs={'class':'badgeText'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewers hotel reviews
				if individual_review_div.find('div', attrs={'class':'contributionReviewBadge'}) is None:
					review_array.append("")
				else:	
					hotel_review_div = individual_review_div.find('div', attrs={'class':'contributionReviewBadge'})
					review_array.append("") if hotel_review_div.find('span', attrs={'class':'badgeText'}) is None else review_array.append('"' + hotel_review_div.find('span', attrs={'class':'badgeText'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewer's city reviews
				if individual_review_div.find('div', attrs={'class':'passportStampsBadge'}) is None:
					review_array.append("") 
				else:
					city_review_div = individual_review_div.find('div', attrs={'class':'passportStampsBadge'})
        	                	review_array.append("") if city_review_div.find('span', attrs={'class':'badgeText'}) is None else review_array.append('"' + city_review_div.find('span', attrs={'class':'badgeText'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewer's helpful votes
				if individual_review_div.find('div', attrs={'class':'helpfulVotesBadge'}) is None:
					review_array.append("")
				else:
					helpfulvotes_review_div = individual_review_div.find('div', attrs={'class':'helpfulVotesBadge'})
	        	                review_array.append("") if helpfulvotes_review_div.find('span', attrs={'class':'badgeText'}) is None else review_array.append('"' + helpfulvotes_review_div.find('span', attrs={'class':'badgeText'}).text.encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewer's overall rating
				review_array.append("") if individual_review_div.find('img', attrs={'property':'v:rating'})['alt'] is None else review_array.append('"' + individual_review_div.find('img', attrs={'property':'v:rating'})['alt'].encode('ASCII', 'ignore').strip("\n") + '"')
				#reviewer's individual rating		
				rating_array = individual_review_div.find_all('li', attrs={'class':'recommend-answer'})
				rating_dict = {}
				for rating in rating_array:
					stars = rating.find('img')
					rating_dict[rating.text.strip("\n")] = stars['alt'].strip("\n")
				rating_array_text = rating_dict.keys()
				if 'Sleep Quality' in rating_array_text:
					review_array.append('"' + rating_dict['Sleep Quality'] + '"')
				else:
					review_array.append("")
				if 'Location' in rating_array_text:
					review_array.append('"' + rating_dict['Location'] + '"')
				else:
					review_array.append("")
				if 'Rooms' in rating_array_text:
					review_array.append('"' + rating_dict['Rooms'] + '"')
				else:
					review_array.append("")
				if 'Service' in rating_array_text:
					review_array.append('"' + rating_dict['Service'] + '"')
				else:
					review_array.append("")
				if 'Value' in rating_array_text:
					review_array.append('"' + rating_dict['Value'] + '"')
				else:
					review_array.append("")
				if 'Cleanliness' in rating_array_text:
					review_array.append('"' + rating_dict['Cleanliness'] + '"')
				else:
					review_array.append("")
				
				review_file.write(','.join(review_array))
				review_file.write("\n");
