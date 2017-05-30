import twitter
import pandas
import os
import re
import json

try:
    os.chdir("/Users/francisco06121988/Desktop/dkc/honest_presentation/get_overlaps")
except:
    print "Not changed"


##Now getting all the retweeters###
x = open("sample_of_green_mom.txt", "r+").readlines()
new_x = [i.replace("\n","") for i in x][1:]

chunks = [new_x[x:x + 180] for x in xrange(0,len(new_x),180)]
del x
del new_x

##Setting API Credentials##
api = twitter.Api(consumer_key="R9R5ic0jM3UjHs38PXIArUG1y",
                consumer_secret="xRYZ8em8ScFD5CCi9kOkomGbhPxPysNH4f4Z2nvO449XNvC7mg",
                access_token_key="122462547-qPHZWrRIZZjk7bp7QccEXpFUL7PJpFEwjx0BG64k",
                access_token_secret="U7rDuZd540WSdGpltXZHrgzgxrBTFWg9S9fI9hN32rdrL")

followers_count = list()
list_of_ids = list()

for i in range(14):
    try:
        next_user = api.GetUser(chunks[3][i])
        print "User " + str(i) + " found"
    except:
        print "User " + str(i) + " not found"
        list_of_ids.append(chunks[3][1])
        followers_count.append(0)
        continue
    try:
        followers_count.append(next_user.followers_count)
    except:
        followers_count.append("followers_count_not_found")

new_list = sum(chunks,[])

categories = list()

for i in range(554):
    if followers_count[i] >=0 and followers_count[i] <=250:
        categories.append("0-250 Followers")
    elif followers_count[i] >= 251 and followers_count[i] <= 500:
        categories.append("251-500 Followers")
    elif followers_count[i] >= 501 and followers_count[i] <= 1000:
        categories.append("501-1000 Followers")
    elif followers_count[i] >= 1001 and followers_count[i] <=2500:
        categories.append("1001-2500 Followers")
    elif followers_count[i] >= 2501 and followers_count[i] <= 5000:
        categories.append("2501-5000 Followers")
    elif followers_count[i] >=5001 and followers_count[i] <= 10000:
        categories.append("5001-10000 Followers")
    elif followers_count[i] >=10001 and followers_count[i] <= 20000:
        categories.append("10001-20000 Followers")
    elif followers_count[i] >=20001:
        categories.append("20001+ Followers")

table = [new_list,categories, followers_count]
df = pandas.DataFrame(table).transpose()

df.columns = ["twitter_id","category","followers_count"]

df.to_csv("green_moms_right_2.csv",encoding="utf-8")

