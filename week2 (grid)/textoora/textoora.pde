Book b;


void setup() {
  size(600,600);
  colorMode(HSB,360,100,100,100);
      
  // create palette
  color palette[] = new color[3];
  int alpha = 100;
  palette[0] = color(44, 62, 96, alpha);
  palette[1] = color(60, 3, 14, alpha);
  palette[2] = color(150, 5, 86, alpha);
  int x = 300;
  b = new Book("Carne\nEmpalada","Rodrigo Junqueira","assets/short-stories/carne-empalada-rodrigo-junqueira.txt",new PVector(x,x*1.6,10),palette);
  b.parseTxt();
  b.generate();
}


void draw() {
  background(0,0,80,100);
  translate(width/2-b.getDimensions().x/2,height/2-b.getDimensions().y/2);
  b.show();
  noLoop();
}
