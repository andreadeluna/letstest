package com.andreadeluna.letstest

import android.os.Bundle
import android.view.Window
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Impedisco all'utente di compiere azioni multimediali sull'app
        // (registrare lo schermo, effettuare screenshot) e oscuro la
        // schermata quando manda in background l'app

        window.addFlags(LayoutParams.FLAG_SECURE)
    }

}
