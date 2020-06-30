package io.github.yuetsin.instapass.login

import io.github.yuetsin.instapass.preferences.UserPrefInitializer.Companion.jwtToken
import io.github.yuetsin.instapass.request.FeatureTypeEnum
import io.github.yuetsin.instapass.request.RequestTypeEnum
import io.github.yuetsin.instapass.request.RequestsManager
import org.json.JSONObject

class LoginHelper {
    companion object {
        // always assume login until one request failed
        var isLogin = true

        fun login(
            username: String,
            password: String,
            success: () -> Void,
            failure: (String) -> Void
        ) {
            RequestsManager.request(RequestTypeEnum.Post, FeatureTypeEnum.Login, "", JSONObject().put("username", username).put("password", password),
                {
                    isLogin = true
                    jwtToken = it["jwt_token"].toString()
                    success()
                }, {
                    isLogin = false
                    failure(it)
                })
        }

        fun logout(success: () -> Void, failure: () -> Void) {
            isLogin = false
            jwtToken = ""

            success()
        }
    }
}