wget -nc https://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_state_500k.zip && \
  unzip cb_2017_us_state_500k.zip && \
  shp2json cb_2017_us_state_500k.shp | \
  mapshaper - -quiet -proj longlat -o ./cb_2017_us_state_500k.json format=geojson && \
  cat cb_2017_us_state_500k.json | \
  geo2topo states=- | \
  topomerge country=states -k '1' > ./us.json && \
  node make_mask_turf.js &&
  rm ./us.json &&
  rm cb_2017_us_state_500k.*
