package com.example.listviewhighlevel;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.Adapter;
import android.widget.ListView;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    ListView lv;
    ArrayList<Fruit> arrF;
    FruitAdapter adapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        AnhXa();
        adapter = new FruitAdapter(this,R.layout.kind_of_fruit,arrF);
        lv.setAdapter(adapter);
    }

    private void AnhXa() {
        lv = (ListView) findViewById(R.id.lvFruit);
        arrF = new ArrayList<>();
        arrF.add(new Fruit("Bo","Mem",R.drawable.img5));
        arrF.add(new Fruit("Tao","Gion",R.drawable.img6));
        arrF.add(new Fruit("Dau tay","Ngot",R.drawable.img7));
        arrF.add(new Fruit("Dau tay","Ngot",R.drawable.img7));
        arrF.add(new Fruit("Dau tay","Ngot",R.drawable.img7));
        arrF.add(new Fruit("Dau tay","Ngot",R.drawable.img7));
        arrF.add(new Fruit("Dau tay","Ngot",R.drawable.img7));
    }
}