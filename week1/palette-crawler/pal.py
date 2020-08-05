import sys
import json

HTML_FOLDER = 'palettes'

for line in sys.stdin:
	wordPalette = json.loads(line);

for w in wordPalette.keys():
	word = w;
	palette = wordPalette[word][2:]

	f = open(HTML_FOLDER + '/' + word + '.html', 'w+')

	html = ''
	html += '<html><head><title>'
	html += word
	html += '</title></head><body style="margin: 0; padding: 0">'
	html += '<h1 style="font-family: Georgia; font-size: 50pt; font-style: italic; margin: 20px 0 10px 40px; text-transform: capitalize;">' + word + '</h1>'
	
	for color in palette:
		html += '<div style="background: rgb(' + color + '); float: left; height: 50px; width: 50px;"></div>'

	html += '<div style="clear: both"></div>'
	html += '<textarea style="display: block; height: 300px	; margin: 20px 45px; width: 600px">' + str(json.dumps(wordPalette)) + '</textarea>'

	html += '</body><html>'

	f.write(html)	
	f.close()
