package io.github.yuetsin.instapass.request

enum class FeatureTypeEnum(val url: String) {
    Login("/login"),
    QrCode("/resident/qrcode"),
    Logout("/resident/logout"),
    Avatar("/resident/avatar"),
    History("/resident/history"),
    Info("/resident/info"),
    Upload("/resident/upload"),
    Notify("/resident/notifications"),
    Community("/resident/community")
}