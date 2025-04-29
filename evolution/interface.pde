/* инициализация интерфейса (начальные кнопки, картинки и т. п.) *///<>// //<>//
void initInterface() {
  calculateSizes();
  targetImage = loadImage(LOADING_IMG);
  targetImage.resize(imgW, imgH);
  topImage = targetImage.get();

  difHistory = new LongList();
  generateHistoryFileName();

  generateStances();
  loadSettings(savesPath+"settings.json");  
  interfaceReady = true;
}

/* обновление интерфейса (обновление экрана, отрисовка лучшего организмуса, вывод количства поколений) */
void updateInterface() {
  totalTime = millis()-startEvolutionTime;
  background(0);
  //getTop();  
  checkGameStance();
  //gameStance = EVOLUTION;

  //saveDifferenceHistory(); //сохраняем историю дифференсов в файл
  //saveScreenShot(); //сохраняем скриншот экрана в файл
}

void startEvolution() {
  generation = 0; 
  difference = Long.MAX_VALUE;
  curDiff = Long.MAX_VALUE;
  lastDiff = Long.MAX_VALUE;

  topCriticus = new Criticus(targetImage, topCriticusImageSize);
  topCriticusSize = topCriticusImageSize;
  criticus = new Criticus(targetImage, criticusImageSize);
  population = generatePopulation();

  evolutionStarted = true;
  startEvolutionTime = millis();

  while (evolutionStarted) {
    t = millis();
    nextGeneration(population);
    oneGenerationTime = millis()-t;
    // to do условия остановки цикла и т.д.
    
    saveDifferenceHistory(); //сохранение Difference для топа
  }
}

void generateStances() { //to do сейчас размеры кнопочек не зависят от размеров экрана
  controls = new ArrayList<Control>();
  generateMenuStance();
  generateSettingsStance();
  generateChoosingImageStance();
  generateEvolutionStance();
}

void generateMenuStance() {
  menuControls = new ArrayList<Control>();

  startButton = new Button("NEW GAME", width/2-space*3, height/2-space*5);
  startButton.w = space*6;
  startButton.h = space*2;
  startButton.textSize = textSize*1.5;
  startButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      gameStance = CHOOSING_IMAGE;
    }
  }
  );

  continueButton = new Button("CONTINUE", width/2-space*3, height/2-space*2, startButton);
  continueButton.bgColor = markedButtonColor;
  continueButton.hoverBg = color(red(markedButtonColor)/1.2, green(markedButtonColor)/1.2, blue(markedButtonColor)/1.2);
  continueButton.pressedBg = color(red(markedButtonColor)/1.5, green(markedButtonColor)/1.6, blue(markedButtonColor)/1.6);
  continueButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      gameStance = EVOLUTION;
    }
  }
  );  

  settingsButton = new Button("SETTINGS", width/2-space*3, height/2+space, startButton);
  settingsButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      gameStance = SETTINGS;
    }
  }
  );

  helpButton = new Button("HELP", width/2-space*3, height/2+space*4, startButton);
  helpButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {      
      launch(sketchPath("\\data\\help\\help.html"));
    }
  }
  );

  exitButton = new Button("EXIT", width/2-space*3, height/2+space*7, startButton);
  exitButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      exit();
    }
  }
  );   

  menuControls.add(startButton);
  menuControls.add(continueButton);
  menuControls.add(settingsButton);
  menuControls.add(helpButton);
  menuControls.add(exitButton);

  //создаем кнопку возврата в меню
  backToMenuButton = new Button();
  backToMenuButton.text = "Menu";
  backToMenuButton.textSize = textSize;
  backToMenuButton.w = space*4;
  backToMenuButton.h = backToMenuButton.textSize*2;
  backToMenuButton.x = rightEdge-backToMenuButton.w-space;
  backToMenuButton.y = bottomEdge-backToMenuButton.h-space;
  backToMenuButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      gameStance = MENU;
      //evolutionStarted = false;
    }
  }
  );
}

void generateSettingsStance() {
  settingsControls = new ArrayList<Control>();

  //form type group
  formTypeGroup = new ButtonsGroup();
  int figureW = (int)(imgW - 1.5*space)/4; 
  figureW*=0.5;
  int columnLeftX = rightEdge-(rightEdge-leftEdge)/2-space*2-imgW;
  int columnRightX = rightEdge-(rightEdge-leftEdge)/2+space*2;
  int columnTop = topEdge+space*2;
  int yShift = (int)(space*3.5); //расстояние от верхнего угла одного слайдера до другого
  PGraphics pGr = createGraphics(figureW, figureW);

  pGr.beginDraw();
  pGr.fill(128);
  pGr.ellipse(figureW/2, figureW/2, figureW, figureW);
  pGr.endDraw();
  ellipseButton = new ImageButton(pGr.get(), columnLeftX, columnTop+space);

  pGr.beginDraw();
  pGr.clear();
  pGr.rect(0, 0, figureW, figureW);
  pGr.endDraw();
  rectButton = new ImageButton(pGr.get(), ellipseButton.x+figureW+space/2, ellipseButton.y);

  pGr.beginDraw();
  pGr.clear();
  pGr.triangle(0, figureW, figureW/2, 0, figureW, figureW);
  pGr.endDraw();
  triangleButton = new ImageButton(pGr.get(), rectButton.x+figureW+space/2, rectButton.y);

  pGr.beginDraw();
  pGr.clear();
  pGr.fill(255, 128);
  pGr.noStroke();
  pGr.ellipse(figureW*0.4, figureW*0.65, figureW*0.8, figureW*0.7);
  pGr.rect(figureW*0.35, figureW*0.16, figureW, figureW*0.64);
  pGr.triangle(figureW*0.4, 0, 0, figureW*0.23, figureW*0.6, figureW*0.9);
  pGr.endDraw();
  allTypesButton = new ImageButton(pGr.get(), triangleButton.x+figureW+space/2, triangleButton.y);

  formTypeGroup.add(ellipseButton);
  formTypeGroup.add(rectButton);
  formTypeGroup.add(triangleButton);
  formTypeGroup.add(allTypesButton);
  formTypeGroup.activeButton = formTypeSettings;
  formTypeGroup.text = "Gene form type";
  formTypeGroup.textSize = textSize;
  settingsControls.add(formTypeGroup);

  //reproduction group
  reproductionTypeGroup = new ButtonsGroup();
  sexsualButton = new Button("Sexual", columnRightX, ellipseButton.y);
  sexsualButton.w=imgW/3;
  sexsualButton.textSize = textSize;
  sexsualButton.h=textSize*2;
  sexsualButton.activeBg = color(0, 100, 0);
  cloneButton = new Button("Clone", sexsualButton.x+sexsualButton.w+space, sexsualButton.y, sexsualButton);
  reproductionTypeGroup.add(sexsualButton);
  reproductionTypeGroup.add(cloneButton);
  reproductionTypeGroup.textSize = textSize;
  reproductionTypeGroup.text = "Reproduction type";
  if (reproductionType == CLONE) reproductionTypeGroup.activeButton = 1; 
  else reproductionTypeGroup.activeButton = 0;
  settingsControls.add(reproductionTypeGroup);

  //sliders
  numOfGenesSlider = new Slider("Initial number of genes", 
    columnLeftX, 
    ellipseButton.y+yShift+space);
  numOfGenesSlider.w = imgW;
  numOfGenesSlider.h = space;
  numOfGenesSlider.min = 1;
  numOfGenesSlider.max = 1000;
  numOfGenesSlider.textSize = textSize;
  numOfGenesSlider.digits = 0;
  numOfGenesSlider.expDependence = true;
  numOfGenesSlider.setValue(numberOfGenesInOrganizmus);
  settingsControls.add(numOfGenesSlider);

  popSizeSlider = new Slider("Population size", 
    numOfGenesSlider.x, 
    numOfGenesSlider.y+yShift, 
    numOfGenesSlider);
  popSizeSlider.setValue(numberOfOrganizmusInPopulation);
  settingsControls.add(popSizeSlider);

  numOfChildrenSlider = new Slider("Number of children", 
    numOfGenesSlider.x, 
    popSizeSlider.y+yShift, 
    numOfGenesSlider);
  numOfChildrenSlider.setValue(numberOfChildren);
  settingsControls.add(numOfChildrenSlider);

  crSizeSlider = new Slider("Initial Criticus size", 
    numOfGenesSlider.x, 
    numOfChildrenSlider.y+yShift, 
    numOfGenesSlider);
  crSizeSlider.min = 8;
  crSizeSlider.max = 512;
  crSizeSlider.numberOfDivisions = 6;
  crSizeSlider.stickToDivisions = true;
  crSizeSlider.setValue(criticusImageSize);
  settingsControls.add(crSizeSlider);

  crThresholdSlider = new Slider("Criticus increase threshold", 
    numOfGenesSlider.x, 
    crSizeSlider.y+yShift, 
    numOfGenesSlider);
  crThresholdSlider.min = 10;
  crThresholdSlider.max = 10000;
  crThresholdSlider.zeroStart = true;
  crThresholdSlider.setValue(criticusThreshold);
  settingsControls.add(crThresholdSlider);

  geneMutChanceSlider = new Slider("Gene mutation chance", 
    columnRightX, 
    numOfGenesSlider.y, 
    numOfGenesSlider);
  geneMutChanceSlider.zeroStart = true;
  geneMutChanceSlider.min = 0.00001;
  geneMutChanceSlider.max = 1;
  geneMutChanceSlider.digits = 5;
  geneMutChanceSlider.setValue(chanceToMutateGene);
  settingsControls.add(geneMutChanceSlider);

  chrMutChanceSlider = new Slider("Chromosome mutation chance", 
    geneMutChanceSlider.x, 
    geneMutChanceSlider.y+yShift, 
    geneMutChanceSlider);
  chrMutChanceSlider.min = 0;
  chrMutChanceSlider.expDependence = false;
  chrMutChanceSlider.digits = 2;
  chrMutChanceSlider.setValue(chanceToMutateChromosome);
  settingsControls.add(chrMutChanceSlider);

  maxDispersionSlider = new Slider("Max dispersion", 
    geneMutChanceSlider.x, 
    chrMutChanceSlider.y+yShift, 
    chrMutChanceSlider);
  maxDispersionSlider.setValue(maxDispersion);
  settingsControls.add(maxDispersionSlider);

  chanceToDieSlider = new Slider("Chance organizmus to die", 
    geneMutChanceSlider.x, 
    maxDispersionSlider.y+yShift, 
    chrMutChanceSlider);
  chanceToDieSlider.setValue(chanceToDie);
  settingsControls.add(chanceToDieSlider);

  //buttons
  saveSettingsButton = new Button("Save", 
    backToMenuButton.x-space-backToMenuButton.w, 
    backToMenuButton.y, 
    backToMenuButton);  
  saveSettingsButton.enabled = false;
  saveSettingsButton.bgColor = markedButtonColor;
  saveSettingsButton.hoverBg = color(red(markedButtonColor)/1.2, green(markedButtonColor)/1.2, blue(markedButtonColor)/1.2);
  saveSettingsButton.pressedBg = color(red(markedButtonColor)/1.5, green(markedButtonColor)/1.6, blue(markedButtonColor)/1.6);
  saveSettingsButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      saveSettings();
    }
  }
  );

  restoreDefaultButton = new Button("Defaults", 
    saveSettingsButton.x-space-backToMenuButton.w, 
    backToMenuButton.y, 
    backToMenuButton);
  restoreDefaultButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      loadSettings(savesPath+"default.json");
      saveSettings();
    }
  }
  );

  settingsControls.add(backToMenuButton);
  settingsControls.add(saveSettingsButton);
  settingsControls.add(restoreDefaultButton);
}

void saveSettings() {
  formTypeSettings = formTypeGroup.activeButton;
  numberOfGenesInOrganizmus = (int)numOfGenesSlider.value;
  numberOfOrganizmusInPopulation = (int)popSizeSlider.value;
  numberOfChildren = (int)numOfChildrenSlider.value;
  criticusImageSize = (int)crSizeSlider.value;
  criticusThreshold = (int)crThresholdSlider.value;
  if (reproductionTypeGroup.activeButton==0) reproductionType = SEXUAL;
  else reproductionType = CLONE;
  chanceToMutateGene = geneMutChanceSlider.value;
  chanceToMutateChromosome = chrMutChanceSlider.value;
  maxDispersion = maxDispersionSlider.value;
  chanceToDie = chanceToDieSlider.value;
  JSONObject jsonSettings = settingsToJSON();
  saveJSONObject(jsonSettings, savesPath+"settings.json");
}

JSONObject settingsToJSON() {
  JSONObject json = new JSONObject();
  json.setInt("formTypeSettings", formTypeSettings);
  json.setInt("reproductionType", reproductionType);
  json.setFloat("formTypeChanceToMutate", formTypeChanceToMutate);
  json.setFloat("visiabilityChanceToMutate", visiabilityChanceToMutate);
  json.setInt("numberOfOrganizmusInPopulation", numberOfOrganizmusInPopulation);
  json.setInt("numberOfChildren", numberOfChildren);
  json.setInt("numberOfGenesInOrganizmus", numberOfGenesInOrganizmus);
  json.setFloat("chanceToMutateGene", chanceToMutateGene);
  json.setFloat("chanceToMutateChromosome", chanceToMutateChromosome);
  json.setFloat("maxDispersion", maxDispersion);
  json.setFloat("chanceToDie", chanceToDie);
  json.setInt("maxAge", maxAge);
  json.setInt("criticusImageSize", criticusImageSize);
  json.setInt("topCriticusImageSize", topCriticusImageSize);
  json.setInt("criticusThreshold", criticusThreshold);
  json.setFloat("criticusThresMultiplicator", criticusThresMultiplicator);
  json.setString("imageToCompare", imageToCompare);

  return json;
}

void loadSettings(String fileName) {
  JSONObject json;
  try {
    json = loadJSONObject(fileName);  
    settingsFromJSON(json);
    generateSettingsStance();
  } 
  catch(NullPointerException e) {
  };
}

void settingsFromJSON(JSONObject json) {
  formTypeSettings = json.getInt("formTypeSettings");
  reproductionType = json.getInt("reproductionType");
  formTypeChanceToMutate = json.getFloat("formTypeChanceToMutate");
  visiabilityChanceToMutate = json.getFloat("visiabilityChanceToMutate");
  numberOfOrganizmusInPopulation = json.getInt("numberOfOrganizmusInPopulation");
  numberOfChildren = json.getInt("numberOfChildren");
  numberOfGenesInOrganizmus = json.getInt("numberOfGenesInOrganizmus");
  chanceToMutateGene = json.getFloat("chanceToMutateGene");
  chanceToMutateChromosome = json.getFloat("chanceToMutateChromosome");
  maxDispersion = json.getFloat("maxDispersion");
  chanceToDie = json.getFloat("chanceToDie");
  maxAge = json.getInt("maxAge");
  criticusImageSize = json.getInt("criticusImageSize");
  topCriticusImageSize = json.getInt("topCriticusImageSize");
  criticusThreshold = json.getInt("criticusThreshold");
  criticusThresMultiplicator = json.getFloat("criticusThresMultiplicator");
  imageToCompare = json.getString("imageToCompare");
}

void generateChoosingImageStance() {
  choosingControls = new ArrayList<Control>();
  OnClickListener listener = new OnClickListener() {
    public void onClick(Control c) {
      evolutionStarted = false;
      gameOver = false;
      ImageButton b = (ImageButton)c;
      targetImage = loadImage(b.name);
      targetImage.resize(imgW, imgH);
      gameStance = EVOLUTION;      
      thread("startEvolution");
    }
  };

  PImage tempImg;
  tempImg = loadImage(CAT);
  imgButton1 = new ImageButton(tempImg, width/2-space*1.5-previewW*2, height/2-space-previewH, previewW, previewH);
  imgButton1.name = CAT;
  imgButton1.setOnClickListener(listener);
  choosingControls.add(imgButton1);

  tempImg = loadImage(MONALIZA);
  imgButton2 = new ImageButton(tempImg, width/2-space*0.5-previewW, height/2-space-previewH, previewW, previewH);
  imgButton2.name = MONALIZA;
  imgButton2.setOnClickListener(listener);
  choosingControls.add(imgButton2);

  tempImg = loadImage(SNEGOVIK);
  imgButton3 = new ImageButton(tempImg, width/2+space*0.5, height/2-space-previewH, previewW, previewH);
  imgButton3.name = SNEGOVIK;
  imgButton3.setOnClickListener(listener);
  choosingControls.add(imgButton3);

  tempImg = loadImage(DARWIN);
  imgButton4 = new ImageButton(tempImg, width/2+space*1.5+previewW, height/2-space-previewH, previewW, previewH);
  imgButton4.name = DARWIN;
  imgButton4.setOnClickListener(listener);
  choosingControls.add(imgButton4);

  tempImg = loadImage(VIVA_LA_EVOLUCION);
  imgButton5 = new ImageButton(tempImg, width/2-space*1.5-previewW*2, height/2+space, previewW, previewH);
  imgButton5.name = VIVA_LA_EVOLUCION;
  imgButton5.setOnClickListener(listener);
  choosingControls.add(imgButton5);

  tempImg = loadImage(PICASSO_CAT);
  imgButton6 = new ImageButton(tempImg, width/2-space*0.5-previewW, height/2+space, previewW, previewH);
  imgButton6.name = PICASSO_CAT;
  imgButton6.setOnClickListener(listener);
  choosingControls.add(imgButton6);

  tempImg = loadImage(IMPRESSIONISM);
  imgButton7 = new ImageButton(tempImg, width/2+space*0.5, height/2+space, previewW, previewH);
  imgButton7.name = IMPRESSIONISM;
  imgButton7.setOnClickListener(listener);
  choosingControls.add(imgButton7);

  tempImg = loadImage(TROGLODYTUS);
  imgButton8 = new ImageButton(tempImg, width/2+space*1.5+previewW, height/2+space, previewW, previewH);
  imgButton8.name = TROGLODYTUS;
  imgButton8.setOnClickListener(listener);
  choosingControls.add(imgButton8);

  openImageButton = new Button("Open image", backToMenuButton.x, backToMenuButton.y-space*2, backToMenuButton);
  openImageButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      selectInput("Choose target image", "openImage");
    }
  }
  );
  choosingControls.add(openImageButton);

  choosingControls.add(backToMenuButton);
}

void openImage(File img) {
  if (img != null) {
    String[] s = split(img.getAbsolutePath(), '.');
    String extension = s[s.length-1].toLowerCase();
    boolean found = false;
    for (int i=0; i < ext.length; i++) {
      if (ext[i].equals(extension)) found = true;
    }
    if (found) {
      targetImage = loadImage(img.getAbsolutePath());    
      targetImage.resize(imgW, imgH);
      evolutionStarted = false;
      gameOver = false;
      gameStance = EVOLUTION;      
      thread("startEvolution");
    }
  }
}

void generateEvolutionStance() {
  evolutionControls = new ArrayList<Control>();
  topPG = createGraphics(imgW, imgH);
  currentCriticusSize = criticusImageSize;
  topCriticusSize = topCriticusImageSize;
  topDnaSize = 0;
  evolutionControls.add(backToMenuButton);

  topHistoryButton = new Button("Review evolution", textLeftEdge, backToMenuButton.y-space*2, backToMenuButton);
  topHistoryButton.w = rightEdge-space-topHistoryButton.x;
  topHistoryButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      if (evolutionSubStance == REVIEW_EVOLUTION) {
        evolutionSubStance = NORMAL_EVOLUTION;
      } else {
        evolutionSubStance = REVIEW_EVOLUTION;
      }
      step = 0;
    }
  }
  );
  evolutionControls.add(topHistoryButton);

  stepByStepButton = new Button("Step by step drawing", textLeftEdge, topHistoryButton.y-space*2, topHistoryButton);
  stepByStepButton.setOnClickListener(new OnClickListener() {
    public void onClick(Control c) {
      if (evolutionSubStance == STEP_BY_STEP_DRAWING) {
        evolutionSubStance = NORMAL_EVOLUTION;
      } else {
        evolutionSubStance = STEP_BY_STEP_DRAWING;
      }
      step = 0;
    }
  }
  );
  evolutionControls.add(stepByStepButton);
}

void checkGameStance() {  
  switch(gameStance) {
  case LOADING:
    loadingStance();
    break;
  case MENU:
    menuStance();
    break;      
  case SETTINGS:
    settingsStance();
    break;
  case CHOOSING_IMAGE:
    choosingStance();
    break;      
  case EVOLUTION:
    evolutionStance();
    break;      
  default:
    loadingStance();
    break;
  }
}

void loadingStance() {
  background(0);
  fill(255);
  textSize(textSize*6);
  textAlign(CENTER, CENTER);
  text("EVOLUTION OF\nISOMORPHES", (rightEdge-leftEdge)/2+leftEdge, (bottomEdge-topEdge)/2+topEdge);
  textSize(textSize*2);
  textAlign(RIGHT, BOTTOM);
  color blinkColor = (int)(sin(frameCount/20f) * 64) + 64;
  fill(blinkColor);
  text("Loading...", rightEdge-space, bottomEdge-space);
  if (interfaceReady) gameStance = MENU;
}

void menuStance() {
  textSize(textSize*3);
  textAlign(CENTER, CENTER);
  fill(255);
  text("EVOLUTION OF ISOMORPHES", width/2, height/2-space*8);
  if (evolutionStarted) continueButton.enabled = true;
  else continueButton.enabled = false;
  for (int i=0; i < menuControls.size(); i++) {
    menuControls.get(i).check();
    menuControls.get(i).show();
  }
}

void settingsStance() {
  checkSettings(); // проверяет, были ли произведены изменения настроек
  for (int i=0; i < settingsControls.size(); i++) {
    settingsControls.get(i).check();
    settingsControls.get(i).show();
  }
}

void checkSettings() {
  boolean settingsChanged = false;
  if (formTypeSettings != formTypeGroup.activeButton) settingsChanged = true;
  if (numberOfGenesInOrganizmus != (int)numOfGenesSlider.value) settingsChanged = true;
  if (numberOfOrganizmusInPopulation != (int)popSizeSlider.value) settingsChanged = true;
  if (numberOfChildren != (int)numOfChildrenSlider.value) settingsChanged = true;
  if (criticusImageSize != (int)crSizeSlider.value) settingsChanged = true;
  if (criticusThreshold != (int)crThresholdSlider.value) settingsChanged = true;
  if (reproductionTypeGroup.activeButton==0 && reproductionType != SEXUAL) settingsChanged = true;
  if (reproductionTypeGroup.activeButton==1 && reproductionType != CLONE) settingsChanged = true;
  if (chanceToMutateGene != geneMutChanceSlider.value) settingsChanged = true;
  if (chanceToMutateChromosome != chrMutChanceSlider.value) settingsChanged = true;
  if (maxDispersion != maxDispersionSlider.value) settingsChanged = true;
  if (chanceToDie != chanceToDieSlider.value) settingsChanged = true;

  if (settingsChanged) saveSettingsButton.enabled = true;
  else saveSettingsButton.enabled = false;
}

void choosingStance() {
  for (int i=0; i < choosingControls.size(); i++) {
    choosingControls.get(i).check();
    choosingControls.get(i).show();
  }
  textSize(textSize*1.5);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Choose target image", width/2, height/2);
}

/* вывод окошка с эволюцией */
void evolutionStance() {
  checkEvolutionSubStance();
  for (int i=0; i < evolutionControls.size(); i++) {
    evolutionControls.get(i).check();
    evolutionControls.get(i).show();
  }
  image(leftImage, leftEdge, topEdge);
  image(rightImage, leftEdge+imgW+space, topEdge);  

  if (gameOver) {
    fill(150, 0, 0);
    textSize(textSize*10);
    textAlign(CENTER, CENTER);
    text("GAME OVER", (rightEdge-leftEdge)/2+leftEdge, (bottomEdge-topEdge)/2+topEdge);
  }
}

void checkEvolutionSubStance() {
  switch(evolutionSubStance) {
  case NORMAL_EVOLUTION:
    normalEvolution();
    break;
  case REVIEW_EVOLUTION:
    reviewEvolution();
    break;
  case STEP_BY_STEP_DRAWING:
    stepByStepDrawing();
    break;
  default:
    normalEvolution();
    break;
  }
}

void normalEvolution() {
  getTop();
  leftImage = targetImage;
  rightImage = topImage;  
  fill(255);
  textAlign(LEFT, BOTTOM);
  textSize(textSize); 
  text("Generation " + generation, textLeftEdge, topEdge+space);
  text("Difference " + (float)difference/(topCriticusSize*topCriticusSize), textLeftEdge, topEdge+space*2);
  text("Current Dif. " + curDiff + " / " + round(criticusThreshold/(criticus==null?1:criticus.multiplicator)), 
    textLeftEdge, topEdge+space*3);
  text("Criticus view size " + currentCriticusSize + " px", textLeftEdge, topEdge+space*4);
  text("DNA " + topDnaSize + " genes", textLeftEdge, topEdge+space*5);
  text("Generation time " + oneGenerationTime + " ms", textLeftEdge, topEdge+space*7);
  text("Total time " + formatTime(totalTime), textLeftEdge, topEdge+space*8);

//Memory usage
  long maxMemory = runtime.maxMemory();
  long allocatedMemory = runtime.totalMemory();
  //long freeMemory = runtime.freeMemory();  
  text("Memory usage " + allocatedMemory/1000000+" / "+maxMemory/1000000+" MB", textLeftEdge, topEdge+space*9);
}

void reviewEvolution() {
  if (step<population.topHistory.size()) {
    rightImage = population.topHistory.get(step).draw(topPG); 
    fill(0, 150, 0);
    textAlign(LEFT, BOTTOM);
    textSize(textSize); 
    text("Reviewing evolution", textLeftEdge, topEdge+space);
    fill(255);
    text("Generation " + (step+1)+" / "+generation, textLeftEdge, topEdge+space*2);
    textAlign(LEFT,TOP);
    text(reviewEvolutionHelpText, textLeftEdge, topEdge+space*5, rightEdge-space-textLeftEdge, space*10);
    step++;
  } else {
    evolutionSubStance = NORMAL_EVOLUTION;
  }
}

void stepByStepDrawing() {
  if (step<top.orderToDraw.size()) {
    long t1 = millis();
    rightImage = top.draw(topPG, step);
    fill(0, 150, 0);
    textAlign(LEFT);
    textSize(textSize); 
    text("Step by step drawing\nof Top Isomorph", textLeftEdge, topEdge+space);
    fill(255);
    text("Gene " + (step+1)+" / "+ top.orderToDraw.size(), textLeftEdge, topEdge+space*3);
    text(stepByStepHelpText, textLeftEdge, topEdge+space*5, rightEdge-space-textLeftEdge, space*10);
    step++;
    if(millis()-t1<stepByStepDelay) delay(int(stepByStepDelay-millis()+t1));
  } else {
    evolutionSubStance = NORMAL_EVOLUTION;
  }
}

/* получение лучшего организмуса и его картинки, diference */
void getTop() {
  if (evolutionStarted && (top != population.topOrganizmus)) {
    top = population.topOrganizmus;
    topImage = top.draw(topPG);
    difference = topCriticus.getDifference(top);
    if (top.rate.containsKey(criticus.id)) {
      curDiff = top.rate.get(criticus.id)/(criticus.size*criticus.size);
    }
    topDnaSize = top.dna.size();
  }
}
/* сохранение истории топдифференсов для каждого поколения */
void saveDifferenceHistory() {
  difHistory.append(difference);
  if (saveHistory && generation%autoSaveCount == 0) {
    PrintWriter output = createWriter(historyFileName);
    output.println("formTypeSettings "+formTypeSettings);
    output.println("reproductionType "+reproductionType);
    output.println("formTypeChanceToMutate "+formTypeChanceToMutate);
    output.println("visiabilityChanceToMutate "+visiabilityChanceToMutate);
    output.println("numberOfOrganizmusInPopulation "+numberOfOrganizmusInPopulation);
    output.println("numberOfChildren "+numberOfChildren);
    output.println("numberOfGenesInOrganizmus "+numberOfGenesInOrganizmus);
    output.println("chanceToMutateGene "+chanceToMutateGene);
    output.println("chanceToMutateChromosome "+chanceToMutateChromosome);
    output.println("maxDispersion "+maxDispersion);
    output.println("chanceToDie "+chanceToDie);
    output.println("maxAge "+maxAge);
    output.println("criticusImageSize "+criticusImageSize);
    output.println("topCriticusImageSize "+topCriticusImageSize);
    output.println("criticusThreshold "+criticusThreshold);
    output.println("criticusThresMultiplicator "+criticusThresMultiplicator);
    output.println("imageToCompare "+imageToCompare);
    output.println();
    for (int i=0; i < difHistory.size(); i++) {
      output.println((i+1)+"\t"+difHistory.get(i));
    }
    output.flush();
    output.close();
  }
}

void calculateSizes() {
  if (9*width<16*height) {
    imgH = width*9/16;
  } else {
    imgH = height;
  }
  imgW = imgH*2/3;
  space = round(imgH*0.04);  
  topEdge = (height-imgH)/2;
  bottomEdge = topEdge+imgH;
  leftEdge = (width-imgH*16/9)/2;
  rightEdge = leftEdge+imgH*16/9;
  previewH = (imgH-space*4)/2;
  previewW = previewH*2/3;
  textSize = space*3/5;
  textSize(textSize);
  textLeftEdge = leftEdge+(imgW+space)*2;
}

String formatTime(long t) {
  int h = int(t/3600000);
  int min = int(t/60000%60);
  int sec = int(t/1000%60);
  return h + ":" + nf(min, 2) + ":" + nf(sec, 2);
}

void saveScreenShot() {
  /*сохраняем скриншот экрана в файл*/
  if (saveImages && lastDiff>difference) { //для ускорения только если новый топ лучше старого
    lastDiff = difference;
    /* сохранение скриншота в каталог и генерация имени с номером поколения в 10-значном числе 
     (например 1 = 0000000001, 123 = 0000000123 и т.п.), чтобы компьютер сортиовал их в правильном порядке */
    save(saveScreenshotPath+nf(generation, 10)+".jpg");
  };
};

void generateHistoryFileName() {
  historyFileName = historyFileName +"-"+ year() +"-"+ month() +"-"+ day() +"-"+ hour() +"-"+ minute() +"-"+ second() + ".txt";
}
