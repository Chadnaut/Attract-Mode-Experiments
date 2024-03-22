fe.do_nut("display_object.nut");
fe.do_nut("display_cache.nut");

// config for grid
local cols = 4;
local rows = 3;
local margin_col = 0.5;
local margin_row = 0.5;

// caching is SLOW!!!
local display_cache = DisplayCache();

// ===========================================
// These magic token function will only work with DisplayObjects
// Fun fact: errors within these functions will CRASH Attract-Mode!

function snap(index_offset, filter_offset) {
    local item = display_cache.get_list_item(index_offset);
    return item ? item.art.snap : "";
}

function Title(index_offset, filter_offset) {
    local item = display_cache.get_list_item(index_offset);
    return item ? item.info[Info.Title] : "";
}

function DisplayName(index_offset, filter_offset) {
    local item = display_cache.get_display_item(index_offset);
    return item ? item.name : "";
}

function FilterName(index_offset, filter_offset) {
    local item = display_cache.get_filter_item(index_offset);
    return item ? item.name : "";
}

// ===========================================

// Create a row of images
function add_row(display_offset, count, x, y, w, h, text_height, space) {
    local text = DisplayObject(fe.add_text("[!DisplayName] - [!FilterName]", x, y, w * count, text_height));
    text.display_offset = display_offset;
    text.char_size = text_height / 2;
    text.margin = 0;
    text.align = Align.TopLeft;

    for (local i=0; i<count; i++) {
        local img = DisplayObject(fe.add_image("[!snap]", x + (i * (w + space)), y + text_height, w, h));
        img.display_offset = display_offset;
        img.index_offset = i;

        local label = DisplayObject(fe.add_text("[!Title]", img.x, img.y, img.width, img.height));
        label.display_offset = display_offset;
        label.char_size = text_height / 3;
        label.margin = text_height / 6;
        label.align = Align.BottomLeft;
        label.index_offset = i;
    }
}

// values for grid
local w = fe.layout.width / (cols + margin_col);
local h = fe.layout.height / (rows + margin_row);
local text_h = h / 4;
local margin_x = (w * margin_col) / (cols + 1);
local margin_y = (h * margin_row) / (rows + 1);
local x = margin_x;
local y = margin_y;
local row_h = h + margin_y;
local bdr = 5;

// Draw rows
for (local i=0; i<rows; i++) {
    local display_offset = i - (rows/2);

    if (display_offset == 0) {
        // Draw selection box
        local box = fe.add_text("", x-bdr, y+(i*row_h)+text_h-bdr, w+bdr*2, h-text_h+bdr*2);
        box.set_bg_rgb(255,255,255);
        box.bg_alpha = 255;
    }

    add_row(display_offset, cols, x, y+(i*row_h), w, h-text_h, text_h, margin_x);
}

// Some custom signal handling
fe.add_signal_handler("on_signal");
function on_signal(signal) {
    switch (signal) {
        case "up":      fe.signal("prev_display"); return true;
        case "down":    fe.signal("next_display"); return true;
        case "left":    fe.signal("prev_game"); return true;
        case "right":   fe.signal("next_game"); return true;
    }
}
