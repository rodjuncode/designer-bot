class Palette {
  
  ArrayList<PVector> options;
  String query;
  
  PVector avg;
  
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
        this.options.add(newColor);
      }
    }
  }
  
  void analyze() {
    
  }
  
  int[] getSimplePalette() {
    int _colors = 3;
    color simple[] = new color[_colors];
    int alpha = 100;
    for (int i = 0; i < _colors; i++) {
      simple[i] = this.getColorOption(i);
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
    pop();
  }
  
  color getColorOption(int i) {
    int alpha = 100;
    return color(this.options.get(i).x,this.options.get(i).y,this.options.get(i).z,alpha); 
  }
  
  
}
