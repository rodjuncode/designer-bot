import spacy
import sys
import json
import re
from requests_html import HTMLSession

GOOGLE = 'https://www.google.com/search?tbm=isch&q='

def mapRGB(val):
	return val*2/255-1

# analyzing text (as seen in spa.py)
nlp = spacy.load("pt_core_news_sm")
f = open("assets/wiki-colors.txt", "r", encoding="utf-8")
text = (f.read())
doc = nlp(text)
spacyTokens = [token.lemma_ for token in doc if token.pos_ == "NOUN" or token.pos_ == "ADJ"]

# reset file
word2colorvec = { "vectors": {} }
out = open('word2colorvec.json','w',encoding="utf-8")
json.dump(word2colorvec,out,ensure_ascii=False)
out.close()

# crawling for colors (as seen in goo.py)
for word in spacyTokens:
	print('Crawling ' + word + ' colors...')
	session = HTMLSession()
	r = session.get(GOOGLE + word)
	r.html.render()
	colors = r.html.search_all("rgb({rgb})")
	gooColors = []
	for c in colors:
		validated = re.match("^[0-9,]+$", c['rgb'])
		isValid = bool(validated)
		if (isValid):
			gooColors.append(c['rgb'])
	session.close()

	# converting to word2vec format (as seen in vec.py)
	print('Converting ' + word + ' to colorvec...')
	colorVec = [];
	for color in gooColors:
		rgb = color.split(",")
		r = int(rgb[0])
		g = int(rgb[1])
		b = int(rgb[2])
		colorVec.append(mapRGB(r))
		colorVec.append(mapRGB(g))
		colorVec.append(mapRGB(b))
	
	out = open('word2colorvec.json','r+',encoding="utf-8")
	word2colorvec = json.load(out)
	word2colorvec['vectors'].update({word: colorVec})
	out.seek(0)
	out.truncate()
	json.dump(word2colorvec,out,ensure_ascii=False)
	out.close();






