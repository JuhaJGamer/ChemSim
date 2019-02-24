
enum BTYPE {
  COVALENT, IONIC, METALLIC
};

enum ATYPE {
  H, O, C, N, Na, Cl, Br,
}

float getBondEnergy(ATYPE a, ATYPE b, int n) {
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

  void refresh() {
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

  void makeBonds(int count) {
    n += count;
    refresh();
  }

  void breakBonds(int count) {
    if (btype == BTYPE.IONIC) {
      if (a.atom.eN < b.atom.eN) {
        a.atom.e -= count;
        b.atom.e += count;
      }
    }
    n -= count;
    refresh();
  }

  float getE(int id) {
    if (a.id == id)
      return eA;
    return eB;
  }

  float getC(int id) {
    if (a.id == id)
      return cA;
    return cB;
  }

  Particle getOther(int id) {
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

  float getE(ArrayList<Bond> bonds, int id) {
    float bondEs = 0;
    for (int i = 0; i < bonds.size(); i++) {
      bondEs += bonds.get(i).getE(id);
    }
    return e + bondEs;
  }

  float getC(ArrayList<Bond> bonds, int id) {
    float bondCs = 0;
    for (int i = 0; i < bonds.size(); i++) {
      bondCs += bonds.get(i).getC(id);
    }
    return bondCs - e;
  }
}
