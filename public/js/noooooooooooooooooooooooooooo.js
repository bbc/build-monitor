    if (document.querySelector){
        // play some audio when we detect a red build
        var el = document.querySelector(".red");
        if (el && (Math.random() * 100 >> 0) === 1) { // only play sound every once in a while, as it's fairly annoying ~ once every 30 minutes
            document.getElementById('audio').innerHTML = '<audio src="/mp3/noooooooooooooooo.mp3?" id="nooooo">Your browser does not support the <code>audio</code> element.</audio>';
            document.getElementById("nooooo").play();
        }   
    }
