class Cover {

  Book book;
  PGraphics art;
  PGraphics title;
  PVector titlePosition;
  
  Grid grid;
  
  Cover(Book book) {
    this.book = book;
  }
  
  void show() {
    this.show(false);
  }
  
  void show(boolean showGrid) {
    if (showGrid) {
      this.grid.show();
    }
    image(this.art, 0, 0);
    image(this.title,this.titlePosition.x,titlePosition.y);
  }
  
  void generate() {
    this.art = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y)); 
    this.grid = new Grid(this.art,9,9, new float[]{10.0,10.0,10.0,30.0});
    this.generateArt();
    this.title = createGraphics((int) this.grid.getWidthFromBlocks(5),(int) this.grid.getHeightFromBlocks(4));
    this.titlePosition = this.grid.getFitRandomPosition(this.title.width,this.title.height);    
    this.generateTitle();
  }
  
  void generateTitle() {
    String title = this.book.getTitle();
    String author = this.book.getAuthor();
    this.title.beginDraw();
    this.title.background(156, random(255), 184);
    this.title.fill(255);
    this.title.textAlign(RIGHT);
    this.title.textFont(createFont("Georgia", 30));
    this.title.text(title,140,50);
    this.title.textSize(15);
    this.title.fill(0,0,0,90);
    this.title.text(author,140,64);
    this.title.noStroke();
    this.title.endDraw();
  }
  
  void generateArt() {
    
    ArrayList<String> sentences = this.book.getSentences();
    int longestSentenceSize = this.book.getLongestSentenceSize();
    color[] palette = this.book.getPalette();
    
    float x = 0;
    float y = 0;
    int w = ceil(random(10,50));
    int h = ceil(random(1,5));
    
    this.art.beginDraw();
    this.art.background(255);
    this.art.colorMode(HSB,360,100,100,100);
    this.art.noStroke();
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
