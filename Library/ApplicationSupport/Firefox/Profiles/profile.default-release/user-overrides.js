//I read the wiki
//https://github.com/arkenfox/user.js/wiki/3.2-Overrides-%5BCommon%5D

// Disable the Daily Ping Usage
// Was recently separated from the other telemetry preferences by default in 136.0, but will likely be blocked by Arkenfox soon.
user_pref("datareporting.usage.uploadEnabled", false);

// Disable those Pocket recommended stories in the new tab page
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Disable AccuWeather
user_pref("browser.newtabpage.activity-stream.showWeather", false);

// Homepage
// 0=blank, 1=home, 2=last visited page, 3=resume previous session
user_pref("browser.startup.page", 1);
user_pref("browser.sessionstore.privacy_level", 0);
// change about:blank to any website (e.g. trafotin.com)
user_pref("browser.startup.homepage", "http://192.168.50.180:8081/");

// Tired of everything getting deleted?
// This must also be checked if you want to "resume previous session."
// If you used Arkenfox in the past, you must update as Firefox has a new API for this.
// https://github.com/arkenfox/user.js/issues/1080
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false); // 2811 FF128-135
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false); // 2812 FF136+

// optional to match when you use settings>Cookies and Site Data>Clear Data
  // user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false); // 2820 FF128-135
  // user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false); // 2821 FF136+

// optional to match when you use Ctrl-Shift-Del (settings>History>Custom Settings>Clear History)
  // user_pref("privacy.clearHistory.historyFormDataAndDownloads", false); // 2830 FF128-135
  // user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false); // 2831 FF136+

// New Tab Options
// user_pref("browser.newtabpage.enabled", true);
// user_pref("browser.newtabpage.activity-stream.default.sites", "");

//Enable Search Engine suggestion
// user_pref("browser.search.suggest.enabled", true);
// user_pref("browser.urlbar.suggest.searches", true);

// Disk caching, which might improve performance if enabled.
// user_pref("browser.cache.disk.enable", true);
