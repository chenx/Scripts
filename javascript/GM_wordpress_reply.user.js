// ==UserScript==
// @name         Reply to WordPress post automatically. For testing use only.
// @namespace    http://your.homepage/
// @version      0.1
// @description  only support http://www.careerassist.org
// @author       X.C.
// @match        http://cssauh.com/xc/wordpress/?p=1
// @match        http://cssauh.com/xc/wordpress/?p=1#*
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


    var seconds = 5; // seconds to wait before posting reply.
    var timer$ = $('<span/>').html(seconds);
    var go$ = $('<button/>').html('Reply');
    
    box$.append(go$)
        .append('<br/>Time: ')
        .append(timer$);

    $('body').append(box$);
    
    
    // Behavior.
    go$.click(function () {
        wait();
    });
    
    function wait() {
        if (seconds == 0) {
            post();
        }
        else {
            seconds --;
            timer$.html(seconds);
            setTimeout(wait, 1000);
        }
    }
    
    function post() {
        $('#author').val('John Doe');
        $('#email').val('John.Doe@gmail.com');        
        $('#comment').val('Current time is: ' + new Date());
        $('#submit').trigger('click');        
    }
    
    //wait(); // uncomment this to automatically start timer upon page load.
})();

