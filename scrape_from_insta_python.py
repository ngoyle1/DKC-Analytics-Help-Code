import os 
import pandas
from bs4 import BeautifulSoup
import mechanize
import json

my_csv = raw_input("Define the .csv File to Read: ")
dir_to_create = raw_input("Name the Destination Directory: ")


def instagram_link_retriever(file_to_read,directory_name):    
    link_df = pandas.read_csv(file_to_read)
    
    links = link_df["link"].tolist()
    list_of_dates = list()
    directory = directory_name
    if not os.path.exists(directory):
        os.makedirs(directory)
    
    os.chdir(directory)
    for i in range(0,len(links)):
        try:
            br = mechanize.Browser()
            br.set_handle_robots(False)   # ignore robots
            br.set_handle_refresh(False)
            br.addheaders =[('User-agent', 'Firefox')]
            my_url = links[i]
            
            response = br.open(my_url)
            
            soup = BeautifulSoup(br.response().read(),"lxml")
            
            script = soup.find('script', text=re.compile('window\._sharedData'))
            
            date = soup.find("meta",{"property":"og:title"})
            
            json_text = re.search(r'^\s*window\._sharedData\s*=\s*({.*?})\s*;\s*$',
                                  script.string, flags=re.DOTALL | re.MULTILINE).group(1)
            
            
            data = json.loads(json_text)
            
            #test = pandas.read_json(data)
            
            file_name = "link_" + str(i) + "_json" + ".txt"
            
            list_of_dates.append(date)
            print "Link " + str(i) + " Retrieved"
            
            with open(file_name, 'w') as outfile:
                json.dump(data, outfile)
        except:
            list_of_dates.append("Not Found")
            print "Problem with Link " + str(i)


instagram_link_retriever(my_csv, dir_to_create)

