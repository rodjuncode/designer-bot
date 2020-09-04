import controlP5.*;
import java.util.*;
import processing.pdf.*;

Book b;
Palette p;

String previousColorQuery = "";
String manuscriptPath = "";
boolean genTexture, genPalette, genText = true;

// ui
ControlP5 cp5;
PGraphics ui;
Grid uiGrid;
boolean debug = false;
int margin = 10;
PVector dspPalette;
int coverWidth,coverHeight;
PVector coverPosition;

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
  coverPosition = uiGrid.getPosition(0,2);  
  int btnSize = 19;
  int txtSize = 24;
  color lblColor = color(#457b9d);
  cp5 = new ControlP5(this);
  PVector txtText1Pos = uiGrid.getPosition(9,2);  
  cp5.addTextfield("title")
     .setCaptionLabel("Titulo")
     .setColorCaptionLabel(lblColor) 
     .setPosition(txtText1Pos.x,txtText1Pos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(5)),txtSize)
     .setFocus(true)     
     .setAutoClear(false)
     ;    
  PVector txtText2Pos = uiGrid.getPosition(9,3);  
  cp5.addTextfield("author")
     .setCaptionLabel("Autor")
     .setColorCaptionLabel(lblColor)     
     .setPosition(txtText2Pos.x,txtText2Pos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(5)),txtSize)
     .setAutoClear(false) 
     ;
  PVector txtText3Pos = uiGrid.getPosition(9,4);  
  cp5.addTextfield("palette")
     .setCaptionLabel("Paleta")
     .setColorCaptionLabel(lblColor)     
     .setPosition(txtText3Pos.x,txtText3Pos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(5)),txtSize)
     .setAutoClear(false) 
     ;  
  dspPalette = uiGrid.getPosition(0,12);     
  PVector tglDebug = uiGrid.getPosition(13,0);
  cp5.addToggle("toggleDebug")
     .setCaptionLabel("Debug")
     .setColorCaptionLabel(lblColor) 
     .setPosition(tglDebug.x,tglDebug.y)
     .setSize(round(uiGrid.getWidthFromBlocks(1)),txtSize)
     .setValue(false)
     .setMode(ControlP5.SWITCH)  
     ;     
  //PVector sldMargins = uiGrid.getPosition(9,5);    
  //cp5.addSlider("margin")
  //   .setCaptionLabel("Margens")
  //   .setColorCaptionLabel(lblColor) 
  //   .setPosition(sldMargins.x,sldMargins.y)
  //   .setSize(round(uiGrid.getWidthFromBlocks(2)),txtSize)
  //   .setRange(0,30)
  //   .setNumberOfTickMarks(4)
  //   .showTickMarks(false)
  //   .setValue(10)
  //   ;          
  //cp5.getController("margin").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  //cp5.getController("margin").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  PVector btnGeneratePos = uiGrid.getPosition(9,6);
  cp5.addButton("generate")
     .setCaptionLabel("Gerar")
     .setPosition(btnGeneratePos.x,btnGeneratePos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(2)),round(uiGrid.getHeightFromBlocks(1)))
     ;
  PVector btnCapturePos = uiGrid.getPosition(12,6);
  cp5.addButton("save")
     .setCaptionLabel("Salvar")
     .setPosition(btnCapturePos.x,btnCapturePos.y)
     .setSize(round(uiGrid.getWidthFromBlocks(2)),round(uiGrid.getHeightFromBlocks(1)))
     ;  
  coverWidth = round(uiGrid.getWidthFromBlocks(7));
  coverHeight = round(uiGrid.getWidthFromBlocks(9));
  String t = "Titulo do livro";
  String a = "Nome do autor";
  String q = "Digite algo para definir cores";
  cp5.get(Textfield.class,"title").setText(t);
  cp5.get(Textfield.class,"author").setText(a);
  cp5.get(Textfield.class,"palette").setText(q);
  //previousColorQuery = new String(q);
  //p = new Palette(q);
  //println("[TEXTOORA] Crawling...");  
  //p.crawl();
  //println("[TEXTOORA] Crawl OK.");  
  //p.analyze();
  //p.generatePalette();  
  //b = new Book(t,a,"assets/short-stories/carne-empalada-rodrigo-junqueira.txt",new PVector(coverWidth,coverHeight,10),p,margin);
  //b.parseTxt();
  //b.generate();    
  selectInput("Selecione o seu manuscrito:", "init");
}

void init(File selection) {
  if (selection == null) {
    println("Usuário não selecionou manuscrito. Por favor, inicialize novamente a aplicação.");
  } else {
    manuscriptPath = selection.getAbsolutePath();
    String q = cp5.get(Textfield.class,"palette").getText();
    previousColorQuery = new String(q);
    p = new Palette(q);
    println("[TEXTOORA] Crawling...");  
    p.crawl();
    println("[TEXTOORA] Crawl OK.");   
    p.analyze();
    p.generatePalette();
    b = new Book(cp5.get(Textfield.class,"title").getText(),cp5.get(Textfield.class,"author").getText(),manuscriptPath,new PVector(coverWidth,coverHeight,10),p,margin);
    b.parseTxt();
    b.generate();     
  }
}

void draw() {
  background(200);
  if (b != null && b.ready()) {
    b.setTitle(cp5.get(Textfield.class,"title").getText());
    b.setAuthor(cp5.get(Textfield.class,"author").getText());
    b.cover.setMargin(margin);
    push();
    translate(coverPosition.x,coverPosition.y);
    if (debug) {
      b.cover.showBoxes();
    }
    b.show();
    pop();
    p.showPalette(dspPalette.x,dspPalette.y,(int) uiGrid.getWidthFromBlocks(7),(int) uiGrid.getHeightFromBlocks(1));
    if (debug) {
      uiGrid.show();
      image(ui,0,0);
      p.showOptions();
    }
  }
}

void generate() {
  String q = new String(cp5.get(Textfield.class,"palette").getText());
  if (q.length() > 0) {
    if (!q.equals(previousColorQuery)) {
      println("Crawling...");
      p = new Palette(q);
      p.crawl();
      p.analyze();    
      b.setPalette(p);
      previousColorQuery = new String(q);
    }
  }
  p.generatePalette();  
  b.cover.generate();
}

void toggleDebug(boolean theFlag) {
  debug = theFlag;
  if (b != null && b.cover != null && !debug) {
    b.cover.generateContent();
  }
}
 //<>//
void save() {
  selectOutput("Selecione o destine do PDF:", "savePdf");
  //b.cover.print();
}

void savePdf(File selection) {
  if (selection == null) {
    println("Usuário não selecionou destino. Operação cancelada.");
  } else {
    b.cover.print(selection.getAbsolutePath());
  }
}

void mouseClicked() {
  // change texture
  if (mouseX > coverPosition.x && mouseX < coverPosition.x + coverWidth &&
      mouseY > coverPosition.y && mouseY < coverPosition.y + coverHeight) {
    println("refresh texture");
    b.cover.generate();
  // change palette
  } else if ( mouseX > dspPalette.x && mouseX < dspPalette.x + (int) uiGrid.getWidthFromBlocks(7) &&
              mouseY > dspPalette.y && mouseY < dspPalette.y + (int) uiGrid.getHeightFromBlocks(1)) {
    println("refresh palette");                
    p.generatePalette(); 
    b.cover.generateArt(b.cover.art);
    b.cover.updateArt();
  }
}
