/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.webdkt.dtrade;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.math3.stat.regression.SimpleRegression;

/**
 *
 * @author frwang
 */
public class KLineRegression {
    public void regressionTest() throws FileNotFoundException{
        BufferedReader inputStream = null;
//        PrintWriter outputStream = null;

        try {
            inputStream = new BufferedReader(new FileReader("D:\\000001.TXT"));
  //          outputStream = new PrintWriter(new FileWriter("characteroutput.txt"));

            String l;
            l = inputStream.readLine(); //skip first line
            double dayIndex = 0;
            ArrayList<Double> prices = new ArrayList<Double>(80);
            
            
            SimpleRegression regression = new SimpleRegression();
            
            
            
            while (((l = inputStream.readLine()) != null)) {
               // outputStream.println(l);
               
               String[] lineContent = l.split("\t");  //first is date, then open/high/low/close 
               if (dayIndex >19){
                   for(int j=0;j<4;j++) {
                       regression.removeData(dayIndex-20, prices.remove(0));
                   }
                   //for(int x=0;x<dayIndex-20;x++){
                   //    System.out.print("                                                    ");
                  // }
               }
               for(int j=1;j<5;j++){
                   prices.add(Double.parseDouble(lineContent[j]));
                   regression.addData(dayIndex, Double.parseDouble(lineContent[j])); //add four new data into the regression model
               }
               dayIndex = dayIndex +1;  //move day index to next value
               
               
               //for (Double idx : prices){
               //    System.out.print(idx+"("+dayIndex+")");
               // }
               //System.out.println();
               System.out.println(lineContent[0]+"N:" + regression.getN()+" : R[" + regression.getR()+"] --- slope["+regression.getSlope()+"]  slope SE: ["+regression.getSlopeStdErr()+"]");
            }
        
        } catch (IOException ex) {
            Logger.getLogger(KLineRegression.class.getName()).log(Level.SEVERE, null, ex);
       } finally {
            if (inputStream != null) {
               try {
                   inputStream.close();
               } catch (IOException ex) {
                   Logger.getLogger(KLineRegression.class.getName()).log(Level.SEVERE, null, ex);
               }
            }
            
        }
    }
    
}
