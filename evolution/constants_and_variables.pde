final int RANDOM = 3, ELLIPSE = 0, RECTANGLE = 1, TRIANGLE = 2;
final int ADD = 0, REPLACE = 1, REMOVE = 2;
final int CLONE = 577889, SEXUAL = 12345;
final int MENU = 0, SETTINGS = 1, CHOOSING_IMAGE = 2, EVOLUTION = 3, LOADING = 4; //main stances
final int NORMAL_EVOLUTION = 0, REVIEW_EVOLUTION = 1, STEP_BY_STEP_DRAWING = 2; //evolution subStances
final String LOADING_IMG = "img/loading.jpeg",
             CAT = "img/cat.jpg", 
             MONALIZA = "img/monaliza.jpg", 
             SNEGOVIK = "img/snegovik.png", 
             DARWIN = "img/darwin.jpg", 
             VIVA_LA_EVOLUCION = "img/evolucion.png",
             PICASSO_CAT = "img/picasso-cat.jpg",
             IMPRESSIONISM = "img/impressionism.jpg",
             TROGLODYTUS = "img/troglodytus.png",
             BUTTON = "img/button.png";
final String savesPath = "data/saves/";

Runtime runtime = Runtime.getRuntime(); // объект для доступа к информации об используемой памяти и пр.
int nextCriticusID = 0; // id (номер), который будет присвоен следующему критикусу

boolean gameOver = false, evolutionStarted = false, interfaceReady = false;

color bgColor = color(0);
String[] ext = {"jpg","jpeg","gif","png","bmp","tga"};

Population population;
//ArrapopulationsList;  // массив популяций
Criticus criticus, topCriticus; //критикус
Organizmus top;
PImage targetImage, topImage, smallTopImage, leftImage, rightImage; // объекты для хранения картинок, выводимых на экран
PGraphics topPG; //PGraphics, на которм мы рисуем лучшую картинку
int imgW, imgH, previewW, previewH, space, textSize; //размеры отображаемых картинок и отступы, размер текста
int topEdge, bottomEdge, leftEdge, rightEdge; //координаты прямоугольника 16/9, в области которого мы рисуем все
int textLeftEdge;
int generation = 0; //поколение
long difference = 0, curDiff = 0, lastDiff = 0;
int currentCriticusSize, topCriticusSize, topDnaSize;
long startEvolutionTime, totalTime, t, oneGenerationTime; //время выполнения (например, nextGeneration)

int gameStance = LOADING; //состояние игры (какое окошко выведено)
int evolutionSubStance = NORMAL_EVOLUTION; //что выводим на основной эволюционный экран

int step = 0; //внутренний счетчик для методов reviewEvolution и stepByStepDrawing

color markedButtonColor = color(200,100,0);
ArrayList<Control> controls, menuControls, settingsControls, choosingControls, evolutionControls;
Button backToMenuButton;

//menu buttons
Button startButton, continueButton, settingsButton, helpButton, exitButton;

//settings controls
ButtonsGroup formTypeGroup, reproductionTypeGroup;
ImageButton ellipseButton, rectButton, triangleButton, allTypesButton;
Slider numOfGenesSlider, popSizeSlider, numOfChildrenSlider, crSizeSlider, crThresholdSlider, 
       geneMutChanceSlider, chrMutChanceSlider, maxDispersionSlider, chanceToDieSlider, maxAgeSlider;
Button sexsualButton, cloneButton, restoreDefaultButton, saveSettingsButton;

//choosingImage buttons
ImageButton imgButton1, imgButton2, imgButton3, imgButton4, imgButton5, imgButton6, imgButton7, imgButton8;
Button openImageButton;

//evolution buttons
Button topHistoryButton, stepByStepButton;

LongList difHistory; //массив всех топдифференсов на протяжении эволюции

/* создание компаратора, который умеет сортировать гены по позиции */
PositionComparator positionComparator = new PositionComparator(); 
