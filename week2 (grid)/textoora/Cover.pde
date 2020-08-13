class Cover {

  Book book;
  PGraphics art;
  int artGridX = 45;
  int artGridY = 45;

  PGraphics title;
  PVector titlePosition;
  
  Grid grid;
  Grid titleGrid;
  
  ArrayList<Box> boxes;
  
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
    this.grid = new Grid(this.art,artGridX,artGridY,new float[]{10.0});
    this.generateArt();
    this.generateBoxes();
  }
  
  void generateTitle() {

  }
  
  void generateBoxes() {

    this.art.loadPixels();
    
    ArrayList<Box> b = new ArrayList<Box>();
    // create boxes or each grid tile
    for (int i = 0; i < artGridX; i++) {
      for (int j = 0; j < artGridY; j++) {
        b.add(new Box(this.art,this.grid,20,2,45,10,i,j,i,j)); // needs to move these arguments to the config
      }
    }
    
    // develop boxes until all are done
    boolean allBoxesDone = false;
    while (!allBoxesDone) {
      allBoxesDone = true;
      for (int i = 0; i < this.boxes.size(); i++) {
        b.get(i).grow();
        b.get(i).checkBorders();
        b.get(i).evaluate();
        if (!b.get(i).done) {
          allBoxesDone = false;  
        }
        if (!b.get(i).valid) {
          b.remove(i);  
        }
      }
    }
    
    // clean boxes    
    this.boxes = new ArrayList<Box>();
    

    
    println(this.boxes.size());
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
