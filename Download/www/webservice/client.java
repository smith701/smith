

/*** modification pour maintenir la session ouverte  ***/

public_91._148._168._88.webservice.WebserviceMSFPortType getWebserviceMSFPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {

        try {

_91._148._168._88.webservice.WebserviceMSFBindingStub _stub = new _91._148._168._88.webservice.WebserviceMSFBindingStub(portAddress, this);

            _stub.setMaintainSession(true);

            _stub.setPortName(getWebserviceMSFPortWSDDServiceName());

            return _stub;

        }

        catch (org.apache.axis.AxisFault e) {

            return null;

        }

}

 

 

/*** Programme de test fait avec Junit ***/

 

package com.xxx.speech2text.test;

 

import java.io.BufferedInputStream;

import java.io.File;

import java.io.FileInputStream;

import java.io.IOException;

import java.rmi.RemoteException;

import org.apache.log4j.Logger;

import junit.framework.TestCase;

import _91._148._168._88.webservice.*;

import org.apache.ws.jaxme.util.Base64Binary;

 

public class Test extends TestCase {

      

      public void testTest1(){

            String[] result = null;

            String[] retUploadFile = null;

            String filename = "test.wav";

            String dirPath = "D:/workspace" +

            "/MaquetteSpeech2Text/WebContent/" +

            "WEB-INF/son.d/";

            

            byte[] data = null;

            String fileContent = null;

            

            try {

                  result = webservice.login("XXX", "XXX");

                  for(int i = 0; i < result.length ; i++){

                        LOG.debug(result[i]);

                  }

            } catch (RemoteException e) {

                  //    TODO Auto-generated catch block

                  LOG.error("[" + e + " ]");

            }

            

            try {

                  File soundFile = new File(dirPath+filename); 

                  data = getArrayByteFromFile(soundFile);

            } catch (IOException e) {

                  // TODO Auto-generated catch block

                  LOG.error(e);

            }

            fileContent = Base64Binary.encode(data);

            try {

                  retUploadFile = webservice.upload(filename, fileContent);

                  for(int i = 0; i < retUploadFile.length ; i++){

                        LOG.debug(retUploadFile[i]);

                  }

            } catch (RemoteException e) {

                  // TODO Auto-generated catch block

                  LOG.error("Erreur pendant de l'upload [ " + e + " ]");

            }

            

            try {

                  result = webservice.logout();

                  for(int i = 0; i < result.length ; i++){

                        LOG.debug(result[i]);

                  }

            } catch (RemoteException e) {

                  // TODO Auto-generated catch block

                  LOG.error("Erreur pendant le logout [ " + e + " ]");

            }

      }

      

      public byte[] getArrayByteFromFile(File f) throws IOException {

            int length = (int) f.length();

            byte[] data = new byte[length];

            BufferedInputStream in = new BufferedInputStream(new FileInputStream(f));

            @SuppressWarnings("unused")

            int result = in.read(data, 0, length);

            return data;

      }

      

      private static final Logger LOG = Logger.getLogger(Test.class);

      private static WebserviceMSFPortTypeProxy webservice = new WebserviceMSFPortTypeProxy();

}

 