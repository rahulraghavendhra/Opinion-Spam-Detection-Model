library("RSQLite")
library(lattice)
library(MASS)
library(plyr)
library(car)

#2. Load the driver
drv <- dbDriver("SQLite")
#3. Establish the connection to the database
  con <- dbConnect(drv, "/home/rahul/Documents/BIS/Project/Codes/data/bis.db")
#4. View all the tables in the database
dbListTables(con)

#5. SQL query processing
case1 = dbGetQuery(con, "select hotels.hotelname, hotels.summaryreview, hotels.detailedreview, hotels.reviewername,
                    hotels.reviewerlocation, hotels.reviewertitle, hotels.totalreviewersreview, hotels.hotelreviews, 
                    hotels.cityreviews, hotels.helpfulvotes, hotels.overallrating, hotels.sleeprating, 
                    hotels.locationrating, hotels.roomrating, hotels.servicerating, hotels.valuerating, 
                    hotels.cleanlinessrating from ( select  hotels.hotelname, hotels.summaryreview, 
                    count(distinct reviewername) cunt from hotels group by hotels.hotelname,
                    hotels.summaryreview having cunt > 1) a,hotels where a.summaryreview = hotels.summaryreview 
                    order by hotels.summaryreview ")
write.csv(case1, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/case1.csv")
case2 = dbGetQuery(con,"select  hotels.hotelname, hotels.summaryreview, hotels.detailedreview, hotels.reviewername, 
                   hotels.reviewerlocation, hotels.reviewertitle, hotels.totalreviewersreview, hotels.hotelreviews, 
                   hotels.cityreviews, hotels.helpfulvotes, hotels.overallrating, hotels.sleeprating, hotels.locationrating, 
                   hotels.roomrating, hotels.servicerating, hotels.valuerating, hotels.cleanlinessrating 
                   from (select  summaryreview,  reviewername, count(*) cunt from hotels group by summaryreview, 
                   reviewername having cunt > 1) a,hotels where a.summaryreview =hotels.summaryreview and 
                   a.reviewername = hotels.reviewername order by hotels.reviewername")
write.csv(case2, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/case2.csv")
case3 = dbGetQuery(con, "select hotels.hotelname, hotels.summaryreview, hotels.detailedreview, hotels.reviewername, 
                   hotels.reviewerlocation, hotels.reviewertitle, hotels.totalreviewersreview, hotels.hotelreviews, 
                   hotels.cityreviews, hotels.helpfulvotes, hotels.overallrating, hotels.sleeprating, hotels.locationrating, 
                   hotels.roomrating, hotels.servicerating, hotels.valuerating, hotels.cleanlinessrating 
                   from (select hotelname, summaryreview, reviewername, count(*) cunt from hotels group by 
                   summaryreview, reviewername having cunt > 1) a,hotels where a.summaryreview = hotels.summaryreview 
                   and a.reviewername = hotels.reviewername and a.hotelname = hotels.hotelname order by hotels.reviewername")
write.csv(case3, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/case3.csv")
case4 = dbGetQuery(con, "select   hotels.hotelname, hotels.summaryreview, hotels.detailedreview, hotels.reviewername, 
                   hotels.reviewerlocation, hotels.reviewertitle, hotels.totalreviewersreview, hotels.hotelreviews, 
                   hotels.cityreviews, hotels.helpfulvotes, hotels.overallrating, hotels.sleeprating, hotels.locationrating, 
                   hotels.roomrating, hotels.servicerating, hotels.valuerating, hotels.cleanlinessrating from 
                   (select summaryreview, count(distinct reviewername) cunt_reviewer, count(distinct hotelname) cunt_hotel, 
                   count(*) from hotels group by summaryreview having cunt_reviewer > 1 and cunt_hotel > 1 ) a, 
                   hotels where a.summaryreview = hotels.summaryreview order by hotels.reviewername")
write.csv(case4, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/case4.csv")
case5 = dbGetQuery(con, "select hotels.reviewername, count(*) from hotels, ( select distinct hotels.hotelname, hotels.reviewername
                    from hotels, (select hotels.reviewername, count(distinct hotelname) distinct_hotels from hotels where
                    upper(hotels.hotelreviewtype) = 'NEGATIVE' group by hotels.reviewername having distinct_hotels > 1 ) 
                    distinct_hotels where distinct_hotels.reviewername = hotels.reviewername and 
                    upper(hotels.hotelreviewtype) = 'NEGATIVE' ) b where hotels.hotelname not in 
                    (select distinct hotels.hotelname from hotels, (select hotels.reviewername, count(distinct hotelname) distinct_hotels 
                    from hotels where upper(hotels.hotelreviewtype) = 'NEGATIVE' group by hotels.reviewername 
                    having distinct_hotels > 1 ) distinct_hotels where distinct_hotels.reviewername = hotels.reviewername 
                    and upper(hotels.hotelreviewtype) = 'NEGATIVE' ) and upper(hotels.hotelreviewtype) = 'POSITIVE' and 
                    hotels.reviewername = b.reviewername group by hotels.reviewername having count(*) > 1")
write.csv(case5, "/home/rahul/Documents/BIS/Project/Data/Results/R-Results/case5.csv")