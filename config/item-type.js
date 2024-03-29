function Item(isLayoutRenderer) {
    this.isLayoutRenderer = isLayoutRenderer;
}

Item.prototype.packageList = function () {
    if (!this.package) {
        return [];
    }
    var packages = this.package;
    if (!_.isArray(packages)) {
        packages = [packages];
    }
    return packages;
}

Item.prototype.packageListTooltip = function () {
    var packages = this.packageList();
    if (!packages) {
        return null;
    }

    if(packages.length === 1){
        return 'Needs package: ' +packages[0];
    }

    if(packages.length >1){
        return 'Needs one of the packages: ' + packages.toString();
    }
}


Item.prototype.aliasList = function () {
    if (!this.aliases) {
        return [];
    }
    var aliases = this.aliases;
    if (!_.isArray(aliases)) {
        aliases = [aliases];
    }
    
    if (this.isLayoutRenderer) {
        return _.map(aliases, toLayoutName);
    }
    return aliases;
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
