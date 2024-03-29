var uiWebview_SearchResultCount = 0;


function uiWebview_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    if (element) {
        if (element.nodeType == 3) {        // Text node
            while (true) {
                //if (counter < 1) {
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                //(value.split);
                
                //we create a SPAN element for every parts of matched keywords
                var span = document.createElement("span");
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                
                span.setAttribute("class","uiWebviewHighlight");
                span.style.backgroundColor="red";
                span.style.color="black";
                
                uiWebview_SearchResultCount++;    // update the counter
                
                text = document.createTextNode(value.substr(idx+keyword.length));
                element.deleteData(idx, value.length - idx);
                var
                next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
                
            }
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    uiWebview_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
    }
}

// the main entry point to start the search
function uiWebview_HighlightAllOccurencesOfString(keyword) {
    uiWebview_RemoveAllHighlights();
    uiWebview_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively removes the highlights in elements and their childs
function uiWebview_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "uiWebviewHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (uiWebview_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}


// the main entry point to remove the highlights
function uiWebview_RemoveAllHighlights() {
    uiWebview_SearchResultCount = 0;
    uiWebview_RemoveAllHighlightsForElement(document.body);
}


function node2str(node) {
    if (node.parentNode != null) {
        for(var i=0; i<node.parentNode.childNodes.length; i++) {
            if(node.parentNode.childNodes[i].isEqualNode(node)) {
                break;
            }
        }
        return node2str(node.parentNode) + '/' + i;
    } else {
        return '';
    }
}

function range2str(range) {
    return node2str(range.startContainer).replace('/', '') + ':' + range.startOffset + ',' +
    node2str(range.endContainer).replace('/', '') + ':' + range.endOffset;
}

function str2node(str) {
    var strSplit = str.split('/');
    var elem = document;
    
    for(var i=0; i<strSplit.length; i++) {
        elem = elem.childNodes[parseInt(strSplit[i])];
    }
    return elem;
}

function str2range(str) {
    var startContainer = str2node(str.split(',')[0].split(':')[0]);
    var startOffset = parseInt(str.split(',')[0].split(':')[1]);
    var endContainer = str2node(str.split(',')[1].split(':')[0]);
    var endOffset = parseInt(str.split(',')[1].split(':')[1]);
    
    var range = document.createRange();
    range.setStart(startContainer, startOffset);
    range.setEnd(endContainer, endOffset);
    return range;
}

function str2highlight(str) {
    var newNode = document.createElement("span");
    newNode.setAttribute("style", "background-color: yellow;");
    str2range(str).surroundContents(newNode);
}

function hightlight2str() {
    
    var str = range2str(document.getSelection().getRangeAt(0));
    str2highlight(str);
    return str;
}