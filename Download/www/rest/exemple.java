package com.exalead.vecsys.client;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.cookie.CookiePolicy;
import org.apache.commons.httpclient.methods.PostMethod;

public class TestRest {

	public static void main(String[] args) {
		try {
			HttpClient client = new HttpClient();
			
			PostMethod postMethod = new PostMethod("https://88.168.148.91/msse/?function=login&username=xxxx&password=xxxx");

			int status = client.executeMethod(postMethod);
			
			String cookie=null;
			String cookieValue = null;
			
			String result = postMethod.getResponseBodyAsString();
			Header [] respHeaders = postMethod.getResponseHeaders();
			
			for (Header header : respHeaders){
				if ( header.getName().toLowerCase().equals("set-cookie") )
				{
					cookie=header.getValue();
					cookieValue = cookie.split(";")[0];
					break;
				}
			}
			
			System.out.println(cookieValue);
			System.out.println(result);
			
			postMethod.releaseConnection();
			
			//Traitement du fichier
			postMethod = new PostMethod("https://88.168.148.91/msse/?function=trans&filename=http://spstaging.ksu.edu.sa/Documents/UsingOpsMgrWizard_Edited.wmv&type=bn&language=eng");
			postMethod.getParams().setCookiePolicy(CookiePolicy.IGNORE_COOKIES);
			postMethod.setRequestHeader("Cookie", cookieValue);
			status = client.executeMethod(postMethod);
			result = postMethod.getResponseBodyAsString();
			System.out.println(result);
			
			Thread.sleep(10000);
			
			//Récupération du statut
			postMethod = new PostMethod("https://88.168.148.91/msse/?function=status&jobid=371346.msf01");
			postMethod.getParams().setCookiePolicy(CookiePolicy.IGNORE_COOKIES);
			postMethod.setRequestHeader("Cookie", cookieValue);
			status = client.executeMethod(postMethod);
			result = postMethod.getResponseBodyAsString();
			
			char transStatus = ' ';
			Pattern cellPattern = Pattern.compile("([0-9]*\\.[a-z]{3}[0-9]* trans [A-Z]) ");
			Matcher m = cellPattern.matcher(result);
			if (m.find() && m.groupCount() > 0) {
				String jobStatus = m.group(1);
				// statut (D-R-E...)
				transStatus = jobStatus.charAt(jobStatus.length()-1);
				System.out.println(transStatus);
			}
			System.out.println(result);
			
			//Récupération du résultat
//			postMethod = new PostMethod("https://88.168.148.91/msse/?function=result&jobid=371346.msf01");
//			postMethod.getParams().setCookiePolicy(CookiePolicy.IGNORE_COOKIES);
//			postMethod.setRequestHeader("Cookie", cookieValue);
//			status = client.executeMethod(postMethod);
//			result = postMethod.getResponseBodyAsString();
//			System.out.println(result);
			
			postMethod.releaseConnection();
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
