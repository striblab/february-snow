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

echo 'Step 6 of 7: Splitting up snow grids ...' && \
mapshaper ./final/snow-grid-full-2019.json -quiet -filter 'max != null' -o ./final/snow-grid-nonull-2019.json && \
mapshaper ./final/snow-grid-nonull-2019.json -each 'pct_msp=max/39*100' -o ./final/pct-msp-2019.json && \


echo 'Step 7 of 7: Making tiles ...' && \
tippecanoe -o ./final/pct-msp-2019.mbtiles --generate-ids ./final/pct-msp-2019.json
