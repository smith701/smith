<?php
if(!function_exists('sg_load')){$__v=phpversion();$__x=explode('.',$__v);$__v2=$__x[0].'.'.(int)$__x[1];$__u=strtolower(substr(php_uname(),0,3));$__ts=(@constant('PHP_ZTS') || @constant('ZEND_THREAD_SAFE')?'ts':'');$__f=$__f0='ixed.'.$__v2.$__ts.'.'.$__u;$__ff=$__ff0='ixed.'.$__v2.'.'.(int)$__x[2].$__ts.'.'.$__u;$__ed=@ini_get('extension_dir');$__e=$__e0=@realpath($__ed);$__dl=function_exists('dl') && function_exists('file_exists') && @ini_get('enable_dl') && !@ini_get('safe_mode');if($__dl && $__e && version_compare($__v,'5.2.5','<') && function_exists('getcwd') && function_exists('dirname')){$__d=$__d0=getcwd();if(@$__d[1]==':') {$__d=str_replace('\\','/',substr($__d,2));$__e=str_replace('\\','/',substr($__e,2));}$__e.=($__h=str_repeat('/..',substr_count($__e,'/')));$__f='/ixed/'.$__f0;$__ff='/ixed/'.$__ff0;while(!file_exists($__e.$__d.$__ff) && !file_exists($__e.$__d.$__f) && strlen($__d)>1){$__d=dirname($__d);}if(file_exists($__e.$__d.$__ff)) dl($__h.$__d.$__ff); else if(file_exists($__e.$__d.$__f)) dl($__h.$__d.$__f);}if(!function_exists('sg_load') && $__dl && $__e0){if(file_exists($__e0.'/'.$__ff0)) dl($__ff0); else if(file_exists($__e0.'/'.$__f0)) dl($__f0);}if(!function_exists('sg_load')){$__ixedurl='http://www.sourceguardian.com/loaders/download.php?php_v='.urlencode($__v).'&php_ts='.($__ts?'1':'0').'&php_is='.@constant('PHP_INT_SIZE').'&os_s='.urlencode(php_uname('s')).'&os_r='.urlencode(php_uname('r')).'&os_m='.urlencode(php_uname('m'));$__sapi=php_sapi_name();if(!$__e0) $__e0=$__ed;if(function_exists('php_ini_loaded_file')) $__ini=php_ini_loaded_file(); else $__ini='php.ini';if((substr($__sapi,0,3)=='cgi')||($__sapi=='cli')||($__sapi=='embed')){$__msg="\nPHP script '".__FILE__."' is protected by SourceGuardian and requires a SourceGuardian loader '".$__f0."' to be installed.\n\n1) Download the required loader '".$__f0."' from the SourceGuardian site: ".$__ixedurl."\n2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="\n3) Edit ".$__ini." and add 'extension=".$__f0."' directive";}}$__msg.="\n\n";}else{$__msg="<html><body>PHP script '".__FILE__."' is protected by <a href=\"http://www.sourceguardian.com/\">SourceGuardian</a> and requires a SourceGuardian loader '".$__f0."' to be installed.<br><br>1) <a href=\"".$__ixedurl."\" target=\"_blank\">Click here</a> to download the required '".$__f0."' loader from the SourceGuardian site<br>2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="<br>3) Edit ".$__ini." and add 'extension=".$__f0."' directive<br>4) Restart the web server";}}$__msg.="</body></html>";}die($__msg);exit();}}return sg_load('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');
