Book b;
ArrayList<Box> boxes = new ArrayList<Box>();
int showBox = 0;

void setup() {
  size(700,700);
  colorMode(HSB,360,100,100,100);
  
  //frameRate(4);
  
  // create palette
  color palette[] = new color[3];
  int alpha = 100;
  palette[0] = color(44, 62, 96, alpha);
  palette[1] = color(60, 3, 14, alpha);
  palette[2] = color(150, 5, 86, alpha);
  int x = 300;
  int h = 20;
  b = new Book("Carne\nEmpalada","Rodrigo Junqueira","assets/short-stories/carne-empalada-rodrigo-junqueira.txt",new PVector(x,x*1.4,10),palette);
  b.parseTxt();
  b.generate();  
  
  //for (int i = 0; i < 45; i++) {
  //  for (int j = 0; j < 45; j++) {
  //    boxes.add(new Box(b.cover.art,b.cover.grid,20,2,45,10,i,j,i,j));
  //  }
  //}
  
  //boxes.add(new Box(b.cover.art,b.cover.grid,1,1,0,0,0,0));
}


void draw() {
  background(0,0,80,100);
  translate(width/2-b.getDimensions().x/2,height/2-b.getDimensions().y/2);
  b.show(false);
  
  //for (int i = 0; i < boxes.size(); i++) {
  //  //boxes.get(i).show();
  //  boxes.get(i).grow();
  //  boxes.get(i).checkBorders();
  //  boxes.get(i).evaluate();
  //  if (!boxes.get(i).valid) {
  //    boxes.remove(i);  
  //  }
  //}
  
  
  //b.generate();
  noLoop();
  
  //saveFrame("../../../_output/textoora/boxes/frame####.png");
}

void mousePressed() {
  //if (showBox < boxes.size()) {
  //  showBox++;
  //} else {
  //  showBox = 0;
  //}
  //saveFrame("../../../_output/textoora/frame####.png");
  //b.generate();  
}
