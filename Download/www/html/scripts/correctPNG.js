function correctPNG(img) // correctly handle PNG transparency in Win IE 5.5 or higher.
   {
	  var thisName = img.src.toUpperCase();
	  if (thisName.substring(thisName.length-3, thisName.length) == "PNG")
	     {
		 var imgID = (img.id) ? "id='" + img.id + "' " : "";
		 var imgClass = (img.className) ? "class='" + img.className + "' " : "";
		 var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' ";
		 var imgStyle = "display:inline-block;" + img.style.cssText ;
		 if (img.align == "left") imgStyle = "float:left;" + imgStyle;
		 if (img.align == "right") imgStyle = "float:right;" + imgStyle;
		 var strNewHTML = "<p " + imgID + imgClass + imgTitle
		 + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
	     + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
		 + "(src=\'" + img.src + "\', sizingMethod='scale');\"></p>" ;
		 img.outerHTML = strNewHTML;
	}

   }