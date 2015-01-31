package de.uni_tuebingen.gris.ml.atsa.cvconvnet;

import org.opencv.core.Mat;

/**
 * Created by david on 1/30/15.
 */
public class CVConvNet {

    private static native short n_getMajorVersion();

    private static native short n_getMinorVersion();

    private static native long n_create();

    private static native void n_destroy(long nativeInstance);

    private static native void n_load(long nativeInstance, String haarcascadePath, String cnnPath);

    private static native short[] n_perform(long nativeInstance, long image);

    private final long nativeInstance;

    public static short getMajorVersion() {
        return CVConvNet.n_getMajorVersion();
    }

    public static short getMinorVersion() {
        return CVConvNet.n_getMinorVersion();
    }

    public static String getVersionString() {
        return String.format("%d.%d",CVConvNet.getMajorVersion(),CVConvNet.getMinorVersion());
    }

    public CVConvNet() {
        this.nativeInstance = CVConvNet.n_create();
    }

    public void load(String haarcascadePath, String cnnPath) {
        CVConvNet.n_load(this.nativeInstance,haarcascadePath,cnnPath);
    }

    public short[] perform(Mat image) {
        return CVConvNet.n_perform(this.nativeInstance,image.nativeObj);
    }

    @Override
    protected void finalize() throws Throwable {

        CVConvNet.n_destroy(this.nativeInstance);
        super.finalize();
    }
}
