package io.github.yuetsin.instapass.request

import com.github.kittinunf.fuel.Fuel
import com.github.kittinunf.fuel.android.extension.responseJson
import com.google.gson.Gson
import io.github.yuetsin.instapass.preferences.UserPrefInitializer
import org.json.JSONObject

class RequestsManager {
    companion object {
        private var baseUrl = "http://47.100.50.175:8288"

        fun request(type: RequestTypeEnum = RequestTypeEnum.Get, feature: FeatureTypeEnum, params: JSONObject?, success: (JSONObject) -> Void, failure: (String) -> Void) {
            if (type == RequestTypeEnum.Get) {

                if (params != null) {
                    println("warning: get operation shouldn't carry param values")
                }

                Fuel.get(baseUrl + feature.url)
                    .header(Pair<String, String>("Jwt-Token", UserPrefInitializer.jwtToken ?: ""))
                    .responseJson { _, _, result ->

                        result.fold({
                            val responseJson = it.obj()
                            if (responseJson["status"] == "ok") {
                                success(responseJson)
                            } else {
                                // TODO: fix status msg
                                failure(responseJson["msg"].toString())
                            }
                        }, {
                            failure(it.localizedMessage ?: "Unknown Error")
                        })
                }
            } else if (type == RequestTypeEnum.Post) {
                Fuel.post(baseUrl + feature.url)
                    .body(Gson().toJson(params))
                    .header(Pair<String, String>("Jwt-Token", UserPrefInitializer.jwtToken ?: ""))
                    .header(Pair<String, String>("Content-Type", "application/json"))
                    .responseJson { _, _, result ->
                        result.fold({
                            val responseJson = it.obj()
                            if (responseJson["status"] == "ok" || responseJson["jwt_token"].toString().isNotEmpty()) {
                                success(responseJson)
                            } else {
                                // TODO: fix status msg
                                failure(responseJson["msg"].toString())
                            }
                        }, {
                            failure(it.localizedMessage ?: "Unknown Error")
                        })
                    }
            }
        }
    }
}