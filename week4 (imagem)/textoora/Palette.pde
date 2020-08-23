class Palette {
  
  JSONArray options;
  String query;
  
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
      this.options = crawled.getJSONArray(this.query);
    }
  }
  
  int[] getSimplePalette() {
    color simple[] = new color[3];
    int alpha = 100;
    for (int i = 0; i < 3; i++) {
      String c = (String) this.options.get(i+2);
      String rgb[] = c.split(",");
      simple[i] = color(Integer.parseInt(rgb[0].trim()),Integer.parseInt(rgb[1].trim()),Integer.parseInt(rgb[2].trim()),alpha);
    }
    return simple;  
  }
  
  
}
