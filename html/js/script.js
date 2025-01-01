window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'headbag') {
        const displayValue = data.state ? 'block' : 'none';

        const audio = new Audio(data.state ? 'https://files.catbox.moe/ath9jo.mp3' : 'https://files.catbox.moe/ath9jo.mp3');
        audio.volume = 0.10;
        audio.play();

        $('.overlay').css('display', displayValue);
        $('.headbag').css('display', displayValue);
    }
});
