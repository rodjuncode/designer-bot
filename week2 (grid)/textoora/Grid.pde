class Grid {
  
  //float bleed;
  float[] margins;
  int horizontalBlocks;
  int verticalBlocks;
  
  PGraphics canvas;
  
  float blockWidth;
  float blockHeight;
  
  final float DIFF = 0.001;
  
  Grid(PGraphics canvas, int horizontalBlocks, int verticalBlocks, float[] margins) {
    this.canvas = canvas;    
    this.horizontalBlocks = horizontalBlocks;
    this.verticalBlocks = verticalBlocks;
    if (margins.length == 1) {
      this.margins = new float[]{margins[0],margins[0],margins[0],margins[0]};
    } else {
      this.margins = margins;
    }
    this.blockWidth = (float) this.getGridWidth()/horizontalBlocks;
    this.blockHeight = (float) this.getGridHeight()/verticalBlocks;
  }
  
  void show() {
    this.canvas.beginDraw();
    // grid
    this.canvas.stroke(240,100,100,100);
    for (float i = this.getLeftMarginPosition(); i <= this.getRightMarginPosition(); i += this.blockWidth) {
      this.canvas.line(i,this.getTopMarginPosition(),i,this.getBottomMarginPosition());
    }
    for (float i = this.getTopMarginPosition(); i <= this.getBottomMarginPosition(); i += this.blockHeight) {
      this.canvas.line(this.getLeftMarginPosition(),i,this.getRightMarginPosition(),i);
    }
    // margins
    this.canvas.stroke(300,100,100,100);
    this.canvas.line(0,this.getTopMarginPosition(),this.canvas.width,this.getTopMarginPosition());
    this.canvas.line(this.getRightMarginPosition(),0,this.getRightMarginPosition(),this.canvas.height);
    this.canvas.line(0,this.getBottomMarginPosition(),this.canvas.width,this.getBottomMarginPosition());    
    this.canvas.line(this.getLeftMarginPosition(),0,this.getLeftMarginPosition(),this.canvas.height);
    this.canvas.endDraw();
  }
  
  PVector getPosition(int x, int y) {
     return new PVector(round(this.getLeftMarginPosition() + this.blockWidth*x),round(this.getTopMarginPosition() + this.blockHeight*y));
  }
  
  PVector getRandomPosition() {
    int _x = floor(random(this.horizontalBlocks));
    int _y = floor(random(this.verticalBlocks));
    return this.getPosition(_x,_y);
  }
  
  PVector getFitRandomPosition(float w, float h) {
    if (w > 0 && 
        w <= this.getGridWidth() && 
        h > 0 && 
        h <= this.getGridHeight()) {
      float wOffSet = this.getGridWidth() - w + 1;
      float hOffSet = this.getGridHeight() - h + 1;
      int horBlocks = ceil(wOffSet/this.blockWidth);
      int verBlocks = ceil(hOffSet/this.blockHeight);
      int _x = floor(random(horBlocks));
      int _y = floor(random(verBlocks));
      return this.getPosition(_x,_y);
    }
    return new PVector(0,0);
  }
  
  float getWidthFromBlocks(int horizontalBlocks) {
    return this.blockWidth*horizontalBlocks;
  }

  float getHeightFromBlocks(int verticalBlocks) {
    return this.blockHeight*verticalBlocks;
  }

  float getTopMargin() {
    return this.margins[0];  
  }

  float getRightMargin() {
    return this.margins[1];  
  }  

  float getBottomMargin() {
    return this.margins[2];  
  }
  
  float getLeftMargin() {
    return this.margins[3];  
  }

  float getTopMarginPosition() {
    return this.getTopMargin();  
  }

  float getRightMarginPosition() {
    return canvas.width-this.getRightMargin();  
  }  

  float getBottomMarginPosition() {
    return this.canvas.height-this.getBottomMargin();  
  }
  
  float getLeftMarginPosition() {
    return this.getLeftMargin();  
  }
  
  float getGridWidth() {
    return this.canvas.width - this.getLeftMargin() - this.getRightMargin();  
  }
  
  float getGridHeight() {
    return this.canvas.height - this.getTopMargin() - this.getBottomMargin();  
  }
  
  boolean beyondBottomMargin(float p) {
    return this.getBottomMarginPosition() - p < DIFF;
  }

  boolean beyondRightMargin(float p) {
    return this.getRightMarginPosition() - p < DIFF;
  }

  
}
