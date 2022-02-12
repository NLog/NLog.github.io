function Item(isLayoutRenderer) {
    this.isLayoutRenderer = isLayoutRenderer;
}

Item.prototype.packageList = function () {
    if (!this.package) {
        return [];
    }
    if (_.isArray(this.package)) {
        return this.package;
    }
    return [this.package];
}

Item.prototype.aliasList = function () {
    if (!this.aliases) {
        return [];
    }
    if (_.isArray(this.aliases)) {
        return this.aliases;
    }
    return [this.aliases];
}

Item.prototype.href = function () {

    if (!this.page) {
        return "";
    }

    if (_.startsWith(this.page, "http://") || _.startsWith(this.page, "https://")) {
        return this.page;
    }

    //relative URL
    return 'https://github.com/NLog/NLog/wiki/' + this.page;
}

Item.prototype.title = function () {

    if (this.isLayoutRenderer) {
        return toLayoutName(this.name);
    }

    return this.name;
}