window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'headbag') {
        const displayValue = data.state ? 'block' : 'none';

        const audio = new Audio('./audio/headbag.mp3');
        audio.volume = 0.10;
        audio.play();

        $('.overlay').css('display', displayValue);
        $('.headbag').css('display', displayValue);
    }
});
