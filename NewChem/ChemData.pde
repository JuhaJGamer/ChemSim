
HashMap<ATYPE, float[]> atypes;
HashMap<ATYPE, Integer> colors;
HashMap<ATYPE, Float> radii;
HashMap<ATYPE, Float> masses;
HashMap<ATYPE, Integer> nonBondCs;
HashMap<ATYPE, Float> nonBondStrs;

HashMap<Character, ATYPE> shortcuts;

void initAtypes() {
  atypes = new HashMap<ATYPE, float[]>(); // start electrons, desired electrons, electronegativity
  atypes.put(ATYPE.H, new float[]{0, 1, 1.5});
  atypes.put(ATYPE.O, new float[]{0, 2, 3});
  atypes.put(ATYPE.C, new float[]{0, 4, 2.5});
  atypes.put(ATYPE.N, new float[]{0, 3, 2});
  atypes.put(ATYPE.Na, new float[]{0, -1, 1});
  atypes.put(ATYPE.Cl, new float[]{0, 1, 3});
  atypes.put(ATYPE.Br, new float[]{0, 1, 2});
}

void initColors() {
  colors = new HashMap<ATYPE, Integer>();
  colors.put(ATYPE.H, color(200, 200, 200));
  colors.put(ATYPE.O, color(200, 80, 80));
  colors.put(ATYPE.C, color(100, 100, 100));
  colors.put(ATYPE.N, color(80, 80, 200));
  colors.put(ATYPE.Na, color(170, 20, 190));
  colors.put(ATYPE.Cl, color(80, 180, 100));
  colors.put(ATYPE.Br, color(135, 35, 0));
}

void initRadii() {
  radii = new HashMap<ATYPE, Float>();
  radii.put(ATYPE.H, 2.5f);
  radii.put(ATYPE.O, 4f);
  radii.put(ATYPE.C, 3f);
  radii.put(ATYPE.N, 3.5f);
  radii.put(ATYPE.Na, 5f);
  radii.put(ATYPE.Cl, 6f);
  radii.put(ATYPE.Br, 10f);
}

void initMasses() {
  masses = new HashMap<ATYPE, Float>();
  masses.put(ATYPE.H, 2f);
  masses.put(ATYPE.O, 6f);
  masses.put(ATYPE.C, 4f);
  masses.put(ATYPE.N, 5f);
  masses.put(ATYPE.Na, 9f);
  masses.put(ATYPE.Cl, 11f);
  masses.put(ATYPE.Br, 18f);
}

void initNonBondCs() {
  nonBondCs = new HashMap<ATYPE, Integer>();
  nonBondCs.put(ATYPE.H, 0);
  nonBondCs.put(ATYPE.O, 1);
  nonBondCs.put(ATYPE.C, 0);
  nonBondCs.put(ATYPE.N, 1);
  nonBondCs.put(ATYPE.Na, 0);
  nonBondCs.put(ATYPE.Cl, 0);
  nonBondCs.put(ATYPE.Br, 0);
}

void initNonBondStrs() {
  nonBondStrs = new HashMap<ATYPE, Float>();
  nonBondStrs.put(ATYPE.H, 0f);
  nonBondStrs.put(ATYPE.O, 4f);
  nonBondStrs.put(ATYPE.C, 1f);
  nonBondStrs.put(ATYPE.N, 1.5f);
  nonBondStrs.put(ATYPE.Na, 0f);
  nonBondStrs.put(ATYPE.Cl, 0f);
  nonBondStrs.put(ATYPE.Br, 0f);
}

void initShortcuts() {
  shortcuts = new HashMap<Character, ATYPE>();
  shortcuts.put('h', ATYPE.H);
  shortcuts.put('o', ATYPE.O);
  shortcuts.put('c', ATYPE.C);
  shortcuts.put('n', ATYPE.N);
  shortcuts.put('N', ATYPE.Na);
  shortcuts.put('C', ATYPE.Cl);
  shortcuts.put('B', ATYPE.Br);
}
