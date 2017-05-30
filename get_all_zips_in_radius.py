import mechanize
from bs4 import BeautifulSoup
import pandas
import os

my_zip = raw_input("Insert Zip Code Number ")
start_distance = int(raw_input("Insert starting distance "))
max_distance = int(raw_input("Insert max distance "))

file_to_write = raw_input("Write file name ")

def content_extractor(zip_code, miles_low, miles_high):
    br = mechanize.Browser()
    br.set_handle_robots(False)   # ignore robots
    br.set_handle_refresh(False)
    br.addheaders =[('User-agent', 'Firefox')]
    my_url = "http://www.zip-codes.com/zip-code-radius-finder.asp?zipMilesLow=" + str(miles_low) + "&zipMilesHigh=" + str(miles_high) + "&zip1=" + str(zip_code) + "&Submit=Search"
    
    response = br.open(my_url)
    soup = BeautifulSoup(br.response().read(),"lxml")
    
    
    tds = soup("td",{"class":"a"})
    
    td_1 = [s.extract() for s in soup('a',{"class":"Tips2"})]
    my_list = list()
    for i in tds:
        print i.text
        my_list.append(i.text)
    new_list = [x for x in my_list if x != '']
    chunks = [new_list[x:x+7] for x in range(0, len(new_list), 7)]
    
    df = pandas.DataFrame(chunks)
    cols = ['index','zip','city','county','state','country','distance']
    df.columns = cols
    return(df)


x = content_extractor(my_zip, start_distance, max_distance)

x.to_csv(file_to_write, index = False)