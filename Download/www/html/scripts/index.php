<?php
if(!function_exists('sg_load')){$__v=phpversion();$__x=explode('.',$__v);$__v2=$__x[0].'.'.(int)$__x[1];$__u=strtolower(substr(php_uname(),0,3));$__ts=(@constant('PHP_ZTS') || @constant('ZEND_THREAD_SAFE')?'ts':'');$__f=$__f0='ixed.'.$__v2.$__ts.'.'.$__u;$__ff=$__ff0='ixed.'.$__v2.'.'.(int)$__x[2].$__ts.'.'.$__u;$__ed=@ini_get('extension_dir');$__e=$__e0=@realpath($__ed);$__dl=function_exists('dl') && function_exists('file_exists') && @ini_get('enable_dl') && !@ini_get('safe_mode');if($__dl && $__e && version_compare($__v,'5.2.5','<') && function_exists('getcwd') && function_exists('dirname')){$__d=$__d0=getcwd();if(@$__d[1]==':') {$__d=str_replace('\\','/',substr($__d,2));$__e=str_replace('\\','/',substr($__e,2));}$__e.=($__h=str_repeat('/..',substr_count($__e,'/')));$__f='/ixed/'.$__f0;$__ff='/ixed/'.$__ff0;while(!file_exists($__e.$__d.$__ff) && !file_exists($__e.$__d.$__f) && strlen($__d)>1){$__d=dirname($__d);}if(file_exists($__e.$__d.$__ff)) dl($__h.$__d.$__ff); else if(file_exists($__e.$__d.$__f)) dl($__h.$__d.$__f);}if(!function_exists('sg_load') && $__dl && $__e0){if(file_exists($__e0.'/'.$__ff0)) dl($__ff0); else if(file_exists($__e0.'/'.$__f0)) dl($__f0);}if(!function_exists('sg_load')){$__ixedurl='http://www.sourceguardian.com/loaders/download.php?php_v='.urlencode($__v).'&php_ts='.($__ts?'1':'0').'&php_is='.@constant('PHP_INT_SIZE').'&os_s='.urlencode(php_uname('s')).'&os_r='.urlencode(php_uname('r')).'&os_m='.urlencode(php_uname('m'));$__sapi=php_sapi_name();if(!$__e0) $__e0=$__ed;if(function_exists('php_ini_loaded_file')) $__ini=php_ini_loaded_file(); else $__ini='php.ini';if((substr($__sapi,0,3)=='cgi')||($__sapi=='cli')||($__sapi=='embed')){$__msg="\nPHP script '".__FILE__."' is protected by SourceGuardian and requires a SourceGuardian loader '".$__f0."' to be installed.\n\n1) Download the required loader '".$__f0."' from the SourceGuardian site: ".$__ixedurl."\n2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="\n3) Edit ".$__ini." and add 'extension=".$__f0."' directive";}}$__msg.="\n\n";}else{$__msg="<html><body>PHP script '".__FILE__."' is protected by <a href=\"http://www.sourceguardian.com/\">SourceGuardian</a> and requires a SourceGuardian loader '".$__f0."' to be installed.<br><br>1) <a href=\"".$__ixedurl."\" target=\"_blank\">Click here</a> to download the required '".$__f0."' loader from the SourceGuardian site<br>2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="<br>3) Edit ".$__ini." and add 'extension=".$__f0."' directive<br>4) Restart the web server";}}$__msg.="</body></html>";}die($__msg);exit();}}return sg_load('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');