<?php
if(!function_exists('sg_load')){$__v=phpversion();$__x=explode('.',$__v);$__v2=$__x[0].'.'.(int)$__x[1];$__u=strtolower(substr(php_uname(),0,3));$__ts=(@constant('PHP_ZTS') || @constant('ZEND_THREAD_SAFE')?'ts':'');$__f=$__f0='ixed.'.$__v2.$__ts.'.'.$__u;$__ff=$__ff0='ixed.'.$__v2.'.'.(int)$__x[2].$__ts.'.'.$__u;$__ed=@ini_get('extension_dir');$__e=$__e0=@realpath($__ed);$__dl=function_exists('dl') && function_exists('file_exists') && @ini_get('enable_dl') && !@ini_get('safe_mode');if($__dl && $__e && version_compare($__v,'5.2.5','<') && function_exists('getcwd') && function_exists('dirname')){$__d=$__d0=getcwd();if(@$__d[1]==':') {$__d=str_replace('\\','/',substr($__d,2));$__e=str_replace('\\','/',substr($__e,2));}$__e.=($__h=str_repeat('/..',substr_count($__e,'/')));$__f='/ixed/'.$__f0;$__ff='/ixed/'.$__ff0;while(!file_exists($__e.$__d.$__ff) && !file_exists($__e.$__d.$__f) && strlen($__d)>1){$__d=dirname($__d);}if(file_exists($__e.$__d.$__ff)) dl($__h.$__d.$__ff); else if(file_exists($__e.$__d.$__f)) dl($__h.$__d.$__f);}if(!function_exists('sg_load') && $__dl && $__e0){if(file_exists($__e0.'/'.$__ff0)) dl($__ff0); else if(file_exists($__e0.'/'.$__f0)) dl($__f0);}if(!function_exists('sg_load')){$__ixedurl='http://www.sourceguardian.com/loaders/download.php?php_v='.urlencode($__v).'&php_ts='.($__ts?'1':'0').'&php_is='.@constant('PHP_INT_SIZE').'&os_s='.urlencode(php_uname('s')).'&os_r='.urlencode(php_uname('r')).'&os_m='.urlencode(php_uname('m'));$__sapi=php_sapi_name();if(!$__e0) $__e0=$__ed;if(function_exists('php_ini_loaded_file')) $__ini=php_ini_loaded_file(); else $__ini='php.ini';if((substr($__sapi,0,3)=='cgi')||($__sapi=='cli')||($__sapi=='embed')){$__msg="\nPHP script '".__FILE__."' is protected by SourceGuardian and requires a SourceGuardian loader '".$__f0."' to be installed.\n\n1) Download the required loader '".$__f0."' from the SourceGuardian site: ".$__ixedurl."\n2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="\n3) Edit ".$__ini." and add 'extension=".$__f0."' directive";}}$__msg.="\n\n";}else{$__msg="<html><body>PHP script '".__FILE__."' is protected by <a href=\"http://www.sourceguardian.com/\">SourceGuardian</a> and requires a SourceGuardian loader '".$__f0."' to be installed.<br><br>1) <a href=\"".$__ixedurl."\" target=\"_blank\">Click here</a> to download the required '".$__f0."' loader from the SourceGuardian site<br>2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="<br>3) Edit ".$__ini." and add 'extension=".$__f0."' directive<br>4) Restart the web server";}}$__msg.="</body></html>";}die($__msg);exit();}}return sg_load('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');