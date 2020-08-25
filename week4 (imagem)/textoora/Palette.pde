class Palette {
  
  ArrayList<PVector> options;
  String query;
  
  PVector avg;
  PVector contrast;
  
  int alpha = 100;
  
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
    this.avg = new PVector(round(r/s),round(g/s),round(b/s));
    
    this.contrast = new PVector(this.avg.x,this.avg.y,this.avg.z);
    float distance = 0;
    for (int i = 0; i < s; i++) {
      float d = this.options.get(i).dist(this.avg);
      if (d > distance) {
        distance = d;
        this.contrast = new PVector(this.options.get(i).x,this.options.get(i).y,this.options.get(i).z);
      }
    }
    
  }
  
  int[] getSimplePalette() {
    int _colors = 3;
    color simple[] = new color[_colors];
    int alpha = 100;
    for (int i = 0; i < _colors; i++) {
      simple[i] = this.getColorOption(floor(random(this.options.size())));
    }
    return simple;  
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
  
  color getColorAvg() {
    return color(this.avg.x,this.avg.y,this.avg.z,alpha); 
  }

  color getColorContrast() {
    return color(this.contrast.x,this.contrast.y,this.contrast.z,alpha); 
  }  
  
  color getColorOption(int i) {
    return color(this.options.get(i).x,this.options.get(i).y,this.options.get(i).z,alpha); 
  }
  
  boolean isWhite(PVector c) {
    int w = 200;
    return (c.x > w && c.y > w && c.z > w);  
  }
  
  boolean isBlack(PVector c) {
    int b = 50;
    return (c.x < b && c.y < b && c.z < b);  
  }  
  
  boolean isColorful(PVector c) {
    return !this.isBlack(c) && !this.isWhite(c);  
  }
  
  
}
