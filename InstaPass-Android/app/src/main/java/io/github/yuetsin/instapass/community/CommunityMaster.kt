package io.github.yuetsin.instapass.community

import io.github.yuetsin.instapass.request.FeatureTypeEnum
import io.github.yuetsin.instapass.request.RequestTypeEnum
import io.github.yuetsin.instapass.request.RequestsManager

class CommunityMaster {

    companion object {
        var communities = ArrayList<Community>()

        fun constantCommunities(): ArrayList<Community> {
            val constantCommunities = ArrayList<Community>()
            for (community in communities) {
                if (!community.temporary) {
                    constantCommunities.add(community)
                }
            }
            return constantCommunities
        }

        fun refreshCommunity(success: () -> Void, failure: (String) -> Void) {
            communities.clear()

            RequestsManager.request(RequestTypeEnum.Get, FeatureTypeEnum.Community, "", null, {
                val listArray = it.getJSONArray("communities")

                for (i in 0 until listArray.length()) {
                    val item = listArray.getJSONObject(i)
                    communities.add(Community(item.getInt("community_id"), item.getString("community"), item.getString("address"), item.getBoolean("temporary")))
                }
                success()
            }, {
                failure(it)
            })
        }
    }
}