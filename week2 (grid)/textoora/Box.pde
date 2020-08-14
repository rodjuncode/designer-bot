class Box {
  int beginX;
  int beginY;
  int endX;
  int endY;
  PVector end;
  int minWidth;
  int minHeight;
  int maxWidth;
  int maxHeight;
  PGraphics canvas;
  Grid grid;
  color myColor;
  color myStroke;
  boolean valid;
  boolean done;
  boolean crashedUp;
  boolean crashedDown;
  boolean crashedLeft;
  boolean crashedRight;  
  
  Box(PGraphics canvas, Grid grid, int minWidth, int minHeight, int maxWidth, int maxHeight, int beginX, int beginY, int endX, int endY) {
    this.canvas = canvas;
    this.grid = grid;
    this.minWidth = minWidth;
    this.minHeight = minHeight;
    this.maxWidth = maxWidth;
    this.maxHeight = maxHeight;
    this.beginX = beginX;
    this.beginY = beginY;
    this.endX = endX;
    this.endY = endY;
    this.myColor = this.getColor(beginX,beginY);
    this.myStroke = color(0,100,100,100);
    this.valid = true;
    this.done = false;
    this.crashedUp = false;
    this.crashedDown = false;
    this.crashedLeft = false;
    this.crashedRight = false;
  }
  
  color getColor(int x, int y) {
    PVector position = this.grid.getPosition(x,y);
    int i = round(position.y*this.canvas.width+position.x);
    return this.canvas.pixels[i];
  }
  
  void show() {
    push();
    noFill();
    stroke(this.myStroke);
    PVector posBegin = this.grid.getPosition(beginX,beginY);
    rect(posBegin.x,posBegin.y,
        this.grid.getWidthFromBlocks(1)*(endX-beginX+1),
        this.grid.getHeightFromBlocks(1)*(endY-beginY+1));
    line(posBegin.x,posBegin.y,posBegin.x+this.grid.getWidthFromBlocks(1)*(endX-beginX+1),posBegin.y+this.grid.getHeightFromBlocks(1)*(endY-beginY+1));
    line(posBegin.x+this.grid.getWidthFromBlocks(1)*(endX-beginX+1),posBegin.y,posBegin.x,posBegin.y+this.grid.getHeightFromBlocks(1)*(endY-beginY+1));    
    pop();
  }
  
  void grow() {
    if (this.beginX > 0) this.beginX--; else this.crashedLeft = true;
    if (this.beginY > 0) this.beginY--; else this.crashedUp = true;  
    if (this.endX < this.grid.horizontalBlocks - 1) this.endX++; else this.crashedRight = true;
    if (this.endY < this.grid.verticalBlocks - 1) this.endY++; else this.crashedDown = true;      
  }
  
  void shrinkLeft() {
    this.beginX++;  
  }
  
  void shrinkRight() {
    this.endX--;
  }
  
  void checkBorders() {
    for (int i = this.beginX; i <= this.endX; i++) {
      color c = this.getColor(i,this.beginY);
      if (c != this.myColor || this.beginY < 0) {
        this.beginY++;
        this.crashedUp = true;
        break;
      }
    }
    for (int i = this.beginX; i <= this.endX; i++) {
      color c = this.getColor(i,this.endY);
      if (c != this.myColor) {
        this.endY--;
        this.crashedDown = true;
        break;
      }
    }
    for (int i = this.beginY; i <= this.endY; i++) {
      color c = this.getColor(this.beginX,i);
      if (c != this.myColor || this.beginX < 0) {
        this.beginX++;
        this.crashedLeft = true;
        break;
      }
    }    
    for (int i = this.beginY; i <= this.endY; i++) {
      color c = this.getColor(this.endX,i);
      if (c != this.myColor || this.endX >= this.grid.horizontalBlocks) {
        this.endX--;
        this.crashedRight = true;
        break;
      }
    }    
  }
  
  void evaluate() {
    if (this.endX-this.beginX+1 > this.maxWidth) { 
      this.valid = false;
      return;
    }
    if (this.endY-this.beginY+1 > this.maxHeight) { 
      this.valid = false;
      return;
    }
    if (this.crashedUp && this.crashedDown && this.endY-this.beginY+1 < this.minHeight) {
      this.valid = false;
      return;
    }
    if (this.crashedLeft && this.crashedRight && this.endX-this.beginX+1 < this.minWidth) {
      this.valid = false;
      return;
    }
    if (this.crashedUp && this.crashedDown && this.crashedLeft && this.crashedRight) {
      this.done = true; 
    }
  }
  
  boolean sameAreaOf(Box b) {
    return (this.beginX == b.beginX &&
            this.endX   == b.endX &&
            this.beginY == b.beginY &&
            this.endY   == b.endY);
  }
  
  boolean done() {
    return this.done;  
  }
  
  boolean valid() {
    return this.valid;  
  }
  
}
