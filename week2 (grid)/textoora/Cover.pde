class Cover {

  Book book;
  PGraphics art;
  int artGridX = 45;
  int artGridY = 45;
  int contentGridX = 3;
  int contentGridY = 1;
  float margin = 10;

  PGraphics title;
  PVector titlePosition;
  
  Grid artGrid;
  Grid contentGrid;
  
  ArrayList<Box> boxes;
  
  Cover(Book book) {
    this.book = book;
  }
  
  void show() {
    this.show(false);
  }
  
  void show(boolean showGrid) {
    if (showGrid) {
      this.contentGrid.show();
    }
    image(this.art, 0, 0);
  }
  
  void generate() {
    this.art = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y)); 
    this.artGrid = new Grid(this.art,artGridX,artGridY,new float[]{margin});
    this.contentGrid = new Grid(this.art,contentGridX,contentGridY,new float[]{margin});
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
        b.add(new Box(this.art,this.artGrid,30,2,45,10,i,j,i,j)); // needs to move these arguments to the config
      }
    }
    
    // grow boxes until all are done
    boolean allBoxesDone = false;
    while (!allBoxesDone) {
      allBoxesDone = true;
      for (int i = 0; i < b.size(); i++) {
        b.get(i).grow();
        b.get(i).checkBorders();
        b.get(i).evaluate();
        if (!b.get(i).done()) {
          allBoxesDone = false;  
        }
        if (!b.get(i).valid()) {
          b.remove(i);  
        }
      }
    }
    
    // clean boxes  
    this.boxes = new ArrayList<Box>();
    for (int i = 0; i < b.size(); i++) {
      Box candidateBox = b.get(i);
      boolean unique = true;
      for (int j = 0; j < this.boxes.size(); j++) {
        Box uniqueBox = this.boxes.get(j);
        if (candidateBox.sameAreaOf(uniqueBox)) {
          unique = false;
        }
      }
      if (unique) {
        this.boxes.add(candidateBox);
      } //<>//
    }
    
    // snap boxes to grid (always retract, because you already expanded everything!!!
    for (int i = 0; i < this.boxes.size(); i++) {
      Box boxToSnap = this.boxes.get(i);
      boolean hit;
      // left side
      hit = false;
      while (!hit) {
        PVector boxPos = this.artGrid.getPosition(boxToSnap.beginX,boxToSnap.beginY);
        float boxLeftLimit = boxPos.x;        
        for (int v = 0; v <= this.contentGrid.getHorizontalBlocks(); v++) {
          int verticalLinePos = round(v*this.contentGrid.getWidthFromBlocks(1)+this.contentGrid.getLeftMargin());
          if (abs(boxLeftLimit - verticalLinePos) < 1) { //<>//
            hit = true;
            break;
          }
        }      
        if (!hit) {
          boxToSnap.shrinkLeft();  
        }
      }
      // right side
      hit = false;
      while (!hit) {
        PVector boxPos = this.artGrid.getPosition(boxToSnap.endX,boxToSnap.endY);        
        float boxRightLimit = boxPos.x + this.artGrid.getWidthFromBlocks(1);        
        for (int v = 0; v <= this.contentGrid.getHorizontalBlocks(); v++) {
          int verticalLinePos = round(v*this.contentGrid.getWidthFromBlocks(1)+this.contentGrid.getLeftMargin());
          println("V:" + verticalLinePos);
          if (abs(boxRightLimit - verticalLinePos) < 1) { //<>//
            hit = true;
            break;
          }
        }      
        if (!hit) {
          boxToSnap.shrinkRight();  
        }
      }
      boxToSnap.evaluate();
      if (!boxToSnap.valid()) {
        this.boxes.remove(i);
      }
    }
    
    print(this.boxes.size());
    
  }
  
  
  void generateArt() {
    
    ArrayList<String> sentences = this.book.getSentences();
    int longestSentenceSize = this.book.getLongestSentenceSize();
    color[] palette = this.book.getPalette();
    
    float x = this.artGrid.getLeftMarginPosition();
    float y = this.artGrid.getTopMarginPosition();

    float w = this.artGrid.getWidthFromBlocks(1);
    float h = this.artGrid.getHeightFromBlocks(1);
    
    this.art.beginDraw();
    this.art.background(palette[0]);
    this.art.colorMode(HSB,360,100,100,100);

    int startChar = floor(random(sentences.size()));
    while(y <= this.artGrid.getBottomMarginPosition()) {
      for (int i = startChar; i < sentences.size(); i++) {
        int size = sentences.get(i).length();
        int hue = round(map(size,0,longestSentenceSize,0,palette.length-1));
        this.art.fill(palette[hue]);
        this.art.stroke(palette[hue]);
        for (int j = 0; j < size; j++) {
          this.art.rect(x,y,w,h);
          x += w;
          if (this.artGrid.hitRightMargin(x)) {            
            x = this.artGrid.getLeftMarginPosition();
            y += h;
          }
          if (this.artGrid.hitBottomMargin(y)) {            
            break;
          }
        }
        if (this.artGrid.hitBottomMargin(y)) {          
          break;
        }
      }
      startChar = 0;  
    }
    this.art.endDraw();
  }
  
}
