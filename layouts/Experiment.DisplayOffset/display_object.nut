class DisplayObject {
    _id = 0;
    _obj = null;
    _prop = null;
    _prevent_refresh = false;

    static _data = {
        id = 0,
        object = {},
    };

    constructor(obj) {
        _obj = obj;
        _id = _data.id++;
        _data.object[_id] <- this;
        _prop = {
            index_offset = 0,
            filter_offset = 0,
            display_offset = 0,
        };

        _prop.index_offset = _obj.index_offset;
        _prop.filter_offset = _obj.filter_offset;

        // store id in index_offset for our custom magic tokens
        _obj.index_offset = _id;
    }

    static function get_object(id) {
        return ((id in _data.object) && !_data.object[id]._prevent_refresh)
            ? _data.object[id]
            : null;
    }

    static function refresh_current() {
        foreach (obj in _data.object) {
            if (obj.display_offset == 0) obj.refresh_magic();
        }
    }

    function _get(idx) {
        return (idx in _prop) ? _prop[idx] : _obj[idx];
    }

    function _set(idx, val) {
        switch (idx) {
            case "index_offset":
            case "filter_offset":
            case "display_offset":
                _prop[idx] = val;
                refresh_magic();
                break;
            default: _obj[idx] = val;
        }
    }

    // changing offset triggers magic token function
    function refresh_magic() {
        _prevent_refresh = true;
        _obj.index_offset = _id - 1;

        _prevent_refresh = false;
        _obj.index_offset = _id;
    }

    // TODO: passthru methods
}