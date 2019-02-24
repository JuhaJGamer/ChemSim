
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
}

int displayMode = 0;
boolean paused = false;
boolean showNonBonding = false;

int elemCounter = 0;

void makeMixture(ATYPE[] mix, int count) {
  particleList = new ArrayList<Particle>();
  for (int i = 0; i < count; i++) {
    particleList.add(new Particle(randPos(), randVel(10), 
      new Atom(mix[(int)random(0, mix.length)]), particleList.size()
      ));
  }
}

int particleCount = 300;

void keyPressed() {
  if (key == '1') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.H, ATYPE.H, ATYPE.O};
    makeMixture(tmp, particleCount);
  } else if (key == '2') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.C, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.H};
    makeMixture(tmp, particleCount);
  } else if (key == '3') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.N, ATYPE.H, ATYPE.H, ATYPE.H};
    makeMixture(tmp, particleCount);
  } else if (key == '4') {
    ATYPE[] tmp = new ATYPE[] {ATYPE.C, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.O, ATYPE.O, ATYPE.O};
    makeMixture(tmp, particleCount);
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
  } else if (key == '=') {
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
  } else if (key == '`') {
    paused = !paused;
  } else if (key == '/') {
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
  makeMixture(tmp, 0);
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
