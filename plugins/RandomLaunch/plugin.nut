/**
 * Random Launch Plugin
 *
 * @summary Randomly select and launch an unplayed game.
 * @version 0.0.1 2025-09-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 */

class UserConfig </ help="Description placeholder" /> {
    </ label="Info", help="The game info to randomly choose", options="Unplayed,Favourite", order=0 /> info = "Unplayed"
    </ label="Launch", help="Launch game after selection", options="Yes,No", order=1 /> launch = "Yes"
}

class RandomLaunch {
    /** @type {UserConfig} */
    config = null

    constructor() {
        config = fe.get_config()
        fe.add_signal_handler(this, "on_signal")
    }

    // Find indexes of games with specific info
    function get_indexes() {
        local arr = []
        local offset = -fe.list.index
        for (local i = 0, n = fe.list.size; i < n; i++) {
            switch (config.info) {
                case "Unplayed":
                    if (fe.game_info(Info.PlayedCount, i + offset) == "0") arr.push(i)
                    break
                case "Favourite":
                    if (fe.game_info(Info.Favourite, i + offset) == "1") arr.push(i)
                    break
            }
        }
        // Prevent current index entering the list
        local i = arr.find(fe.list.index)
        if (i != null) arr.remove(i)
        return arr
    }

    // Select a random game from get_indexes, or if there are none then just any random
    function select_random() {
        local indexes = get_indexes()
        local len = indexes.len()
        fe.list.index = len
            ? indexes[(len * rand()) / RAND_MAX]
            : (fe.list.size * rand()) / RAND_MAX
    }

    // Capture the random_game signal and select our own
    function on_signal(signal) {
        if (signal == "random_game") {
            select_random()
            if (config.launch == "Yes") fe.signal("select")
            return true
        }
        return false
    }
}

fe.plugin["RandomLaunch"] <- RandomLaunch()
