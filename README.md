# Attract Mode Experiments

> Attract-Mode Experiments  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Experiments

## Disclaimer

These are work-in-progress proof-of-concept experiments. They may be unfinished, slow, broken, or crash AM outright.

At worst you'll need to edit `attract.cfg` to restore your previous layout - use at your own risk!

## Contents

- [DisplayOffset](./layouts/Experiment.DisplayOffset/README.md) - Adds a `display_offset` property which is used to shift assets by display, works like `filter_offset` and `index_offset`.
- [LCD](./layouts/Experiment.LCD/README.md) - A `shader` that pixelates and monotones the image to create an LCD effect. Good for some logos, not so good for others.
- [Mask](./layouts/Experiment.Mask/README.md) - A `shader` that uses a second texture to multiply the target image, creates cutout and filtering effects.
- [Reflection](./layouts/Experiment.Reflection/README.md) - A `shader` that creates a mipmap based blur effect. The actual mirror is simply a clone with a flipped subimg.
