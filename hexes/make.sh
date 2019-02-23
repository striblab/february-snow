# Base states file: http://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_state_500k.zip
# Readme: ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt

rm -f ./us-grid.* &&

wget -nc http://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_state_500k.zip &&
unzip cb_2017_us_state_500k.zip && \

echo 'Making U.S. basemap ...'
mapshaper -i cb_2017_us_state_500k.shp \
  -quiet \
  -proj latlon \
  -o format=topojson ./us-base.json &&
rm cb_2017_us_state_500k.shp.ea.iso.xml && \
rm cb_2017_us_state_500k.shp.iso.xml && \
rm cb_2017_us_state_500k.shp.xml && \
rm cb_2017_us_state_500k.shp && \
rm cb_2017_us_state_500k.shx && \
rm cb_2017_us_state_500k.dbf && \
rm cb_2017_us_state_500k.prj && \
rm cb_2017_us_state_500k.cpg &&

echo 'Making hex grid ...'
node _make_hexgrid.js &&
mapshaper us-grid.tmp.json \
  -clip us-base.json \
  -o format=shapefile us-grid.shp &&

rm us-grid.tmp.json &&
rm us-base.json &&

echo 'Done!'
