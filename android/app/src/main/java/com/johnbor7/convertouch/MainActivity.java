package com.johnbor7.convertouch;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "convertouch/main_activity";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getMessage")) {
                                String message = getMessage();
                                result.success(message);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private String getMessage() {
        return "Hello, convertouch app with flutter, attempt: ";
    }
}
