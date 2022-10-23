var e="undefined"!==typeof navigator&&navigator.userAgent.toLowerCase().indexOf("firefox")>0;function addEvent(e,t,n,r){e.addEventListener?e.addEventListener(t,n,r):e.attachEvent&&e.attachEvent("on".concat(t),(function(){n(window.event)}))}function getMods(e,t){var n=t.slice(0,t.length-1);for(var r=0;r<n.length;r++)n[r]=e[n[r].toLowerCase()];return n}function getKeys(e){"string"!==typeof e&&(e="");e=e.replace(/\s/g,"");var t=e.split(",");var n=t.lastIndexOf("");for(;n>=0;){t[n-1]+=",";t.splice(n,1);n=t.lastIndexOf("")}return t}function compareArray(e,t){var n=e.length>=t.length?e:t;var r=e.length>=t.length?t:e;var o=true;for(var a=0;a<n.length;a++)-1===r.indexOf(n[a])&&(o=false);return o}var t={backspace:8,"⌫":8,tab:9,clear:12,enter:13,"↩":13,return:13,esc:27,escape:27,space:32,left:37,up:38,right:39,down:40,del:46,delete:46,ins:45,insert:45,home:36,end:35,pageup:33,pagedown:34,capslock:20,num_0:96,num_1:97,num_2:98,num_3:99,num_4:100,num_5:101,num_6:102,num_7:103,num_8:104,num_9:105,num_multiply:106,num_add:107,num_enter:108,num_subtract:109,num_decimal:110,num_divide:111,"⇪":20,",":188,".":190,"/":191,"`":192,"-":e?173:189,"=":e?61:187,";":e?59:186,"'":222,"[":219,"]":221,"\\":220};var n={"⇧":16,shift:16,"⌥":18,alt:18,option:18,"⌃":17,ctrl:17,control:17,"⌘":91,cmd:91,command:91};var r={16:"shiftKey",18:"altKey",17:"ctrlKey",91:"metaKey",shiftKey:16,ctrlKey:17,altKey:18,metaKey:91};var o={16:false,18:false,17:false,91:false};var a={};for(var i=1;i<20;i++)t["f".concat(i)]=111+i;var s=[];var f=false;var c="all";var l=[];var d=function code(e){return t[e.toLowerCase()]||n[e.toLowerCase()]||e.toUpperCase().charCodeAt(0)};var u=function getKey(e){return Object.keys(t).find((function(n){return t[n]===e}))};var p=function getModifier(e){return Object.keys(n).find((function(t){return n[t]===e}))};function setScope(e){c=e||"all"}function getScope(){return c||"all"}function getPressedKeyCodes(){return s.slice(0)}function getPressedKeyString(){return s.map((function(e){return u(e)||p(e)||String.fromCharCode(e)}))}function filter(e){var t=e.target||e.srcElement;var n=t.tagName;var r=true;!t.isContentEditable&&("INPUT"!==n&&"TEXTAREA"!==n&&"SELECT"!==n||t.readOnly)||(r=false);return r}function isPressed(e){"string"===typeof e&&(e=d(e));return-1!==s.indexOf(e)}function deleteScope(e,t){var n;var r;e||(e=getScope());for(var o in a)if(Object.prototype.hasOwnProperty.call(a,o)){n=a[o];for(r=0;r<n.length;)n[r].scope===e?n.splice(r,1):r++}getScope()===e&&setScope(t||"all")}function clearModifier(e){var t=e.keyCode||e.which||e.charCode;var r=s.indexOf(t);r>=0&&s.splice(r,1);e.key&&"meta"===e.key.toLowerCase()&&s.splice(0,s.length);93!==t&&224!==t||(t=91);if(t in o){o[t]=false;for(var a in n)n[a]===t&&(hotkeys[a]=false)}}function unbind(e){if("undefined"===typeof e)Object.keys(a).forEach((function(e){return delete a[e]}));else if(Array.isArray(e))e.forEach((function(e){e.key&&y(e)}));else if("object"===typeof e)e.key&&y(e);else if("string"===typeof e){for(var t=arguments.length,n=new Array(t>1?t-1:0),r=1;r<t;r++)n[r-1]=arguments[r];var o=n[0],i=n[1];if("function"===typeof o){i=o;o=""}y({key:e,scope:o,method:i,splitKey:"+"})}}var y=function eachUnbind(e){var t=e.key,r=e.scope,o=e.method,i=e.splitKey,s=void 0===i?"+":i;var f=getKeys(t);f.forEach((function(e){var t=e.split(s);var i=t.length;var f=t[i-1];var c="*"===f?"*":d(f);if(a[c]){r||(r=getScope());var l=i>1?getMods(n,t):[];a[c]=a[c].filter((function(e){var t=!o||e.method===o;return!(t&&e.scope===r&&compareArray(e.mods,l))}))}}))};function eventHandler(e,t,n,r){if(t.element===r){var a;if(t.scope===n||"all"===t.scope){a=t.mods.length>0;for(var i in o)Object.prototype.hasOwnProperty.call(o,i)&&(!o[i]&&t.mods.indexOf(+i)>-1||o[i]&&-1===t.mods.indexOf(+i))&&(a=false);if((0===t.mods.length&&!o[16]&&!o[18]&&!o[17]&&!o[91]||a||"*"===t.shortcut)&&false===t.method(e,t)){e.preventDefault?e.preventDefault():e.returnValue=false;e.stopPropagation&&e.stopPropagation();e.cancelBubble&&(e.cancelBubble=true)}}}}function dispatch(e,t){var i=a["*"];var f=e.keyCode||e.which||e.charCode;if(hotkeys.filter.call(this,e)){93!==f&&224!==f||(f=91);-1===s.indexOf(f)&&229!==f&&s.push(f);["ctrlKey","altKey","shiftKey","metaKey"].forEach((function(t){var n=r[t];e[t]&&-1===s.indexOf(n)?s.push(n):!e[t]&&s.indexOf(n)>-1?s.splice(s.indexOf(n),1):"metaKey"===t&&e[t]&&3===s.length&&(e.ctrlKey||e.shiftKey||e.altKey||(s=s.slice(s.indexOf(n))))}));if(f in o){o[f]=true;for(var c in n)n[c]===f&&(hotkeys[c]=true);if(!i)return}for(var l in o)Object.prototype.hasOwnProperty.call(o,l)&&(o[l]=e[r[l]]);if(e.getModifierState&&!(e.altKey&&!e.ctrlKey)&&e.getModifierState("AltGraph")){-1===s.indexOf(17)&&s.push(17);-1===s.indexOf(18)&&s.push(18);o[17]=true;o[18]=true}var u=getScope();if(i)for(var p=0;p<i.length;p++)i[p].scope===u&&("keydown"===e.type&&i[p].keydown||"keyup"===e.type&&i[p].keyup)&&eventHandler(e,i[p],u,t);if(f in a)for(var y=0;y<a[f].length;y++)if(("keydown"===e.type&&a[f][y].keydown||"keyup"===e.type&&a[f][y].keyup)&&a[f][y].key){var v=a[f][y];var h=v.splitKey;var g=v.key.split(h);var m=[];for(var k=0;k<g.length;k++)m.push(d(g[k]));m.sort().join("")===s.sort().join("")&&eventHandler(e,v,u,t)}}}function isElementBind(e){return l.indexOf(e)>-1}function hotkeys(e,t,r){s=[];var o=getKeys(e);var i=[];var c="all";var u=document;var p=0;var y=false;var v=true;var h="+";var g=false;void 0===r&&"function"===typeof t&&(r=t);if("[object Object]"===Object.prototype.toString.call(t)){t.scope&&(c=t.scope);t.element&&(u=t.element);t.keyup&&(y=t.keyup);void 0!==t.keydown&&(v=t.keydown);void 0!==t.capture&&(g=t.capture);"string"===typeof t.splitKey&&(h=t.splitKey)}"string"===typeof t&&(c=t);for(;p<o.length;p++){e=o[p].split(h);i=[];e.length>1&&(i=getMods(n,e));e=e[e.length-1];e="*"===e?"*":d(e);e in a||(a[e]=[]);a[e].push({keyup:y,keydown:v,scope:c,mods:i,shortcut:o[p],method:r,key:o[p],splitKey:h,element:u})}if("undefined"!==typeof u&&!isElementBind(u)&&window){l.push(u);addEvent(u,"keydown",(function(e){dispatch(e,u)}),g);if(!f){f=true;addEvent(window,"focus",(function(){s=[]}),g)}addEvent(u,"keyup",(function(e){dispatch(e,u);clearModifier(e)}),g)}}function trigger(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:"all";Object.keys(a).forEach((function(n){var r=a[n].find((function(n){return n.scope===t&&n.shortcut===e}));r&&r.method&&r.method()}))}var v={getPressedKeyString:getPressedKeyString,setScope:setScope,getScope:getScope,deleteScope:deleteScope,getPressedKeyCodes:getPressedKeyCodes,isPressed:isPressed,filter:filter,trigger:trigger,unbind:unbind,keyMap:t,modifier:n,modifierMap:r};for(var h in v)Object.prototype.hasOwnProperty.call(v,h)&&(hotkeys[h]=v[h]);if("undefined"!==typeof window){var g=window.hotkeys;hotkeys.noConflict=function(e){e&&window.hotkeys===hotkeys&&(window.hotkeys=g);return hotkeys};window.hotkeys=hotkeys}export{hotkeys as default};

