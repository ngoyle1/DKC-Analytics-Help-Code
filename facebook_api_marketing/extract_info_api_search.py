def extract_info(facebook_response):
    first_list = list(facebook_response)
    coverage = list()
    ids = list()
    names = list()
    descriptions = list()
    
    for i in range(0, len(first_list)):
        try:
            my_coverage = re.search('"audience_size": [0-9]{1,15}',str(first_list[i])).group(0)
            coverage.append(my_coverage)
            print my_coverage
        except:
            continue
        try:
            my_description = re.search('"description": "[aA-Zz].+"',str(first_list[i])).group(0)
            descriptions.append(my_description)
            print my_description
        except:
            continue
            
        try:
            my_ids = re.search('"id": "[0-9]{1,20}"',str(first_list[i])).group(0)
            ids.append(my_ids)
            print my_ids
        except:
            continue
        try:
            my_names = re.search('"name": "[aA-Zz].+"',str(first_list[i])).group(0)
            names.append(my_names)
            print my_names
        except:
            continue
    
    return(None)
