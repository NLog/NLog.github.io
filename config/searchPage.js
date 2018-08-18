


var url = 'http://nlog.github.io/config/'


function getQueryStringValue(key, defaultValue) {
    var match = RegExp('[?&]' + key + '=([^&]*)').exec(window.location.search);
    var val = match && decodeURIComponent(match[1].replace(/\+/g, ' '));
    if (val == null) {
        return defaultValue;
    }
    return val;
}

function isMobileOrTablet() {
    return typeof window.orientation !== 'undefined';
}

var app = new Vue({
    el: '#app',
    data: {
        search: null,
        totalCount: 0,
        layoutRendersCount: 0,
        layoutsCount: 0,
        targetsCount: 0,
        showInfo: false,
        platforms: {
            "net35": { name: ".NET 3.5" },
            "net40": { name: ".NET 4" },
            "net45": { name: ".NET 4.5" },
            "netstandard1.3": { name: ".NET Standard 1.3" },
            "netstandard1.5": { name: ".NET Standard 1.5" },
            "netstandard2.0": { name: ".NET Standard 2.0" },
            "ios": { name: "Xamarin iOs" },
            "android": { name: "Xamarin Android" },
            "mono": { name: "Mono" },
            "sl": { name: "Silverlight" },
            "wp8": { name: "Windows Phone 8" },
        },
        platformFilter: "",
        tab: "targets"
    },


    created: function () {
        var self = this;

        try {
            var filter = localStorage.getItem("platformFilter");
            if (!filter) filter = "";
            this.platformFilter = filter;
            this.showInfo = localStorage.getItem("hideInfo") == "0";
        } catch (e) {
            console.error(e);
        }
        this.search = getQueryStringValue("search", null);
        this.tab = getQueryStringValue("tab", this.tab);
    },

    mounted: function () {
        this.focusSearch();
    },
    watch: {
        // whenever question changes, this function will run
        platformFilter: function (value) {
            try {
                localStorage.setItem("platformFilter", value);
            } catch (e) {
                console.error(e);
            }
        },
        search: function () {
            this.updateUrl();
        },
        tab: function () {
            this.updateUrl();
        }
    },
    methods: {
        updateUrl: function () {
            try {
                var value = this.search;
                var tab = this.tab;
                var stateObj = { search: value, tab: tab };
                var isEmpty = (value == undefined || value.trim() == "")
                if (!isEmpty) {
                    value = value.trim();
                }
                var url = ("?tab=" + tab + (isEmpty ? "" : "&search=" + value));
                history.replaceState(stateObj, "", url);

            } catch (e) {
                console.error(e);
            }
        },

        focusSearch: function () {
            //don't focus on non-desktops, that annoying
            if (!isMobileOrTablet()) {
                this.$nextTick(function () {
                    this.$refs.search.focus();
                });
            }
        },
        setTab: function (tab) {
            this.tab = tab;
            this.focusSearch();
        },
        toggleShowInfo: function () {
            this.showInfo = !this.showInfo;
            try {
                localStorage.setItem("hideInfo", !this.showInfo ? "1" : "0");
            } catch (e) {
                console.error(e);
            }
        },
        onInitCount: function (count) {
            // console.log("count update", count)
            this.totalCount += count;

        },
        onCountUpdateLayoutRenders: function (count) {
            // console.log("count update", count)
            this.layoutRendersCount = count;

        },
        onCountUpdateLayouts: function (count) {
            // console.log("count update", count)
            this.layoutsCount = count;

        },
        onCountUpdateTargets: function (count) {
            // console.log("count update", count)
            this.targetsCount = count;

        }
    },
    computed: {
        searchPlaceHolder: function () {

            if (this.totalCount > 0) {
                return 'search all ' + this.totalCount + ' items'
            }
            return "";
        },
        infoCssClass: function () {
            return this.showInfo ? "fa-chevron-down" : "fa-chevron-up"
        }
    }
})


