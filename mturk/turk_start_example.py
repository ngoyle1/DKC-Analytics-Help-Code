from boto.mturk.connection import MTurkConnection
from boto.mturk.price import Price

ACCESS_ID = "AKIAIKZES5XNPMUS4HTQ"
SECRET_KEY = "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"
HOST =  'mechanicalturk.amazonaws.com'

mturk = MTurkConnection(aws_access_key_id=ACCESS_ID,
                        aws_secret_access_key=SECRET_KEY,
                        host=HOST)

print mturk.get_account_balance()




##Get Worker IDS##
hit = '3PR3LXCWSF67WOX6Y5S8??????????'
assignments = mturk.get_assignments(hit)

for a in assignments:
    print a.WorkerId
    
##Assign a Qualification##

#assign qualifications

qualification = "3JNQJJEQXNSX7K3S6OQG?????????"

for a in assignments:
    mturk.assign_qualification(qualification,a.WorkerId,
                               send_notification=False) 




#pay bonuses

payment = Price(1.00)
message = "[message that accompanies your bonus payment]"

for a in assignments:
    mturk.grant_bonus(a.WorkerId,a.AssignmentId,
                      payment,message)
                      
                      
#message workers

subject = "[message subject]"
message = "[main message]"

for a in assignments:
    mturk.notify_workers(a.WorkerId, subject, message)



##Pay more than 10 workers bonuses
'''

By R Gordon Rinderknecht, using Python 2.7.

Feel free to take any part of it and claim it as your own.

'''

from boto.mturk.connection import MTurkConnection
from boto.mturk.price import Price

ACCESS_ID = your access id
SECRET_KEY = your secret key
HOST = 'mechanicalturk.amazonaws.com'

mturk = MTurkConnection(aws_access_key_id=ACCESS_ID,
                        aws_secret_access_key=SECRET_KEY,
                        host=HOST)


def get_all_assignments(hit):
    assignments = []

    page = 1

    while len(mturk.get_assignments(hit, page_number=str(page)))>0:

        assignments.extend(mturk.get_assignments(hit,
                                                 page_number=
                                                 str(page)))
        page += 1

    return assignments


assignments = get_all_assignments("3JU8CV4BRLJ5U2Z???????????????")

payment = Price(1.00)
message = ("[message that accompanies your bonus payment]")

for a in assignments:
    mturk.grant_bonus(a.WorkerId,a.AssignmentId,payment,message)