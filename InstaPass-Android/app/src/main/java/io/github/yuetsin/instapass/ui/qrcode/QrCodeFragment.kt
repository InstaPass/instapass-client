package io.github.yuetsin.instapass.ui.qrcode

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import io.github.yuetsin.instapass.R

class QrCodeFragment : Fragment() {

    private lateinit var qrCodeViewModel: QrCodeViewModel

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        qrCodeViewModel =
                ViewModelProviders.of(this).get(QrCodeViewModel::class.java)
        return inflater.inflate(R.layout.fragment_qrcode, container, false)
    }
}
