'''
_bin.py

Bins pixel data from aggregated raster snowfall files into hexes, as defined
by codes in ./hexes. Takes forever to run and consumes a ton of memory.
'''

import json
import fiona
from rasterstats import zonal_stats

with fiona.open('./hexes/us-grid.shp') as src:
    stats = zonal_stats(src,
        "tmp/aggregate.tif",
        stats="max",
        geojson_out=True,
        nodata=0.0)

    result = {"type": "FeatureCollection", "features": stats}

    with open('./final/snow-grid-full.json', 'w') as f:
        json.dump(result, f)