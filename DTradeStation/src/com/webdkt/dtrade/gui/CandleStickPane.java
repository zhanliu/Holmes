/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.webdkt.dtrade.gui;

import javafx.geometry.Orientation;
import javafx.scene.control.SplitPane;

/**
 *
 * @author frwang
 */
public class CandleStickPane extends SplitPane{
    CandleStickMainPanel mainPanel ;  //main panel
    IndicatorPanel  indicatorPanel;   //indicator panel
    
    CandleStickChart kchart ; // K线图
    
    private int startDayIndex =1;

    public int getStartDayIndex() {
        return startDayIndex;
    }

    public void setStartDayIndex(int startDayIndex) {
        this.startDayIndex = startDayIndex;
    }

    public int getWindowDayCount() {
        return windowDayCount;
    }

    public void setWindowDayCount(int windowDayCount) {
        this.windowDayCount = windowDayCount;
    }
    private int windowDayCount = 90;
    
    public CandleStickPane(){
        super();
        mainPanel = new CandleStickMainPanel();
        indicatorPanel = new IndicatorPanel();
        this.setOrientation(Orientation.VERTICAL);
        this.getItems().addAll(mainPanel,indicatorPanel);
        this.setDividerPosition(0, 0.8);
        kchart  = new CandleStickChart();  //k线图
        mainPanel.setCenter(kchart);
        
        
    }
    
    
    public void setData(){
        
    }
    
}
