import controlP5.*;
import java.util.*;

Book b;
Palette p;

// ui
ControlP5 cp5;
PGraphics ui;
Grid uiGrid;
boolean debug = false;
int margin;

void setup() {
  
  // 1. ui 
  size(700,700);
  //colorMode(HSB,360,100,100,100);
  colorMode(RGB,255,255,255,100);  
  // 1.1 grid
  ui = createGraphics(width,height);
  uiGrid = new Grid(ui,14,14,new float[]{50.0});
  // 1.2 controls
  //PFont uiFont = createFont("assets/fonts/BebasNeue-Regular.ttf",10);
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
  PVector txtText3Pos = uiGrid.getPosition(8,4);  
  cp5.addTextfield("palette")
     .setCaptionLabel("Paleta")
     .setColorCaptionLabel(lblColor)     
     .setPosition(txtText3Pos.x,txtText3Pos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(6)),txtSize)
     .setAutoClear(false);     
  PVector tglDebug = uiGrid.getPosition(13,0);
  cp5.addToggle("toggleDebug")
     .setCaptionLabel("Debug")
     .setColorCaptionLabel(lblColor) 
     .setPosition(tglDebug.x,tglDebug.y)
     .setSize(round(uiGrid.getWidthFromBlocks(1)),txtSize)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;     
  PVector sldMargins = uiGrid.getPosition(8,5);    
  cp5.addSlider("margin")
     .setCaptionLabel("Margens")
     .setColorCaptionLabel(lblColor) 
     .setPosition(sldMargins.x,sldMargins.y)
     .setSize(round(uiGrid.getWidthFromBlocks(2)),txtSize)
     .setRange(0,30)
     .setNumberOfTickMarks(4)
     .showTickMarks(false)
     .setValue(10);
  cp5.getController("margin").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("margin").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  //PVector sldProportion = uiGrid.getPosition(8,9);
  //List p = Arrays.asList("1:1.8","1:1.6", "1:1.4", "1:1.3", "1:1");
  //cp5.addScrollableList("proportion")
  //   .setCaptionLabel("Proporcao")
  //   .setPosition(sldProportion.x,sldProportion.y)
  //   .setSize(round(uiGrid.getWidthFromBlocks(2)),txtSize*p.size())
  //   .setBarHeight(txtSize)
  //   .setItemHeight(txtSize)
  //   .addItems(p)
  //   .setType(ScrollableList.DROPDOWN)
  //   .setOpen(false);     
  PVector btnGeneratePos = uiGrid.getPosition(8,10);
  cp5.addButton("generate")
     .setCaptionLabel("Gerar")
     .setPosition(btnGeneratePos.x,btnGeneratePos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(2)),round(uiGrid.getHeightFromBlocks(1)));
     
  // create palette
  color palette[] = new color[3];
  int alpha = 100;
  palette[0] = color(244, 204, 93, alpha);
  palette[1] = color(35, 35, 34, alpha);
  palette[2] = color(208, 219, 213, alpha);
  int x = round(uiGrid.getWidthFromBlocks(7));
  int y = round(uiGrid.getWidthFromBlocks(9));
  String t = "NEUROMANCER";
  String a = "WILLIAN GIBSON";
  String q = "cyberpunk";
  cp5.get(Textfield.class,"title").setText(t);
  cp5.get(Textfield.class,"author").setText(a);
  cp5.get(Textfield.class,"palette").setText(q);
  p = new Palette(q);
  p.crawl();
  p.analyze();
  b = new Book(t,a,"assets/short-stories/carne-empalada-rodrigo-junqueira.txt",new PVector(x,y,10),p,margin);
  b.parseTxt();
  b.generate();

  
  
}

void draw() {
  background(200);
  
  b.setTitle(cp5.get(Textfield.class,"title").getText());
  b.setAuthor(cp5.get(Textfield.class,"author").getText());
  b.cover.setMargin(margin);

  PVector bookPosition = uiGrid.getPosition(0,2);
  push();
  translate(bookPosition.x,bookPosition.y);
  if (debug) {
    b.cover.showBoxes();
  }
  b.show();
  pop();
  
  if (debug) {
    uiGrid.show();
    image(ui,0,0);
    p.showOptions();
  }
}


void generate() {
  String q = cp5.get(Textfield.class,"palette").getText();
  if (q.length() > 0) {
    p = new Palette(q);
    p.crawl();
    p.analyze();
    b.setPalette(p);
  }
  b.generate();
}
  
void toggleDebug(boolean theFlag) {
  debug = theFlag;
  if (b != null && b.cover != null && !debug) {
    b.cover.generateContent();
  }
}

void keyPressed() {
  if (key == 'c') {
    saveFrame("../../../_output/textoora/typography/####.png");  
  }
}
