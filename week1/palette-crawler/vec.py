import sys
import json

def mapRGB(val):
	return val*2/255-1

for line in sys.stdin:
	wordPalette = json.loads(line);

for w in wordPalette.keys():
	word = w;
	palette = wordPalette[word]

	colorVec = [];
	for color in palette:
		rgb = color.split(",")
		r = int(rgb[0])
		g = int(rgb[1])
		b = int(rgb[2])
		colorVec.append(mapRGB(r))
		colorVec.append(mapRGB(g))
		colorVec.append(mapRGB(b))
		
	word2colorvec = { w : colorVec }

	print(json.dumps(word2colorvec))


