import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class NewChem extends PApplet {


ArrayList<Particle> particleList;

int tickCount = 1;

public void init() {
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
float mwheelMul = 0.2f;

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

public void makeMixture(recipecomponent[] mix_c, int count) {
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

public void makeMixtureOld(ATYPE[] mix, int count) {
  particleList = new ArrayList<Particle>();
  for (int i = 0; i < count; i++) {
    particleList.add(new Particle(randPos(), randVel(10),
      new Atom(mix[(int)random(0, mix.length)]), particleList.size()
      ));
  }
}

int particleCount = 800;

public void mouseWheel(MouseEvent event) {
   cameraZoom -= event.getCount() * mwheelMul;
   if(cameraZoom <= 1) cameraZoom = 1;
   rMul = cameraZoom;
   viewPortWidth = (int)(width/cameraZoom);
   viewPortHeight = (int)(height/cameraZoom);
   viewPortTopX = cameraPosX - viewPortWidth/2;
   viewPortTopY = cameraPosY - viewPortHeight/2;
}

public void keyPressed() {
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

public void setup() {
  //fullScreen();
  
  textAlign(CENTER, CENTER);
  strokeCap(SQUARE);
  init();
  ATYPE[] tmp = new ATYPE[] {ATYPE.H, ATYPE.H, ATYPE.H, ATYPE.O};
  makeMixtureOld(tmp, 0);
}

public void draw() {
  Particle[] particles = particleList.toArray(new Particle[particleList.size()]);
  if (!paused)
    for (int i = 0; i < tickCount; i++)
      physUpdateParticles(particles);
  showParticles(particles, displayMode);
  //println(frameRate);
  //println(elemCounter);
}

enum BTYPE {
  COVALENT, IONIC, METALLIC
};

enum ATYPE {
  H, O, C, N, Na, Cl, Br, S
}

public float getBondEnergy(ATYPE a, ATYPE b, int n) {
  String[] keyarr;
  String e1 = a.toString();
  String e2 = b.toString();
  for (String key : bondEnergies.keySet()) {
    keyarr = key.split(" ");
    if (((keyarr[0].equals(e1) && keyarr[2].equals(e2)) || (keyarr[0].equals(e2) && keyarr[2].equals(e1))) && keyarr[1].length() == n) {
      return bondEnergies.get(key);
    }
  }
  return 0;
}

class Bond {
  Particle a, b;
  int n;
  float cA, cB, eA, eB;
  float bondEnergy;
  BTYPE btype;

  boolean nonBond = false;

  Bond(Particle _a, Particle _b) {
    a = _a;
    b = _b;
    n = 2;
    nonBond = true;
  }

  Bond(Particle _a, Particle _b, int _n, BTYPE _btype) {
    a = _a;
    b = _b;
    n = _n;
    btype = _btype;
    refresh();
  }

  Bond(Particle _a, Particle _b, int _n) {
    if (_a.atom.e < _a.atom.dE && _b.atom.e < _b.atom.dE) {
      a = _a;
      b = _b;
      btype = BTYPE.COVALENT;
    } else if (_a.atom.e < _a.atom.dE) {
      a = _a;
      b = _b;
      btype = BTYPE.IONIC;
    } else if (_b.atom.e < _b.atom.dE) {
      a = _b;
      b = _a;
      btype = BTYPE.IONIC;
    } else {
      a = _a;
      b = _b;
      btype = BTYPE.METALLIC;
    }
    n = _n;
    refresh();
  }

  public void refresh() {
    Atom aA = a.atom, aB = b.atom;
    cA = -n * (2 * aA.eN / (aA.eN + aB.eN) - 1);
    cB = -n * (2 * aB.eN / (aA.eN + aB.eN) - 1);
    if (btype == BTYPE.IONIC) {
      eA = 1;
      eB = -1;
    } else if (btype == BTYPE.COVALENT) {
      eA = 1;
      eB = 1;
    } else if (btype == BTYPE.METALLIC) {
      eA = -1;
      eB = -1;
    }
    eA *= n;
    eB *= n;
    bondEnergy = getBondEnergy(aA.atype, aB.atype, n);
  }

  public void makeBonds(int count) {
    n += count;
    refresh();
  }

  public void breakBonds(int count) {
    if (btype == BTYPE.IONIC) {
      if (a.atom.eN < b.atom.eN) {
        a.atom.e -= count;
        b.atom.e += count;
      }
    }
    n -= count;
    refresh();
  }

  public float getE(int id) {
    if (a.id == id)
      return eA;
    return eB;
  }

  public float getC(int id) {
    if (a.id == id)
      return cA;
    return cB;
  }

  public Particle getOther(int id) {
    if (a.id == id)
      return b;
    return a;
  }
}

class Atom {
  float e, dE, eN;
  ATYPE atype;

  Atom(ATYPE _atype) {
    e = atypes.get(_atype)[0];
    dE = atypes.get(_atype)[1];
    eN = atypes.get(_atype)[2];
    atype = _atype;
  }

  /*
  Atom(float _e, float _dE, float _eN, ATYPE _atype) {
   e = _e;
   dE = _dE;
   eN = _eN;
   atype = _atype;
   }
   */

  public float getE(ArrayList<Bond> bonds, int id) {
    float bondEs = 0;
    for (int i = 0; i < bonds.size(); i++) {
      bondEs += bonds.get(i).getE(id);
    }
    return e + bondEs;
  }

  public float getC(ArrayList<Bond> bonds, int id) {
    float bondCs = 0;
    for (int i = 0; i < bonds.size(); i++) {
      bondCs += bonds.get(i).getC(id);
    }
    return bondCs - e;
  }
}

HashMap<ATYPE, float[]> atypes;
HashMap<ATYPE, Integer> colors;
HashMap<ATYPE, Float> radii;
HashMap<ATYPE, Float> masses;
HashMap<ATYPE, Integer> nonBondCs;
HashMap<ATYPE, Float> nonBondStrs;

HashMap<Character, ATYPE> shortcuts;

public void initAtypes() {
  atypes = new HashMap<ATYPE, float[]>(); // start electrons, desired electrons, electronegativity
  atypes.put(ATYPE.H, new float[]{0, 1, 1.5f});
  atypes.put(ATYPE.O, new float[]{0, 2, 3});
  atypes.put(ATYPE.C, new float[]{0, 4, 2.5f});
  atypes.put(ATYPE.N, new float[]{0, 3, 2});
  atypes.put(ATYPE.Na, new float[]{0, -1, 1});
  atypes.put(ATYPE.Cl, new float[]{0, 1, 3});
  atypes.put(ATYPE.Br, new float[]{0, 1, 2});
  atypes.put(ATYPE.S, new float[] {0, 2, 2.58f});
}

public void initColors() {
  colors = new HashMap<ATYPE, Integer>();
  colors.put(ATYPE.H, color(200, 200, 200));
  colors.put(ATYPE.O, color(200, 80, 80));
  colors.put(ATYPE.C, color(100, 100, 100));
  colors.put(ATYPE.N, color(80, 80, 200));
  colors.put(ATYPE.Na, color(170, 20, 190));
  colors.put(ATYPE.Cl, color(80, 180, 100));
  colors.put(ATYPE.Br, color(135, 35, 0));
  colors.put(ATYPE.S, color(255,255,0));
}

public void initRadii() {
  radii = new HashMap<ATYPE, Float>();
  radii.put(ATYPE.H, 2.5f);
  radii.put(ATYPE.O, 4f);
  radii.put(ATYPE.C, 3f);
  radii.put(ATYPE.N, 3.5f);
  radii.put(ATYPE.Na, 5f);
  radii.put(ATYPE.Cl, 6f);
  radii.put(ATYPE.Br, 10f);
  radii.put(ATYPE.S, 8.5f);
}

public void initMasses() {
  masses = new HashMap<ATYPE, Float>();
  masses.put(ATYPE.H, 2f);
  masses.put(ATYPE.O, 6f);
  masses.put(ATYPE.C, 4f);
  masses.put(ATYPE.N, 5f);
  masses.put(ATYPE.Na, 9f);
  masses.put(ATYPE.Cl, 11f);
  masses.put(ATYPE.Br, 18f);
  masses.put(ATYPE.S, 16f);
}

public void initNonBondCs() {
  nonBondCs = new HashMap<ATYPE, Integer>();
  nonBondCs.put(ATYPE.H, 0);
  nonBondCs.put(ATYPE.O, 1);
  nonBondCs.put(ATYPE.C, 0);
  nonBondCs.put(ATYPE.N, 1);
  nonBondCs.put(ATYPE.Na, 0);
  nonBondCs.put(ATYPE.Cl, 0);
  nonBondCs.put(ATYPE.Br, 0);
  nonBondCs.put(ATYPE.S, 0);
}

public void initNonBondStrs() {
  nonBondStrs = new HashMap<ATYPE, Float>();
  nonBondStrs.put(ATYPE.H, 0f);
  nonBondStrs.put(ATYPE.O, 4f);
  nonBondStrs.put(ATYPE.C, 1f);
  nonBondStrs.put(ATYPE.N, 1.5f);
  nonBondStrs.put(ATYPE.Na, 0f);
  nonBondStrs.put(ATYPE.Cl, 0f);
  nonBondStrs.put(ATYPE.Br, 0f);
  nonBondStrs.put(ATYPE.S,0f);
}

public void initShortcuts() {
  shortcuts = new HashMap<Character, ATYPE>();
  shortcuts.put('h', ATYPE.H);
  shortcuts.put('o', ATYPE.O);
  shortcuts.put('c', ATYPE.C);
  shortcuts.put('n', ATYPE.N);
  shortcuts.put('N', ATYPE.Na);
  shortcuts.put('C', ATYPE.Cl);
  shortcuts.put('B', ATYPE.Br);
  shortcuts.put('S', ATYPE.S);
}

float maxVel = 14;
float minVel = 3;

float temp = 8;

final float maxVel2 = maxVel * maxVel;
final float minVel2 = minVel * minVel;

final float tMul = 0.1f;
final float initRMul = 3;
final float mMul = 1;
final float repelMul = 0.07f;
final float cMul = 0.01f;
final float dampMul = 0;
final float overlapMul = 3;
final float bMul = 12;
final float bMul2 = 2.5f;
final float bDistMul = 1.15f;
final float veMul = 0;
final float eaMul = 1.1f;
final float wallMul = 20;
final float probMul = 40;
final float chargeDist = 4;

float rMul = 1;

final float g = 0;

public float mag2(PVector vec) {
  return vec.x * vec.x + vec.y * vec.y;
}

public PVector randPos() {
  return new PVector(random(0, width), random(0, height));
}

public PVector randVel(float v) {
  float angle = random(0, TWO_PI);
  return new PVector(cos(angle) * v, sin(angle) * v);
}

public void drawBond(PVector a, PVector b, int n) {
  boolean white = false;
  if(a.x < viewPortTopX && b.x < viewPortTopX) return;
  if(a.x > viewPortTopX + viewPortWidth && b.x < viewPortTopX + viewPortWidth) return;
  if(a.y < viewPortTopY && b.y < viewPortTopY) return;
  if(a.y > viewPortTopY + viewPortHeight && b.y > viewPortTopY + viewPortWidth) return;
  for (int i = n; i > 0; i--) {
    if (white)
      stroke(255);
    else
      stroke(0);
    white = !white;
    strokeWeight(rMul * (i * 1.5f - 0.75f));
    line((a.x-viewPortTopX) * cameraZoom, (a.y-viewPortTopY) * cameraZoom, (b.x-viewPortTopX) * cameraZoom, (b.y-viewPortTopY) *cameraZoom);
  }
}

Particle dragParticle;
boolean dragging = false;

public void mousePressed() {
  if(mouseButton == LEFT) {
    if (particleList.size() == 0)
      return;
    float minD2 = -1;
    for (int i = 0; i < particleList.size(); i++) {
      PVector mouse = new PVector(mouseX, mouseY).div(cameraZoom).add(new PVector(viewPortTopX,viewPortTopY));
      PVector dif = PVector.sub(particleList.get(i).pos, mouse);
      float d2 = dif.x * dif.x + dif.y * dif.y;
      //stroke(1); //debugging purposes, please ignore
      //noFill();
      //ellipse(mouse.x, mouse.y, 2,2);
      if (d2 < minD2 || minD2 < 0) {
        minD2 = d2;
        dragParticle = particleList.get(i);
      }
    }
    dragging = true;
  }
  else if(mouseButton == CENTER) {
   lastCPosX = cameraPosX;
   lastCPosY = cameraPosY;
   lastMX = mouseX;
   lastMY = mouseY;
   //println(mouseX);
  }
}

public void mouseReleased() {
  dragging = false;
}

public void mouseDragged() {
   if(mousePressed && mouseButton==CENTER) {
       cameraPosX = (int)(lastCPosX + (lastMX - mouseX) / cameraZoom);
       cameraPosY = (int)(lastCPosY + (lastMY - mouseY) / cameraZoom);
       viewPortWidth = (int)(width/cameraZoom);
       viewPortHeight = (int)(height/cameraZoom);
       viewPortTopX = cameraPosX - viewPortWidth/2;
       viewPortTopY = cameraPosY - viewPortHeight/2;
       println(cameraPosX);
   }
}

public void physUpdateParticles(Particle[] particles) {
  if (dragging) {
    PVector mouse = new PVector(mouseX, mouseY).div(cameraZoom).add(new PVector(viewPortTopX,viewPortTopY));
    PVector dif = PVector.sub(mouse, dragParticle.pos);
    dragParticle.addForce(PVector.mult(dif, dif.mag()));
  }
  for (int i = 0; i < particles.length; i++) {
    particles[i].physUpdate(particles);
  }
}

public void showParticles(Particle[] particles, int displayMode) {
  background(255);
  for (int i = 0; i < particles.length; i++) {
    if (!particles[i].nonBonding || showNonBonding)
      particles[i].showBonds();
  }
  noStroke();
  for (int i = 0; i < particles.length; i++) {
    if (!particles[i].nonBonding || showNonBonding)
      particles[i].show(displayMode);
  }
}

class Particle {
  PVector pos, vel;
  float r, m;
  int c;
  int id;

  boolean nonBonding = false;

  Atom atom;

  ArrayList<Bond> bonds;

  Particle(PVector _pos, PVector _vel, Atom _atom, int _id) {
    pos = _pos;
    vel = _vel;
    r = radii.get(_atom.atype) * initRMul;
    m = masses.get(_atom.atype) * mMul;
    c = colors.get(_atom.atype);
    atom = _atom;
    bonds = new ArrayList<Bond>();
    id = _id;
    int nonBondingCount = nonBondCs.get(_atom.atype);
    float base = random(0, TWO_PI);
    for (int i = 0; i < nonBondingCount; i++) {
      float angle = base + TWO_PI * (float)i / nonBondingCount;
      PVector tPos = new PVector(cos(angle) * 2 * r, sin(angle) * 2 * r);
      Particle tmp = new Particle(PVector.add(pos, tPos), randVel(4), particleList.size(), nonBondStrs.get(_atom.atype));
      addNonBond(tmp);
      particleList.add(tmp);
    }
  }

  Particle(PVector _pos, PVector _vel, int _id, float _str) {
    pos = _pos;
    vel = _vel;
    r = _str * initRMul;
    m = 1;
    c = color(0);
    nonBonding = true;
    bonds = new ArrayList<Bond>();
    id = _id;
  }

  public void addForce(PVector force) {
    vel.add(PVector.div(force, m));
  }

  public void subForce(PVector force) {
    vel.sub(PVector.div(force, m));
  }

  public void show(int displayMode) {
    if(pos.x < viewPortTopX-(r*rMul) || pos.y < viewPortTopY-(r*rMul)) return;
    if(pos.x > viewPortTopX + viewPortWidth + (r*rMul) && pos.y > viewPortTopY + viewPortWidth + (r*rMul)) return;
    if (displayMode == 0)
      fill(c);
    else if (displayMode == 1)
      fill(255);
    else if (displayMode == 2 && !nonBonding) {
      float v = atom.getC(bonds, id);
      if (v > 0)
        fill(v * 125, 0, 0);
      if (v <= 0)
        fill(0, 0, -v * 125);
    }
    if(displayMode == 3 && !nonBonding) {
      fill(255);
      if(atom.atype != ATYPE.H && atom.atype != ATYPE.C) {
        ellipse((pos.x-viewPortTopX) * cameraZoom, (pos.y-viewPortTopY) * cameraZoom, 2 * r, 2 * r);
        textSize(2 * r * rMul);
        fill(0);
        text(atom.atype.toString(), (pos.x-viewPortTopX) * cameraZoom, (pos.y-viewPortTopY) * cameraZoom);
      } else if (atom.atype == ATYPE.C) {
        fill(0);
        ellipse((pos.x-viewPortTopX) * cameraZoom, (pos.y-viewPortTopY) * cameraZoom, 0.8f * rMul, 0.8f * rMul);
      }
    } else {
      ellipse((pos.x-viewPortTopX) * cameraZoom, (pos.y-viewPortTopY) * cameraZoom, 2 * r * rMul, 2 * r * rMul);
      if (displayMode == 1 && !nonBonding) {
        textSize(2 * r * rMul);
        fill(0);
        text(atom.atype.toString(), (pos.x-viewPortTopX) * cameraZoom, (pos.y-viewPortTopY) * cameraZoom);
      }
    }
  }

  public void showBonds() {
    stroke(0);
    for (int i = 0; i < bonds.size(); i++) {
      Particle other = bonds.get(i).getOther(id);
      if (other.id > id || (other.nonBonding && !showNonBonding)) continue;
      if(displayMode == 3 && !nonBonding && !other.nonBonding && ((atom.atype != ATYPE.C && other.atom.atype != ATYPE.C) || (other.atom.atype == ATYPE.H && atom.atype == ATYPE.C) || (other.atom.atype == ATYPE.C && atom.atype == ATYPE.H))) continue;
      drawBond(pos, other.pos, bonds.get(i).n);
      //strokeWeight(1.5 * bonds.get(i).n);
      //line(pos.x, pos.y, other.pos.x, other.pos.y);
    }
  }

  public void physUpdate(Particle[] particles) {
    gravitate();
    particleInteract(particles);
    wallInteract();
    bondInteract();
    bondInteract2();
    move();
  }

  public void move() {
    float vmag2 = mag2(vel);
    if (vmag2 < minVel2)
      vel.mult(minVel / sqrt(vmag2));
    else if (vmag2 > maxVel2)
      vel.mult(maxVel / sqrt(vmag2));
    pos.add(PVector.mult(vel, tMul));
  }

  public void particleInteract(Particle[] particles) {
    for (int i = 0; i < particles.length; i++) {
      Particle other = particles[i];
      if (other.nonBonding) continue;
      PVector dif = PVector.sub(pos, other.pos);
      float d2 = mag2(dif);
      if (d2 == 0) return;
      if (d2 < chargeDist * sq(r + other.r) && getBondWith(other) == null) {
        float d = sqrt(d2);
        float overlap = r + other.r - d;
        float thisC = (nonBonding) ? -1 : atom.getC(bonds, id);
        float otherC = (other.nonBonding) ? -1 : other.atom.getC(other.bonds, other.id);
        float f = -repelMul / overlap + cMul * overlap * -(thisC * otherC);
        addForce(PVector.mult(dif, f));
        other.subForce(PVector.mult(dif, f));
        if (d2 < sq(r + other.r) && !nonBonding && !other.nonBonding) {
          addForce(PVector.mult(dif, overlapMul * overlap));
          other.subForce(PVector.mult(dif, overlapMul * overlap));
          if (!nonBonding && !other.nonBonding)
            tryReact(other);
        }
      } else if (d2 < sq(r + other.r)) {
        float overlap = r + other.r - sqrt(d2);
        ;
        addForce(PVector.mult(dif, overlapMul * overlap));
        other.subForce(PVector.mult(dif, overlapMul * overlap));
      }
    }
  }

  public void wallInteract() {
    float leftOverlap = r - pos.x;
    float rightOverlap = pos.x + r - width;
    float topOverlap = r - pos.y;
    float bottomOverlap = pos.y + r - height;
    if (leftOverlap > 0) vel.x += leftOverlap * wallMul;
    else if (rightOverlap > 0) vel.x -= rightOverlap * wallMul;
    if (topOverlap > 0) vel.y += topOverlap * wallMul;
    else if (bottomOverlap > 0) vel.y -= bottomOverlap * wallMul;
  }

  public void bondInteract() {
    for (int i = bonds.size() - 1; i >= 0; i--) {
      Bond bond = bonds.get(i);
      if (bond.n <= 0) {
        bond.a.bonds.remove(bond);
        bond.b.bonds.remove(bond);
        continue;
      }
      Particle other = bond.getOther(id);
      if (other.id > id) continue;
      PVector dif = PVector.sub(pos, other.pos);
      float d = dif.mag();
      float v = (d - (r + other.r) * bDistMul) / (r + other.r);
      //if (v < 0.4) continue;
      PVector vdif = PVector.sub(vel, other.vel);
      float vdifMag = vdif.mag() / maxVel;
      if (vdifMag > 1)
        vdifMag = 1;
      float f = bMul * sqrt(bond.n) * v - vdifMag * dampMul;
      subForce(PVector.mult(dif, f));
      other.addForce(PVector.mult(dif, f));
      //if (!bond.a.nonBonding && !bond.b.nonBonding && random(0, probMul * 1000 * bonds.get(i).bondEnergy) < temp * temp + 1000 * vdifMag * vdifMag) {
      //  bond.a.bonds.remove(bond);
      //  bond.b.bonds.remove(bond);
      //  continue;
      //}
      //if ((!bond.a.nonBonding && !bond.b.nonBonding) && !(bond.a.atom.e != bond.a.atom.dE && bond.b.atom.e != bond.b.atom.dE) && ((bond.a.bonds.size() > 1 && bond.b.atom.e != bond.b.atom.dE) || (bond.b.bonds.size() > 1 && bond.a.atom.e != bond.a.atom.dE))) {
      //  println(bond.a.atom.atype, bond.b.atom.atype);
      if((!bond.a.nonBonding && !bond.b.nonBonding) && (bond.a.atom.getE(bond.a.bonds, bond.a.id) != bond.a.atom.dE && bond.b.atom.getE(bond.b.bonds, bond.b.id) != bond.b.atom.dE)) {
        bond.a.tryReact(bond.b);
      }
    }
  }

  public Bond getBondWith(Particle other) {
    for (int i = 0; i < bonds.size(); i++) {
      Bond tmp = bonds.get(i);
      if ((tmp.a.id == id && tmp.b.id == other.id) || (tmp.a.id == other.id && tmp.b.id == id)) {
        return bonds.get(i);
      }
    }
    return null;
  }

  public void bondInteract2() {
    for (int i = 0; i < bonds.size(); i++) {
      Bond bond = bonds.get(i);
      Particle tmp = bond.getOther(id);
      for (int j = 0; j < tmp.bonds.size(); j++) {
        Bond oBond = tmp.bonds.get(j);
        Particle other = oBond.getOther(tmp.id);
        //if (other.id == id) continue;
        PVector dif = PVector.sub(pos, other.pos);
        float d = dif.mag();
        float v = d / (r + other.r);
        float f = v;
        if (f == 0) continue;
        addForce(PVector.mult(dif, bMul2 / (f * f)));
        other.subForce(PVector.mult(dif, bMul2 / (f * f)));
      }
    }
  }

  public void addNonBond(Particle other) {
    Bond bond = new Bond(this, other);
    bonds.add(bond);
    other.bonds.add(bond);
  }

  public void addBond(Particle other, int n) {
    Bond bond = new Bond(this, other, n);
    bonds.add(bond);
    other.bonds.add(bond);
  }

  public Bond getLowestEnergy(int n) {
    return getLowestEnergy(null, n);
  }

  public Bond getLowestEnergy(Bond exclude, int n) {
    float lowestEnergy = -1;
    Bond lowestBond = null;
    for (int i = 0; i < bonds.size(); i++) {
      Bond bond = bonds.get(i);
      if ((exclude == null || exclude != bonds.get(i)) && !bonds.get(i).a.nonBonding && !bonds.get(i).b.nonBonding) {
        float energy = bond.bondEnergy - getBondEnergy(bond.a.atom.atype, bond.b.atom.atype, bond.n - n);
        if (energy < lowestEnergy || lowestEnergy == -1) {
          lowestEnergy = energy;
          lowestBond = bond;
        }
      }
    }
    return lowestBond;
  }

  public void tryDisplace(Particle other) {
    Atom a = atom, b = other.atom;
    float aE = a.getE(bonds, id), bE = b.getE(other.bonds, other.id);
    Bond tmp = getBondWith(other);
    float increase = 0;
    float decrease = 0;
    if (tmp == null) {
      increase = getBondEnergy(atom.atype, other.atom.atype, 1);
    } else {
      if (bonds.size() == 1)
        return;
      increase = getBondEnergy(atom.atype, other.atom.atype, tmp.n + 1);
      decrease = tmp.bondEnergy;
    }
    Bond lowestBond = getLowestEnergy(tmp, 1);
    float lowestCost = lowestBond.bondEnergy - getBondEnergy(lowestBond.a.atom.atype, lowestBond.b.atom.atype, lowestBond.n - 1);
    decrease += lowestCost;
    if (increase > eaMul * decrease) {
      lowestBond.breakBonds(1);
      if (lowestBond.n <= 0) {
        lowestBond.a.bonds.remove(lowestBond);
        lowestBond.b.bonds.remove(lowestBond);
      }
      if (tmp == null) {
        addBond(other, (int)min(abs(aE - a.dE), abs(bE - b.dE)));
      } else {
        tmp.makeBonds((int)min(abs(aE - a.dE), abs(bE - b.dE)));
      }
    }
  }

  public void tryReact(Particle other) {
    Atom a = atom, b = other.atom;
    float aE = a.getE(bonds, id), bE = b.getE(other.bonds, other.id);
    if (aE != a.dE && bE != b.dE) {
      Bond tmp = getBondWith(other);
      if (tmp == null) {
        addBond(other, (int)min(abs(aE - a.dE), abs(bE - b.dE)));
      } else {
        tmp.makeBonds((int)min(abs(aE - a.dE), abs(bE - b.dE)));
      }
    } else if (aE == a.dE && bE != b.dE) {
      tryDisplace(other);
    } else if (bE == b.dE && aE != a.dE) {
      other.tryDisplace(this);
    } else {
      Bond tmp = getBondWith(other);
      float increase = 0;
      float decrease = 0;
      if (tmp == null) {
        increase = getBondEnergy(atom.atype, other.atom.atype, 1);
      } else {
        if (bonds.size() == 1)
          return;
        increase = getBondEnergy(atom.atype, other.atom.atype, tmp.n + 1);
        decrease = tmp.bondEnergy;
      }
      Bond tlowestBond = getLowestEnergy(tmp, 1);
      float tlowestCost = tlowestBond.bondEnergy - getBondEnergy(tlowestBond.a.atom.atype, tlowestBond.b.atom.atype, tlowestBond.n - 1);
      decrease += tlowestCost;
      Bond olowestBond = other.getLowestEnergy(tmp, 1);
      float olowestCost = olowestBond.bondEnergy - getBondEnergy(olowestBond.a.atom.atype, olowestBond.b.atom.atype, olowestBond.n - 1);
      decrease += olowestCost;
      if (increase > eaMul * decrease) {
        tlowestBond.breakBonds(1);
        if (tlowestBond.n <= 0) {
          tlowestBond.a.bonds.remove(tlowestBond);
          tlowestBond.b.bonds.remove(tlowestBond);
        }
        olowestBond.breakBonds(1);
        if (olowestBond.n <= 0) {
          olowestBond.a.bonds.remove(olowestBond);
          olowestBond.b.bonds.remove(olowestBond);
        }
        if (tmp == null) {
          addBond(other, (int)min(abs(aE - a.dE), abs(bE - b.dE)));
        } else {
          tmp.makeBonds((int)min(abs(aE - a.dE), abs(bE - b.dE)));
        }
      }
    }
  }

  public void gravitate() {
    vel.y += g;
  }
}

HashMap<String, Float> bondEnergies;

public void initBondEnergies() {
  bondEnergies = new HashMap<String, Float>();
  bondEnergies.put("H - H", 432.0f);
  bondEnergies.put("H - C", 411.0f);
  bondEnergies.put("H - Si", 148.0f);
  bondEnergies.put("H - N", 386.0f);
  bondEnergies.put("H - O", 459.0f);
  bondEnergies.put("H - S", 363.0f);
  bondEnergies.put("H - F", 565.0f);
  bondEnergies.put("H - Cl", 428.0f);
  bondEnergies.put("H - Br", 362.0f);
  bondEnergies.put("C - C", 346.0f);
  bondEnergies.put("C -- C", 602.0f);
  bondEnergies.put("C --- C", 835.0f);
  bondEnergies.put("C - Si", 318.0f);
  bondEnergies.put("C - N", 305.0f);
  bondEnergies.put("C -- N", 615.0f);
  bondEnergies.put("C --- N", 887.0f);
  bondEnergies.put("C - O", 358.0f);
  bondEnergies.put("C -- O", 799.0f);
  bondEnergies.put("C --- O", 1072.0f);
  bondEnergies.put("C - S", 272.0f);
  bondEnergies.put("C -- S", 573.0f);
  bondEnergies.put("C - F", 485.0f);
  bondEnergies.put("C - Cl", 327.0f);
  bondEnergies.put("C - Br", 285.0f);
  bondEnergies.put("Si - Si", 222.0f);
  bondEnergies.put("Si - N", 355.0f);
  bondEnergies.put("Si - O", 452.0f);
  bondEnergies.put("Si - S", 293.0f);
  bondEnergies.put("Si - F", 565.0f);
  bondEnergies.put("Si - Cl", 381.0f);
  bondEnergies.put("Si - Br", 310.0f);
  bondEnergies.put("N - N", 167.0f);
  bondEnergies.put("N -- N", 418.0f);
  bondEnergies.put("N --- N", 942.0f);
  bondEnergies.put("N - O", 201.0f);
  bondEnergies.put("N -- O", 607.0f);
  bondEnergies.put("N - F", 283.0f);
  bondEnergies.put("N - Cl", 313.0f);
  bondEnergies.put("O - O", 142.0f);
  bondEnergies.put("O -- O", 494.0f);
  bondEnergies.put("O - F", 190.0f);
  bondEnergies.put("S - O", 100.0f);
  bondEnergies.put("S -- O", 522.0f);
  bondEnergies.put("S - S", 226.0f);
  bondEnergies.put("S -- S", 425.0f);
  bondEnergies.put("S - F", 284.0f);
  bondEnergies.put("S - Cl", 255.0f);
  bondEnergies.put("F - F", 155.0f);
  bondEnergies.put("Cl - Cl", 240.0f);
  bondEnergies.put("Br - Br", 190.0f);
  bondEnergies.put("Fe - O", 400.0f);
  bondEnergies.put("Na - O", 257.0f);
  bondEnergies.put("Na - Na", 77.0f);
  bondEnergies.put("Na - Cl", 410.0f);
  
}
  public void settings() {  size(1500, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "NewChem" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
