// ==UserScript==
// @name         WordPress Replybot
// @namespace    http://your.homepage/
// @version      0.1
// @description  Reply to WordPress post automatically. For testing use only.
// @author       X.C.
// @match        http://mysite.com/wordpress/?p=1
// @match        http://mysite.com/wordpress/?p=1#*
// @require      http://code.jquery.com/jquery-latest.js
// ==/UserScript==

(function () {
    if (top !== window) {
        return false;
    }
    
    // UI.
    var box$ = $('<div/>').css({
        'position': 'fixed',
        'top': 100,
        'right': 0,
        'background': '#fff',
        'border': '2px solid red',
        'padding': 10,
        'lineHeight': '30px',
        'z-index': 100
    });


    var seconds = 3; // seconds to wait before posting reply.
    var time$ = $('<span/>').html(seconds);
    var go$ = $('<button/>').html('Reply');
    
    box$.append(go$)
        .append('<br/>Timer: ')
        .append(time$);

    $('body').append(box$);
    
    // Behavior.
    go$.click(function () {
        go$.prop('disabled', true);
        timer();
    });
    
    function timer() {
        if (seconds == 0) {
            post();
        }
        else {
            seconds --;
            time$.html(seconds);
            setTimeout(timer, 1000);
        }
    }
    
    function post() {
        $('#author').val('John Doe');
        $('#email').val('John.Doe@gmail.com');        
        $('#comment').val('Current time is: ' + new Date());
        $('#submit').trigger('click');        
    }
    
    //timer(); // uncomment this to automatically start timer upon page load.
})();


