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
        private var qrCodeSecret: String? = null
        private var lastRefreshTime: Date? = null
        private val qrCodeColor = Color.valueOf(0.390625F, 0.8203125F, 0.46484375F)
        private val backgroundColor = Color.TRANSPARENT

        fun getQrCodeImage(width: Int, height: Int): Bitmap? {
            return try {
                val result = MultiFormatWriter().encode(
                    qrCodeSecret
                        ?: "instapass{None}", BarcodeFormat.QR_CODE, width, height)
                BarcodeEncoder().createBitmap(result)
            } catch (e: WriterException){
                e.printStackTrace()
                null
            } catch (_: IllegalArgumentException) {
                null
            }
        }

        fun refreshQrCode(success: (String, Date) -> Void, failure: (String) -> Void) {
            RequestsManager.request(
                RequestTypeEnum.Get,
                FeatureTypeEnum.QrCode,
                null,
                {
                    val secret = it["secret"].toString()
                    val refreshTime = it["last_refresh_time"].toString().toLong()
                    val date = Date(refreshTime)
                    qrCodeSecret =
                        secret
                    lastRefreshTime =
                        date
                    success(secret, date)
                },
                {
                    qrCodeSecret =
                        null
                    lastRefreshTime =
                        null
                    failure(it)
                })
        }
    }
}