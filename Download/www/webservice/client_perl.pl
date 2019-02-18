#!/usr/bin/perl -w
  
use SOAP::Lite;
use HTTP::Cookies;
use Data::Dumper;
$Data::Dumper::Indent = 1;


  if (1)
  {
    #************************************************************************    
    #************************************************************************
    
    my $COOKIE       = './coooooooooookie.txt';
    my $SET_COOKIE   = HTTP::Cookies->new(ignore_discard => 1,
                        file=> $COOKIE, 
                        autosave=>1);


    my $soapLite = SOAP::Lite->new();
    
    $soapLite->proxy('https://mediaspeech.com/webservice', cookie_jar => $SET_COOKIE);
    $soapLite->service('https://mediaspeech.com/webservice/server.wsdl');
        
    print "******************************************************\nresXML\n";
    $Resultats  = $soapLite->login('xxx', 'xxx!');
    $ResXML     = $Resultats->result;
    $Xml        = join("", @$ResXML);
    print $Xml."\n";

    $som        = SOAP::Deserializer->deserialize($Xml);
    $a          = $som->dataof("//result/status");
    print $a->value."\n";

    print "******************************************************\n";
    $Resultats  = $soapLite->status('231429.msf01');
    $ResXML     = $Resultats->result;
    $Xml        = join("", @$ResXML);
    print $Xml."\n";

    $som        = SOAP::Deserializer->deserialize($Xml);
    $a          = $som->dataof("//result/status");
    print $a->value."\n";
    
    #************************************************************************    
    #************************************************************************    
    
  }

  print "fin\n"; 
  
  