import json
import sys

outjson_file = sys.argv[1]
f = open(outjson_file)
data = json.load(f) # data is loaded as a dictionary
compact = json.dumps(data["inputs"], separators=(',',':'))
# escape = compact.replace('"','\\"')
escape = compact.replace('[',"")
escape = escape.replace(']',"")
print (escape)