
float maxVel = 14;
float minVel = 3;

float temp = 8;

final float maxVel2 = maxVel * maxVel;
final float minVel2 = minVel * minVel;

final float tMul = 0.1;
final float initRMul = 1.5;
final float mMul = 1;
final float repelMul = 0.07;
final float cMul = 0.01;
final float dampMul = 0;
final float overlapMul = 3;
final float bMul = 12;
final float bMul2 = 2.5;
final float bDistMul = 1.5;
final float veMul = 0;
final float eaMul = 1.1;
final float wallMul = 20;
final float probMul = 40;
final float chargeDist = 4;

float rMul = initRMul;

final float g = 0;

float mag2(PVector vec) {
  return vec.x * vec.x + vec.y * vec.y;
}

PVector randPos() {
  return new PVector(random(0, width), random(0, height));
}

PVector randVel(float v) {
  float angle = random(0, TWO_PI);
  return new PVector(cos(angle) * v, sin(angle) * v);
}

void drawBond(PVector a, PVector b, int n) {
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
    strokeWeight(rMul * (i * 1.5 - 0.75));
    line((a.x-viewPortTopX) * cameraZoom, (a.y-viewPortTopY) * cameraZoom, (b.x-viewPortTopX) * cameraZoom, (b.y-viewPortTopY) *cameraZoom);
  }
}

Particle dragParticle;
boolean dragging = false;

void mousePressed() {
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

void mouseReleased() {
  dragging = false;
}

void mouseDragged() {
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

void physUpdateParticles(Particle[] particles) {
  if (dragging) {
    PVector mouse = new PVector(mouseX, mouseY).div(cameraZoom).add(new PVector(viewPortTopX,viewPortTopY));
    PVector dif = PVector.sub(mouse, dragParticle.pos);
    dragParticle.addForce(PVector.mult(dif, dif.mag()));
  }
  for (int i = 0; i < particles.length; i++) {
    particles[i].physUpdate(particles);
  }
}

void showParticles(Particle[] particles, int displayMode) {
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
  color c;
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

  void addForce(PVector force) {
    vel.add(PVector.div(force, m));
  }

  void subForce(PVector force) {
    vel.sub(PVector.div(force, m));
  }

  void show(int displayMode) {
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
        ellipse((pos.x-viewPortTopX) * cameraZoom, (pos.y-viewPortTopY) * cameraZoom, 0.8 * rMul, 0.8 * rMul);
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

  void showBonds() {
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

  void physUpdate(Particle[] particles) {
    gravitate();
    particleInteract(particles);
    wallInteract();
    bondInteract();
    bondInteract2();
    move();
  }

  void move() {
    float vmag2 = mag2(vel);
    if (vmag2 < minVel2)
      vel.mult(minVel / sqrt(vmag2));
    else if (vmag2 > maxVel2)
      vel.mult(maxVel / sqrt(vmag2));
    pos.add(PVector.mult(vel, tMul));
  }

  void particleInteract(Particle[] particles) {
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

  void wallInteract() {
    float leftOverlap = r - pos.x;
    float rightOverlap = pos.x + r - width;
    float topOverlap = r - pos.y;
    float bottomOverlap = pos.y + r - height;
    if (leftOverlap > 0) vel.x += leftOverlap * wallMul;
    else if (rightOverlap > 0) vel.x -= rightOverlap * wallMul;
    if (topOverlap > 0) vel.y += topOverlap * wallMul;
    else if (bottomOverlap > 0) vel.y -= bottomOverlap * wallMul;
  }

  void bondInteract() {
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

  Bond getBondWith(Particle other) {
    for (int i = 0; i < bonds.size(); i++) {
      Bond tmp = bonds.get(i);
      if ((tmp.a.id == id && tmp.b.id == other.id) || (tmp.a.id == other.id && tmp.b.id == id)) {
        return bonds.get(i);
      }
    }
    return null;
  }

  void bondInteract2() {
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

  void addNonBond(Particle other) {
    Bond bond = new Bond(this, other);
    bonds.add(bond);
    other.bonds.add(bond);
  }

  void addBond(Particle other, int n) {
    Bond bond = new Bond(this, other, n);
    bonds.add(bond);
    other.bonds.add(bond);
  }

  Bond getLowestEnergy(int n) {
    return getLowestEnergy(null, n);
  }

  Bond getLowestEnergy(Bond exclude, int n) {
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

  void tryDisplace(Particle other) {
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

  void tryReact(Particle other) {
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

  void gravitate() {
    vel.y += g;
  }
}
