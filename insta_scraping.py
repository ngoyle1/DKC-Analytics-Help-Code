import mechanize
from bs4 import BeautifulSoup
import pandas
import os
import json
import re 

os.chdir("/Users/harrocyranka/Desktop/")


br = mechanize.Browser()
br.set_handle_robots(False)   # ignore robots
br.set_handle_refresh(False)
br.addheaders =[('User-agent', 'Firefox')]

my_url = "https://www.instagram.com/explore/locations/1025542755/"

response = br.open(my_url)

soup = BeautifulSoup(br.response().read(),"lxml")

states = soup("script",{"type":"text/javascript"})



my_json = states[4].next

x = str(my_json)

m = re.search(r"(?s)window._sharedData\s*=\s*(\{.*?\});", x)

k = json.loads(m.group(1))

k["entry_data"]["LocationsPage"][0]["location"]["media"]["nodes"][15]["comments"]


k["entry_data"]["LocationsPage"][0]["nodes"]
