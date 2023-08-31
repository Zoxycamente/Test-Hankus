package meta.state.menus; //isso aqui foi feito com o clyde, do discord

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import lime.app.Application;

class GalleryState extends FlxState {
    var images:Array<FlxSprite>;
    var currentIndex:Int;

    override public function create():Void {
        // Adicione o fundo
        var background:FlxSprite = new FlxSprite(0, 0).loadGraphic("assets/images/gallery/background.png");
        add(background);

        // Inicialize as imagens e descrições
        images = [];
        for (i in 0...5) {
            var image:FlxSprite = new FlxSprite(100 + (i * 100), 100).loadGraphic("assets/images/gallery/image" + (i + 1) + ".png");
            images.push(image);
        }

        currentIndex = 0;

        Application.current.window.title = "Friday Night Funkin': V.S Hankus 2023 Remake - Gallery";

        // Exiba a imagem e a descrição atual
        add(images[currentIndex]);
        var currentDescription:FlxText = new FlxText(100, 250, FlxG.width - 200, getDescription(currentIndex));
        add(currentDescription);

        // Adicione os botões de navegação
        var prevButton:FlxButton = new FlxButton(50, 300, "<", navigatePrev);
        var nextButton:FlxButton = new FlxButton(FlxG.width - 50, 300, ">", navigateNext);
        add(prevButton);
        add(nextButton);
    }

    public function getDescription(index:Int):String {
        // Retorne a descrição correspondente ao índice da imagem
        switch (index) {
            case 0: return "placeholder irado";
            case 1: return "fotinha de perfil irada";
            case 2: return "hankus do deko";
            case 3: return "hankus do zezo";
            case 4: return "PAREM";
            default: return "";
        }
    }

    public function navigatePrev():Void {
        // Navegue para a imagem anterior
        currentIndex--;
        if (currentIndex < 0) {
            currentIndex = images.length - 1;
        }

        // Atualize a exibição da imagem e descrição
        remove(images[currentIndex + 1]);
        add(images[currentIndex]);
        var currentDescription:FlxText = new FlxText(100, 250, FlxG.width - 200, getDescription(currentIndex));
        add(currentDescription);
    }

    public function navigateNext():Void {
        // Navegue para a próxima imagem
        currentIndex++;
        if (currentIndex >= images.length) {
            currentIndex = 0;
        }

        // Atualize a exibição da imagem e descrição
        remove(images[currentIndex - 1]);
        add(images[currentIndex]);
        var currentDescription:FlxText = new FlxText(100, 250, FlxG.width - 200, getDescription(currentIndex));
        add(currentDescription);
    }
}