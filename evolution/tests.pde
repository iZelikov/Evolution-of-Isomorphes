int testI=0;
Gene testG;
Organizmus testO;
Organizmus testO2;
Population testP;
PGraphics testPG;
void runTests() {
  //testGene();
  //testOrganizmus();
  //testReproduction();
  //testSuddenDeath();
  testTriangle();
}
void testGene() {
  if (testI==0) {
    testPG = createGraphics(width, height);
    testG = new Gene();
  }
  testI++;
  //background(0);
  testPG.beginDraw();
  testPG.noStroke();
  testPG.rectMode(CENTER);
  testPG.clear();  
  testG.draw(testPG);
  testPG.endDraw();
  image(testPG, 0, 0);

  testG.mutate(0);
};

void testTriangle() {
  if (testI==0) {
    testPG = createGraphics(width, height);
    testG = new Gene();
  }
  testI++;
  //delay(100);
  background(0);
  testPG.beginDraw();
  testPG.noStroke();
  testPG.rectMode(CENTER);
  testPG.clear();
  testG.alpha=0.5;
  testG.draw(testPG);
  testG.formType = ELLIPSE;  
  testG.draw(testPG);
  testG.formType = TRIANGLE;  
  testG.draw(testPG);
  testPG.endDraw();
  image(testPG, 0, 0); 
  testG.mutateTriangle(0.1);
  testG.setTriangleCoordinate();
  
}

void testOrganizmus() {

  if (testI==0) {
    testPG = createGraphics(width/2, height);
    testO = new Organizmus();
    testO.generate(10);
    testO2 = testO.copy();
  }
  testI++;
  background(0);


  image(testO.draw(testPG), 0, 0);
  image(testO2.draw(testPG), width/2, 0);
  testO2.geneMutate(0.1, 0.2);
}

void testReproduction() {
  if (testI==0) {
    testPG = createGraphics(width/10, height/10);
    testP = new Population(1);
  }
  testI++;
  background(0);
  for (int j=0; j<testP.victims.size(); j++) {
    Organizmus o = testP.victims.get(j); //<>//
    image(o.draw(testPG), j*testPG.width%width, (testPG.height)*(j*testPG.width/width));
  }
  testP.growUp();
  testP.reproduction();
  testP.oldAgeDeath();

  delay(1000);
  
}

void testSuddenDeath(){
  if (testI==0) {
    testPG = createGraphics(width/10, height/10);
    testP = new Population(100);
  }
  testI++;
  background(0);
  for (int j=0; j<testP.victims.size(); j++) {
    Organizmus o = testP.victims.get(j);
    image(o.draw(testPG), j*testPG.width%width, (testPG.height)*(j*testPG.width/width));
  }
  testP.suddenDeath();
  delay(1000);
}
