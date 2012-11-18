/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.webdkt.dtrade.gui;

import java.util.ArrayList;
import javafx.beans.InvalidationListener;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.CheckMenuItem;
import javafx.scene.control.CheckMenuItemBuilder;
import javafx.scene.control.Label;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuBuilder;
import javafx.scene.control.MenuItem;
import javafx.scene.control.MenuItemBuilder;
import javafx.scene.input.KeyCombination;
import javafx.scene.layout.VBox;

/**
 *
 * @author frwang
 *
 *
 */
public class MenuBox extends VBox {

    static String menuName = "";
    // 此处定义菜单格局，顶级菜单需要单独定义，次级菜单定义到一个数组里面，后面自动循环生成。此种方式不支持第三级菜单
    Menu mFile;
    String[] mFileItems = {"Test", "-", "Exit"};
    Menu mOption;
    String[] mOptionItems = {"Setting"};
    Menu mHelp;
    String[] mHelpItems = {"About"};

    public MenuBox() {
        super();

        final MenuBar menuBar = new MenuBar();
        final Class[] actionParam = {ActionEvent.class};

        mFile = new Menu("File");  //生成 File Menu以及子菜单
        for (String item : mFileItems) {
            final MenuItem menuItem = new MenuItem(item);
            final String menuActionName = "menuFile" + item + "Action";
            //System.out.println("now menuActionName is: " + menuName+"Action");
            menuItem.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent t) {
                    try {
                        
                        //动态定义子菜单会调用 MenuActionController.xxxxAction的方法  xxx是菜单名字，例如 File下面的Open，就是menuFileOpenAction
                        System.out.println(menuActionName);
                        
                        MenuActionController.class.getMethod(menuActionName, actionParam).invoke(null,t);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
            mFile.getItems().add(menuItem);
        }
        mOption = new Menu("Option");
        for (String item : mOptionItems) {
            MenuItem menuItem = new MenuItem(item);
            menuName = "menuOption" + item;
            menuItem.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent t) {
                    try {
                        //动态定义子菜单会调用 MenuActionController.xxxxAction的方法  xxx是菜单名字，例如 File下面的Open，就是menuFileOpenAction
                        //MenuActionController.class.getMethod( + "Action", ActionEvent.class).invoke(t);
                        ;
                            
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
            mOption.getItems().add(menuItem);
        }
        mHelp = new Menu("Help");
        for (String item : mHelpItems) {
            MenuItem menuItem = new MenuItem(item);
            menuName = "menuHelp" + item;
            menuItem.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent t) {
                    try {
                        //动态定义子菜单会调用 MenuActionController.xxxxAction的方法  xxx是菜单名字，例如 File下面的Open，就是menuFileOpenAction
                        MenuActionController.class.getMethod(menuName + "Action",actionParam).invoke(null,t);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
            mHelp.getItems().add(menuItem);
        }
        menuBar.getMenus().addAll(mFile, mOption, mHelp);


        this.getChildren().addAll(menuBar);
    }
}
