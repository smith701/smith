<?php
if(!function_exists('sg_load')){$__v=phpversion();$__x=explode('.',$__v);$__v2=$__x[0].'.'.(int)$__x[1];$__u=strtolower(substr(php_uname(),0,3));$__ts=(@constant('PHP_ZTS') || @constant('ZEND_THREAD_SAFE')?'ts':'');$__f=$__f0='ixed.'.$__v2.$__ts.'.'.$__u;$__ff=$__ff0='ixed.'.$__v2.'.'.(int)$__x[2].$__ts.'.'.$__u;$__ed=@ini_get('extension_dir');$__e=$__e0=@realpath($__ed);$__dl=function_exists('dl') && function_exists('file_exists') && @ini_get('enable_dl') && !@ini_get('safe_mode');if($__dl && $__e && version_compare($__v,'5.2.5','<') && function_exists('getcwd') && function_exists('dirname')){$__d=$__d0=getcwd();if(@$__d[1]==':') {$__d=str_replace('\\','/',substr($__d,2));$__e=str_replace('\\','/',substr($__e,2));}$__e.=($__h=str_repeat('/..',substr_count($__e,'/')));$__f='/ixed/'.$__f0;$__ff='/ixed/'.$__ff0;while(!file_exists($__e.$__d.$__ff) && !file_exists($__e.$__d.$__f) && strlen($__d)>1){$__d=dirname($__d);}if(file_exists($__e.$__d.$__ff)) dl($__h.$__d.$__ff); else if(file_exists($__e.$__d.$__f)) dl($__h.$__d.$__f);}if(!function_exists('sg_load') && $__dl && $__e0){if(file_exists($__e0.'/'.$__ff0)) dl($__ff0); else if(file_exists($__e0.'/'.$__f0)) dl($__f0);}if(!function_exists('sg_load')){$__ixedurl='http://www.sourceguardian.com/loaders/download.php?php_v='.urlencode($__v).'&php_ts='.($__ts?'1':'0').'&php_is='.@constant('PHP_INT_SIZE').'&os_s='.urlencode(php_uname('s')).'&os_r='.urlencode(php_uname('r')).'&os_m='.urlencode(php_uname('m'));$__sapi=php_sapi_name();if(!$__e0) $__e0=$__ed;if(function_exists('php_ini_loaded_file')) $__ini=php_ini_loaded_file(); else $__ini='php.ini';if((substr($__sapi,0,3)=='cgi')||($__sapi=='cli')||($__sapi=='embed')){$__msg="\nPHP script '".__FILE__."' is protected by SourceGuardian and requires a SourceGuardian loader '".$__f0."' to be installed.\n\n1) Download the required loader '".$__f0."' from the SourceGuardian site: ".$__ixedurl."\n2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="\n3) Edit ".$__ini." and add 'extension=".$__f0."' directive";}}$__msg.="\n\n";}else{$__msg="<html><body>PHP script '".__FILE__."' is protected by <a href=\"http://www.sourceguardian.com/\">SourceGuardian</a> and requires a SourceGuardian loader '".$__f0."' to be installed.<br><br>1) <a href=\"".$__ixedurl."\" target=\"_blank\">Click here</a> to download the required '".$__f0."' loader from the SourceGuardian site<br>2) Install the loader to ";if(isset($__d0)){$__msg.=$__d0.DIRECTORY_SEPARATOR.'ixed';}else{$__msg.=$__e0;if(!$__dl){$__msg.="<br>3) Edit ".$__ini." and add 'extension=".$__f0."' directive<br>4) Restart the web server";}}$__msg.="</body></html>";}die($__msg);exit();}}return sg_load('34D2975E4756B09AAAQAAAAXAAAABJAAAACABAAAAAAAAAD/M/OFROt/NoxRaAbfmkYq7X09jofuWCfj1ejSVvGNaaHs9ZMtxC9vgWccLmSQJzwGnkR9XLZHU/dSIoTnA3c7VmotSWMSkxDrlIj7vSP7NfZbmkYNt5BuVjFtFHP4PSO+1nwQcHMSL6Ti79Mh7FTpuDiIAuNYgLxlZXtli8ni8GeZvn6S3ihWJLTbwxWNE+4RNgAAALgCAACdqdM7QNgsGTZcyKN0bjRhek78GqKyU96ydC4HavenRHtruC9sJZnZkh7Nr6qWodlccgp4ykWzrSJKa//Xx7gUgN3QmzLc816IpIRtpMgx/qefH47hCdW8AQ+t2sYHygXiYNO7ajFg8b/A9VAMX5dvQ60XqkP/YIB786F4FVFy3goLbNnM8lLfcjkDmNc3mO5Cm4V6ka13W/M9k3FzVyIueQFqtKwysowfW3dtzu7/LPm5AfOUag/ShU+GaOngS6/IQ9mpESLZ3sDZSYlKMd2FY15KR4K2phl82zX0nGAFx3CQAPyrBWglBP3A6yWwk4HEtR1WcVmYS3sMobchdKJg6WRtZ73gfSPGfgvYDNLAWZT6XvrrmhoP3LcrFvAf1PmRBUzi5Ar5zKrM1zzWBevUGvPn0+5CE5gTN7lYBWTbHnFUFFzOrsDcmXxU2l8eesNXsuXFZs8KNlGcxC9iZL2cps8ComFuus8QYnZgfkO+b3SevHBt3Mjgay94GCEmxz8M90VNjsjnGnJcBhhWEenvV9pwGx25Zp+BtYsNQ3xnl/L052TuePalhRg+alvKjPHQbUkqoc9EwaMWfOT0BUVGwfwJ3mB7LsBqpOuaN9pKxfMRbUV8DSP03A956OsWXQkTyvoqQYdEIrs2DTNc6OEsQ3TkMxELkbA4XJezq08rxzMuIzkbcOlTkaLJC1PP4OI16+i4ujfbA3jq9RRgPscbGZtHQqKbgTd0l3u6rqz1OTO8LLBERFkDGkqTQKUJDdk7MqaHRgVusv6fc3KmScc9ZwSc7uueW7YiQMJMrquNPd5FpVbgANr+uG3XsnwpYD7iq0V9TzlADgnB5HVA+Tk0iXxkzi4B2Czek7x1BLSKEzFqtO3W/VkNTVVXezpq395Dw5oWkJ5mL51V0+TX/s5GnC5lCdqg1/U3AAAAyAIAAGv9l01sECtUTqIT/fqGStWb6RZ0ILobkljvIJNhuXgbp84iOnUOf40rQ8wos98tDOFkjNlyFuuoglRpLgJ4Fp89m3Mdg7bF2KeGzGrkFqH9nw5Y92k6pMc0abUJbideXIHG/Y+SgoAaYb4ejuDpQxhSu+d4485IbwusNkxC/w9N6d0ipbfDPq9NuAk+pGkx+25Ko8KSlF9HV7T9jA5IQ0X06eltiAkyRjX9M1ghl/VcQN5N2K1aOFDmRtYbdTfSVNxkpYG50IM3Nm+7h74CW3eSzcxE82BQXNm6IpoGuYb0p0SWDOnIaHjkgiOMvOsoBI5jJwdB8LgSCDm5RkjGQh5MPdnsqR36jFX0NoyjAr//kXLPDsg5/SIjJOj8mns4AOr9u+V/Y8zFa0jt8dGw3DDeyzYu2REsH54dFehEjTvnXy878CR4PqmzlIWyHwb0x8U82lQ+gNO+ln3lCHlSEUvZXvHGh1LldWpCHjLm+gMKjMc4QBFFR3iUA9zCox+6K2eWnjlsE1uGaNQs1nB+TzSRAnY02y4q7gnNoDn+Lx3nvecf7e1ZiLrPgqKRNW+YSVacIB54cQkrzM0OGXVIWZbnf2G69/vLbSzMhmio8cT8C2QyzORve9Tz3nZB5zXeuz/ClEZAu3894JvSv1pcm2gVEI5SR5ODmrEZPIB17WD8L5UaAbE+Mk+kBU2mbCoBjNFh06HjesNrtEEVX2x/P6AzGinqe8C212t2D/pR050tRTKj3C8cL/mYW5x8/fHxG7gAuiXfXsZ8pQ2D9DMQ4TD2IbkQ/mKJdyjCD1U8BM5VZmcwSB9T5UtVqUwTMdcjsGxY88Tk8mAnQeNBKEoxdIyL6LnvG3AtY1JA9eIxeJP+uDpHh12PTFREqvFJQE9LKbQu0P6xSEFbf9SIIPGNoTSdEc0ZBGq6UkN2NQVLudZCWzR1ITkvpYo4AAAAyAIAAAVt64whwkU87XFjiFrxql8S1USSuWV0wscZIjTi1o5GCJdVKZlKcTfQhlOpSf3+8Ak5+ebuuDicw10624U1tcabE38Y2rQqOpCv2WSw8wSVIjAaglY1nIPuO9H9mkMzmGABH9MgF7o6DoQIOnHL7mzXU81SC6ZpAgaFyPwrCxy4e3x8xhkm7QTwWvk72hkctF7onZRvl+VXqIpfEOAaADBZw/sxOUn9KEZzj63EixwKLN1mnp8lAUePNchBrBOnHMTI/CT7LHCNKiyOMC58mHr7OXVTrF5Vclw2Q7eH4hl2FXXimFuahw3/qSo7t5j/dNimjph7T4Ji77sKgT+j4itwZn9I+AlDNcmIBfSfLnx5Ze/Qc4mZSY3G66DWX1+op6gaBKUdL8rkHmODxFYPxW3bdCYBQZH0MVkqQNe+KHEPYGfTLRnYZS+8RgCJfs6M/yEd92w9tTcspOJ16emRN4vqtky28Z7eNqy4l6tSvnKyzv+Ylf2wr/Ee5KzQ6Rs3ExAEYyJWUfKh4lFEbVkIU/SabewE+6/KaH4c8gKwS+y7OAwi9wnvJvqwpieXwl1TftuGc9Awmx9ZiCSLhLVSrxUFQs5Si5rnvZgR7QNMH76fJab+lSkzlBSDs1jJhQc3vCTpZksuvJwGe2LpUYaVWl1lpYrTUhMlhrQ7tZsmcSxADse/ipHnE7pcEqunS9ZzK67sqqPJnOcPSD9ch2zu+zzpzDg8mheUoN8wGB3lWVEzj60Gz250Wob1L2IOyBl8j6+EQatn4b9Q9Lf1pXcZ+UgcFILuX8DMWd2+FWL4s/T3GS8HLqogn0wzeoV2ZhxLBKu3jI9kfH+B4eBIbW+VXBAwKq4FrbO6nLRM22nSxb5tePTA8OBou0I+pOrk1Cm6GMiOhU2fdKacDobh9vX05wLGTAgf29C+GT/GALCLrGenShPKJb0fgt8HAAAAeAIAAJqkJxozPHPy4SL+YFqZJZafc2R65bcGbyh6hsDFYEBc8bHOg8Da3DdgR66XLvTQIWWQtfqfuJnx4XL2b37tTUVcDRGEIpex6DeUw9Ka65cpbA4Z2/0VArAOUIpasRDeAgwCqBKblZEs9Sdg6BMQspkKs+rjV2ydUb1Q6bRLHHxVr1fNN6nkcps+fR+gJB9o5f1Rwj9kR7G038ohUbYezp/b+HNs1igaWBD3QyUvu33JZP8wKEOJl0b2y94Xqi8R6prv6TNNrEs9qMvVucIK++jCGHPiAf9PycRFGF1RXzRae/M9FWUm/z/wBZ983tfMnxnpmhqWdWdDndckqLmKr1n9p3vOIKhpVvqNZcIWQYIw3XULjso/6IuZw8I1+BTkTYWn63sP0Fvj1c1EXUp9HFYAa19VZie5YBbjwpCK+en/UK+QH5lAUQnH8y6d3ovL+EqSN7J55Bvex+Q9/defZp6fF9eKcgEQRDvbjc/EWnC6ylC5OFsXU7SjGg3/ZwHTgVoRfX1OUVxgWBOx0DtFrqMiTiolV+M+TDXDfSiZUZj9VcVCJn+GX5zGxmUUTC7BZnPUbClvJRrvy2zpERynaLNv+UccgfQn8qic7qOXAIRMR+ikSMFCE2tegJZqhxbhOxih4dveQY1wD9Q1Fv/9a+ZI9nDwFm0DwIICH12WSVMq4dQJQCkOXhUwPVhVC4Y/z6WRhd1ZXi3O3GO/fy0vADjFfGi7jLihx4hdfUKyhMrtXZ0WjWlDgxySMqtnOERwiy6KwTbTXLsXtxvhKyztX/tpex46kvd1rdBFkt0vI81a/2bcbb2EJBeAVeNI4/P3Gkw6PEiw74WmAAAAAA==');