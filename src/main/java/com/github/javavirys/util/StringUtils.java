package com.github.javavirys.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.LinkedHashMap;
import java.util.Map;

public class StringUtils {

    public static Map<String, String> splitQuery(String url) throws UnsupportedEncodingException {
        Map<String, String> queryPairs = new LinkedHashMap<>();
        int beginIndex = url.indexOf('#');
        if (beginIndex != -1 && beginIndex + 1 < url.length()) {
            String query = url.substring(beginIndex + 1);
            if (query.trim().length() == 0) return queryPairs;
            String[] pairs = query.split("&");
            for (String pair : pairs) {
                int idx = pair.indexOf("=");
                queryPairs.put(URLDecoder.decode(pair.substring(0, idx), "UTF-8"),
                        URLDecoder.decode(pair.substring(idx + 1), "UTF-8"));
            }
        }
        return queryPairs;
    }
}