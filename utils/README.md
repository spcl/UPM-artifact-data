cmp_page_hash.py:
Compare the pages(or half page, 1/4 page etc.) of two binary files to check if they are identical.
Accept two input arguments: 
	1. path to file 1  
	2. path to file 2 
	3. how many parts you want to divide one page into, for example you want to compare 1/8 page, then enter 8
file1_out.txt: shows the duplicated pages in file 1
file2_out.txt: shows the duplicated pages in file 2
cmp_out.txt: shows how the pages in file2 are identical to those in file 1

eg: In file1, page1 and page2 are identical, it will be present in file1_out.txt.
Then page3 in file 2 is idential to page2 in file1(also page1 in file 1), in cmp_out.txt only file1's page1 is identical to file2's page3 will be present.

filter_patches.sh:
Find number of pages where most of the content are/partially identical. Change x and y where x <= $line_num < y($line_num == y means the pages are identical).

seperate_pages.sh:
divide pages-1.img dumped by criu into 4k pages.
