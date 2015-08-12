import glob

for filename in glob.iglob('/home/rahul/Documents/BIS/Project/Data/spam/negative_polarity/deceptive_from_MTurk/fold5/*.txt'):
    with open(filename) as f:
	data = f.read()
	data = data.replace('\n', '');
	print data 
