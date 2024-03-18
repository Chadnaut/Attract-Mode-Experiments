# Attract Mode Experiments

> Attract-Mode Experiments  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Experiments

## Disclaimer

These are work-in-progress proof-of-concept experiments. They may be unfinished, slow, broken, or crash AM outright. The worst-case scenario is you'll need to edit `attract.cfg` to restore your previous layout - use at your own risk!

## Contents

### DisplayOffset

![Example](./layouts/Experiment.DisplayOffset/example.png)

[DisplayOffset](./layouts/Experiment.DisplayOffset/layout.nut) adds a `display_offset` property which is used to shift assets by display, works like `filter_offset` and `index_offset`.

### Reflection

![Example](./layouts/Experiment.Reflection/example.png)

[Reflection](./layouts/Experiment.Reflection/layout.nut) uses a `shader` to create a flipped image with a LOD-based blur effect.
