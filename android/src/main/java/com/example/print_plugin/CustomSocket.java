package com.example.print_plugin;

import android.util.Log;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;

public class CustomSocket  {
    byte[] data;
    String ip;
    int port;

    public CustomSocket(ArrayList<Integer> data, String ip, int port) {
        this.ip = ip;
        this.port = port;
        byte[] result = new byte[data.size()];
        for(int i = 0; i < data.size(); i++) {
            result[i] = data.get(i).byteValue();
        }
        this.data = result;
        init();
    }

    DataOutputStream _outToServer;

    void init() {
            Thread thread = new Thread(() -> {
                Socket socket;
                try {
                    socket = new Socket(ip, port);
                    if (!socket.isConnected()){
                        Log.println(Log.DEBUG, "local addr", String.valueOf(socket.getLocalAddress()));
                        Log.println(Log.DEBUG, "local port", String.valueOf(socket.getLocalPort()));
                        Log.println(Log.DEBUG, "des addr", String.valueOf(socket.getInetAddress()));
                        Log.println(Log.DEBUG, "des port", String.valueOf(socket.getPort()));
                    }
                    _outToServer = new DataOutputStream(socket.getOutputStream());
                    _outToServer.write(data);
                    _outToServer.flush();
                    _outToServer.close();
                    socket.close();
                } catch (IOException ioException) {
                    Log.e("IOException", ioException.toString(), ioException);
                }
            });
            thread.start();
    }
}
