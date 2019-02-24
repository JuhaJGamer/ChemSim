
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
  viewPortTopX = 0;
  viewPortTopY = 0;
  viewPortWidth = width;
  viewPortHeight = height;
  cameraPosX = width/2;
  cameraPosY = height/2;
}

int displayMode = 0;
boolean paused = false;
boolean showNonBonding = false;

int cameraPosX = width/2;
int cameraPosY = height/2;
int lastCPosY = 0;
int lastCPosX = 0;
int lastMX = 0;
int lastMY = 0;
float cameraZoom = 1;
float mwheelMul = 0.2;

int viewPortTopX = 0;
int viewPortTopY = 0;
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

int particleCount = 2400;

void mouseWheel(MouseEvent event) {
   cameraZoom -= event.getCount() * mwheelMul;
   if(cameraZoom <= 1) cameraZoom = 1;
   rMul = rMulO * cameraZoom;
   viewPortWidth = (int)(width/cameraZoom);
   viewPortHeight = (int)(height/cameraZoom);
   viewPortTopX = cameraPosX - viewPortWidth/2;
   viewPortTopY = cameraPosY - viewPortHeight/2;
   println(cameraZoom);
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
      particleList.add(new Particle(new PVector(mouseX, mouseY), randVel(1), new Atom(shortcuts.get(key)), particleList.size()));
    /*
    int tmp = elemCounter;
     for (int i = 0; i < ATYPE.values().length; i++) {
     ATYPE atype = ATYPE.values()[i];
     if (atype.toString().toLowerCase().charAt(0) == key) {
     if (tmp <= 0) {
     particleList.add(new Particle(new PVector(mouseX, mouseY), randVel(1), new Atom(atype), particleList.size()));
     break;
     }
     tmp--;
     }
     }
     */
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
