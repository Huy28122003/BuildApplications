package com.example.listviewhighlevel;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

public class FruitAdapter extends BaseAdapter {
    private Context cnt;
    private int layout;
    private List<Fruit> listFruit;

    public FruitAdapter(Context cnt, int layout, List<Fruit> listFruit) {
        this.cnt = cnt;
        this.layout = layout;
        this.listFruit = listFruit;
    }

    @Override
    public int getCount() {
        return listFruit.size();
    }

    @Override
    public Object getItem(int i) {
        return null;
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        LayoutInflater inflater = (LayoutInflater) cnt.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        view = inflater.inflate(R.layout.kind_of_fruit,null);

        //Anh xa
        TextView txtName = (TextView) view.findViewById(R.id.textView);
        TextView txtInfo = (TextView) view.findViewById(R.id.textView2);
        ImageView imgHinh = (ImageView) view.findViewById(R.id.imageView);

        // Gan gi tri
        Fruit fr = listFruit.get(i);
        txtName.setText(fr.getName());
        txtInfo.setText(fr.getInfo());
        imgHinh.setImageResource(fr.getHinhAnh());
        return view;
    }
}
