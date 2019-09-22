/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.postgresql;

/**
 *
 * @author bipin
 */
public class CartList {
    private int prodId;
    private String prodName;
    private float prodPrice;
    private int quantity;
    private float total;
    private float grantTotal;
    private int billid;
    private String billdate;

    public CartList(String prodName, float prodPrice, int quantity, float total) {
        this.prodName = prodName;
        this.prodPrice = prodPrice;
        this.quantity = quantity;
        this.total = total;
    }

    
    public CartList(float grantTotal, int billid, String billdate) {
        this.grantTotal = grantTotal;
        this.billid = billid;
        this.billdate = billdate;
    }

    public CartList() {
    }

    
    public int getBillid() {
        return billid;
    }

    public void setBillid(int billid) {
        this.billid = billid;
    }

    public String getBilldate() {
        return billdate;
    }

    public void setBilldate(String billdate) {
        this.billdate = billdate;
    }        

    public int getProdId() {
        return prodId;
    }

    public void setProdId(int prodId) {
        this.prodId = prodId;
    }

    public String getProdName() {
        return prodName;
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }

    public float getProdPrice() {
        return prodPrice;
    }

    public void setProdPrice(float prodPrice) {
        this.prodPrice = prodPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }

    public float getGrantTotal() {
        return grantTotal;
    }

    public void setGrantTotal(float grantTotal) {
        this.grantTotal = grantTotal;
    }
    
    
}
