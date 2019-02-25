
//base-2 logarithm for binary magnitude
float log2 (int x) {
  return (log(x) / log(2)); 
}

int getByte(int in, int _byte) {
  return (in >> _byte*2)%256;
}

//Main abstact class so that I can sort everything into arraylists. Also has some of the common values built in
abstract class GUIWidget {
  protected int _color = 0x000000FF; //color as a 32-bit integer
  protected PVector pos; //position vector (usually top left)
  
  protected setColor(int _color) {
    if(_color > pow(2,32)) { // Color over 32 bits
      throw new RuntimeException("Color MUST be either a 24- or a 32-bit integer"); 
    }
    byte tmp = getByte(_color,1); //store alpha
    _color = _color * pow(16,2); //move the thingy by two 
    _color += tmp;
  }
  
  protected getColor() {
    return _color;
  }
  
  protected getColor24() {
    return _color >> 256;
  }
  
  protected getAlpha() {
    return getByte(_color,1); 
  }
  
  void show(); //Function for drawing, override this when making the widgets;
  void interact(); //Function for interaction and updating the widget. Override this too.
}

//Panel for GUI decoration
class Panel extends GUIWidget { 
   private PVector size; //Size vector (w,h)
   
   public Panel (PVector pos,int _color) { //Constructor with PVector, int
     this._color = _color * (int)pow(10,8 - (int)log10(_color)); //Making sure order of magnitude is always 8
     this.pos = pos;
   }
   
   public Panel (PVector pos, int _color, int alpha = 255) {
     if(_color > pow(2,6)) {
       throw new RuntimeException("Color MUST be either a 24-bit integer or a 32-bit integer"); 
     }
      this._color = _color * (int)pow(10,6-(int)log10(_color)); //Magnitude always 6; 
   }
}

class Label extends GUIWidget {
   private String text;
   
   public Label(String text, PVector position) {
     this.text = text;
     this.pos = position;
   }
   
   public void setText(String text) {
     this.text = text; 
   }
   
   public String getText() {
      return text;
   }
   
   public void setPos(PVector position) {
      this.pos = position; 
   }
   
   public PVector getPos() {
      return pos; 
   }
}

void drawGUI() { //GUI drawing
  //println("guifunc");
  if(showGUI) {
   // println("printing gui");
    fill(0xDD,0xDD);
    rect(0,0,width/4,height/3,4);
    fill(0x00,0xE6);
    textSize(22);
    textAlign(LEFT, CENTER);
    text("FPS:" + (int)frameRate,1,15);
    text("Max Elements:" + particleCount,1,52);
    stroke(0xAF,0xE6);
    strokeWeight(15);
    line(15,84,width/4-15,84);
    fill(0xEE,0xE6);
    noStroke();
    rect(width/6/350*eSlider,69,30,30);
    textAlign(CENTER, CENTER);
  }
}

void GUIInteract() {
  if() 
}
