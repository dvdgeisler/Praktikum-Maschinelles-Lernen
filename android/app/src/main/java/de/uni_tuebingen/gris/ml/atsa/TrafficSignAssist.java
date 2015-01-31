package de.uni_tuebingen.gris.ml.atsa;

import android.content.Context;
import android.nfc.Tag;
import android.os.Environment;
import android.util.Log;

import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.core.Core;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import de.uni_tuebingen.gris.ml.atsa.CameraObserver;
import de.uni_tuebingen.gris.ml.atsa.cvconvnet.CVConvNet;

/**
 * Created by david on 1/30/15.
 */
public class TrafficSignAssist {
    private static final String TAG = "TrafficSignAssist";

    private static final TrafficSignAssist instance = new TrafficSignAssist();

    private CameraObserver cameraObserver;

    private TrafficSignAssist() {}

    public void loadOpenCVLibrary(Context context) {

        Log.i(TAG,"load opencv");
        System.loadLibrary("opencv_java");
        Log.i(TAG, "opencv successful loaded : ver " + Core.VERSION);
    }

    public void loadCVConvNetLibrary(Context context) {

        Log.i(TAG,"load cvconvnet");
        System.loadLibrary("CVConvNet");
        Log.i(TAG, "cvconvnet successful loaded : ver " + CVConvNet.getVersionString());
    }

    private int writeRessourceToFile(Context context, int resId, File outFile) throws IOException {

        final InputStream in;
        final OutputStream out;

        final byte[] buffer;
        int length;
        int totalLength;

        if(!outFile.createNewFile()) {
            throw new IOException(String.format("cannot create file:",outFile.getAbsolutePath()));
        }

        in = context.getResources().openRawResource(resId);
        out = new FileOutputStream(outFile);
        buffer = new byte[1024];
        length = 0;
        totalLength = 0;

        while ((length = in.read(buffer)) != -1) {
            out.write(buffer, 0, length);
            totalLength += length;
        }

        in.close();
        out.close();

        return totalLength;
    }

    public void loadCameraObserver(Context context) {

        final File haarcascadeFile;
        final File cnnFile;

        Log.i(TAG,"load camera observer");

        haarcascadeFile = new File(Environment.getExternalStorageDirectory(),"haarcascade.xml");
        cnnFile = new File(Environment.getExternalStorageDirectory(),"cnn.xml");

        haarcascadeFile.delete();
        cnnFile.delete();

        if(!haarcascadeFile.exists() || true) {
            Log.i(TAG,String.format("create haarcascade definition: %s",haarcascadeFile.getAbsolutePath()));
            try {
                Log.i(TAG,String.format("wrote %d bytes to %s",
                        this.writeRessourceToFile(context,R.raw.haarcascade,haarcascadeFile),
                        haarcascadeFile.getAbsolutePath()));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        } else
            Log.i(TAG,String.format("found haarcascade definition: %s",haarcascadeFile.getAbsolutePath()));

        if(!cnnFile.exists() ) {
            Log.i(TAG,String.format("create cnn definition: %s",cnnFile.getAbsolutePath()));
            try {
                Log.i(TAG,String.format("wrote %d bytes to %s",
                        this.writeRessourceToFile(context,R.raw.cnn,cnnFile),
                        cnnFile.getAbsolutePath()));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        } else
            Log.i(TAG,String.format("found cnn definition: %s",cnnFile.getAbsolutePath()));

        if(!haarcascadeFile.isFile() || !haarcascadeFile.canRead()) {
            Log.e(TAG,"no harcascade definition found");
            throw new RuntimeException(String.format("cannot access file:",haarcascadeFile.getAbsolutePath()));
        }

        if(!cnnFile.isFile() || !cnnFile.canRead()) {
            Log.e(TAG,"no cnn definition found");
            throw new RuntimeException(String.format("cannot access file:",cnnFile.getAbsolutePath()));
        }

        this.cameraObserver = new CameraObserver(haarcascadeFile.getPath(),cnnFile.getPath());
    }

    public static TrafficSignAssist getInstance() {
        return TrafficSignAssist.instance;
    }

    public CameraObserver getCameraObserver() {
        return this.cameraObserver;
    }
}
