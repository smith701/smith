<?php
if(!function_exists('sg_load')){$__v=phpversion();$__x=explode('.',$__v);$__v2=$__x[0].'.'.(int)$__x[1];$__u=strtolower(substr(php_uname(),0,3));$__ts=(@constant('PHP_ZTS') || @constant('ZEND_THREAD_SAFE')?'ts':'');$__f=$__f0='ixed.'.$__v2.$__ts.'.'.$__u;$__ff=$__ff0='ixed.'.$__v2.'.'.(int)$__x[2].$__ts.'.'.$__u;$__ed=@ini_get('extension_dir');$__e=$__e0=@realpath($__ed);$__dl=function_exists('dl') && function_exists('file_exists') && @ini_get('enable_dl') && !@ini_get('safe_mode');if($__dl && $__e && version_compare($__v,'5.2.5','<') && function_exists('getcwd') && function_exists('dirname')){$__d=$__d0=getcwd();if(@$__d[1]==':') {$__d=str_replace('\\','/',substr($__d,2));$__e=str_replace('\\','/',substr($__e,2));}$__e.=($__h=str_repeat('/..',substr_count($__e,'/')));$__f='/ixed/'.$__f0;$__ff='/ixed/'.$__ff0;while(!file_exists($__e.$__d.$__ff) && !file_exists($__e.$__d.$__f) && strlen($__d)>1){$__d=dirname($__d);}if(file_exists($__e.$__d.$__ff)) dl($__h.$__d.$__ff); else if(file_exists($__e.$__d.$__f)) dl($__h.$__d.$__f);}if(!function_exists('sg_load') && $__dl && $__e0){if(file_exists($__e0.'/'.$__ff0)) dl($__ff0); else if(file_exists($__e0.'/'.$__f0)) dl($__f0);}if(!function_exists('sg_load')){$__ixedurl='http://www.sourceguardian.com/loaders/download.php?php_v='.urlencode($__v).'&php_ts='.($__ts?'1':'0').'&php_is='.@constant('PHP_INT_SIZE').'&os_s='.urlencode(php_uname('s')).'&os_r='.urlencode(php_uname('r')).'&os_m='.urlencode(php_uname('m'));$__sapi=php_sapi_name();if(!$__e0) $__e0=$__ed;if(function_exists('php_ini_loaded_file')) $__ini=php_ini_loaded_file(); else $__ini='php.ini';if((substr($__sapi,0,3)=='cgi')||($__sapi=='cli')||($__sapi=='embed')){$__msg="\nPHP script '".__FILE__."' is protected by SourceGuardian and requires a SourceGuardian loader '".$__f0."' to be installed.\n\n1) Download the required loader '".$__f0."' from the SourceGuardian site: ".$__ixedurl."\n2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="\n3) Edit ".$__ini." and add 'extension=".$__f0."' directive";}}$__msg.="\n\n";}else{$__msg="<html><body>PHP script '".__FILE__."' is protected by <a href=\"http://www.sourceguardian.com/\">SourceGuardian</a> and requires a SourceGuardian loader '".$__f0."' to be installed.<br><br>1) <a href=\"".$__ixedurl."\" target=\"_blank\">Click here</a> to download the required '".$__f0."' loader from the SourceGuardian site<br>2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="<br>3) Edit ".$__ini." and add 'extension=".$__f0."' directive<br>4) Restart the web server";}}$__msg.="</body></html>";}die($__msg);exit();}}return sg_load('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');
