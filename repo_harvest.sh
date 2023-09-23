# Author MawlzGPT
# Date   666
# Desc   Point it at a file and itll clone all the github repos it finds...
#        Format to find and clone: http://github.com/someusername/somerepo 
#        I forgot to account for caps in the pre username/repo part but whatever.
#        Had it working with pointing it at a URL to do the same thing but for some reason decided to drop that.
# Usage  $ python scriptname.py filenametoparse.extension

import re
import sys
import subprocess
import multiprocessing

# Check if a filename is provided as a command-line argument
if len(sys.argv) != 2:
    print("Usage: python script.py <filename>")
    sys.exit(1)

# Read the filename from the command line
filename = sys.argv[1]

# Define the regular expression pattern
pattern = r'(https:\/\/github\.com\/[a-zA-Z0-9]+\/[a-zA-Z0-9\-_]+)'

# Initialize a list to store matched URLs
matched_urls = []

# Open the file and search for matching URLs
with open(filename, 'r') as file:
    for line in file:
        matches = re.findall(pattern, line)
        matched_urls.extend(matches)

# Append '.git' to matched URLs
git_urls = [url + '.git' for url in matched_urls]

# Determine the number of CPU cores available
num_cores = multiprocessing.cpu_count()

# Calculate the number of threads to use (half of available cores)
num_threads = max(1, num_cores // 2)

# Function to clone repositories
def clone_repository(url):
    subprocess.run(['git', 'clone', url])

# Create a thread pool and clone repositories concurrently
with multiprocessing.Pool(processes=num_threads) as pool:
    pool.map(clone_repository, git_urls)

# Print a message for successful cloning
print(f"Cloned {len(git_urls)} GitHub repositories using {num_threads} threads.")
