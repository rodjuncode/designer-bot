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

	print(json.dumps(wordPalette))



