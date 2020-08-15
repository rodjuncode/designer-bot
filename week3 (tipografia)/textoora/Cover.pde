class Cover {

  Book book;
  PGraphics art;
  int artGridX = 45;
  int artGridY = 45;
  PGraphics content;  
  int contentGridX = 3;
  int contentGridY = 1;
  float margin = 10;

  PGraphics title;
  PVector titlePosition;
  
  Grid artGrid;
  Grid contentGrid;
  
  ArrayList<Box> boxes;
  ArrayList<String> contentText;
  
  Cover(Book book) {
    this.book = book;
  }
  
  void show() {
    this.show(false);
  }
  
  void show(boolean showGrid) {
    if (showGrid) {
      this.artGrid.show();
    }
    image(this.art,0,0);
    image(this.content,0,0);
  }
  
  void updateContent() {
    this.content.beginDraw();
    this.content.clear(); //<>//
    PFont font = createFont("assets/fonts/BebasNeue-Regular.ttf", 1);
    this.content.textFont(font);
    for (int i = 0; i < this.contentText.size(); i++) {
      String text = this.contentText.get(i);
      if (text.length() > 0) {
        PVector txtPos = this.boxes.get(i).getPosition();
        PVector txtSize = this.boxes.get(i).getSize();
        int s = 2;
        this.content.textSize(s);
        while (this.content.textWidth(text) < txtSize.x) {
          s++;
          this.content.textSize(s);
        }
          println(s);        
        this.content.fill(255);
        this.content.text(text,txtPos.x,txtPos.y,txtSize.x,txtSize.y);
      }
    }
    this.content.endDraw();
  }
  
  void generate() {
    this.contentText = new ArrayList<String>();    
    this.art = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y)); 
    this.artGrid = new Grid(this.art,artGridX,artGridY,new float[]{margin});
    this.content = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y));
    this.contentGrid = new Grid(this.art,contentGridX,contentGridY,new float[]{margin});
    this.generateArt();
    this.generateBoxes();
  }

  void generateBoxes() {

    this.art.loadPixels();
    
    ArrayList<Box> b = new ArrayList<Box>();
    // create boxes or each grid tile
    for (int i = 0; i < artGridX; i++) {
      for (int j = 0; j < artGridY; j++) {
        b.add(new Box(this.art,this.artGrid,30,3,45,20,i,j,i,j)); // needs to move these arguments to the config
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
      }
    }
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
  
  void addTextToContent(String c) {
    this.contentText.add(c);  
  }
  
  void clearTextContent() {
    this.contentText.clear();  
  }
  
}
