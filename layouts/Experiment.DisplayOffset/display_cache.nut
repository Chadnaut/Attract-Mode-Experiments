class DisplayCache {

    // The info to store for each game
    static info_keys = [
        Info.Name,
        Info.Title,
        Info.Emulator,
        Info.CloneOf,
        Info.Year,
        Info.Manufacturer,
        Info.Category,
        Info.Players,
        Info.Rotation,
        Info.Control,
        Info.Status,
        Info.DisplayCount,
        Info.DisplayType,
        Info.AltRomname,
        Info.AltTitle,
        Info.Extra,
        Info.Favourite,
        Info.Tags,
        Info.PlayedCount,
        Info.PlayedTime,
        Info.FileIsAvailable,
        Info.System,
        Info.Overview,
        Info.IsPaused,
        Info.SortValue,
    ];

    display_data = null;

    constructor() {
        display_data = get_display_data();
        ::fe.add_transition_callback(this, "on_transition");
    }

    function modulo(i, n) {
        while (i < 0) i += n;
        return i % n;
    }

    // ===========================================

    // get list of filters for current display
    function get_filter_data() {
        local filters = [];
        foreach (filter in fe.filters) {
            filters.push({
                name = filter.name,
                index = filter.index,
                size = filter.size,
                sort_by = filter.sort_by,
                reverse_order = filter.reverse_order,
                list_limit = filter.list_limit,
                list = [],
            });
        }
        return filters;
    }

    // get list of games for passed filters
    function get_list_data(filters) {
        local list = [];
        local indexes = {};
        foreach (filter_index, filter in filters) {
            local list_size = filter.size;
            local list_offset = filter.index;
            local filter_offset = filter_index - fe.list.filter_index;
            for (local list_index = 0; list_index < list_size; list_index++) {
                local index_offset = list_index - list_offset;
                local name = fe.game_info(Info.Name, index_offset, filter_offset);

                if (!(name in indexes)) {
                    // get all game info
                    local info = {};
                    foreach (key in info_keys) info[key] <- fe.game_info(key, index_offset, filter_offset);

                    local item = {
                        info = info,
                        art = {
                            // TODO: read emulator cfg to find all artwork types
                            // This part will likely be very slow for all types / images / videos
                            snap = ::fe.get_art("snap", index_offset, filter_offset, Art.ImagesOnly),
                        },
                    };
                    indexes[name] <- list.len();
                    list.push(item);
                }

                // store index of game for filter
                filter.list.push(indexes[name]);
            }
        }
        return list;
    }

    // get all display, filter and game data
    function get_display_data() {
        local displays = [];
        local display_index = fe.list.display_index;
        foreach (i, display in fe.displays) {
            // change the display, then fetch all data for it - SLOW
            fe.set_display(i, false, false);
            local filters = get_filter_data();
            local list = get_list_data(filters);
            displays.push({
                name = display.name,
                layout = display.layout,
                romlist = display.romlist,
                in_cycle = display.in_cycle,
                in_menu = display.in_menu,

                filter_index = fe.list.filter_index,
                filters = filters,
                list = list,
            });
        }
        fe.set_display(display_index, false, false);
        return displays;
    }

    // ===========================================
    // helpers to fetch stored data for a DisplayObject

    function get_display_item(index_offset) {
        local obj = DisplayObject.get_object(index_offset);
        if (!obj) return null;

        local display_index = modulo(fe.list.display_index + obj.display_offset, display_data.len());
        return display_data[display_index];
    }

    function get_filter_item(index_offset) {
        local obj = DisplayObject.get_object(index_offset);
        if (!obj) return null;

        local display = get_display_item(index_offset);
        local filter_index = modulo(display.filter_index + obj.filter_offset, display.filters.len());
        return display.filters[filter_index];
    }

    function get_list_item(index_offset) {
        local obj = DisplayObject.get_object(index_offset);
        if (!obj) return null;

        local display = get_display_item(index_offset);
        local filter = get_filter_item(index_offset);
        local list_index = modulo(filter.index + obj.index_offset, filter.list.len());
        local index = filter.list[list_index];
        return display.list[index];
    }

    // ===========================================

    function on_transition(ttype, var, ttime) {

        // refresh current objects if filter_index changes
        local display = display_data[fe.list.display_index];
        if (display.filter_index != fe.list.filter_index) {
            display.filter_index = fe.list.filter_index;
            DisplayObject.refresh_current();
        }

        switch (ttype) {
            case Transition.ToNewSelection:
                // this updates index before magic function gets fired
                local display = display_data[fe.list.display_index];
                local filter = display.filters[fe.list.filter_index];
                filter.index = modulo(fe.list.index + var, filter.list.len());
                break;
        }
    }
}

