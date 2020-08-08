class Grid {
  
  Cover cover;
  //float bleed;
  //float margin;
  float res;
    
  Grid(Cover cover) { // isso deve ser em funçao de tamanho e res, podendo ser utilizado para o Title, por exemplo).
                      // um grid só seria mais fácil. Assumir Title como um simples textArea
    this.cover = cover;
    this.res = 30;    
  }
  
  void show() {
    this.cover.art.beginDraw();
    this.cover.art.stroke(240,100,100,100);
    for (float i = 0; i <= this.cover.book.getDimensions().x; i += this.res) {
      this.cover.art.line(i,0,i,this.cover.book.getDimensions().y);
    }
    for (float i = 0; i <= this.cover.book.getDimensions().y; i += this.res) {
      this.cover.art.line(0,i,this.cover.book.getDimensions().x,i);
    }
    this.cover.art.endDraw();
  }
  
  PVector getPosition(int x, int y) {
     return new PVector(this.res*x,this.res*y);
  }
  
  PVector getRandomPosition() {
    int _x = floor(random(this.getMaxHorizontalGrid()));
    int _y = floor(random(this.getMaxVerticalGrid()));
    return this.getPosition(_x,_y);
  }
  
  int getMaxHorizontalGrid() {
    return floor(this.cover.book.getDimensions().x/this.res)-1;  
  }
  
  int getMaxVerticalGrid() {
    return floor(this.cover.book.getDimensions().y/this.res)-1;
  }
  
  float getResolution() {
    return this.res;  
  }
  
}
