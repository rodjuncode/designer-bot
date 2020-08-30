import os
import sys
import json
from requests_html import HTMLSession

GOOGLE = 'https://www.google.com/search?tbm=isch&q='

if len(sys.argv) == 2:

	q = str(sys.argv[1])

	session = HTMLSession()
	r = session.get(GOOGLE + q)
	r.html.render()
	colors = r.html.search_all("rgb({rgb})")

	palette = [] 
	for c in colors:
	  palette.append(c['rgb'])
	wordPalette	= { q : palette }

	out = open(os.path.dirname(os.path.abspath(__file__)) + '/palette.json','w+',encoding="utf-8")
	json.dump(wordPalette,out,ensure_ascii=False)
	out.close();	



