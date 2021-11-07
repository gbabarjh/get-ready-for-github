int lifetime;
int lifeCounter;
PVector target;
Population population;
void setup(){
  size(800,200);
  smooth();
  lifetime=200;
  lifeCounter=0;
  target=new PVector(width/2,24);
  population =new Population(0.01,50);
}
void draw(){
  background(255);
  fill(0);
  ellipse(target.x,target.y,24,24);
  if (lifeCounter<lifetime){
    population.live();
    lifeCounter++;
  }else{
    lifeCounter=0;
    population.fitness();
    population.selection();
    population.reproduction();
  }
  fill(0);
  text("child #:"+population.getGenerations(),10,18);
   text("round#:"+(lifetime-lifeCounter),10,36);
}
void mousePressed(){
  target.x=mouseX;
    target.y=mouseY;
}
class DNA {
PVector[]genes;
float maxforce =0.1;

  DNA() {
    genes = new PVector[lifetime];
    for (int i = 0; i < genes.length; i++) {
      genes[i] =PVector.random2D();
       genes[i].mult(random(0,maxforce));
    }
  }
   DNA crossover(DNA partner) {
    PVector[] child = new PVector[genes.length];
    int crossover = int(random(genes.length));
    for (int i = 0; i < genes.length; i++) {
      if (i > crossover) child[i] = genes[i];
      else               child[i] = partner.genes[i];
    }
    DNA newgenes = new DNA(child);
    return newgenes;
  }
   void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
         genes[i] = new PVector(cos(random(TWO_PI)),sin(random(TWO_PI)));
           genes[i] .mult(random(0,maxforce));
      }
    }
  }
    DNA(PVector[] newgenes) {
    genes = newgenes;
  }
}
class Rocket{
  DNA dna;
  boolean hitTarget=false;
  float r;
  float fitness;
  int geneCounter =0;
  PVector location;
    PVector velocity;
      PVector acceleration;
      
      Rocket(PVector l, DNA dna_){
        acceleration=new PVector();
        velocity =new PVector();
        location =l.get();
        r=4;
        dna =dna_;
      }
      void applyForce2(PVector f){
        acceleration.add(f);
      }
      void update(){
        velocity.add(acceleration);
        location.add(velocity);
        acceleration.mult(0);
      }
      void fitness(){
        float d=dist (location.x,location.y,target.x,target.y);
        fitness= pow(1/d,2);
      }
   void   display(){
        float theta =velocity.heading2D()+PI/2;
        fill(200,100);
        stroke(0);
        pushMatrix();
        translate(location.x,location.y);
        rotate(theta);
        rectMode(CENTER);
        fill(0);
        rect(-r/2,r*2,r/2,r);
         rect(r/2,r*2,r/2,r);
         fill(175);
         beginShape(TRIANGELES);
         vertex(0,-r*2);
            vertex(-r,r*2);
               vertex(r,r*2);
               endShape();
               popMatrix();
      }
      void checkTarget(){
        float d =dist (location.x, location.y,target.x,target.y);
        if(d<12){
          hitTarget=true;
        }
      }
      
      void run(){ 
         checkTarget();
         if(!hitTarget){
        applyForce2(dna.genes(geneCounter));
        geneCounter=(geneCounter +1)%dna.genes.length;
        update();
      }
      display();
}
float getFitness(){
  return fitness;
}
class Population{
  float mutationRate;
  Rocket[]population;
  ArrayList<Rocket>matingPool;
  int gennerations;
  Population(float m, int num){
    mutationRate=m;
    population=new Rocket[num];
    matingPool=new ArrayList<Rocket>();
    generations=0;
    for(int i=0;i<population.length;i++){
      PVector location=new PVector (width/2,height+20);
      population[i]=new Rocket (location,new DNA());
    }
  }
  void live(){
    for(int i=0; i<population.length;i++){
      population[i].run();
    }
  }
  
  void fitness(){
    for(int i=0; i<population.length;i++){
         population[i].fitness();
  }
  }
  void selection(){
  matingPool.clear();
  float maxFitness=getMaxFitness();
   for(int i=0; i<population.length;i++){
      float fitnessNormal= map(population[i].getFitness(),0,maxFitness,0,1);
      int n= (int)(fitnessNormal*100);
      for(int j=0; j<n;j++){
        matingPool.add(population[i]);
      }
  }
  }
  void reproduction(){
      for(int i=0; i<population.length;i++){
        int m=int(random(matingPool.size()));
               int d=int(random(matingPool.size()));
               Rocket mom=matingPool.get(m);
                       Rocket dad=matingPool.get(d);
                       DNA momgenes=mom.getDNA();
                       DNA dadgenes=dad.getDNA();
                       chid.mutate(mutationRate);
                       PVector location =newPVector(width/2,height+20);
                       population[i]=new Rocket(location,child);
  }
  generations++;
}
float getMaxFitness(){
  flaot record=0;
    for(int i=0; i<population.length;i++){
      if(population[i].getFitness()>record){
        record=population[i].getFitness();
      }
    }return record;
}
int getGenerations(){
  return generations;
}
}
