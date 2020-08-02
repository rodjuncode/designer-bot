function Book(title,author,text,dimensions,palette) {
    this.title = title;
    this.author = author;
    this.text = text;
    this.dimensions = dimensions;
    this.palette = palette;

    this.sentences = [];
    this.sentencesWordCount = {};
    this.longestSentenceSize = 0;

    this.cover;

    this.shadowSize = 5;
    this.foldSize = 5;

    this.show = function() {
        this.castShadow();
        this.cover.show();
        this.castFolds();
    }

    this.castShadow = function() {
        push();
        noStroke();
        fill(0,0,0,40);
        rect(-this.shadowSize,this.shadowSize,this.dimensions.x,this.dimensions.y);
        pop();
    }

    this.castFolds = function() {
        push();
        noStroke();
        fill(0,0,0,10);
        rect(0,0,this.foldSize,this.dimensions.y);
        rect(this.foldSize*5,0,this.foldSize*.75,this.dimensions.y);
        pop();
    }

    this.parseTxt = function() {
        let full = txt.join('\n');
        let tokens;
        tokens = matchAll(full,'[^\.\!\?]*[\.\!\?]');
        for (let i = 0; i < tokens.length; i++) {

            let sentence = tokens[i][0].trim();
            let sentenceSize = sentence.length;

            this.sentences.push(sentence);
            this.sentencesWordCount[sentence] = sentence.sentenceSize;

            if (sentenceSize > this.longestSentenceSize) {
                this.longestSentenceSize = sentenceSize;
            }

        }
    }

    this.generateArt = function() {
        this.cover = new Cover(this);
        this.cover.generate();
    }

    this.getSentences = function() {
        return this.sentences;
    }

    this.getLongestSentenceSize = function() {
        return this.longestSentenceSize;
    }

    this.getDimensions = function() {
        return this.dimensions;
    }

    this.getPalette = function() {
        return this.palette;
    }

    this.getTitle = function() {
        return this.title;
    }

    this.getAuthor = function() {
        return this.author;
    }

}