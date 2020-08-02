let txt;
let b;

function preload() {
    txt = loadStrings('assets/short-stories/carne-empalada-rodrigo-junqueira.txt');
}

function setup() {
    createCanvas(600,600);
    colorMode(HSB,360,100,100,100);

    // create palette
    let palette = [];
    let alpha = 100;
    palette.push(color(44, 62, 96, alpha));
    palette.push(color(60, 3, 14, alpha));
    palette.push(color(150, 5, 86, alpha));

    // new book
    b = new Book("Carne\nEmpalada","Rodrigo Junqueira",txt,createVector(300,400,10),palette);
    b.parseTxt();
    b.generateArt();

}

function draw() {
    background(90);
    translate(width/2-b.getDimensions().x/2,height/2-b.getDimensions().y/2);
    b.show();
    noLoop();

}