class Cover {

  Book book;
  PGraphics art;
  PGraphics title;
  PVector titlePosition;
  
  Grid grid;
  Grid titleGrid;
  
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
  }
  
  void generate() {
    this.art = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y)); 
    this.grid = new Grid(this.art,45,45,new float[]{10.0});
    this.generateArt();
  }
  
  void generateTitle() {

  }
  
  void generateArt() {
    
    ArrayList<String> sentences = this.book.getSentences();
    int longestSentenceSize = this.book.getLongestSentenceSize();
    color[] palette = this.book.getPalette();
    
    float x = this.grid.getLeftMarginPosition();
    float y = this.grid.getTopMarginPosition();

    float w = this.grid.getWidthFromBlocks(1);
    float h = this.grid.getHeightFromBlocks(1);
    
    this.art.beginDraw();
    this.art.background(palette[0]);
    this.art.colorMode(HSB,360,100,100,100);

    int startChar = floor(random(sentences.size()));
    while(y <= this.grid.getBottomMarginPosition()) {
      for (int i = startChar; i < sentences.size(); i++) {
        int size = sentences.get(i).length();
        int hue = round(map(size,0,longestSentenceSize,0,palette.length-1));
        this.art.fill(palette[hue]);
        this.art.stroke(palette[hue]);
        for (int j = 0; j < size; j++) {
          this.art.rect(x,y,w,h);
          x += w;
          if (this.grid.beyondRightMargin(x)) {            
            x = this.grid.getLeftMarginPosition();
            y += h;
          }
          if (this.grid.beyondBottomMargin(y)) {            
            break;
          }
        }
        if (this.grid.beyondBottomMargin(y)) {          
          break;
        }
      }
      startChar = 0;  
    }
    this.art.endDraw();
  }
  
}
