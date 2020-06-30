package io.github.yuetsin.instapass.ui.qrcode

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import com.google.android.material.tabs.TabLayout
import io.github.yuetsin.instapass.R
import io.github.yuetsin.instapass.qrcode.QrCodeMaster
import kotlinx.android.synthetic.main.fragment_qrcode.*

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
