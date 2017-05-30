import mechanize
from bs4 import BeautifulSoup
import pandas
import os

os.chdir("/Users/francisco06121988/Desktop/dkc/sears_home_mac/sears_web_scraping")

my_states = pandas.read_csv("regions_states.csv")

list_of_states = my_states["State"].tolist()
state = list()
zip_1 = list()
street = list()
locality = list()

for i in range(0,50):
    try:
        br = mechanize.Browser()
        br.set_handle_robots(False)   # ignore robots
        br.set_handle_refresh(False)
        br.addheaders =[('User-agent', 'Firefox')]
        my_url = "http://www.sears.com/stores/" + list_of_states[i] + ".html"
        
        response = br.open(my_url)
        
        soup = BeautifulSoup(br.response().read(),"lxml")
        
        states = soup("span",{"itemprop":"addressRegion"})
        zip_tags = soup("span",{"itemprop":"postalCode"})
        street_tags = soup("span",{"itemprop":"streetAddress"})
        localities = soup("span",{"itemprop":"addressLocality"})
        for tag in states:
            print tag.next
            state.append(tag.next)
        for tag in zip_tags:
            print tag.next
            zip_1.append(tag.next)
        for tag in street_tags:
            print tag.next
            street.append(tag.next)
        for tag in localities:
            print tag.next
            locality.append(tag.next)
    except:
        print list_of_states[i] + " not retrieved"

table = [street,locality,state,zip_1]
df = pandas.DataFrame(table).transpose()
cols = ['street','locality','state','zip_1']
df.columns = cols

df.to_csv("new_sears_list_scraped.csv", index = False)


