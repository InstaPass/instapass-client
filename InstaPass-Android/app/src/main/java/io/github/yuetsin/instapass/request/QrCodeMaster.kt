package io.github.yuetsin.instapass.request

import android.graphics.Bitmap
import android.graphics.Color
import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.google.zxing.common.BitMatrix
import com.journeyapps.barcodescanner.BarcodeEncoder
import java.util.*

class QrCodeMaster {

    companion object {
        private var qrCodeSecret: String? = null
        private var lastRefreshTime: Date? = null
        private val qrCodeColor = Color.valueOf(0.390625F, 0.8203125F, 0.46484375F)
        private val backgroundColor = Color.TRANSPARENT

        fun getQrCodeImage(width: Int, height: Int): Bitmap? {
            var bitmap: Bitmap? = null
            try {
                val result = MultiFormatWriter().encode(qrCodeSecret ?: "instapass{None}", BarcodeFormat.QR_CODE, width, height)
                bitmap = BarcodeEncoder().createBitmap(result)
            } catch (e: WriterException){
                e.printStackTrace()
            } catch (_: IllegalArgumentException) {
                return null
            }
            return bitmap
        }

        fun refreshQrCode(success: (String, Date) -> Void, failure: (String) -> Void) {
            RequestsManager.request(RequestTypeEnum.Get, FeatureTypeEnum.QrCode, null, {
                val secret = it["secret"].toString()
                val lastRefreshTime = it["last_refresh_time"].toString().toLong()
                val date = Date(lastRefreshTime)
                success(secret, date)
            }, {
                qrCodeSecret = null
                failure(it)
            })
        }
    }
}