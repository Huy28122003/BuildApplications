package com.example.appofhuy;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

public class NoteAdapter extends BaseAdapter {
    private Context context;
    private int layout;
    private List<Note> noteList;

    public NoteAdapter(Context context, int layout, List<Note> noteList) {
        this.context = context;
        this.layout = layout;
        this.noteList = noteList;
    }

    @Override
    public int getCount() {
        return noteList.size();
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
        LayoutInflater layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        view = layoutInflater.inflate(layout,null);

        TextView txtTit = (TextView) view.findViewById(R.id.txtTitle);
        TextView txtDa = (TextView) view.findViewById(R.id.txtDate);
        ImageView imgV = (ImageView) view.findViewById(R.id.img);

        Note note =noteList.get(i);
        txtTit.setText(note.getTitle());
        txtDa.setText(note.getDate());
        imgV.setImageResource(note.getIdImg());

        return view;
    }
}
