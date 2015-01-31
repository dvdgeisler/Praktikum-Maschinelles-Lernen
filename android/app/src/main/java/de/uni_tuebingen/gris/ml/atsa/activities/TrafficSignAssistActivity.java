package de.uni_tuebingen.gris.ml.atsa.activities;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.SurfaceView;
import android.view.WindowManager;

import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.CameraBridgeViewBase;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;
import org.opencv.core.Mat;

import de.uni_tuebingen.gris.ml.atsa.R;
import de.uni_tuebingen.gris.ml.atsa.TrafficSignAssist;


public class TrafficSignAssistActivity extends ActionBarActivity {
    private static final String TAG = "OCVSample::Activity";

    private CameraBridgeViewBase cameraView;

    public TrafficSignAssistActivity() {}

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TrafficSignAssist.getInstance().loadOpenCVLibrary(this.getApplicationContext());
        TrafficSignAssist.getInstance().loadCVConvNetLibrary(this.getApplicationContext());
        TrafficSignAssist.getInstance().loadCameraObserver(this.getApplicationContext());

        this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        this.setContentView(R.layout.activity_traffic_sign_assist);
        this.cameraView = (CameraBridgeViewBase) findViewById(R.id.camera_view);
        this.cameraView.setVisibility(SurfaceView.VISIBLE);
        this.cameraView.setCvCameraViewListener(TrafficSignAssist.getInstance().getCameraObserver());
        this.cameraView.enableView();
    }

    @Override
    public void onPause()
    {
        super.onPause();
        if (cameraView != null)
            cameraView.disableView();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (cameraView != null)
            cameraView.disableView();
    }
}
