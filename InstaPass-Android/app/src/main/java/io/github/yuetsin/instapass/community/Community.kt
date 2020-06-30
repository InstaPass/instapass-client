package io.github.yuetsin.instapass.community

class Community(id: Int, name: String, address: String, temporary: Boolean) {
    var id: Int
    lateinit var name: String
    lateinit var address: String
    var temporary: Boolean

    init {
        this.id = id
        this.name = name
        this.address = address
        this.temporary = temporary
    }
}