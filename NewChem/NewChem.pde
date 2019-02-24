
ArrayList<Particle> particleList;

int tickCount = 1;

void init() {
  initAtypes();
  initColors();
  initRadii();
  initMasses();
  initNonBondCs();
  initNonBondStrs();
  initBondEnergies();
  initShortcuts();
  viewPortTopLeft = new PVector(0,0);
  viewPortWidth = width;
  viewPortHeight = height;
  cameraPos = new PVector(width/2,height/2);
  lastCPos = cameraPos;
}

int displayMode = 0;
boolean paused = false;
boolean showNonBonding = false;

PVector cameraPos;
PVector lastCPos;
int lastMX = 0;
int lastMY = 0;
float cameraZoom = 1;
float mwheelMul = 0.2;

PVector viewPortTopLeft;
int viewPortWidth = width;
int viewPortHeight = height;

int elemCounter = 0;

class recipecomponent {
   public ATYPE atom;
   public int weight;

   public recipecomponent(ATYPE atom, int weight) {
      this.atom = atom;
      this.weight = weight;
   }
}

void makeMixture(recipecomponent[] mix_c, int count) {
  particleList = new ArrayList<Particle>();
  ArrayList<ATYPE> mix = new ArrayList<ATYPE>();
  for(int i = 0; i < mix_c.length; i++) {
    for(int j = 0; j < mix_c[i].weight; j++) {
      mix.add(mix_c[i].atom);
    }
  }
  for (int i = 0; i < count; i++) {
    particleList.add(new Particle(randPos(), randVel(10),
      new Atom(mix.get((int)random(0, mix.size()))), particleList.size()
      ));
  }
}

void makeMixtureOld(ATYPE[] mix, int count) {
  particleList = new ArrayList<Particle>();
  for (int i = 0; i < count; i++) {
    particleList.add(new Particle(randPos(), randVel(10),
      new Atom(mix[(int)random(0, mix.length)]), particleList.size()
      ));
  }
}

//Converts a position on screen (usually mouse pos) into the exact position in the world. Used for user interaction
PVector screenToAbsoluteVector(PVector in)
{
  return in.div(cameraZoom).add(viewPortTopLeft);
}

//Wrapper for earlier to get mouse pos in world
PVector getMousePos() {
  return screenToAbsoluteVector(new PVector(mouseX,mouseY));
}

int particleCount = 800;

void mouseWheel(MouseEvent event) {
   cameraZoom -= event.getCount() * mwheelMul;
   if(cameraZoom <= 1) cameraZoom = 1;
   rMul = cameraZoom;
   viewPortWidth = (int)(width/cameraZoom);
   viewPortHeight = (int)(height/cameraZoom);
   viewPortTopLeft.x = cameraPos.x - viewPortWidth/2;
   viewPortTopLeft.y = cameraPos.y - viewPortHeight/2;
}

void keyPressed() {
  if (key == '1') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.H, ATYPE.H, ATYPE.O};
    makeMixtureOld(tmp, particleCount);
  } else if (key == '2') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.C, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.H};
    makeMixtureOld(tmp, particleCount);
  } else if (key == '3') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.N, ATYPE.H, ATYPE.H, ATYPE.H};
    makeMixtureOld(tmp, particleCount);
  } else if (key == '4') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.C, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.O, ATYPE.O, ATYPE.O};
    makeMixtureOld(tmp, particleCount);
  } else if (key == '5') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.C, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.O, ATYPE.O, ATYPE.N, ATYPE.N, ATYPE.N, ATYPE.Na, ATYPE.Cl, ATYPE.Br};
    makeMixtureOld(tmp, particleCount);
  } else if (key == '6') {
    recipecomponent[] tmp = new recipecomponent[] { new recipecomponent (ATYPE.Br,1), new recipecomponent(ATYPE.Na,2), new recipecomponent(ATYPE.Cl,4),new recipecomponent(ATYPE.N,20),new recipecomponent(ATYPE.O,50),new recipecomponent(ATYPE.O,100), new recipecomponent(ATYPE.C, 90),new recipecomponent(ATYPE.H, 200)};
    makeMixture(tmp, particleCount);
  } else if (key == '7') { //rough estimation of early atmosphere (what I can do)
    recipecomponent[] tmp = new recipecomponent[]{
      new recipecomponent(ATYPE.C, 200),
      new recipecomponent(ATYPE.O, 250),
      new recipecomponent(ATYPE.H, 300),
      new recipecomponent(ATYPE.N, 100),
      new recipecomponent(ATYPE.S, 50),
      new recipecomponent(ATYPE.Na,40),
      new recipecomponent(ATYPE.Cl,40),
      new recipecomponent(ATYPE.Br,10)
    };
    makeMixture(tmp,particleCount);
  } else if (key == '0') {
    elemCounter++;
    if (elemCounter > 1)
      elemCounter = 0;
  } else if (key == '9') {
    elemCounter--;
    if (elemCounter < 0)
      elemCounter = 0;
  } else if (key == '.') {
    tickCount++;
    if (tickCount > 100)
      tickCount = 100;
  } else if (key == ',') {
    tickCount--;
    if (tickCount < 1)
      tickCount = 1;
  } else if (key == '+') {
    temp++;
    if (temp > 15)
      temp = 15;
  } else if (key == '-') {
    temp--;
    if (temp < -10)
      temp = -10;
  } else if (key == ' ') {
    displayMode++;
    if (displayMode > 3)
      displayMode = 0;
  } else if (key == 'ä') {
    paused = !paused;
  } else if (key == 'å') {
    showNonBonding = !showNonBonding;
  } else {
    if (shortcuts.containsKey(key))
      particleList.add(new Particle(new PVector(mouseX / cameraZoom + viewPortTopX, mouseY / cameraZoom + viewPortTopY), randVel(1), new Atom(shortcuts.get(key)), particleList.size()));
  }
}

void setup() {
  //fullScreen();
  size(1500, 1000);
  textAlign(CENTER, CENTER);
  strokeCap(SQUARE);
  init();
  ATYPE[] tmp = new ATYPE[] {ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.O};
  makeMixtureOld(tmp, 0);
}

void draw() {
  Particle[] particles = particleList.toArray(new Particle[particleList.size()]);
  if (!paused)
    for (int i = 0; i < tickCount; i++)
      physUpdateParticles(particles);
  showParticles(particles, displayMode);
  //println(frameRate);
  //println(elemCounter);
}
