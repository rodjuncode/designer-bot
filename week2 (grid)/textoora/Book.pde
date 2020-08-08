class Book {
  
  String title;
  String author;
  String txtFile;
  PVector dimensions;
  color[] palette;
  
  ArrayList<String> sentences;
  int longestSentenceSize;
  
  Cover cover;
 
  float shadowSize = 5;
  float foldSize = 5;
  
  Book(String title,String author,String txtFile, PVector dimensions, color[] palette) {
    this.title = title;
    this.author = author;
    this.txtFile = txtFile;
    this.dimensions = dimensions;
    this.palette = palette;

    this.sentences = new ArrayList<String>();
    this.longestSentenceSize = 0;

    this.shadowSize = 5;
    this.foldSize = 5;
  }
  
  void show() {
    this.castShadow();
    this.cover.show(true);
    this.castFolds();
  }


  void castShadow() {
    push();
    noStroke();
    fill(0,0,40);
    rect(-this.shadowSize,this.shadowSize,this.dimensions.x,this.dimensions.y);
    pop();    
  }
  
  void castFolds() {
    push();
    noStroke();
    fill(0,0,0,10);
    rect(0,0,this.foldSize,this.dimensions.y);
    rect(this.foldSize*4,0,this.foldSize*.75,this.dimensions.y);
    pop();
  }

  void parseTxt() {
    String[] lines = loadStrings(this.txtFile);
    String full = "";
    for (int i = 0; i < lines.length; i++) {
      full += lines[i];
    }
    String
    tokens[][] = matchAll(full,"[^.!?]*[.!?]");

    for (int i = 0; i < tokens.length; i++) {
      String sentence = tokens[i][0].trim();
      int sentenceSize = sentence.length();
      this.sentences.add(sentence);
      if (sentenceSize > this.longestSentenceSize) {
        this.longestSentenceSize = sentenceSize;  
      }      
    }
  }


  void generate() {
    this.cover = new Cover(this);  
    this.cover.generate();
  }
  
  ArrayList<String> getSentences() {
    return this.sentences;  
  }

  int getLongestSentenceSize() {
    return this.longestSentenceSize;  
  }

  PVector getDimensions() {
    return this.dimensions;
  }

  color[] getPalette() {
    return this.palette;  
  }
  
  String getTitle() {
    return this.title;
  }

  String getAuthor() {
    return this.author;  
  }
  
}
