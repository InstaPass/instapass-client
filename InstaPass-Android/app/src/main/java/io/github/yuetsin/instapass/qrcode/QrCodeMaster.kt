package io.github.yuetsin.instapass.qrcode

import android.graphics.Bitmap
import android.graphics.Color
import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.journeyapps.barcodescanner.BarcodeEncoder
import io.github.yuetsin.instapass.request.FeatureTypeEnum
import io.github.yuetsin.instapass.request.RequestTypeEnum
import io.github.yuetsin.instapass.request.RequestsManager
import java.util.*

class QrCodeMaster {

    companion object {
        private val qrCodeColor = Color.valueOf(0.34375F, 0.58203125F, 0.671875F)
        private val backgroundColor = Color.TRANSPARENT

        fun getQrCodeImage(qrCodeSecret: String, width: Int, height: Int): Bitmap? {
            return try {
                val result = MultiFormatWriter().encode(
                    qrCodeSecret, BarcodeFormat.QR_CODE, width, height)
                BarcodeEncoder().createBitmap(result)
            } catch (e: WriterException){
                e.printStackTrace()
                null
            } catch (_: IllegalArgumentException) {
                null
            }
        }

        fun refreshQrCode(id: Int, success: (String, Date) -> Void, failure: (String) -> Void) {
            RequestsManager.request(
                RequestTypeEnum.Get,
                FeatureTypeEnum.QrCode,
                id.toString(),
                null,
                {
                    val secret = it["secret"].toString()
                    val refreshTime = it["last_refresh_time"].toString().toLong()
                    val date = Date(refreshTime)
                    success(secret, date)
                },
                {
                    failure(it)
                })
        }
    }
}