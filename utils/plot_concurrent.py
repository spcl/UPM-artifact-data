import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import sys
import math

benchmark = sys.argv[1]
num = sys.argv[2]
dedup = sys.argv[3]

if dedup == "1":
    data_dir = os.path.join("/data", benchmark + "/", "concurrent_containers_dedupon")
else:
    data_dir = os.path.join("/data", benchmark + "/", "concurrent_containers_dedupoff")

n = math.log(int(num),2)
n = int(n)
x_axis = np.logspace(0,n,n+1,base=2)

data = {}
data_rss_avg = []
data_rss_err = []
data_pss_avg = []
data_pss_err = []
data_private_avg = []
data_private_err = []

for i in x_axis:
    i = int(i)
    data[str(i)] = {}
    file_name = "pmap_result" + str(i) + ".csv"
    data[str(i)]["df"] = pd.read_csv(os.path.join(data_dir + "/", str(i) + "/", file_name))
    data[str(i)]["rss"] = data[str(i)]["df"]["rss"]
    data[str(i)]["pss"] = data[str(i)]["df"]["pss"]
    data[str(i)]["private_clean"] = data[str(i)]["df"]["private_clean"]
    data[str(i)]["private_dirty"] = data[str(i)]["df"]["private_dirty"]
    data[str(i)]["rss_avg"] = np.mean(data[str(i)]["rss"])
    data[str(i)]["rss_err"] = round(np.std(data[str(i)]["rss"]),1)
    data[str(i)]["pss_avg"] = np.mean(data[str(i)]["pss"])
    data[str(i)]["pss_err"] = round(np.std(data[str(i)]["pss"]),1)
    data[str(i)]["private_avg"] = np.mean(data[str(i)]["private_clean"] + data[str(i)]["private_dirty"])
    data[str(i)]["private_err"] = round(np.std(data[str(i)]["private_clean"] + data[str(i)]["private_dirty"]),1)

    data_rss_avg.append(data[str(i)]["rss_avg"])
    data_rss_err.append(data[str(i)]["rss_err"])
    data_pss_avg.append(data[str(i)]["pss_avg"])
    data_pss_err.append(data[str(i)]["pss_err"])
    data_private_avg.append(data[str(i)]["private_avg"])
    data_private_err.append(data[str(i)]["private_err"])
    # print (data[str(i)]["df"])
    # print (data[str(i)]["rss"])
    # print (data[str(i)]["rss_avg"])
    # print (data[str(i)]["rss_err"])
    # print (data[str(i)]["pss_avg"])
    # print (data[str(i)]["pss_err"])

data_rss_avg = pd.Series(data_rss_avg) / 1024
data_rss_err = pd.Series(data_rss_err) / 1024
data_pss_avg = pd.Series(data_pss_avg) / 1024
data_pss_err = pd.Series(data_pss_err) / 1024
data_private_avg = pd.Series(data_private_avg) / 1024
data_private_err = pd.Series(data_private_err) / 1024

x = np.arange(1,n+2)
# print(x)


plt.rcParams['figure.dpi'] = 500
plt.errorbar(x, data_rss_avg, yerr=data_rss_err,  fmt='o-', label="RSS")
plt.errorbar(x, data_pss_avg, yerr=data_pss_err,  fmt='o-', label="PSS")
plt.errorbar(x, data_private_avg, yerr=data_private_err,  fmt='o-', label="Private")
plt.title('Concurrent containers running ' + benchmark)
plt.xlabel('Number of concurrent containers')
plt.ylabel('Memory size (MB)')
# plt.ylim(ymin=0, ymax=350)
plt.xticks(x, x_axis)
plt.legend(loc="lower left")
print("dedup:", dedup)
if dedup == "1":
    print("saving to concurrent_dedup.jpg")
    plt.savefig(os.path.join(data_dir + "/", "concurrent_dedup.jpg"))
else:
    print("saving to concurrent.jpg")
    plt.savefig(os.path.join(data_dir + "/", "concurrent.jpg"))