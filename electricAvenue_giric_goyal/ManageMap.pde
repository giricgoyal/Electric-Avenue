
public class ManageMap {


  private Float sizeMapWidth, sizeMapHeight;
  private int countryCount, widthProj, heightProj, colorIndex=0;
  private PShape worldMap, country;
  private Country countryObj;
  private ProcessTable countries;
  private ArrayList<Country> countryList;
  public ArrayList<Color> colorList;
  public ArrayList<Color> assignedColorList;


  private PApplet applet;
  private color countryColor;
  private String name;
  private Float sizeWind;
  private PApplet main;
  private Color color1= new Color(251, 128, 114);
  private Color color2= new Color(179, 222, 105);
  private Color color3= new Color(128, 177, 211);
  private Color color4= new Color(141, 211, 199);
  private Color color5= new Color(190, 186, 218);
  private Color color6= new Color(253, 180, 98);

  public ManageMap(Float sizeMapWidth, Float sizeMapHeight, ProcessTable data, ArrayList<Country> countryList, int widthProj, int heightProj, PApplet main) {
    this.countries = data;
    this.countryList = countryList;
    this.widthProj = widthProj;
    this.heightProj = heightProj;
    this.main = main;
    this.sizeMapWidth = sizeMapWidth;
    this.sizeMapHeight = sizeMapHeight;
    colorList = new ArrayList<Color>();
    assignedColorList = new ArrayList<Color>();
    initColorList();
  }


  public void setupMap() {
    worldMap = loadShape("worldmap.svg");

    worldMap.disableStyle();
    countryCount = countries.getRowCount();
  }

  public PShape getWorldMap() {
    return worldMap;
  }

  public void drawMap() {
    worldMap.scale(1/sizeMapWidth, 1/sizeMapHeight);
    //background(255);
    stroke(0);
    strokeWeight(1);
    shapeMode(CORNER);
    shape(worldMap, gwPlotX1, gwPlotY1);
    worldMap.scale(sizeMapWidth, sizeMapHeight);
    for (int row = 0; row < countryCount; row++) {
      name = countries.getRowName(row);
      country = worldMap.getChild(name.toLowerCase());
//      println(name);
//      println(country);

      if (isInCountryList(name)) {
        countryObj = countryList.get(findIndex(name));
        paintCountry(country, countryObj.getColor().getRed(), countryObj.getColor().getGreen(), countryObj.getColor().getBlue());
      }
      else {
        paintCountry(country, 240, 240, 240);
      }
      printCountryName(country, name);
    }
  }

  public void paintCountry(PShape country, int g, int b, int r) {
    if (country!=null) {
      country.scale(1/sizeMapWidth, 1/sizeMapHeight);
      fill(g, b, r);
      shapeMode(CORNER); 
      shape(country, gwPlotX1, gwPlotY1);
      country.scale(sizeMapWidth, sizeMapHeight);
      noFill();
    }
  }

  public void selectDeselect(PShape country) {
    //debug

    if (!isInCountryList(country.getName())) {
      if (countryList.size()>5) return;
      Color countryColor = assignColor();
      countryList.add(new Country(country.getName(), countryColor));
    }
    else {
      int index = findIndex(country.getName());
      Color c=countryList.get(index).getColor();
      assignedColorList.remove(c);
      countryList.remove(index);
    }
  }

  public void printCountryName(PShape country, String name) {
    if (country!=null) {
      if (isSelected(country)) {
        fill(0);
        countryName = name;
        text(name, requestX(), requestY());
      }
      fill(255);
    }
  }
  public boolean isSelected(PShape country) {
    if (country.contains(requestX()*sizeMapWidth-gwPlotX1*sizeMapWidth, requestY()*sizeMapHeight-gwPlotY1*sizeMapHeight))
      return true;
    else return false;
  }

  public boolean isSelectedOMC(PShape country) {
    println(requestTouchX());
    if (country.contains(requestTouchX()/sizeMapWidth-gwPlotX1*sizeMapWidth, requestTouchY()*sizeMapHeight-gwPlotY1*sizeMapHeight))
      return true;
    else return false;
  }

  public boolean isInCountryList(String name) {
    if (countryList.isEmpty()) return false;
    for (Country c: countryList) {
      if (c.getName().equals(name)) return true;
    }
    return false;
  }

  public int findIndex(String name) {
    for (int i=0;i<countryList.size();i++) {
      if (countryList.get(i).getName().equals(name))
        return i;
    }
    return 0;
  }

  public Color assignColor() {
    for (Color c: colorList) {
      if (!assignedColorList.contains(c))
      {
        assignedColorList.add(c);
        return c;
      }
    }
    return new Color(0, 0, 0);
  }

  public void initColorList() {
    colorList.add(color1);
    colorList.add(color2);
    colorList.add(color3);
    colorList.add(color4);
    colorList.add(color5);
    colorList.add(color6);
  }

  public void setSizeMap(float width, float height) {
    float floatHeight = (height);
    float floatWidth =  (width);
    sizeMapHeight = 622/floatHeight;
    sizeMapWidth = 950/floatWidth;
  }

  public float getSizeMap() {
    return sizeMapWidth;
  }
}

