# Experiment DisplayOffset

> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Experiments

![Example](example.png)

Adds a `display_offset` property which is used to shift assets by display, works like `filter_offset` and `index_offset`.

Due to the cumbersome nature of having to cache ALL display info to make it work, this is likely why you dont see many themes do this.

## Important

- All your displays must use this layout, or it will change as it tries to parse your collection!
- Editing `attract.cfg` is easiest way to set them all to `layout Experiment.DisplayOffset`
- It takes around 1-second per 1000 games to parse - it you have LOTS of games this may stall AM, in which case you might need to revert your changes to `attract.cfg`

## Controls

- left/right - prev/next game
- up/down - prev/next display
- whatever you have configured for prev/next filter

## Files

- `display_cache.nut` - Reads all info from every display
- `display_object.nut` - Object wrapper with the `display_offset` prop
- `layout.nut` - The example layout
