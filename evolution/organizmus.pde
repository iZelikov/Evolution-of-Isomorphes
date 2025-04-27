class Organizmus {
  ArrayList<Gene> dna = new ArrayList<Gene>(); 
  ArrayList<Gene> orderToDraw;
  int age=0;
  HashMap<Integer,Long> rate = new HashMap<Integer,Long>();

  /* генерирование нового организмуса, в котором numberOfGenes генов типа formTypeSettings */
  void generate(int numberOfGenes) {
    Gene g;
    for (int i=0; i < numberOfGenes; i++) {
      g = new Gene(formTypeSettings);
      dna.add(g);
    }
  }

  /* функция создания организмуса о, аналогичного данному */
  Organizmus copy() {
    Organizmus o = new Organizmus();
    Gene g;
    for (int i=0; i < dna.size(); i++) {
      g = dna.get(i).copy();
      o.dna.add(g);
    }    
    return o;
  }
  /* функция полового размножения */
  Organizmus sex(Organizmus parthner) {
    Organizmus child = new Organizmus();
    int n = min(dna.size(), parthner.dna.size());
    int crossingoverPosition = floor(random(n));
    for (int i=0; i < crossingoverPosition; i++) {
      child.dna.add(dna.get(i).copy());
    }
    for (int i=crossingoverPosition; i < parthner.dna.size(); i++) {
      child.dna.add(parthner.dna.get(i).copy());
    }     
    return child;
  }

  /* функция рисования */
  PImage draw(PGraphics pg) {
    if (orderToDraw == null) {
      generateOrder();
    }
    return draw(pg,orderToDraw.size());
  }
  
  PImage draw(PGraphics pg, int n){
    if (orderToDraw == null) {
      generateOrder();
    }
    pg.beginDraw();
    pg.noStroke();
    pg.rectMode(CENTER);
    pg.clear();
    pg.background(bgColor);
    for (int i=0; i < n; i++) {
      orderToDraw.get(i).draw(pg);
    }
    pg.endDraw();
    PImage img = pg.get();
    return img;
  }
  /* функция мутации генов */
  void geneMutate(float chanceToMutateGene, float maxDispersion) {
    for (int i=0; i < dna.size(); i++) {
      if (random(1)<chanceToMutateGene) {
        dna.get(i).mutate(maxDispersion);
      }
    }
  }
  /* функция хромосомной мутации */
  void chromosomeMutate(float chanceToMutateChromosome, float maxDispersion) {
    if (random(1)<chanceToMutateChromosome) {
      int dice=floor(random(3));
      switch(dice) {
      case ADD:
        addGene(maxDispersion);
        break;
      case REPLACE:
        replaceGene(maxDispersion);
        break;
      case REMOVE:
        removeGene();
        break;
      default: 
        break;
      }
    }
  }
  /* функция добавления рандомного гена или мутированной копии другого в конец днк */
  void addGene(float maxDispersion) {
    Gene g;
    if (random(2)>1) {
      g = new Gene(formTypeSettings);
    } else {
      int geneNumber = floor(random(dna.size()));
      g = dna.get(geneNumber).copy();
      g.mutate(maxDispersion);
    }
    dna.add(g);
  }
  /* функция замены гена рандомным или мутированной копией другого */
  void replaceGene(float maxDispersion) {
    Gene g;
    if (random(2)>1) {
      g = new Gene(formTypeSettings);
    } else {
      int geneNumber = floor(random(dna.size()));
      g = dna.get(geneNumber).copy();
      g.mutate(maxDispersion);
    }
    int geneNumber = floor(random(dna.size()));
    dna.set(geneNumber, g);
  }
  /* функция удаления гена */
  void removeGene() {
    if (dna.size()>1) {
      int geneNumber = floor(random(dna.size()));
      dna.remove(geneNumber);
    }
  }
  /* создание отсортированного списка генов по позиции */
  void generateOrder() {
    orderToDraw = new ArrayList<Gene>();
    for (int i=0; i < dna.size(); i++) {
      if (dna.get(i).visible) {
        orderToDraw.add(dna.get(i));
      }
    }
    orderToDraw.sort(positionComparator); //сортировка по позиции
  }
}
