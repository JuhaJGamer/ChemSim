
//Main abstact class so that I can sort everything into arraylists. Also has some of the common values built in
abstract class GUIWidget {
  protected int _color = 0x000000; //color as a 24-bit integer
  protected int alpha = (byte)0xFF; //alpha as an 8-bit integer
  protected PVector pos; //position vector (usually top left)
  
  protected void setColor(int _color) {
    if(_color >= pow(2,24) || _color < 0) { // Color over 24 bits
      throw new RuntimeException("Color MUST be a 24-bit positive integer: got " + _color); 
    }
    this._color = _color;
  }
  
  protected void setColor(int _color, int alpha) {
    if(_color >= pow(2,24) || _color < 0) { // Color over 24 bits
      throw new RuntimeException("Color MUST be a 24-bit positive integer: got" + _color); 
    }
    if(alpha >= pow(2,8) ||alpha < 0) { //Alpha over 8 bits
      throw new RuntimeException("Alpha MUST be an 8-bit positive integer: got " + alpha );
    }
    this._color = _color;
    this.alpha = alpha;
  }
  
  protected int getColor() {
    return _color;
  }
  
  protected int getAlpha() {
    return alpha; 
  }
  
  void show() { //Function for drawing, override this when making the widgets;
  
  }
  void interact(){ //Function for interaction and updating the widget. Override this too.
  
  }
}

//Panel for GUI decoration
class Panel extends GUIWidget { 
   private PVector size; //Size vector (w,h)
   
   public Panel (PVector pos,PVector size,int _color) { //Constructor with PVector, int
     setColor(_color);
     this.pos = pos;
     this.size = size;
   }
   
   public Panel (PVector pos, PVector size, int _color, int alpha) {
      this.pos = pos;
      this.size = size;
      setColor(_color, alpha);
   }
   
   public Panel (int x, int y, int w, int h,int _color) { //Constructor with PVector, int
     setColor(_color);
     this.pos = new PVector(x,y);
     this.size = new PVector(w,h);
   }
   
   public Panel (int x, int y, int w, int h, int _color, int alpha) {
      this.pos = new PVector(x,y);
      this.size = new PVector(w,h);
      setColor(_color, alpha);
   }
   
   public void show() {
     fill(_color, alpha);
     println("Fill:" + _color + "," + alpha);
     rect(pos.x, pos.y, size.x, size.y);
     println(pos.x + " " + pos.y + " " + size.x + " " + size.y + " ");
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

void initGUI() {
  guiWidgetList.add(new Panel(0,0,1000,1000,0xDDD,0xDD));
}

ArrayList<GUIWidget> guiWidgetList = new ArrayList<GUIWidget>();

void drawGUI() { //GUI drawing
  //println("guifunc");
  if(showGUI) {
   // println("printing gui");
   for(int i = 0; i < guiWidgetList.size(); i++) {
     guiWidgetList.get(i).show();
     //println("Running show() for element:" + i);
   }
  }
}

void GUIInteract() {
  //if() {}
}
