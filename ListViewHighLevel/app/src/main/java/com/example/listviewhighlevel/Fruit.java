package com.example.listviewhighlevel;

public class Fruit {
    private String name;
    private String info;
    private int hinhAnh;

    public Fruit(String name, String info, int hinhAnh) {
        this.name = name;
        this.info = info;
        this.hinhAnh = hinhAnh;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public int getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(int hinhAnh) {
        this.hinhAnh = hinhAnh;
    }
}
