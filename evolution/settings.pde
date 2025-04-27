boolean testMode = false; //включает/выключает режим тестирования 
int formTypeSettings = RECTANGLE; //тип генерируемых форм генов (RANDOM, ELLIPSE, RECTANGLE, TRIANGLE)
int reproductionType = SEXUAL; //тип размножения (CLONE - бесполое, SEXUAL - половое)

float formTypeChanceToMutate = 0.2; //шанс гена поменять свой тип формы при мутации 
float visiabilityChanceToMutate = 0.2; //шанс гена выключиться при мутации 
int numberOfOrganizmusInPopulation = 30; //число организмусов в популяции
int numberOfChildren = 25; //число потомков каждого организмуса за одно поколение
int numberOfGenesInOrganizmus = 1; //число генов в новом организмусе
float chanceToMutateGene = 0.003; //шанс мутации гена (цвет, положение, размер)
float chanceToMutateChromosome = 0.2; //шанс мутации числа генов в днк
float maxDispersion = 0.3; //максимальная величина, на которую может мутировать ген
float chanceToDie = 0.1; //шанс организмуса случайно умереть
int maxAge = 5; //максимальный возраст организмуса (после этого она умирает) 
int criticusImageSize = 16; //размер картинки, когда критикус ее сравнивает (в пикселях)
int topCriticusImageSize = 512; //размер картинки, с которой сравнивает топкритикус, чтобы посчитать difference для топкартинки 
int criticusThreshold = 1000; //порог difference, после которого критикус удваивает свой размер
float criticusThresMultiplicator = 1.5; 
String imageToCompare = CAT; //картинка, к которой стремимся (CAT, MONALIZA, SNEGOVIK, DARWIN, VIVA_LA_EVOLUCION) 

int stepByStepDelay = 100;

boolean saveHistory = false;
int autoSaveCount = 500; //количество поколений, после которого мы сохраняем diffenerce в файл
String historyFileName = "../output/history"; 

boolean saveImages = false;
String saveScreenshotPath = "../output/img/";
