# colorize.sh

# Colorizes the map so we can take a quick look before the more expensive
# rendering processes start.

gdalwarp \
  -q \
  -t_srs "EPSG:4326" \
  -srcnodata "-99999" \
  -dstnodata "None" \
  ./tmp/aggregate.tif ./tmp/proj.tif;

# Make version for places with more snow than MN
gdaldem color-relief \
  ./tmp/proj.tif \
  ./color-ramp-more.txt \
  ./tmp/more_than_msp.tif;

# Make version for places with less snow than MN
gdaldem color-relief \
  ./tmp/proj.tif \
  ./color-ramp-less.txt \
  ./tmp/less_than_msp.tif;

rm ./tmp/proj.tif;