package com.example.appofhuy;

import static com.example.appofhuy.R.id.imgCamera;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContract;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;


import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;

public class NoteContent extends AppCompatActivity {
    EditText edtTT, edtD,edtC;
    ImageView imgCmr, imgAnh;
    Button btn,btnUp;
    Bitmap bitmap;
    public static SharedPreferences sharedPreferences;



    public String bitmapToString(Bitmap bitmap) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        return Base64.encodeToString(byteArray, Base64.DEFAULT);
    }

    private final ActivityResultLauncher<Intent> launcher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            new ActivityResultCallback<ActivityResult>() {
                @Override
                public void onActivityResult(ActivityResult result) {
                    if(result.getResultCode()==RESULT_OK){
                        Intent intent = result.getData();
                        assert intent != null;
                        bitmap = (Bitmap) intent.getExtras().get("data");
                        imgAnh.setImageBitmap(bitmap);
                    }
                }
            });

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note_content);
        edtTT = (EditText) findViewById(R.id.tt);
        edtD = (EditText) findViewById(R.id.dd);
        imgCmr = (ImageView)  findViewById(R.id.imgCamera);
        imgAnh = (ImageView)  findViewById(R.id.imgAnh);
        btn = (Button) findViewById(R.id.btnCf);
        btnUp = (Button) findViewById(R.id.btnUpdate);
        edtC = (EditText) findViewById(R.id.edtContent);
        sharedPreferences = getSharedPreferences("dataNote",MODE_PRIVATE);

        Intent intent = getIntent();
        int idItem = intent.getIntExtra("idNote",-1);
        if(idItem !=-1){
            btn.setEnabled(false);
            edtTT.setEnabled(false);
            edtD.setEnabled(false);
            imgCmr.setEnabled(false);
            edtTT.setText(MainActivityListNote.arrNote.get(idItem).getTitle());
            edtD.setText(MainActivityListNote.arrNote.get(idItem).getDate());
            imgAnh.setImageResource(MainActivityListNote.arrNote.get(idItem).getIdImg());
            edtC.setText(sharedPreferences.getString("Content"+idItem," "));
        }
        else{
            btnUp.setEnabled(false);
        }

        Map<String, ?> allEntries = sharedPreferences.getAll();
        for (Map.Entry<String, ?> entry : allEntries.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            // Xử lý giá trị tương ứng với khóa key ở đây
            // Ví dụ: In ra khóa và giá trị
            Log.d("SharedPreferences", key + ": " + value.toString());
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy");

        edtD.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Calendar calendar = Calendar.getInstance();
                int d = calendar.get(Calendar.DATE);
                int m = calendar.get(Calendar.MONTH);
                int y = calendar.get(Calendar.YEAR);
                DatePickerDialog datePickerDialog = new DatePickerDialog(NoteContent.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker datePicker, int i, int i1, int i2) {
                        // calendar sẽ luôn luôn lấy thời gian hiện tại
                        // nếu muốn lấy thời gian mong muốn thì cần gọi PT set(int year,int month,int day)
                        // các  tham số i,i1,i2 của hàm onDateSet sẽ trả về năm, tháng, ngày.
                        calendar.set(i,i1,i2);
                        edtD.setText(simpleDateFormat.format(calendar.getTime()));
                    }
                },y,m,d);
                datePickerDialog.show();
            }
        });
        imgCmr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                launcher.launch(intent);
            }
        });
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String tt = edtTT.getText().toString().trim();
                String d = edtD.getText().toString().trim();
                if(tt.length()>0 && d.length()>0 && bitmap!=null){

                    // Lấy vị trí làm tag để lưu
                    int countNote;
                    countNote = MainActivityListNote.arrNote.size();

                    // Thêm đối tượng vào arrNote và cập nhật, thông báo cho noteAdapter biết
                    Note note = new Note(tt,d);
                    MainActivityListNote.arrNote.add(note);
                    MainActivityListNote.noteAdapter.notifyDataSetChanged();

                    SharedPreferences.Editor editor = sharedPreferences.edit();
                    editor.putString("Title"+countNote,edtTT.getText().toString());
                    editor.putString("Date"+countNote,edtD.getText().toString());
                    String bitmaptoString = bitmapToString(bitmap);
                    editor.putString("Image"+countNote,bitmaptoString);
                    editor.putString("Content"+countNote,edtC.getText().toString());
//                    editor.remove("Title5");
//                    editor.remove("Date5");
//                    editor.remove("Image5");
//                    editor.remove("Content5");
                    editor.commit();
                    Toast.makeText(NoteContent.this, MainActivityListNote.arrNote.size()+" ", Toast.LENGTH_SHORT).show();
                    finish();
                }

            }
        });
        btnUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedPreferences.Editor editor = sharedPreferences.edit();
                editor.putString("Content"+idItem,edtC.getText().toString());
                editor.commit();
            }
        });
    }
}