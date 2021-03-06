function Cover(book) {
    this.book = book;
    this.art = createGraphics(this.book.getDimensions().x,this.book.getDimensions().y);
    this.title = createGraphics(this.book.getDimensions().x/2,this.book.getDimensions().y/2);

    this.show = function() {
        image(this.art, 0, 0);
        image(this.title,random(50,150),random(50,150));
    }

    this.generate = function() {
        this.generateArt();
        this.generateTitle();
    }

    this.generateTitle = function() {
        // lots to re-do here
        let title = this.book.getTitle();
        let author = this.book.getAuthor();
        this.title.background(156, random(255), 184);
        this.title.fill(255);
        this.title.textAlign(RIGHT);
        this.title.textFont('Georgia');
        this.title.textSize(32);
        this.title.text(title,146,50);
        this.title.textSize(15);
        this.title.fill(0,0,0,90);
        this.title.text(author,140,64);
        this.title.noStroke();
    }

    this.generateArt = function() {
        
        let sentences = this.book.getSentences();
        let longestSentenceSize = this.book.getLongestSentenceSize();
        let palette = this.book.getPalette();

        this.art.background(255);
        this.art.colorMode(HSB,360,100,100,100);

        this.art.noStroke();

        let x = 0;
        let y = 0;

        // vertical
        let w = ceil(random(10,50));
        let h = ceil(random(1,5));

        while(x <= this.book.getDimensions().x) {
            for (let i = 0; i < sentences.length; i++) {
                let size = sentences[i].length;
                let hue = round(map(size,0,longestSentenceSize,0,palette.length-1));
                this.art.fill(palette[hue]);        
                for (let j = 0; j < sentences[i].length; j++) {
                    this.art.rect(x,y,w,h);
                    y += h;
                    if (y >= this.book.getDimensions().y) {
                        y = 0;
                        x += w;
                    }
                }
            }
        }

        // ideias
        // - vertical
        // - arcos
        // - horizontal
        // - paralelograma
        // - perlin noise para shiftar linhas
        // - combinar padrões com alpha
        // let w = ceil(random(1,5));
        // let h = ceil(random(10,50));
        // while(y <= this.book.getDimensions().y) {
        //     for (let i = 0; i < sentences.length; i++) {
        //         let size = sentences[i].length;
        //         let hue = round(map(size,0,longestSentenceSize,0,palette.length-1));
        //         this.art.fill(palette[hue]);        
        //         for (let j = 0; j < sentences[i].length; j++) {
        //             this.art.rect(x,y,w,h);
        //             x += w;
        //             if (x >= this.book.getDimensions().x) {
        //                 x = 0;
        //                 y += h;
        //             }
        //         }
        //     }
        // }
    }
}