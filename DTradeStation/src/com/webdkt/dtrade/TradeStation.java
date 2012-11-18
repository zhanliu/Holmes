/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.webdkt.dtrade;


import com.webdkt.dtrade.gui.CandleStickPane;
import com.webdkt.dtrade.gui.MenuBox;
import javafx.application.Application;
import javafx.beans.InvalidationListener;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.image.*;
import javafx.scene.control.*;
import javafx.scene.input.KeyCombination;

import javafx.scene.layout.*;

import javafx.stage.Stage;

/**
 *
 * @author frwang
 */
public class TradeStation extends Application {
    VBox menuBox ;
    public static Stage currentStage;
    
    @Override
    public void start(Stage primaryStage) {
        this.currentStage = primaryStage;
        init(primaryStage);
        
        primaryStage.show();
    }

    /**
     * The main() method is ignored in correctly deployed JavaFX application.
     * main() serves only as fallback in case the application can not be
     * launched through deployment artifacts, e.g., in IDEs with limited FX
     * support. NetBeans ignores main().
     *
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        launch(args);
    }
    
    private void init(Stage primaryStage){
        menuBox = new VBox(20);
        
        BorderPane rootBorderPane = new BorderPane();
        
        
        
        Scene scene = new Scene(rootBorderPane, 1024, 768);
        scene.getStylesheets().add(TradeStation.class.getResource("ensemble2.css").toExternalForm());
        
        primaryStage.setTitle("DTradeStation");
        primaryStage.setScene(scene);
        
        MenuBox menuBox = new MenuBox();
        CandleStickPane candleStickPane = new CandleStickPane();
     
        rootBorderPane.setTop(menuBox);
        rootBorderPane.setCenter(candleStickPane);
        
        
    }
    
    
}
