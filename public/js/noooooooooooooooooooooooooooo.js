
    // play some audio when we detect a red build
    var el = document.querySelector(".red");
	if (el) {
        document.getElementById('audio').innerHTML = '<audio src="/mp3/noooooooooooooooo.mp3" loop="false" id="nooooo">Your browser does not support the <code>audio</code> element.</audio>';
        document.getElementById("nooooo").play();
    }   
    
