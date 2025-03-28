# Attract Mode Experiments

> Attract-Mode Experiments  
> Chadnaut 2025  
> https://github.com/Chadnaut/Attract-Mode-Experiments  
>\
>[<img src="https://github.com/Chadnaut/Attract-Mode-Plus-Squirrel/blob/master/assets/images/banner.png?raw=true" width="48" align="left">][extension]
Get the [*AM+ Squirrel*][extension] extension for VS Code
<br><sup><sub>A suite of support tools to enhance your AM+ development experience. Code completions, highlighting, linting, formatting, and more!</sub></sup>

[extension]: https://marketplace.visualstudio.com/items?itemName=chadnaut.am-squirrel

## Disclaimer

These are work-in-progress proof-of-concept experiments. They may be unfinished, non-performant, or broken.

## Experiments

- *Debug* - Testing or debugging during development.
- *Element* - A new layout element with unique behaviors.
- *Shader* - Adds an effect to an existing layout element.
- *Utility* - Additional functions and classes.

[ArtworkRatio]: ./layouts/Experiment.ArtworkRatio/layout.nut
[Bezel]: ./layouts/Experiment.Bezel/layout.nut
[BoxArt]: ./layouts/Experiment.BoxArt/layout.nut
[BumpMap]: ./layouts/Experiment.BumpMap/layout.nut
[Cathode]: ./layouts/Experiment.Cathode/layout.nut
[Clock]: ./layouts/Experiment.Clock/layout.nut
[CubeMap]: ./layouts/Experiment.CubeMap/layout.nut
[Cylinder]: ./layouts/Experiment.Cylinder/layout.nut
[DisplayOffset]: ./layouts/Experiment.DisplayOffset/README.md
[LCD]: ./layouts/Experiment.LCD/layout.nut
[Mallow]: ./layouts/Experiment.Mallow/layout.nut
[Panorama]: ./layouts/Experiment.Panorama/layout.nut
[Reflection]: ./layouts/Experiment.Reflection/layout.nut
[RetroZoom]: ./layouts/Experiment.RetroZoom/layout.nut
[Sand]: ./layouts/Experiment.Sand/README.md
[SpinBox]: ./layouts/Experiment.SpinBox/layout.nut
[UltraSweep]: ./layouts/Experiment.UltraSweep/layout.nut

|Preview|Version|Description|Type|Demo|
|-|-|-|-|-|
|[<img width="64" height="42" src="./layouts/Experiment.ArtworkRatio/example.png"/>][BoxArt]|`v0.0.1`|[ArtworkRatio] - Match an Artworks aspect ratio.|*Utility*|[Example](./layouts/Experiment.ArtworkRatio/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Bezel/example.png"/>][Bezel]|`v0.0.1`|[Bezel] - Bezel reflection effects.|*Shader*|[Example](./layouts/Experiment.Bezel/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.BoxArt/example.png"/>][BoxArt]|`v0.2.0`|[BoxArt] - A Shader that adds a conforming reflection to angled boxart images.|*Shader*|[Example](./layouts/Experiment.BoxArt/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.BumpMap/example.png"/>][BumpMap]|`v0.0.1`|[BumpMap] - Simple bumpmap effects.|*Shader*|[Example](./layouts/Experiment.BumpMap/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Cathode/example.png"/>][Cathode]|`v0.0.1`|[Cathode] - Cubemap, bezel glow, and screen corners.|*Shader*|[Example](./layouts/Experiment.Cathode/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Clock/example.png"/>][Clock]|`v0.0.1`|[Clock] - A realtime animated clock.|*Element*|[Example](./layouts/Experiment.Clock/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.CubeMap/example.png"/>][CubeMap]|`v0.0.1`|[CubeMap] - Cubemap distortion effects.|*Shader*|[Example](./layouts/Experiment.CubeMap/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Cylinder/example.png"/>][Cylinder]|`v0.0.1`|[Cylinder] - A cylinder effect.|*Shader*|[Example](./layouts/Experiment.Cylinder/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.DisplayOffset/example.png"/>][DisplayOffset]|`v0.0.2`|[DisplayOffset] - Adds a `display_offset` property which is used to shift assets by display, works like `filter_offset` and `index_offset`. *Currently Broken.*|*Utility*|[Example](./layouts/Experiment.DisplayOffset/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.LCD/example.png"/>][LCD]|`v0.0.1`|[LCD] - A shader that pixelates and monotones the image to create an LCD effect. Good for some logos, not so good for others.|*Shader*|[Example](./layouts/Experiment.LCD/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Mallow/example.png"/>][Mallow]|`v0.0.1`|[Mallow] - Happy little marshmallows! *Requires AM+ 3.1.0*|*Utility*|[Example](./layouts/Experiment.Mallow/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Panorama/example.png"/>][Panorama]|`v0.0.1`|[Panorama] - A panoramic screen example.|*Shader*|[Example](./layouts/Experiment.Panorama/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Reflection/example.png"/>][Reflection]|`v0.0.1`|[Reflection] - A shader that creates a mipmap based blur effect. The actual mirror is simply a clone with a flipped subimg.|*Shader*|[Example](./layouts/Experiment.Reflection/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.RetroZoom/example.png"/>][RetroZoom]|`v0.0.1`|[RetroZoom] - Scale an image over a non-clearing surface to produce a retro zoom effect.|*Utility*|[Example](./layouts/Experiment.RetroZoom/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.Sand/example3.png"/>][Sand]|`v0.0.3`|[Sand] - Something different with a surface shader feedback loop. *Now with Sand, Fire & Plasma!*|*Shader*|[Example](./layouts/Experiment.Sand/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.SpinBox/example.png"/>][SpinBox]|`v0.0.1`|[SpinBox] - A fake 3D spinning box.|*Utility*|[Example](./layouts/Experiment.SpinBox/layout.nut)
|[<img width="64" height="42" src="./layouts/Experiment.UltraSweep/example.png"/>][UltraSweep]|`v0.0.1`|[UltraSweep] - Zero asset light sweep effect.|*Utility*|[Example](./layouts/Experiment.UltraSweep/layout.nut)

## Looking for More?

When code graduates from an experiment to a full-featured module it gets moved to the Modules repo:

- https://github.com/Chadnaut/Attract-Mode-Modules
