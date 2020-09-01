package com.github.javavirys.test.utils;

import com.github.javavirys.util.StringUtils;
import org.junit.Test;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.CoreMatchers.is;

public class StringUtilsTest {

    private final String[] SUCCESS_URLS = {
            "https://www.domain.com/index",
            "https://www.domain.com/index#key1=value1",
            "https://www.domain.com/index#key1=value1&key2=value2",
            "https://www.domain.com/index#key1=value1&key2=value2&key3=value3",
    };

    private final String[] INVALID_URLS = {
            "",
            "https://",
            "https://www.domain.com/index#"
    };

    @Test
    public void testSplitQueryWithValidUrls() throws UnsupportedEncodingException {
        for (int i = 0; i < SUCCESS_URLS.length; i++) {
            Map<String, String> map = StringUtils.splitQuery(SUCCESS_URLS[i]);
            assertThat(map.size(), is(i));
            for (int j = 1; j < i + 1; j++) {
                assertThat(map.containsKey("key" + j), is(true));
                assertThat(map.containsValue("value" + j), is(true));
            }
        }
    }

    @Test
    public void testSplitQueryWithInvalidUrls() throws UnsupportedEncodingException {
        for (String invalid_url : INVALID_URLS) {
            Map<String, String> map = StringUtils.splitQuery(invalid_url);
            assertThat(map.isEmpty(), is(true));
        }
    }
}
