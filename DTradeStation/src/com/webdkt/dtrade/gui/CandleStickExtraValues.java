/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.webdkt.dtrade.gui;

/**
 *
 * @author frwang
 */
public class CandleStickExtraValues {

        private double close;
        private double high;
        private double low;
        private double average;

        public CandleStickExtraValues(double close, double high, double low, double average) {
            this.close = close;
            this.high = high;
            this.low = low;
            this.average = average;
        }

        public double getClose() {
            return close;
        }

        public double getHigh() {
            return high;
        }

        public double getLow() {
            return low;
        }

        public double getAverage() {
            return average;
        }
    
    
}
