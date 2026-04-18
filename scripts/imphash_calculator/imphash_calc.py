import sys
import pefile
import peutils  # Imported here, but not used in this script

# Get the PE file path from the first command-line argument
pe_file = sys.argv[1]

# Load the PE (Portable Executable) file
pe = pefile.PE(pe_file)

# Calculate the import hash (imphash) of the PE file
# The imphash is based on the imported functions/libraries
# and is often used in malware analysis for clustering samples
imphash = pe.get_imphash()

# Print the resulting imphash
print(imphash)