class Cover {

  Book book;
  PGraphics art;
  PGraphics title;
  
  Grid grid;
  
  Cover(Book book) {
    this.book = book;
    this.grid = new Grid(this);    
  }
  
  void show() {
    this.show(false);
  }
  
  void show(boolean showGrid) {
    if (showGrid) {
      this.grid.show();
    }
    image(this.art, 0, 0);
    //image(this.title,random(50,150),random(50,150));
    PVector titlePos = this.grid.getRandomPosition();
    image(this.title,titlePos.x,titlePos.y);
  }
  
  void generate() {
    this.generateArt();
    this.generateTitle();
  }
  
  void generateTitle() {
    this.title = createGraphics(round(this.book.getDimensions().x/2),round(this.book.getDimensions().y/2));    
    String title = this.book.getTitle();
    String author = this.book.getAuthor();
    this.title.beginDraw();
    this.title.background(156, random(255), 184);
    this.title.fill(255);
    this.title.textAlign(RIGHT);
    this.title.textFont(createFont("Georgia", 32));
    this.title.text(title,146,50);
    this.title.textSize(15);
    this.title.fill(0,0,0,90);
    this.title.text(author,140,64);
    this.title.noStroke();
    this.title.endDraw();
  }
  
  void generateArt() {
    this.art = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y));    
    ArrayList<String> sentences = this.book.getSentences();
    int longestSentenceSize = this.book.getLongestSentenceSize();
    color[] palette = this.book.getPalette();
    
    this.art.beginDraw();
    this.art.background(255);
    this.art.colorMode(HSB,360,100,100,100);
    this.art.noStroke();
    
    float x = 0;
    float y = 0;
    
    int w = ceil(random(10,50));
    int h = ceil(random(1,5));
    
    while(x <= this.book.getDimensions().x) {
      for (int i = 0; i < sentences.size(); i++) {
        int size = sentences.get(i).length();
        int hue = round(map(size,0,longestSentenceSize,0,palette.length-1));
        this.art.fill(palette[hue]);
        for (int j = 0; j < sentences.get(i).length(); j++) {
          this.art.rect(x,y,w,h);
          y += h;
          if (y >= this.book.getDimensions().y) {
            y = 0;
            x += w;
          }
        }
      }
    }
    this.art.endDraw();
  }
  
}
