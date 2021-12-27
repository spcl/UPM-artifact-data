import json
import pandas as pd
import numpy as np
import sys

# the directory depends on the file_name directory, the result is add to checkpoint_result.csv

# only parse pages in container2 
pagemapjson_file = sys.argv[1]
identical_page_file = sys.argv[2]
f = open(pagemapjson_file)

anonymous_page_num = 0
file_backed_page_num = 0

pages = [] # index as page order, value as flag
pages.append("NULL")
data = json.load(f)
for entry in data["entries"]:
    if "nr_pages" not in entry:
        continue
    for i in range(1, entry["nr_pages"] + 1):
        pages.append(entry["flags"])

identical_pages = pd.read_csv(identical_page_file, header=None)
for page_index in identical_pages[0]:
    page_index = int(page_index)
    if pages[page_index] == "PE_LAZY | PE_PRESENT":
        anonymous_page_num += 1
    elif pages[page_index] == "PE_PRESENT":
        file_backed_page_num += 1
    else:
        print ("page[%d] error!" % page_index)

print ("# anonymous pages: %d " % anonymous_page_num)
print ("# file-backed pages: %d" % file_backed_page_num)

anonymous = ["identical anonymous", anonymous_page_num]
file_backed = ["identical file-backed", file_backed_page_num]

checkpoint_data = pd.read_csv("checkpoint_result.csv")

checkpoint_data["anonymous pages"] = anonymous_page_num
checkpoint_data["file-backed pages"] = file_backed_page_num
checkpoint_data.to_csv("checkpoint_result.csv", index=False, sep=",")
