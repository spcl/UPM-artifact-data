
# Description and usage of the scripts 

## Basic description

The scripts are used to get the profiling results for the benchmarks https://github.com/spcl/serverless-benchmarks/tree/dev.

The profiled data are:

1. How memory / sharable memory changes with the number of requests (this is to see when the memory gets) 
2. How much memory is already shared by OverlayFS, how much is shareable but not shared, among them how much is anonymous, how much is file-backed (**this is our main objective**)
3. How many pages are partially identical (this is to see if we need patches, see *Difference Engine* paper) 
4. Peak vs after-execution memory measurements (this is because our measurements of memory are all taken after request, i.e. after-execution measurements, we want to see if its needed to collect data at the peak memory point)
5. How ASLR affects the sharing potential

A slides presenting the profiling results can be found at this repo.

## Usage of the scripts

### 1. How memory changes with # of requests
`./curl_test_whole_process.sh $benchmark $curl_times`

This will start two containers running `$benchmark` from different directories (/root/serverless-benchmarks1 and /root/serverless-benchmarks2). Using *pmap* to track the changes of rss, and *docker checkpoint* to see the changes of the shareable memory.

For example, 

`./curl_test_whole_process.sh 110.dynamic-html 20` 

will see how memory changes with 20 requests for container.

This will call `curl_test.sh`, `loop_pmap.sh`, `get_cmp_result.sh` and `plot_curl.py`. The data will be saved at `$data_dir/$benchmark/curl_container*`The plot will be saved at `$data_dir/$benchmark/curl_container1/multiple_curls.jpg`.

From this we can get after how many requests the memory gets stable.

### 2. How much memory is already shared and can be shared & how much is partially identical & aslr effects
`./checkpoint_see_sharable_two_containers.sh $benchmark $request_times $aslr`

`$request_times` is the request times to get a stable memory.

`$aslr` 1 means aslr is on, 0 means aslr is off.

The user needs to input the requests to the shell for the two containers.

This script will call `loop_pmap.sh`, `cmp_page_hash.py`, `get_anonymous_filebacked_data.sh`. The data are stored at `$data_dir/$benchmark/$aslr`. There isn't plot for a single benchmark. The plot is draw after getting the results of all the benchmarks that want to tested.

To see how many pages are partically identical, the data is recorded in `identicalpage_result.csv` in `$data_dir/$benchmark`.

To get the data with aslr on/off, turn on/off the aslr and the re-do the above process.

After getting the data of all benchmarks, run `plot_share.py` or `plot_share.ipynb` jupyter notebook, the latter is more recomannded. The plot showing the absolute value is stored as `/data/share.jpg`, the plot showing the sharing pencentage over rss is stored as `/data/share_perc.jpg`.

### 3. Comparison with aslr on and off
Run `plot_aslr.py` or `plot_aslr.ipynb` after getting the data of all benchmarks with aslr on and off. The plot shows the comparison between aslr on and off of all benchmarks, is stored as `/data/aslr.jpg`.


<font color=red>NOTE!! The data directory I use is `/data`, so all my data are stored in `/data` and for some scripts, if the data is stored elsewhere, some changes of the script is needed.</font>