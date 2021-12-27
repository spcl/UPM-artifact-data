import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import sys


x = ["ASLR enabled", "ASLR disabled"]
# benchmarks = ["110.dynamic-html", "210.thumbnailer", "411.image-recognition"]

aslr1_data = []
aslr0_data = []

bar_width = 0.4

aslr1_df = pd.read_csv("/data/aslr1_share.csv")
# aslr1_df = aslr1_df.iloc[0:2]

# aslr1_df = aslr1_df.iloc[2]
print (aslr1_df)

aslr0_df = pd.read_csv("/data/aslr0_share.csv")
# aslr0_df = aslr0_df.iloc[0:2]
# aslr0_df = aslr0_df.iloc[2]

print (aslr0_df)

print (aslr0_df["benchmarks"])

benchmarks = pd.Series(aslr1_df["benchmarks"]).str.slice(start=4)

# benchmarks = aslr0_df["benchmarks"]

index = np.arange(len(benchmarks))

plt.figure(figsize=(7,4))
plt.bar(index, aslr1_df["not shareable"], bar_width - 0.05, color = "lightgrey", label="Not shareable")
plt.bar(index, aslr1_df["shared-clean"], bar_width - 0.05, color = "indianred", bottom = aslr1_df["not shareable"], label="Already shared by OverlayFS")
plt.bar(index, aslr1_df["shareable anon"], bar_width - 0.05, color = "yellow", bottom = aslr1_df["shared-clean"] + aslr1_df["not shareable"], label="Shareable anonymous memory")
plt.bar(index, aslr1_df["shareable file-backed"], bar_width - 0.05, color = "lightsalmon", bottom = aslr1_df["shared-clean"] + aslr1_df["not shareable"] + aslr1_df["shareable anon"], label = "Shareable file-backed memory")

plt.bar(index + bar_width + 0.05, aslr0_df["not shareable"], bar_width - 0.05, color = "lightgrey")
plt.bar(index + bar_width + 0.05, aslr0_df["shared-clean"], bar_width - 0.05, color = "indianred", bottom = aslr0_df["not shareable"])
plt.bar(index + bar_width + 0.05, aslr0_df["shareable anon"], bar_width - 0.05, color = "yellow", bottom = aslr0_df["shared-clean"] + aslr0_df["not shareable"])
plt.bar(index + bar_width + 0.05, aslr0_df["shareable file-backed"], bar_width - 0.05, color = "lightsalmon", bottom = aslr0_df["shared-clean"] + aslr0_df["not shareable"] + aslr0_df["shareable anon"])


# plt.bar(index + bar_width + 0.05, aslr0_df["not shareable"], bar_width - 0.05, color = "lightgrey", label="Not shareable")
# plt.bar(index + bar_width + 0.05, aslr0_df["shared-clean"], bar_width - 0.05, color = "indianred", bottom = aslr0_df["not shareable"], label="Already shared by OverlayFS")
# plt.bar(index + bar_width + 0.05, aslr0_df["shareable anon"], bar_width - 0.05, color = "yellow", bottom = aslr0_df["shared-clean"] + aslr0_df["not shareable"], label="Shareable anonymous memory")
# plt.bar(index + bar_width + 0.05, aslr0_df["shareable file-backed"], bar_width - 0.05, color = "lightsalmon", bottom = aslr0_df["shared-clean"] + aslr0_df["not shareable"] + aslr0_df["shareable anon"], label = "Shareable file-backed memory")

# for i in range(0,1):
#     plt.text(i - 0.18, 28, s="ASLR enabled")
#     plt.text(i+ bar_width /2 + 0.05, 28, s="ASLR disabled")

    
# for i in index:
#     plt.text(i - 0.08, 80, s="ASLR enabled")
#     plt.text(i+ bar_width - 0.04, 80, s="ASLR disabled")

plt.rcParams['figure.dpi'] = 600
plt.xticks(index + bar_width /2 + 0.05 /2, benchmarks)
plt.legend()
plt.ylim(ymin=0)
# plt.ylim(ymin=0, ymax=550)
plt.title("ASLR effects")
plt.ylabel("Memory size (MB)")
plt.savefig('/data/aslr.jpg')
