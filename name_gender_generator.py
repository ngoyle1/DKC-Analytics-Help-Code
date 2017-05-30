def name_gender_generator(list_of_names):
    import os
    import pandas
    
    os.chdir('/Users/harrocyranka/Desktop/code/name/name') ##Change this to where the names are
    name_frames = pandas.read_csv("names_with_probabilities.csv")
    list_of_names = [str(x) for x in list_of_names]
    
    list_of_names = [x.lower() for x in list_of_names]
    list_check  = name_frames["name"].tolist()
    results = list()
    for i in list_of_names:
        string_name = str(i)
        try:
            probability = name_frames.loc[name_frames["name"] == string_name,"p_female"].values[0]
            if probability > 0.55:
                print "Female Name"
                results.append("Female")
            elif  0.45 <= probability <= 0.55:
                print "Ambiguous Name"
                results.append("Ambiguous")
            else:
                print "Male Name"
                results.append("Male")
        except:
            print "Name not in list" 
            results.append("NA")
    return results  