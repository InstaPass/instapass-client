package io.github.yuetsin.instapass.preferences

import android.app.Activity
import android.content.Context.MODE_PRIVATE

class UserPrefInitializer {
    companion object {
        var jwtToken: String?
            get() {
                return Activity().getPreferences(MODE_PRIVATE).getString(PrefKeyEnum.JwtToken.key, "")
            }
            set(value) {
                val editor = Activity().getPreferences(MODE_PRIVATE).edit()
                editor.putString(PrefKeyEnum.JwtToken.key, value)
                editor.apply()
            }

        var userName: String?
            get() {
                return Activity().getPreferences(MODE_PRIVATE).getString(PrefKeyEnum.UserName.key, "")
            }
            set(value) {
                val editor = Activity().getPreferences(MODE_PRIVATE).edit()
                editor.putString(PrefKeyEnum.UserName.key, value)
                editor.apply()
            }

        var userId: String?
            get() {
                return Activity().getPreferences(MODE_PRIVATE).getString(PrefKeyEnum.UserId.key, "")
            }
            set(value) {
                val editor = Activity().getPreferences(MODE_PRIVATE).edit()
                editor.putString(PrefKeyEnum.UserId.key, value)
                editor.apply()
            }
    }
}