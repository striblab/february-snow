mkdir -p raw && \
mkdir -p tmp && \
mkdir -p final && \

echo 'Step 1 of 7: Scraping snowfall totals for February 2019 ...' && \
python ./_scrape.py && \

echo 'Step 2 of 7: Aggregating totals into a single raster ...' && \
./_aggregate.sh && \

echo 'Step 3 of 7: Colorizing totals for testing purposes ...' && \
./_colorize.sh && \

echo 'Step 4 of 7: Making hexgrid for binning ...' && \
cd hexes && \
./make.sh && \
cd .. && \

echo 'Step 5 of 7: Binning pixels into vectors (this takes a while) ...' && \
python ./_bin.py && \

# 5-year average of snow before this was 10.32 inches. Rounded to 11 here.
#  https://w2.weather.gov/climate/getclimate.php?date=&wfo=MPX&sid=msp&pil=CF6&recent=&specdate=2019-02-28+11%3A11%3A11
echo 'Step 6 of 7: Splitting up snow grids ...' && \
mapshaper ./final/snow-grid-full-2014-2018.json -quiet -filter 'max != null' -o ./final/snow-grid-nonull-2014-2018.json && \
mapshaper ./final/snow-grid-nonull-2014-2018.json -quiet -filter 'max < 11' -o ./final/less-than-msp-2014-2018.json && \
mapshaper ./final/snow-grid-nonull-2014-2018.json -quiet -filter 'max >= 11' -o ./final/more-than-msp-2014-2018.json && \

echo 'Step 7 of 7: Making tiles ...' && \
tippecanoe -o ./final/more-than-msp-2014-2018.mbtiles --generate-ids ./final/more-than-msp-2014-2018.json &&
tippecanoe -o ./final/less-than-msp-2014-2018.mbtiles --generate-ids ./final/less-than-msp-2014-2018.json