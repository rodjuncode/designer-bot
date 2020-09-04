class Book {
  
  String title;
  String author;
  String txtFile;
  PVector dimensions;
  Palette palette;
  boolean ready;
  
  ArrayList<String> sentences;
  int longestSentenceSize;
  
  Cover cover;
 
  float shadowSize = 5;
  float foldSize = 5;
  
  Book(String title,String author,String txtFile, PVector dimensions, Palette palette, int margin) {
    this.title = title;
    this.author = author;
    this.txtFile = txtFile;
    this.dimensions = dimensions;
    this.palette = palette;

    this.sentences = new ArrayList<String>();
    this.longestSentenceSize = 0;

    this.shadowSize = this.dimensions.x/50;
    this.foldSize = this.dimensions.x/50;

    this.cover = new Cover(this);
    this.cover.setMargin(margin);
    
    this.ready = false;
  }
  
  void show() {
    this.castShadow();
    this.cover.show();
  }

  void show(boolean showGrid) {
    this.castShadow();
    this.cover.show(showGrid);
  }

  void castShadow() {
    push();
    noStroke();
    fill(0,0,0,30);
    rect(-this.shadowSize,this.shadowSize,this.dimensions.x,this.dimensions.y);
    pop();    
  }
  
  @Deprecated // ebooks don't have folds
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
    String tokens[][] = matchAll(full,"[^.!?]*[.!?]");
    for (int i = 0; i < tokens.length; i++) {
      String sentence = tokens[i][0].trim();
      int sentenceSize = sentence.length();
      this.sentences.add(sentence);
      if (sentenceSize > this.longestSentenceSize) {
        this.longestSentenceSize = sentenceSize;  
      }      
    }
    this.ready = true;
  }
  
  boolean ready() {
    return this.ready;  
  }

  void generate() {
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

  Palette getPalette() {
    return this.palette;  
  }
  
  String getTitle() {
    return this.title;
  }

  String getAuthor() {
    return this.author;  
  }
  
  void setTitle(String title) {
    this.title = title;    
  }
  
  void setAuthor(String author) {
    this.author = author;
  }
  
  void setPalette(Palette palette) {
    this.palette = palette;    
  }
  
}
