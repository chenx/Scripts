// ==UserScript==
// @name         Remove WordPress Spam
// @namespace    http://your.homepage/
// @version      0.1
// @description  only support http://www.careerassist.org
//               This scripts removes comments of WordPress by automatically
//               checking relevant form elements and submit the form.
//               This applies when, for example, you have not setup a captcha 
//               on your WordPress site yet, and all your comments are spam.
//               To use this script:
//               1) set value of "max_trash_count" below.
//               2) uncomment "return" on line 54.
// @author       X. Chen, 8/31/2015
// @match        http://www.careerassist.org/news/wp-admin/edit-comments.php
// @match        http://www.careerassist.org/news/wp-admin/edit-comments.php?paged=1&ids=*
// @require      http://code.jquery.com/jquery-latest.js
// ==/UserScript==

(function () {
    // avoid iframe load
    if (top !== window) {
        return false;
    }

    // Set this value when you start.
    // Delete stops when trash count reaches this number.
    var max_trash_count = 2000;

    // replace ',' with '', so number in format '1,300' is converted to '1300'.
    var trash_count = parseInt( $('.trash-count').html().replace(',', '') );
    //alert(trash_count);
    //return;

    var box$ = $('<div/>').css({
        'position': 'fixed',
        'top': 100,
        'right': 0,
        'background': '#fff',
        'border': '2px solid red',
        'padding': 10,
        'lineHeight': '30px'
    });
    var timer = 5;
    var time$ = $('<input type="text" id="txtTimer" style="width:100px;"/>').val(timer);
    
    box$.append('Start Time: ')
            .append(time$)
            .append(' seconds ')
            .append('<br/>Max trash count: ' + max_trash_count)
            .append('<br/>Current trash count: ' + trash_count);

    $('body').append(box$);
    
    //return; // uncomment this for use.
    
    if (! do_stop()) {
        do_delete();
    }

   
    function do_stop() {
        return trash_count >= max_trash_count;
    }

    function do_delete() {       
        console.log('go..');
        
        if (timer == 0) {
           console.log('now delete.. ');
           //$('#cb-select-all-1').attr('checked', true);
           $('#cb-select-all-1').trigger('click');
           $('#bulk-action-selector-top').val('trash');
           $('#doaction').trigger('click');
        }
        else {
            -- timer;
            $('#txtTimer').val(timer);
            
            handler = setTimeout(function() { do_delete(); }, 1000);
        }        
    }

})();
