  class Palette {
  
  ArrayList<PVector> options;
  String query;
  
  PVector avg;
  PVector contrast;
  
  ArrayList<PVector> artPalette;
  ArrayList<PVector> txtPalette;

  int artColors = 3;
  int txtColors = 2;
  
  int alpha = 100;
  
  final double ART_CONTRAST = 1.2;
  final double AUTHOR_CONTRAST = 1.5;
  final double TITLE_CONTRAST = 1.8;

  Palette(String query) {
    this.query = query;
  }
  
  void crawl() {
    if (this.query != null && this.query.length() > 0) {
      Process p = exec("python",sketchPath("")+"/goo.py",this.query);
      try {
        p.waitFor();
      } catch (InterruptedException e) { }
      JSONObject crawled = loadJSONObject("palette.json");
      JSONArray o = crawled.getJSONArray(this.query);
      this.options = new ArrayList<PVector>();
      for (int i = 2; i < o.size(); i++) {
        String c = (String) o.get(i);
        String rgb[] = c.split(",");
        PVector newColor = new PVector(Integer.parseInt(rgb[0].trim()),Integer.parseInt(rgb[1].trim()),Integer.parseInt(rgb[2].trim()));
        if (this.isColorful(newColor)) this.options.add(newColor);
      }
    }
  }
  
  void analyze() {
    int r = 0;
    int g = 0;
    int b = 0;
    int s = this.options.size();
    for (int i = 0; i < s; i++) {
      r += round(this.options.get(i).x);
      g += round(this.options.get(i).y);
      b += round(this.options.get(i).z);      
    }
    
    // 'average' color
    this.avg = new PVector(round(r/s),round(g/s),round(b/s));
    
    // 'contrast' color is the most distant from 'average' color
    this.contrast = new PVector(this.avg.x,this.avg.y,this.avg.z);
    float distance = 0;
    for (int i = 0; i < s; i++) {
      float d = this.options.get(i).dist(this.avg);
      if (d > distance) {
        distance = d;
        this.contrast = new PVector(this.options.get(i).x,this.options.get(i).y,this.options.get(i).z);
      }
    }
    this.options.remove(contrast);
    
  }
  
  boolean isValidTitleColor(PVector candidate) {
    for (int i = 0; i < this.artPalette.size(); i++) {
      if (this.contrast(candidate,this.artPalette.get(i)) < TITLE_CONTRAST) {
        return false;
      }
    }
    return true;  
  }
  
  boolean isValidAuthorColor(PVector candidate) {
    for (int i = 0; i < this.artPalette.size(); i++) {
      if (this.contrast(candidate,this.artPalette.get(i)) < AUTHOR_CONTRAST) {
        return false;
      }
    }
    return true;  
  }
  
  boolean isValidArtColor(PVector candidate) {
    for (int i = 0; i < this.artPalette.size(); i++) {
      if (this.contrast(candidate,this.artPalette.get(i)) < ART_CONTRAST) {
        return false;  
      }
    }
    return true;  
  }  
  
  double contrast(PVector c1, PVector c2) {
    color rgb1 = color(c1.x,c1.y,c1.z);
    color rgb2 = color(c2.x,c2.y,c2.z);
    double lum1 = this.luminance(c1);
    double lum2 = this.luminance(c2);    
    double l1 = Math.max(lum1,lum2);
    double l2 = Math.min(lum1,lum2);
    double c = (l1 + 0.05) / (l2 + 0.05);
    return c;
  }
  
  double luminance(PVector c) {
    double r = this.channelForLuminance(c.x/255);
    double g = this.channelForLuminance(c.y/255);
    double b = this.channelForLuminance(c.z/255);
    double l = 0.2126*r + 0.7152*g + 0.0722*b;
    return l;
  }
  
  double channelForLuminance(double v) {
    if (v <= 0.03928) {
      return v/12.92;  
    } else {
      return Math.pow((v+0.055)/1.055,2.4);
    }
  }
  
  void generatePalette() {
    this.artPalette = new ArrayList<PVector>();
    this.txtPalette = new ArrayList<PVector>();
    // generate art colors
    for (int i = 0; i < this.artColors; i++) {
      PVector candidate = this.getRandomOption();      
      while (!this.isValidArtColor(candidate)) {
        candidate = this.getRandomOption();
      }      
      this.artPalette.add(candidate);
    }
    // generate text colors
    PVector white = new PVector(255,255,255);
    PVector black = new PVector(50,50,50);
    if (this.isValidTitleColor(white)) {
      this.txtPalette.add(white);      
    } else if (this.isValidTitleColor(black)) {
      this.txtPalette.add(black);
    } else if (this.isValidTitleColor(this.contrast)){
      this.txtPalette.add(this.contrast);
    } else {
      PVector candidate = this.getRandomOption();
      while (!this.isValidAuthorColor(candidate)) {
        candidate = this.getRandomOption();  
      }
      this.txtPalette.add(candidate);
    }
    if (this.isValidAuthorColor(this.contrast)) {
      this.txtPalette.add(this.contrast);  
    } else {
      PVector candidate = this.getRandomOption();
      while (!this.isValidAuthorColor(candidate)) {
        candidate = this.getRandomOption();  
      }
      this.txtPalette.add(candidate);      
    }
    
  }

  
  int[] getSimplePalette() {
    int _colors = 3;
    color simple[] = new color[_colors];
    int alpha = 100;
    for (int i = 0; i < _colors; i++) {
      simple[i] = this.getRandomColorOption();
    }
    return simple;  
  }
  
  int[] getArtPalette() {
    int _colors = this.artPalette.size();
    color simple[] = new color[_colors];
    for (int i = 0; i < _colors; i++) {
      simple[i] = this.getArtColor(i);
    }
    return simple;  
  }  
  
  PVector getRandomOption() {
    return this.options.get(floor(random(this.options.size())));
  }
  
  color getRandomColorOption() {
    return this.getColorOption(floor(random(this.options.size())));
  }
  
  color getArtColor(int i) {
    return color(this.artPalette.get(i).x,this.artPalette.get(i).y,this.artPalette.get(i).z,alpha); 
  }
  
  color getTxtColor(int i) {
    return color(this.txtPalette.get(i).x,this.txtPalette.get(i).y,this.txtPalette.get(i).z,alpha); 
  }
  
  void showOptions() {
    push();
    noStroke();
    int _colorGridRowSize = 40;
    int _colorGridColorSize = 10;
    for (int i = 0; i < this.options.size(); i++) {
      fill(this.getColorOption(i));
      rect((i % _colorGridRowSize)*_colorGridColorSize,floor(i/_colorGridRowSize)*_colorGridColorSize,_colorGridColorSize,_colorGridColorSize);  
    }
    fill(this.getColorAvg());
    rect(_colorGridRowSize*_colorGridColorSize,0,_colorGridColorSize*2,_colorGridColorSize*2);
    fill(this.getColorContrast());
    rect(_colorGridRowSize*_colorGridColorSize+_colorGridColorSize*2,0,_colorGridColorSize*2,_colorGridColorSize*2);
    
    pop();
  }
  
  void showArtPalette() {
    push();
    noStroke();
    int _colorGridRowSize = 40;
    int _colorGridColorSize = 10;
    for (int i = 0; i < this.artPalette.size(); i++) {
      fill(this.getArtColor(i));
      rect((i % _colorGridRowSize)*_colorGridColorSize,floor(i/_colorGridRowSize)*_colorGridColorSize+50,_colorGridColorSize,_colorGridColorSize);  
    }
    pop();
  }  
  
  void showTxtPalette() {
    push();
    noStroke();
    int _colorGridRowSize = 40;
    int _colorGridColorSize = 10;
    for (int i = 0; i < this.txtPalette.size(); i++) {
      fill(this.getTxtColor(i));
      rect((i % _colorGridRowSize)*_colorGridColorSize,floor(i/_colorGridRowSize)*_colorGridColorSize+60,_colorGridColorSize,_colorGridColorSize);  
    }
    pop();
  }   
  
  color getColorAvg() {
    return color(this.avg.x,this.avg.y,this.avg.z,alpha); 
  }

  color getColorContrast() {
    return color(this.contrast.x,this.contrast.y,this.contrast.z,alpha); 
  }  
  
  color getColorOption(int i) {
    return color(this.options.get(i).x,this.options.get(i).y,this.options.get(i).z,alpha); 
  }
  
  boolean isWhite(PVector c) { // TODO: improve this
    int w = 200;
    return (c.x > w && c.y > w && c.z > w);  
  }
  
  boolean isBlack(PVector c) { // TODO: improve this
    int b = 50;
    return (c.x < b && c.y < b && c.z < b);  
  }  
  
  boolean isColorful(PVector c) { // TODO: improve this
    return !this.isBlack(c) && !this.isWhite(c);  
  }
  
  color getColor(PVector c) {
    return color(c.x,c.y,c.z,alpha);  
  }
  
  void showPalette(float x, float y, int w, int h) {
    ArrayList<PVector> fullPalette = new ArrayList<PVector>();
    fullPalette.addAll(this.artPalette);
    fullPalette.addAll(this.txtPalette);
    float colorSpace = w/(fullPalette.size());
    push();
    translate(x,y);
    noStroke();
    for (int i = 0; i < fullPalette.size(); i++) {
      fill(this.getColor(fullPalette.get(i)));
      rect(i*colorSpace,0,colorSpace,h);  
    }
    pop();      
  }

  
}
