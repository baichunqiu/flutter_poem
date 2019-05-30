package com.bcq.poetry;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipInputStream;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        new Thread(new Runnable() {
            @Override
            public void run() {
                copyDatabaseFromAssets(MainActivity.this);
            }
        }).start();
        GeneratedPluginRegistrant.registerWith(this);
    }

    private final String TAG = "copyDatabaseFromAssets";
    private final String DB_NAME = "shici.db";
    private final String mAssetPath = "databases" + File.separator + DB_NAME;

    @TargetApi(Build.VERSION_CODES.DONUT)
    private void copyDatabaseFromAssets(Context context) {
        Log.e(TAG, "copying database from assets...");
        String mDatabasePath = context.getApplicationInfo().dataDir + File.separator + "databases";
        String dest = mDatabasePath + File.separator + DB_NAME;
        Log.e(TAG, "assetPath = " + mAssetPath);
        Log.e(TAG, "destPath  = " + dest);
        File df = new File(dest);
        if (df.exists()) {
            Log.e(TAG, "db exists ");
            return;
        }
        InputStream is = null;
        boolean isZip = false;
        try {
            // try uncompressed
            is = context.getAssets().open(mAssetPath);
        } catch (IOException e) {
            // try zip
            try {
                is = context.getAssets().open(mAssetPath + ".zip");
                isZip = true;
            } catch (IOException e2) {
                // try gzip
                try {
                    is = context.getAssets().open(mAssetPath + ".gz");
                } catch (IOException e3) {
                    Log.e("copyDatabaseFromAssets", "Missing " + mAssetPath + " file (or .zip, .gz archive) in assets, or target folder not writable");
                }
            }
        }
        if (null == is) {
            Log.e(TAG, "open db from assets fail");
            return;
        }
        Log.e(TAG, "open db from assets success");
        try {
            File f = new File(mDatabasePath + "/");
            if (!f.exists()) {
                f.mkdir();
            }
            Log.e(TAG, "isZip = " + isZip);
            if (isZip) {
                ZipInputStream zis = Utils.getFileFromZip(is);
                if (zis == null) {
                    Log.e(TAG, "Archive is missing a SQLite database file");
                    return;
                }
                Utils.writeExtractedFileToDisk(zis, new FileOutputStream(dest));
                Log.e(TAG, "database copy complete");
            } else {
                Utils.writeExtractedFileToDisk(is, new FileOutputStream(dest));
            }
        } catch (IOException e) {
            Log.e(TAG, "Unable to write " + dest + " to data directory");
        }
    }


}
