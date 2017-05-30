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

##adTargetingCategory
params = {
    'type': 'adTargetingCategory',
    'class': 'moms',
}

resp = TargetingSearch.search(params=params)

for i, value in enumerate(resp[0]):
    print value,resp[0]
    
x = dict(resp[0])    

###
parents = {
    'type': 'adTargetingCategory',
    'class': 'demographics',
}

response = TargetingSearch.search(params=parents)
##Finding values
