# Experiment DisplayOffset

> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Experiments

![Example](example.png)

Adds a `display_offset` property which is used to shift assets by display, works like `filter_offset` and `index_offset`.

Due to the cumbersome nature of having to cache ALL display info to make it work, this is likely why you dont see many themes do this. Do not try this at home.

## Setup

- All your displays must use this layout or it will not work
- Editing `attract.cfg` is easiest -> layout Experiment.DisplayOffset

## Controls

- left/right - prev/next game
- up/down - prev/next display
- whatever you have configured for prev/next filter

## Files

- `display_cache.nut` - Reads all info from every display, around 1 second per 1000 games
- `display_object.nut` - Object wrapper with the `display_offset` prop
- `layout.nut` - The example layout
