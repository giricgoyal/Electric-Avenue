import java.awt.*;

public class Country {
  
  private String name;
  private boolean selected;
  private Color newColor;
  
  public Country(String name, Color newColor){
    this.name=name;
    this.newColor=newColor;
    selected=false;
  }
  
  public boolean isSelected(){
    return selected;
  }
  
  public void setSelected(){
    this.selected = true; 
  }
  
  public void setUnselected(){
     this.selected = false;
  }
  
  public String getName(){
     return name; 
  }
  
  public Color getColor(){
    return newColor;
  }
  
  
  
 
}
