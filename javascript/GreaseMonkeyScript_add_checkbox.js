// ==UserScript==
// @name       script name
// @namespace  http://my.homepage/
// @version    0.1
// @description  add marking checkbox.
// @match      http://matched_website.com
// @match      https://matched_website.com
// ==/UserScript==

function changhandler(event) {
    if (event.target.checked) {
        localStorage[event.target.name] = true;
    } else {
        localStorage.removeItem(event.target.name);
    }
}

[].forEach.call(
    document.getElementById('main').getElementsByTagName('li'),
    function(e) {
        var checkBox = document.createElement('input');
        checkBox.type = 'checkbox';
        checkBox.name = e.getElementsByTagName('a')[0].innerHTML;
        checkBox.checked = localStorage[e.getElementsByTagName('a')[0].innerHTML];
        checkBox.addEventListener('change', changhandler, false);
        oj.insertBefore(checkBox, null);
    }
); 
