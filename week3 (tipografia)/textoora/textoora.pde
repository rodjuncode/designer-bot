import controlP5.*;

// ui
ControlP5 cp5;
PGraphics ui;
Grid uiGrid;
boolean showGrid = false;
boolean showBoxes = false;

Book b;

void setup() {
  
  // 1. ui 
  size(700,700);
  colorMode(HSB,360,100,100,100);
  // 1.1 grid
  ui = createGraphics(width,height);
  uiGrid = new Grid(ui,14,14,new float[]{50.0});
  // 1.2 controls
  int btnSize = 19;
  int txtSize = 24;
  color lblColor = color(#457b9d);
  cp5 = new ControlP5(this);
  PVector txtText1Pos = uiGrid.getPosition(8,2);  
  cp5.addTextfield("title")
     .setCaptionLabel("Titulo")
     .setColorCaptionLabel(lblColor) 
     .setPosition(txtText1Pos.x,txtText1Pos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(6)),txtSize)
     .setFocus(true)     
     .setAutoClear(false);  
  PVector txtText2Pos = uiGrid.getPosition(8,3);  
  cp5.addTextfield("author")
     .setCaptionLabel("Autor")
     .setColorCaptionLabel(lblColor)     
     .setPosition(txtText2Pos.x,txtText2Pos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(6)),txtSize)
     .setAutoClear(false);
  PVector tglShowBoxes = uiGrid.getPosition(8,10);
  cp5.addToggle("toggleShowBoxes")
      .setCaptionLabel("Caixas")
     .setPosition(tglShowBoxes.x,tglShowBoxes.y)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;     
     
  PVector btnGeneratePos = uiGrid.getPosition(0,13);
  cp5.addButton("gerar")
     .setPosition(btnGeneratePos.x,btnGeneratePos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(2)),round(uiGrid.getHeightFromBlocks(1)));
     
     
  // create palette
  color palette[] = new color[3];
  int alpha = 100;
  palette[0] = color(44, 62, 96, alpha);
  palette[1] = color(60, 3, 14, alpha);
  palette[2] = color(150, 5, 86, alpha);
  int x = round(uiGrid.getWidthFromBlocks(7));
  int y = round(uiGrid.getWidthFromBlocks(9));
  b = new Book("Carne\nEmpalada","Rodrigo Junqueira","assets/short-stories/carne-empalada-rodrigo-junqueira.txt",new PVector(x,y,10),palette);
  b.parseTxt();
  b.generate();  
  

  
}

void draw() {
  background(0,0,80,100);

  //String title = cp5.get(Textfield.class,"title").getText();
  //String[] titleTokens = split(title, ' ');
  //int halfTitle = ceil(titleTokens.length/2);
  //String fstTitleHalf = "";
  //String sndTitleHalf = "";
  //for (int i = 0; i < titleTokens.length; i++) {
  //  if (i < halfTitle) {
  //    fstTitleHalf += (fstTitleHalf.length() > 0 ? " " : "") + titleTokens[i];  
  //  } else {
  //    sndTitleHalf += (sndTitleHalf.length() > 0 ? " " : "") + titleTokens[i];
  //  }
  //}

  //b.cover.clearTextContent();
  //b.cover.addTextToContent(fstTitleHalf);
  //if (sndTitleHalf.length() > 0) b.cover.addTextToContent(sndTitleHalf);  
  //b.cover.addTextToContent(cp5.get(Textfield.class,"author").getText());
  
  b.setTitle(cp5.get(Textfield.class,"title").getText());
  b.setAuthor(cp5.get(Textfield.class,"author").getText());
  b.cover.generateContent();
  
  //b.cover.addTextToContent(cp5.get(Textfield.class,"texto4").getText());  

  PVector bookPosition = uiGrid.getPosition(0,2);
  push();
  translate(bookPosition.x,bookPosition.y);
  if (showBoxes) {
    b.cover.showBoxes();
  }
  b.show();
  pop();
  
  
  
  uiGrid.show();
  if (showGrid) image(ui,0,0);
  
  saveFrame("../../../_output/textoora/tipografia/#####.png");
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == ALT) {
      showGrid = !showGrid;
    }
  }  
}

void gerar() {
  b.generate();
}
  
void toggleShowBoxes(boolean theFlag) {
  showBoxes = theFlag;
}
