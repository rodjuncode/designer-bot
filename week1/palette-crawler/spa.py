import spacy

nlp = spacy.load("pt_core_news_sm")

f = open("assets/carne-empalada-rodrigo-junqueira.txt", "r", encoding="utf-8")

# Process whole documents
text = (f.read())
doc = nlp(text)

# Analyze syntax
words = [token.lemma_ for token in doc if token.pos_ == "NOUN" or token.pos_ == "ADJ"]
print(words)
