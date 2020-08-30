class Cover {

  Book book;
  PGraphics art;
  int artGridX = 45;
  int artGridY = 45;
  PGraphics content;  
  int contentGridX = 3;
  int contentGridY = 1;
  int margin = 0;
  int startChar = 0;
 
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

  void showBoxes() {
    for (int i = 0; i < this.boxes.size(); i++) {
      PVector txtPos = this.boxes.get(i).getPosition();
      PVector txtSize = this.boxes.get(i).getSize();      
      // show
      this.content.beginDraw();
      this.content.push();
      this.content.noFill();
      this.content.strokeWeight(2);
      this.content.stroke(0,255,0);
      this.content.rect(txtPos.x,txtPos.y,txtSize.x,txtSize.y);
      this.content.pop();
      this.content.endDraw();
    }
  }
  
  void generateContent() {
    this.content.beginDraw();
    this.content.clear();
    this.generateContent(this.content);
    this.content.endDraw();
  }
  
  void generateContent(PGraphics canvas) {
    int margin = 3;
    float scalar = 0.76;
    PFont titleFont = createFont("assets/fonts/Anton-Regular.ttf", 1);    
    PFont authorFont = createFont("assets/fonts/Teko-Regular.ttf", 1);    
    canvas.textFont(titleFont);
    String title = this.book.getTitle().toUpperCase();
    String author = this.book.getAuthor().toUpperCase();
    PVector txtPos, txtSize;
    float s;
    // title
    if (title != null && title.length() > 0) {
      // 1st Half
      String[] titleTokens = split(title, ' ');
      int halfTitle = ceil(titleTokens.length/2);
      String fstTitleHalf = "";
      String sndTitleHalf = "";
      for (int i = 0; i < titleTokens.length; i++) {
        if (i < halfTitle) {
          fstTitleHalf += (fstTitleHalf.length() > 0 ? " " : "") + titleTokens[i];  
        } else {
          sndTitleHalf += (sndTitleHalf.length() > 0 ? " " : "") + titleTokens[i];
        }
      }    
      String[] titleChunks = new String[]{fstTitleHalf, sndTitleHalf};
      for (int i = 0; i < titleChunks.length; i++) {
        if (titleChunks[i].length() > 0) {
          txtPos = this.boxes.get(i).getPosition();
          txtSize = this.boxes.get(i).getSize();
          s = txtSize.y;
          canvas.textSize(s);
          float verticalOffset = 0;
          if (txtPos.y > artGrid.getTopMargin() + artGrid.getHeightFromBlocks(1)) {
            verticalOffset = artGrid.getHeightFromBlocks(1);
          }
          while(canvas.textAscent()*scalar < txtSize.y + verticalOffset) {
            s+=1.5;
            canvas.textSize(s);
          }
          canvas.textAlign(LEFT);
          canvas.fill(this.book.palette.getTxtColor(0));
          while (canvas.textWidth(titleChunks[i]) >= txtSize.x - margin*3) {
            s-=0.05;
            canvas.textSize(s);
          }
          canvas.text(titleChunks[i],txtPos.x+margin,txtPos.y+txtSize.y-0.5);  
        }
      }
    }  //<>//
    // author
    if (author != null && author.length() > 0) {
      canvas.textFont(authorFont);
      txtPos = this.boxes.get(2).getPosition();
      txtSize = this.boxes.get(2).getSize();
      s = txtSize.y*.70;
      canvas.textAlign(RIGHT);
      canvas.textSize(s);
      canvas.fill(this.book.palette.getTxtColor(1));      
      while (canvas.textWidth(author) >= txtSize.x - margin*3) {
        s-=0.05;
        canvas.textSize(s);
      }
      canvas.text(author,txtPos.x+txtSize.x-margin,txtPos.y+txtSize.y-1); 
    }
  }

  void generate() {
    this.art = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y)); 
    this.artGrid = new Grid(this.art,artGridX,artGridY,new float[]{margin,margin,margin,margin});
    this.content = createGraphics(round(this.book.getDimensions().x),round(this.book.getDimensions().y));
    this.contentGrid = new Grid(this.art,contentGridX,contentGridY,new float[]{margin,margin,margin,margin});
    this.generateArt();
    this.generateBoxes();
    this.generateContent();
  }
  
  void print() {
    PGraphics pdf = createGraphics(round(this.book.dimensions.x),round(this.book.dimensions.y),PDF,"../../../_output/textoora/capas/capa.pdf");
    pdf.beginDraw();
    this.generateArt(pdf);
    this.generateContent(pdf);
    pdf.dispose();
    pdf.endDraw();
  }
  
  void generateBoxes() {
    this.art.loadPixels();
    ArrayList<Box> b = new ArrayList<Box>();
    // create boxes or each grid tile
    for (int i = 0; i < artGridX; i++) {
      for (int j = 0; j < artGridY; j++) {
        b.add(new Box(this.art,this.artGrid,20,3,45,30,i,j,i,j)); // needs to move these arguments to the config
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
    // clean duplicated boxes  
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
    // snap boxes to content grid
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
          if (abs(boxLeftLimit - verticalLinePos) < 1) {
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
          if (abs(boxRightLimit - verticalLinePos) < 1) {
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
  } 
  
  
  void generateStartChar() {
    this.startChar = floor(random(this.book.getSentences().size())); 
  }
  
  void generateArt() {
    this.generateStartChar();
    this.art.beginDraw();
    this.art.clear();
    this.generateArt(this.art);
    this.art.endDraw();
  }
  
  void generateArt(PGraphics canvas) {
    
    ArrayList<String> sentences = this.book.getSentences();
    int longestSentenceSize = this.book.getLongestSentenceSize();
    color[] palette = this.book.palette.getArtPalette();
    
    float x = this.artGrid.getLeftMarginPosition();
    float y = this.artGrid.getTopMarginPosition();

    float w = this.artGrid.getWidthFromBlocks(1);
    float h = this.artGrid.getHeightFromBlocks(1);
    
    canvas.background(palette[0]);
    canvas.colorMode(HSB,360,100,100,100);

    int s = this.startChar;
    while(y <= this.artGrid.getBottomMarginPosition()) {
      for (int i = s; i < sentences.size(); i++) {
        int size = sentences.get(i).length();
        int hue = round(map(size,0,longestSentenceSize,0,palette.length-1));
        canvas.fill(palette[hue]);
        canvas.stroke(palette[hue]);
        for (int j = 0; j < size; j++) {
          canvas.rect(x,y,w,h);
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
      s = 0;  
    }
  }
  
  void setMargin(int margin) {
    this.margin = margin;  
  }
  
}
