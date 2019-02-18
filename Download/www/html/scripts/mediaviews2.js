/* 
 * <p>mediaview.js, v1.3, 18 fevrier 2013</p>
 * Version 1.3 passage à JQuery 1.9 + migrate et ajout de tooltip.js  
 * Copyright (c) 2013 Bertin Technologies, Consulting Dpt.
 * Information and Content Processing Activity.
 * All rights reserved. Use is subject to license terms.
 * 
 * BERTIN TECHNOLOGIES PROPRIETARY/CONFIDENTIAL.
 * 
 * @author <a href="mailto:bouzerna@bertin.fr">Nabil Bouzerna</a>
 * 
 */

/**
 * fonction en charge d'allumer un terme
 */
jQuery.fn.highlight = function(pat) {
    function innerHighlight(node, pat) {
        var skip = 0;
        if (node.nodeType == 3) {
            var expression = new RegExp('\\s'+ pat + '\\s', 'i');
            var pos = node.data.search(expression);
            //var pos = node.data.indexOf(pat);
            if (pos >= 0) {
                var spannode = document.createElement('span');
                spannode.className = 'high';
                var middlebit = node.splitText(pos+1);
                middlebit.splitText(pat.length);
                var middleclone = middlebit.cloneNode(true);
                spannode.appendChild(middleclone);
                middlebit.parentNode.replaceChild(spannode, middlebit);
                skip = 1;
            }
        }
        else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
            for (var i = 0; i < node.childNodes.length; ++i) {
                i += innerHighlight(node.childNodes[i], pat);
            }
        }
        return skip;
    }
    return this.each(function() {
        innerHighlight(this, pat);
    });
};


/**
 * fonction en charge de supprimer les highlight courant
 */
jQuery.fn.removeHighlight = function() {
    return this.find("span.high").each(function() {
        with (this.parentNode) {
            replaceChild(this.firstChild, this);
            normalize();
            }
    }).end();
};
            

// TODO synchro du résumé vidéo       
var timeshot = [0, 3, 8, 14, 19, 25, 29, 37]; 
var index = 1;           
var paused=true;
var elapsed ;
var PlayerPosition;
/**
 * scan régulier lors de la lecture d'un vidéo pour conserver la synchro
 * entre la parole et la traduction 
 */                 
function updateValues(data) {
    //on regarde si la position a changé et qu'on est toujours en play
    if (PlayerPosition == playerInstance.getPosition())
    {
      if (playerInstance.getState('PLAYING'))
          elapsed = elapsed + 1; //le timeout est à 1s
    }
    else
    {
      elapsed = playerInstance.getPosition();
      PlayerPosition = elapsed;
    }
      
    highlight(elapsed);
    //console.log("pos="+elapsed);
  
    if (playerInstance.getState('PLAYING'))
      setTimeout("updateValues()",1000); 
}

         
/**
 *
 */                    
var speechhighlighted;
var transhighlighted;                       
function highlight(second) 
{
        var pos = Math.round(second);
        var parent, fullOffset;
        var selectors = $("#speech2text p span.audiounit"+pos);
        if (selectors.size() >= 1) 
        {
            if (speechhighlighted != null) 
            {
                speechhighlighted.removeClass("highlight");
            }
            speechhighlighted = selectors.addClass("highlight");
            parent = speechhighlighted.parent().parent().stop();
            fullOffset = (speechhighlighted.offset().top + parent.scrollTop()) - parent.offset().top;
            parent.animate({
                scrollTop: fullOffset-30
            }, 350);
        }
        

}
           
          
// gestion des boutons et évenements pour les boutons metadata, 
// video summerization, tag cloud, 
$(function() {
    $( "#speech2text" ).dblclick(function(event) {
        event.stopPropagation();
        var targ;
                   
        if (event.target) 
          targ = event.target;
        else if (event.srcElement) 
          targ = e.srcElement;
        
        if (targ.nodeType == 3) // defeat Safari bug
            targ = targ.parentNode;
          
        //en ajoutant la couleur du mots on arrive ici sur la balise font au lieu de classunit
        targ = targ.parentNode;
        var time = targ.className.replace("audiounit","");
        if("high" == time)
        {// cas d'un terme higlighhter
            targ = targ.parentNode; 
            time = targ.className.replace("audiounit","");
        }
        highlight(time);
        
        console.log("setPlayhead="+time);
        playerInstance.setPlayhead(parseInt(time));
        //playerInstance.setPlayhead("+60");

    });
                    
    $( "#speech2text").show();

  });



/**
 * Ensemble des fonction à la fin de la création de la page
 * Instanciation et paramtérage de tagcloud
 */
$(document).ready(function(){

    $('.tooltip').tooltipster({
        animation: 'fade',
        arrow: true,
        arrowColor: '',
        content: '',
        delay: 0,
        fixedWidth: 200,
        maxWidth: 350,
        functionBefore: function(origin, continueTooltip) {
            continueTooltip();
        },
        functionReady: function(origin, tooltip) {},
        functionAfter: function(origin) {},
        icon: '(?)',
        iconDesktop: false,
        iconTouch: true,
        iconTheme: '.tooltipster-icon',
        interactive: true,
        interactiveTolerance: 1000,
        offsetX: 0,
        offsetY: 75,
        onlyOne: true,
        position: 'top',
        speed: 100,
        timer: 0,
        theme: '.tooltipster-default',
        touchDevices: true,
        trigger: 'hover',
        updateAnimation: true
    });

});
     


