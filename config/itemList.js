function loadJSON(file, callback) {
    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    file = file + "?c=" + Date.now(); //cache buster
    xobj.open('GET', file, true);
    // Replace 'my_data' with the path to your file
    xobj.onreadystatechange = function () {
        // console.log("ready", xobj.readyState, xobj.status)
        if (xobj.readyState === 4 && xobj.status === 200) {
            // Required use of an anonymous callback 
            // as .open() will NOT return a value but simply returns undefined in asynchronous mode
            // console.log("callback")
            var responseOjb = JSON.parse(xobj.responseText)
            callback(responseOjb);

            console.log("done loading", file);

        }
    };
    xobj.send(null);
}

window.toLayoutName = function (name) {
    return '${' + name.toLowerCase() + '}';
};





function assignList(list, isLayoutRenderer) {

    for (i = 0; i < list.length; i++) {
        list[i] = _.assignIn(list[i], new Item(isLayoutRenderer));
    }

    //and reoder
    list = _.orderBy(list, function (item) { return item.name })
    return list;

}



function sortObject(obj) {
    return Object.keys(obj).sort().reduce(function (result, key) {
        result[key] = obj[key];
        return result;
    }, {});
}


Vue.component('item-list', {
    template: '#item-list-template',
    props: ['search', 'title', 'itemName', 'platformFilter', 'file', 'isLayoutRenderer'],
    data: function () {
        return {
            items: []
        }
    },


    created: function () {

        var self = this;
        loadJSON(url + this.file, function (list) {
            self.items = assignList(list, self.isLayoutRenderer);

            self.$emit('init-count', self.items.length);
            // console.log("emit count update",  self.items.length)
        });
    },

    mounted: function () {


    },
    watch: {

    },
    methods: {

        /**
         * @returns {[]}
         */
        getPackageList: function (item) {
            if (!item.package) {
                return [];
            }
            if (_.isArray(item.package)) {
                return item.package;
            }
            return [item.package];
        },

        countGroup: function (obj) {
            var count = 0;
            for (var k in obj) {
                count += obj[k].length;
            }
            return count;
        },
        /** text includes all terms in "includes"
         * @param text {string}
         * @param includes {string[]} all must be in text
         * @returns {boolean}
          */
        includesAll: function (text, includes) {
            for (var i = 0; i < includes.length; i++) {
                var include = includes[i];
                if (!_.includes(text, include)) {
                    return false;
                }

            }
            return true;

        },
        /** text includes any terms in "includes"
         * @param text {string}
         * @param includes {string[]} one must be in text
         * @returns {boolean}
          */
        includesAny: function (text, includes) {
            for (var i = 0; i < includes.length; i++) {
                var include = includes[i];
                if (_.includes(text, include)) {
                    return true;
                }

            }
            return false;

        },
        /** text includes any terms in "includes"
         * @param text {string[]}
         * @param includes {string[]} one must be in text
         * @returns {boolean}
          */
        includesAnyArray: function (texts, includes) {
            var self = this;
            for (var i = 0; i < texts.length; i++) {
                var text = texts[i];
                if (self.includesAny(text, includes)) {
                    return true;
                }

            }
            return false;

        },

        /** @param items {string[]}
         * @returns {string[]}
         */
        trimAll: function (items) {

            items = _.map(items, function (it) {
                if (it == null) it = "";
                return it.trim()
            });
            return items;
        },

        filterList: function (items) {
            var filteredItems;
            var self = this;
            if (!items) {
                return [];
            }

            if (this.search == undefined || this.search.trim() == "") {
                filteredItems = items;
            }
            else {

                var searchValue = self.search.trim().toLowerCase();
                var searchValues = _.split(searchValue, " ");

                searchValues = self.trimAll(searchValues);

                //remove whitespace terms
                _.remove(searchValues, function (value) {
                    value == null || value == ""
                });

                //search for "package:""
                var packageSearchValues = _.remove(searchValues, function (value) {
                    return _.startsWith(value, "package:")
                });
                packageSearchValues = self.trimAll(packageSearchValues);

                //remove package: of every item
                packageSearchValues = _.map(packageSearchValues, function (it) {
                    return _.trimStart(it, "package:");
                });




                if (packageSearchValues.length) {


                    items = _.filter(items, function (item) {
                        if (!item.package || item.package.length == 0) {
                            return false;
                        }
                        if (_.isArray(item.package)) {
                            var packages = _.map(item.package, function (it) {
                                return it.toLowerCase();
                            })

                            return self.includesAnyArray(packages, packageSearchValues);
                        } else {
                            var package = item.package.toLowerCase();

                            return self.includesAny(package, packageSearchValues);
                        }
                    });
                }

                var filteredItems = _.filter(items, function (item) {


                    var itemName = item.name.toLowerCase();
                    if (this.isLayoutRenderer) {
                        itemName = toLayoutName(itemName);
                    }

                    if (item.description == null) {
                        item.description = "";
                    }

                    var isMatch = item && itemName && self.includesAll(itemName, searchValues)
                        || self.includesAll(item.description.toLowerCase(), searchValues);

                    //  console.log("search keyword?", item.keywords)
                    if (!isMatch && item.keywords) {
                        for (var i = 0; i < item.keywords.length; i++) {
                            var keyword = item.keywords[i].toLowerCase();
                            // console.log("search keyword", keyword)
                            isMatch = self.includesAll(keyword, searchValues)
                            if (isMatch) {
                                break;
                            }
                        }
                    }


                    return isMatch;
                })

            }

            if (self.platformFilter) {
                filteredItems = _.filter(filteredItems, function (item) {
                    //not known, then all platforms
                    if (item.platforms == null) {
                        return true;
                    }

                    return item.platforms.indexOf(self.platformFilter) >= 0
                });
            }
            self.$emit('count-update', filteredItems.length);
            return filteredItems;
        },

        groupByCategory: function (list) {
            var grouped = _.groupBy(list, function (item) {
                if (item.category == undefined) {
                    return "";
                }
                return item.category;
            })
            return sortObject(grouped);
        }
    },
    computed: {
        isLoading: function () {
            return !(this.items && this.items.length);
        },

        filteredItems: function () {

            var list = this.filterList(this.items);
            var grouped = this.groupByCategory(list);
            return grouped;
        }

    }
})