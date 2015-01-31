package de.uni_tuebingen.gris.ml.atsa;

import android.util.Log;

import org.opencv.android.CameraBridgeViewBase;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Rect;
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

    private void drawRect(Mat img, Rect rect, Scalar color) {
        Point p1,p2,p3,p4;

        p1 = new Point(rect.x,rect.y);
        p2 = new Point(rect.x+rect.width,rect.y);
        p3 = new Point(rect.x+rect.width,rect.y+rect.height);
        p4 = new Point(rect.x,rect.y+rect.height);

        Core.line(img,p1,p2,color,2);
        Core.line(img,p2,p3,color,2);
        Core.line(img,p3,p4,color,2);
        Core.line(img,p4,p1,color,2);
    }

    @Override
    public Mat onCameraFrame(CameraBridgeViewBase.CvCameraViewFrame inputFrame) {
        short[] result;
        Mat img;
        short x, y, w, h;
        Point p1,p2,p3,p4;
        Scalar color;
        Mat subMat, subMatLeft, subMatRight;
        Rect subMatLeftRect, subMatRightRect, resultRect;

        img = inputFrame.rgba();

        subMatLeftRect = new Rect(0,0,img.width()/3,img.height());
        subMatRightRect = new Rect((img.width()/3)*2,0,img.width()/3,img.height());
        subMatLeft = img.submat(subMatLeftRect);
        subMatRight = img.submat(subMatRightRect);

        result = this.convNet.perform(subMatLeft);
        subMat = null;
        for(int i = 1; i < result.length; i+=5) {
            x = (short) (result[i] + subMatLeftRect.x);
            y = (short) (result[i+1] + subMatLeftRect.y);
            w = result[i+2];
            h = result[i+3];

            resultRect = new Rect(new Point(x,y),new Point(x+w,y+h));
            subMat = img.submat(resultRect);
            this.drawRect(img,resultRect,new Scalar(255,0,0));
        }

        result = this.convNet.perform(subMatRight);
        subMat = null;
        for(int i = 1; i < result.length; i+=5) {
            x = (short) (result[i] + subMatRightRect.x);
            y = (short) (result[i+1] + subMatRightRect.y);
            w = result[i+2];
            h = result[i+3];

            resultRect = new Rect(new Point(x,y),new Point(x+w,y+h));
            subMat = img.submat(resultRect);
            this.drawRect(img,resultRect,new Scalar(255,0,0));
        }


        this.drawRect(img,subMatLeftRect,new Scalar(0,255,0));
        this.drawRect(img,subMatRightRect,new Scalar(0,255,0));

        return img;
    }

}
