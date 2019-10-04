# Replicated

This is a single bash script that extracts useful information from a support
bundle.

## Data to be extracted

- Kernel type                                                                       
- Kernel version                                                                 
- Number of cores (physical and logical)                                                                 
- Load average in seconds over the past 15 minutes                                
- Disk usage in bytes on the root device                                          
- Docker version                                                                  
- Docker storage driver 

## Usage
path_to_script path_to_support_bundle

For example: ./extract_data.bash supportbundle.tar.gz 

This will create a info.txt file with all the required information.

There can be lots of additions to this simple script like better formatting,
output based on user preference, etc. But that's future work.  

