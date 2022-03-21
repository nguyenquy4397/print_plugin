package com.example.print_plugin;

import android.util.Log;

import androidx.annotation.Nullable;

import java.io.BufferedOutputStream;
import java.util.concurrent.TimeUnit;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;

public class CustomSocket  {
    byte[] data;
    String ip;
    int port;
    int partSize;
    int timeDelay; //MILLISECONDS

    public CustomSocket(ArrayList<Integer> data, String ip, int port, int partSize, int timeDelay) {
        this.ip = ip;
        this.port = port;
        byte[] result = new byte[data.size()];
        for(int i = 0; i < data.size(); i++) {
            result[i] = data.get(i).byteValue();
        }
        this.data = result;
        this.partSize = partSize;
        this.timeDelay = timeDelay;
        init();
    }

    BufferedOutputStream _outToServer;

    void init() {
            Thread thread = new Thread(() -> {
                Socket socket;
                try {
                    socket = new Socket(ip, port);
                    _outToServer = new BufferedOutputStream(socket.getOutputStream());
                    Log.println(Log.DEBUG, "partSize", String.valueOf(partSize));
                    if (partSize == 0) {
                        _outToServer.write(data);
                    } else {
                        for (int i = 0; i < data.length; i += partSize) {
                            _outToServer.write(data, i, partSize);
                            Log.println(Log.DEBUG, "pause", String.valueOf(i));
                            TimeUnit.MILLISECONDS.sleep(1000);
                        }
                    }
                    _outToServer.flush();
                    _outToServer.close();
                    socket.close();
                } catch (IOException | InterruptedException ioException) {
                    Log.e("IOException", ioException.toString(), ioException);
                }
            });
            thread.start();
    }
}
