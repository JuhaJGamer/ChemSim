//Mouse interaction constants
final int ui_DRAG = 0;
final int ui_MOVE = 1;
final int ui_PRESS = 2;
final int ui_RELEASE = 3;



//Main abstact class so that I can sort everything into arraylists. Also has some of the common values built in
abstract class GUIWidget {
  protected int _color = 0x000000; //color as a 24-bit integer
  protected int alpha = 255; //alpha as an 8-bit integer
  protected PVector pos; //position vector (usually top left)
  
  protected void setColor(int _color) {
    /*if(_color >= pow(2,24) || _color < 0) { // Color over 24 bits
      throw new RuntimeException("Color MUST be a 24-bit positive integer: got " + _color); 
    }*/
    this._color = _color;
  }
  
  protected void setColor(int _color, int alpha) {
    /*if(_color >= pow(2,24) || _color < 0) { // Color over 24 bits
      throw new RuntimeException("Color MUST be a 24-bit positive integer: got" + _color); 
    }*/
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
  void mouseInteract(int action){ //Function for interaction and updating the widget. Override this too.
  
  }
  void keyInteract() { //Ditto
    
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
     rect(pos.x, pos.y, size.x, size.y);
   }
}

class Label extends GUIWidget {
   private String text;
   int align = LEFT;
   int textSize = 22;
   
   public Label(int textSize, String text, PVector position, int _color) {
     this.text = text;
     this.pos = position;
     this.textSize = textSize;
     setColor(_color);
   }
   
   public Label(int textSize, String text, PVector position, int _color, int alpha) {
     this.text = text;
     this.pos = position;
     this.textSize = textSize;
     setColor(_color,alpha);
   }
   
   public Label(int textSize,String text, int x, int y, int _color, int alpha) {
     this.text = text;
     this.pos = new PVector(x,y);
     this.textSize = textSize;
     setColor(_color,alpha);
   }
   
   public Label(int textSize, String text, int x, int y, int _color) {
     this.text = text;
     this.pos = new PVector(x,y);
     this.textSize = textSize;
     setColor(_color);
   }
   
   public Label setText(String text) {
     this.text = text; 
     return this;
   }
   
   public String getText() {
      return text;
   }
   
   public Label setPos(PVector position) {
      this.pos = position; 
      return this;
   }
   
   public PVector getPos() {
      return pos;
   }
   
   public Label setAlign(int align) {
     this.align = align;  
     return this;
   }
   
   public void show() {
     fill(_color,alpha);
     textSize(textSize);
     textAlign(align);
     text(text,pos.x,pos.y+textSize);
   }
}

class Slider extends GUIWidget {
  private int rangeMax = 100;
  private int rangeMin = 0;
  private int value = 0;
  private int slideColor = 0;
  private int slideAlpha = 0;
  private int _length = 100;
  private int stroke = 15;
  private boolean dragged = false;
  private int lastMouse = 0;
  private int oldSlider = 0;
  
  public Slider(PVector pos,int _length,int stroke, int _color, int alpha, int slideColor, int slideAlpha) {
    this.pos = pos;
    this._length = _length;
    this.stroke = stroke;
    this._color = _color;
    this.alpha = alpha;
    this.slideColor = slideColor;
    this.slideAlpha = slideAlpha;
  }
  
  public Slider(int x, int y,int _length,int stroke, int _color, int alpha, int slideColor, int slideAlpha) {
    this(new PVector(x,y),_length,stroke,_color,alpha,slideColor,slideAlpha);
  }
  
  public void setSlidePos(int value) {
    if(value > rangeMax || value < rangeMin) {
      throw new RuntimeException("Value must be in slider range"); 
    }
    this.value = value;
  }
  
  void show() {
    strokeWeight(stroke);
    stroke(_color,alpha);
    line(pos.x,pos.y,_length,pos.y);
    noStroke();
    fill(slideColor,slideAlpha);
    rect(pos.x+(_length/rangeMax)*value-15,pos.y-15,30,30);
  }
  
  void mouseInteract(int action) {
    if(action == ui_PRESS) {
      if(mouseX > pos.x+(rangeMax/_length)*value-15 && mouseX < pos.x+(rangeMax/_length)*value+15
      && mouseY > pos.y-15 && mouseY < pos.y+15) {
        dragged = true;
        println("sliderClick");
        oldSlider = (int)pos.x+(rangeMax/_length)*value;
        lastMouse = mouseX;
      }
    } else if(action == ui_DRAG && dragged) {
      value = (int)((float)(mouseX-lastMouse)*((float)rangeMax/(float)_length));
      println(value);
      if(value > rangeMax) value = rangeMax;
      if(value < rangeMin) value = rangeMin;
    }
  }
}

void initGUI() {
  guiWidgetList.add(new Panel(0,0,width/4,height/2,#DDDDDD,0xDD));
  guiWidgetList.add(new Label(22,"FPS: 0",15,15,0));
  guiWidgetList.add(new Label(22,"Maximum particles: 0",15,52,0));
  guiWidgetList.add(new Slider(30,104,width/4-30,15,#AFAFAF,127,#FFFFFF,0xCD));
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

void GUIMouse(int action) {
  for(int i = 0; i < guiWidgetList.size(); i++) {
     guiWidgetList.get(i).mouseInteract(action);
     //println("Running show() for element:" + i);
   }
}

void GUIupdate() {
  if(showGUI) {
    ((Label)guiWidgetList.get(1) ).setText("FPS: " + (int)frameRate);
    ((Label)guiWidgetList.get(2) ).setText("Maximum particles: " + particleCount);
  }
}
