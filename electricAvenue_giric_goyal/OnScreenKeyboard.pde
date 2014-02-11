class OnScreenKeyboard {
  
  float xCordinate1, xCordinate2;
  float yCordinate1, yCordinate2;
  float keyboardWidth, keyboardHeight;
  int foreGroundColor, backGroundColor;
  
 void display(float X1, float X2, float Y1, float Y2, int bgColor, int fgColor) {
    
    xCordinate1 = X1;
    xCordinate2 = X2;
    yCordinate1 = Y1;
    yCordinate2 = Y2;
    keyboardWidth = X2 - X1;
    keyboardHeight = Y2 - Y1;      
    foreGroundColor = fgColor;
    backGroundColor = bgColor;
    
    stroke(foreGroundColor);
    noFill();
    rectMode(CORNERS);
    rect(xCordinate1, yCordinate1, xCordinate2, yCordinate2);
  }
}
