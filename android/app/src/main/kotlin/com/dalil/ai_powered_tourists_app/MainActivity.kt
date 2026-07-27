package com.ahizaz.dalil

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "app.channel.audio"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "setMediaVolumeMax" -> {
                    try {
                        val audioManager =
                            getSystemService(
                                Context.AUDIO_SERVICE
                            ) as AudioManager

                        val maxVolume =
                            audioManager.getStreamMaxVolume(
                                AudioManager.STREAM_MUSIC
                            )

                        audioManager.setStreamVolume(
                            AudioManager.STREAM_MUSIC,
                            maxVolume,
                            0
                        )

                        result.success(true)
                    } catch (e: Exception) {
                        result.error(
                            "ERROR",
                            e.message,
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}