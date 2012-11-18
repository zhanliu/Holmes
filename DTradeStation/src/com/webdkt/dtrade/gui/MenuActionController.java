/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.webdkt.dtrade.gui;

import com.webdkt.dtrade.KLineRegression;
import com.webdkt.dtrade.TradeStation;
import java.io.FileNotFoundException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.layout.BorderPane;
import jfx.messagebox.MessageBox;

/**
 *
 * @author frwang
 */
public class MenuActionController{

    public static void menuFileExitAction(ActionEvent t){
        MessageBox.show(TradeStation.currentStage,
         "Sample of information dialog.\n\nDialog option is below.\n[MessageBox.ICON_INFORMATION | MessageBox.OK | MessageBox.CANCEL]",
         "Information dialog",
         MessageBox.OK );
        System.exit(0);
    }
    
    public static void menuFileTestAction(ActionEvent t){
        double[][] data = new double[][]{
            {1,  25, 20, 32, 16, 20},
            {2,  26, 30, 33, 22, 25},
            {3,  30, 38, 40, 20, 32},
            {4,  24, 30, 34, 22, 30},
            {5,  26, 36, 40, 24, 32},
            {6,  28, 38, 45, 25, 34},
            {7,  36, 30, 44, 28, 39},
            {8,  30, 18, 36, 16, 31},
            {9,  40, 50, 52, 36, 41},
            {10, 30, 34, 38, 28, 36},
            {11, 24, 12, 30, 8,  32.4},
            {12, 28, 40, 46, 25, 31.6},
            {13, 28, 18, 36, 14, 32.6},
            {14, 38, 30, 40, 26, 30.6},
            {15, 28, 33, 40, 28, 30.6},
            {16, 25, 10, 32, 6,  30.1},
            {17, 26, 30, 42, 18, 27.3},
            {18, 20, 18, 30, 10, 21.9},
            {19, 20, 10, 30, 5,  21.9},
            {20, 26, 16, 32, 10, 17.9},
            {21, 38, 40, 44, 32, 18.9},
            {22, 26, 40, 41, 12, 18.9},
            {23, 30, 18, 34, 10, 18.9},
            {24, 12, 23, 26, 12, 18.2},
            {25, 30, 40, 45, 16, 18.9},
            {26, 25, 35, 38, 20, 21.4},
            {27, 24, 12, 30, 8,  19.6},
            {28, 23, 44, 46, 15, 22.2},
            {29, 28, 18, 30, 12, 23},
            {30, 28, 18, 30, 12, 23.2},
            {31, 28, 18, 30, 12, 22},
            {32, 28, 18, 30, 12, 22},
            {33, 28, 18, 30, 12, 22},
            {34, 28, 18, 30, 12, 22},
            {35, 28, 18, 30, 12, 22},
            {36, 28, 18, 30, 12, 22},
            {37, 28, 18, 30, 12, 22},
            {38, 28, 18, 30, 12, 22},
    };
        final NumberAxis xAxis = new NumberAxis(0,32,1);
        xAxis.setMinorTickCount(0);
        final NumberAxis yAxis = new NumberAxis();
        final CandleStickChartSample bc = new CandleStickChartSample(xAxis,yAxis);
        // setup chart
        bc.setTitle("Custom Candle Stick Chart");
        xAxis.setLabel("Day");
        yAxis.setLabel("Price");
        // add starting data
        XYChart.Series<Number,Number> series = new XYChart.Series<Number,Number>();
        for (int i=0; i< data.length; i++) {
            double[] day = data[i];
            series.getData().add(
                new XYChart.Data<Number,Number>(day[0],day[1],new CandleStickExtraValues(day[2],day[3],day[4],day[5]))
            );
        }
        ObservableList<XYChart.Series<Number,Number>> serieldata = bc.getData();
        if (serieldata == null) {
            serieldata = FXCollections.observableArrayList(series);
            bc.setData(serieldata);
        } else {
            bc.getData().add(series);
        }
        //return bc;
        BorderPane rootPane =(BorderPane) TradeStation.currentStage.getScene().getRoot();
        rootPane.setCenter(bc);
        
        
        //KLineRegression test= new KLineRegression();
        //try {
        //    test.regressionTest();
        //} catch (FileNotFoundException ex) {
        //    Logger.getLogger(MenuActionController.class.getName()).log(Level.SEVERE, null, ex);
        //}
            
    }
    
    

   
}
