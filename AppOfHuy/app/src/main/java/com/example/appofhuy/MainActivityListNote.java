package com.example.appofhuy;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.PopupMenu;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Map;

public class MainActivityListNote extends AppCompatActivity {
    ListView lv;
    public static ArrayList<Note> arrNote;
    public static NoteAdapter noteAdapter;
    Button btn;
    ActivityResultLauncher<Intent> launcher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            new ActivityResultCallback<ActivityResult>() {
                @Override
                public void onActivityResult(ActivityResult o) {

                }
            }
    );
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_list_note);

        btn = (Button) findViewById(R.id.bntAdd);
        lv = (ListView) findViewById(R.id.lview);
        arrNote = new ArrayList<>();
        int numKeyinShared;
        NoteContent.sharedPreferences = getSharedPreferences("dataNote",MODE_PRIVATE);
        Map<String, ?> allEntries = NoteContent.sharedPreferences.getAll();
        for (Map.Entry<String, ?> entry : allEntries.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            // Xử lý giá trị tương ứng với khóa key ở đây
            // Ví dụ: In ra khóa và giá trị
            Log.d("AAAA", key + ": " + value.toString());
        }
        numKeyinShared = allEntries.size()/4;

        Toast.makeText(this, numKeyinShared+" ", Toast.LENGTH_SHORT).show();
        if(numKeyinShared>0){
            for(int i=0;i<numKeyinShared;i++){
                String t = NoteContent.sharedPreferences.getString("Title"+i," ");
                String d = NoteContent.sharedPreferences.getString("Date"+i," ");
                String img = NoteContent.sharedPreferences.getString("Image"+i," ");
                arrNote.add(new Note(t,d));
            }
        }

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivityListNote.this,NoteContent.class);
                launcher.launch(intent);
            }
        });
        noteAdapter = new NoteAdapter(this,R.layout.item_note,arrNote);
        lv.setAdapter(noteAdapter);

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Intent intent = new Intent(MainActivityListNote.this, NoteContent.class);
                intent.putExtra("idNote",i);
                startActivity(intent);
            }
        });
        lv.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long l) {
                PopupMenu popupMenu = new PopupMenu(MainActivityListNote.this, lv);
                popupMenu.getMenuInflater().inflate(R.menu.menu_popup,popupMenu.getMenu());
                popupMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem menuItem) {
                       // Toast.makeText(MainActivityListNote.this, i+"", Toast.LENGTH_SHORT).show();
                        arrNote.remove(i);
                        noteAdapter.notifyDataSetChanged();
                        SharedPreferences.Editor editor = NoteContent.sharedPreferences.edit();
                        editor.remove("Title"+i);
                        editor.remove("Date"+i);
                        editor.remove("Image"+i);
                        editor.remove("Content"+i);
                        editor.commit();
                        Toast.makeText(MainActivityListNote.this, arrNote.size()+"", Toast.LENGTH_SHORT).show();
                        for(int j=i;j< arrNote.size();j++){
                            String t = NoteContent.sharedPreferences.getString("Title"+(j+1),"");
                            String d = NoteContent.sharedPreferences.getString("Date"+(j+1),"");
                            String im = NoteContent.sharedPreferences.getString("Image"+(j+1),"");
                            String c = NoteContent.sharedPreferences.getString("Content"+(j+1),"");
                            editor.putString("Title"+j,t);
                            editor.putString("Date"+j,d);
                            editor.putString("Image"+j,im);
                            editor.putString("Content"+j,c);
                            editor.commit();
                        }
                        return true;
                    }
                });
                popupMenu.show();
                return true;
            }
        });

    }

    @Override
    protected void onRestart() {
        noteAdapter = new NoteAdapter(this, R.layout.item_note, arrNote);
        lv.setAdapter(noteAdapter);
        super.onRestart();
    }


}