package com.example.appofhuy;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityOptionsCompat;

import android.app.ActivityOptions;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    Button btnLogin;
    EditText edtName, edtPass;
    CheckBox cb;
    SharedPreferences sharedPreferences;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnLogin = (Button) findViewById(R.id.btn);
        edtName = (EditText) findViewById(R.id.name);
        edtPass = (EditText) findViewById(R.id.pass);
        cb = (CheckBox) findViewById(R.id.ckeckB);
        sharedPreferences = getSharedPreferences("dataLogin",MODE_PRIVATE);

        String n = sharedPreferences.getString("name","Name");
        String p = sharedPreferences.getString("pass","Pass");
        edtName.setText(n);
        edtPass.setText(p);
        cb.setChecked(true);
        Toast.makeText(this, R.drawable.ic_launcher_background+" ", Toast.LENGTH_SHORT).show();

        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String n = edtName.getText().toString();
                String p = edtPass.getText().toString();
                SharedPreferences.Editor editor = sharedPreferences.edit();
                if( n.equals("n q huy") && p.equals("12345678")){
                    if(cb.isChecked()){
                        editor.putString("name",n);
                        editor.putString("pass",p);
                        editor.commit();
                    }
                    else{
                        editor.remove("name");
                        editor.remove("pass");
                        editor.commit();
                    }
                    Intent intent = new Intent(MainActivity.this,MainActivityListNote.class);
                    ActivityOptionsCompat options = ActivityOptionsCompat.makeCustomAnimation(
                            MainActivity.this, R.anim.anim_enter, R.anim.anim_exit);
                    startActivity(intent, options.toBundle());
                }
            }
        });


    }

}