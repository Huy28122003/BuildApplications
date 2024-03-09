package com.example.appofhuy;


public class Note {
    private String title;
    private String date;
    private int idImg;

    public Note() {
        this.title = "";
        this.date = "";
        this.idImg = 700001;
    }

    public Note(String title, String date){
        this.title = title;
        this.date = date;
        this.idImg = R.drawable.ic_launcher_foreground;
    }

    public Note(String title, String date, int idImg) {
        this.title = title;
        this.date = date;
        this.idImg = R.drawable.ic_launcher_foreground;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getIdImg() {
        return idImg;
    }

    public void setIdImg(int idImg) {
        this.idImg = idImg;
    }
}

