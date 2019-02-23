# aggregate.sh

# Combines multiple 24-hour accumulation rasters from February into a single 
# file representing total accumulation for the month.

# Combine the first handful of files into a single aggregate
gdal_calc.py \
  -A ./raw/sfav2_CONUS_24h_2019020100.tif \
  -B ./raw/sfav2_CONUS_24h_2019020200.tif \
  -C ./raw/sfav2_CONUS_24h_2019020300.tif \
  -D ./raw/sfav2_CONUS_24h_2019020400.tif \
  -E ./raw/sfav2_CONUS_24h_2019020500.tif \
  -F ./raw/sfav2_CONUS_24h_2019020600.tif \
  -G ./raw/sfav2_CONUS_24h_2019020700.tif \
  -H ./raw/sfav2_CONUS_24h_2019020800.tif \
  -I ./raw/sfav2_CONUS_24h_2019020900.tif \
  -J ./raw/sfav2_CONUS_24h_2019021000.tif \
  -K ./raw/sfav2_CONUS_24h_2019021100.tif \
  -L ./raw/sfav2_CONUS_24h_2019021200.tif \
  -M ./raw/sfav2_CONUS_24h_2019021300.tif \
  -N ./raw/sfav2_CONUS_24h_2019021400.tif \
  -O ./raw/sfav2_CONUS_24h_2019021500.tif \
  -P ./raw/sfav2_CONUS_24h_2019021600.tif \
  -Q ./raw/sfav2_CONUS_24h_2019021700.tif \
  -R ./raw/sfav2_CONUS_24h_2019021800.tif \
  -S ./raw/sfav2_CONUS_24h_2019021900.tif \
  -T ./raw/sfav2_CONUS_24h_2019022000.tif \
  -U ./raw/sfav2_CONUS_24h_2019022100.tif \
  -V ./raw/sfav2_CONUS_24h_2019022200.tif \
  --outfile=./tmp/aggregate.tmp.tif \
  --calc="A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V" \
  --NoDataValue=0 &&

# Same for the rest. Splitting this up because months have more than 26 days.
gdal_calc.py \
  -A ./tmp/aggregate.tmp.tif \
  -B ./raw/sfav2_CONUS_24h_2019022300.tif \
  --outfile=./tmp/aggregate.tmp.tif \
  --calc="A+B" \
  --NoDataValue=0 &&

# Just in case we need it later
# gdal_calc.py \
#   -A ./tmp/aggregate.tmp.tif \
#   --outfile=./tmp/aggregate.tmp.tif \
#   --calc="A*(A>=30)" \
#   --NoDataValue=0 &&

# Fixes weird nodata issues
gdalwarp -srcnodata "3.40282346600000016e+38" -dstnodata "0" ./tmp/aggregate.tmp.tif ./tmp/aggregate.tif &&
rm ./tmp/aggregate.tmp.tif