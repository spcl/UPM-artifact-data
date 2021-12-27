import pandas as pd
import matplotlib.pyplot as plt

# in curl_container* dir, run python3 plot.py

curl_data = pd.read_csv("pmap_result.csv")
print (curl_data)
curl_data["file"] = curl_data["file"].str.extract('(\d+)', expand=False)
curl_data[" rss"] = curl_data[" rss"].values / 1024
curl_data[" pss"] = curl_data[" pss"].values / 1024

plt.plot(curl_data["file"], curl_data[" rss"], 'o-', label="rss")
# plt.plot(curl_data["file"], curl_data[" pss"], 'o-', label="pss")

checkpoint_data = pd.read_csv("../identicalpage_result.csv")
print (checkpoint_data)
checkpoint_data["identical page num"] = checkpoint_data["identical page num"].values * 4 / 1024

# plt.plot(curl_data["file"], checkpoint_data["identical page num"], 'o-', label="size of the identical pages")
shareable = checkpoint_data["identical page num"].values - curl_data[" shared_clean"].values / 1024
print (shareable)
plt.plot(curl_data["file"], shareable, 'o-', label="size of shareable pages")

# plt.xticks(rotation=30)
plt.title('411.image-recognition on tencent machine')
plt.xlabel('Number of requests')
plt.ylabel('Memory size (MB)')
plt.ylim(ymin=0)
plt.legend()
plt.savefig('test.jpg')

#plt.show()
