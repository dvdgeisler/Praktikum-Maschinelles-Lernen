package de.uni_tuebingen.gris.ml.atsa;

import android.util.Log;

import org.opencv.android.CameraBridgeViewBase;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;

import java.nio.ByteBuffer;

import de.uni_tuebingen.gris.ml.atsa.cvconvnet.CVConvNet;

/**
 * Created by david on 1/30/15.
 */
public class CameraObserver implements CameraBridgeViewBase.CvCameraViewListener2 {
    private static final String TAG = "TrafficSignAssist";

    private CVConvNet convNet;
    private String haarcascadePath;
    private String cnnPath;
    private short[] lastResult = new short[] {0};

    public CameraObserver(String haarcascadePath, String cnnPath) {
        this.convNet = null;
        this.haarcascadePath = haarcascadePath;
        this.cnnPath = cnnPath;
    }

    @Override
    public void onCameraViewStarted(int width, int height) {
        if(this.convNet == null) {
            this.convNet = new CVConvNet();
            this.convNet.load(this.haarcascadePath,this.cnnPath);
        }
    }

    @Override
    public void onCameraViewStopped() {

    }

    @Override
    public Mat onCameraFrame(CameraBridgeViewBase.CvCameraViewFrame inputFrame) {
        short[] result;
        Mat img;
        short x, y, w, h;
        Point p1,p2,p3,p4;
        Scalar color;

        img = inputFrame.rgba();
        result = this.convNet.perform(img);
        color = new Scalar(255,0,0);

        if(result[0] == 0)
            result = this.lastResult;
        else
            this.lastResult = result;

        Log.i(TAG, String.format("found %d results " , result[0]));
        for(int i = 1; i < result.length; i+=5) {
            x = result[i];
            y = result[i+1];
            w = result[i+2];
            h = result[i+3];
            p1 = new Point(x,y);
            p2 = new Point(x+w,y);
            p3 = new Point(x+w,y+h);
            p4 = new Point(x,y+h);
            Core.line(img,p1,p2,color,2);
            Core.line(img,p2,p3,color,2);
            Core.line(img,p3,p4,color,2);
            Core.line(img,p4,p1,color,2);
        }

        return img;
    }

}
