import hashlib
import sys


dic1 = {}
dic2 = {}

part = int(sys.argv[3]) # divide the page into n parts

file_name_1 = sys.argv[1]
file_name_2 = sys.argv[2]

print ("checking duplicated content in file 1...")
with open(file_name_1, "rb") as fp:
    i = 1
    j = 1
    while True:
        data = fp.read(int(4096/int(part)))
        if not data:
            break
        #print ("checking page%d-%d in file 1" % (j, i)) 
        md5_value = hashlib.md5(data).hexdigest()
        if md5_value in dic1.keys():
            with open('file1_out.txt', 'a+') as f1:
                f1.write("page%d-%d is identical to %s\n" % (j, i, dic1[md5_value]))
        else:
            dic1[md5_value] = "page" + str(j) + '-' + str(i)

        i += 1
        if i == part + 1:
            i = 1
            j += 1
        
print ("checking duplicated content in file 2...")
with open(file_name_2, "rb") as fp:
    i = 1
    j = 1
    while True:
        data = fp.read(int(4096/int(part)))
        if not data:
            break
        #print ("checking page%d-%d in file 2" % (j, i)) 
        md5_value = hashlib.md5(data).hexdigest()
        if md5_value in dic2.keys():
            with open('file2_out.txt', 'a+') as f2:
                f2.write("page%d-%d is identical to %s\n" % (j, i, dic2[md5_value]))
        else:
            dic2[md5_value] = "page" + str(j) + '-' + str(i)
        
        if md5_value in dic1.keys():
            with open('cmp_out.txt', 'a+') as out_fp:
                out_fp.write("file 1 %s is identical to file 2 page%d-%d\n" % (dic1[md5_value], j, i))

        i += 1
        if i == part + 1:
            i = 1
            j += 1
