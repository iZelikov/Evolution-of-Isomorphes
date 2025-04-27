import java.util.Comparator; //подгружаем библиотеку, из которой узнаем, что такое компаратор
import java.util.Arrays;

void setup() {
  fullScreen();
  //size(600,800);
  background(0);
  thread("initInterface");  
  /* генерация популяций и создание критикуса */
  /* to do перенести все это на реакцию кнопки старт */
}

void draw() {
  if (testMode) {
    runTests();
  } else {
    /* смена поколений в популяции (размножение, мутации, естественный отбор и т. п.) */
    //t = millis();
    //nextGeneration(population); 
    //t = millis()-t;
    updateInterface();
  }
}

void keyPressed() {
  if (key == ESC && gameStance != LOADING) { 
    key = 0;
    gameStance = MENU;
  }
}
