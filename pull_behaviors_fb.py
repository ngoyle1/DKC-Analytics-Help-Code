#Add to header of your file
from facebookads.api import FacebookAdsApi
from facebookads import objects
from facebookads.adobjects.targetingsearch import TargetingSearch
import pandas


#Initialize a new Session and instantiate an API object:

my_app_id = '1045624065519288'
my_app_secret = "ff93f7d28d956c381a7b61b0149fe41a"
my_access_token = "EAAO2ZCVLZBbrgBABiI5jJr2MNnORf9ctU9ZACdN2mKuJGCSusVkEne4f1M3Vv1QwG4Jd9d1GZAAM8ATLY5pAhfDohIBX4R5T7PENhcbSNpZAeW7Krjl7nzExRtkHvBuPYxvB7q5tjZA6qNv3GodhhmBPlUtqGLCU0ZARK97hqk0kAZDZD"
FacebookAdsApi.init(my_app_id, my_app_secret, my_access_token)


#Add to header of your file
from facebookads.objects import AdUser
 
#Add after FacebookAdsApi.init
me = AdUser(fbid='me')
my_account = me.get_ad_accounts()[0]

params = {
    'q':'affinity',
    'type': 'adTargetingCategory',
    'class': 'behaviors',
}

resp = TargetingSearch.search(params=params)

myNames = list()
myTypes = list()
myIds = list()
descriptions = list()

for i in range(0,len(resp)):
    print resp[i]['name']
    myNames.append(resp[i]['name'])
    print resp[i]['type']
    myTypes.append(resp[i]['type'])
    print resp[i]['id']
    myIds.append(resp[i]['id'])
    print resp[i]['description']
    descriptions.append(resp[i]['description'])
    

myTable = [myNames, myTypes, myIds, descriptions]
df = pandas.DataFrame(myTable).transpose()
df.columns = ['name','type','id','descriptions']

df

df.to_excel('behaviors_for_fb_ads2.xlsx', index=False)

