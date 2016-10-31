
package com.reactlibrary;

import com.coremedia.iso.boxes.Container;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import android.util.Log;
import com.facebook.react.bridge.ReadableArray;

import com.googlecode.mp4parser.authoring.Movie;
import com.googlecode.mp4parser.authoring.Track;
import com.googlecode.mp4parser.authoring.container.mp4.MovieCreator;
import com.googlecode.mp4parser.authoring.tracks.AppendTrack;
import com.googlecode.mp4parser.authoring.builder.DefaultMp4Builder;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class RNVideoEditorModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNVideoEditorModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @ReactMethod
  public void merge(ReadableArray videoFiles, Callback errorCallback, Callback successCallback) {

    List<Movie> inMovies = new ArrayList<Movie>();

    for (int i = 0; i < videoFiles.size(); i++) {
     String videoUrl = videoFiles.getString(i).replaceFirst("file://", "");

      try {
        inMovies.add(MovieCreator.build(videoUrl));
      } catch (IOException e) {
        errorCallback.invoke(e.getMessage());
        e.printStackTrace();
      }
    }

    List<Track> videoTracks = new LinkedList<Track>();
    List<Track> audioTracks = new LinkedList<Track>();

    for (Movie m : inMovies) {
      for (Track t : m.getTracks()) {
        if (t.getHandler().equals("soun")) {
          audioTracks.add(t);
        }
        if (t.getHandler().equals("vide")) {
          videoTracks.add(t);
        }
      }
    }

    Movie result = new Movie();

    if (!audioTracks.isEmpty()) {
      try {
        result.addTrack(new AppendTrack(audioTracks.toArray(new Track[audioTracks.size()])));
      } catch (IOException e) {
        errorCallback.invoke(e.getMessage());
        e.printStackTrace();
      }
    }
    if (!videoTracks.isEmpty()) {
      try {
        result.addTrack(new AppendTrack(videoTracks.toArray(new Track[videoTracks.size()])));
      } catch (IOException e) {
        errorCallback.invoke(e.getMessage());
        e.printStackTrace();
      }
    }

    Container out = new DefaultMp4Builder().build(result);
    FileChannel fc = null;

    try {

      Long tsLong = System.currentTimeMillis()/1000;
      String ts = tsLong.toString();

      String outputVideo = reactContext.getApplicationContext().getCacheDir().getAbsolutePath()+"output_"+ts+".mp4";

      fc = new RandomAccessFile(String.format(outputVideo), "rw").getChannel();

      Log.d("VIDEO", String.valueOf(fc));
      out.writeContainer(fc);
      fc.close();
      successCallback.invoke("", outputVideo);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      errorCallback.invoke(e.getMessage());
    } catch (IOException e) {
      e.printStackTrace();
      errorCallback.invoke(e.getMessage());
    }

  }

  @Override
  public String getName() {
    return "RNVideoEditor";
  }
}
