# aggregate.sh

# Combines multiple 24-hour accumulation rasters from February into a single 
# file representing total accumulation for the month.

declare -a arr=("2018" "2017" "2016" "2015" "2014")

for i in "${arr[@]}"
do

  if [ $i == "2017" ] || [ $i == "2018" ]; then
    h="00"
  else
    h="12"
  fi

  # Combine the first handful of files into a single aggregate
  gdal_calc.py \
    -A "./raw/sfav2_CONUS_24h_"$i"0201"$h".tif" \
    -B "./raw/sfav2_CONUS_24h_"$i"0202"$h".tif" \
    -C "./raw/sfav2_CONUS_24h_"$i"0203"$h".tif" \
    -D "./raw/sfav2_CONUS_24h_"$i"0204"$h".tif" \
    -E "./raw/sfav2_CONUS_24h_"$i"0205"$h".tif" \
    -F "./raw/sfav2_CONUS_24h_"$i"0206"$h".tif" \
    -G "./raw/sfav2_CONUS_24h_"$i"0207"$h".tif" \
    -H "./raw/sfav2_CONUS_24h_"$i"0208"$h".tif" \
    -I "./raw/sfav2_CONUS_24h_"$i"0209"$h".tif" \
    -J "./raw/sfav2_CONUS_24h_"$i"0210"$h".tif" \
    -K "./raw/sfav2_CONUS_24h_"$i"0211"$h".tif" \
    -L "./raw/sfav2_CONUS_24h_"$i"0212"$h".tif" \
    -M "./raw/sfav2_CONUS_24h_"$i"0213"$h".tif" \
    -N "./raw/sfav2_CONUS_24h_"$i"0214"$h".tif" \
    -O "./raw/sfav2_CONUS_24h_"$i"0215"$h".tif" \
    -P "./raw/sfav2_CONUS_24h_"$i"0216"$h".tif" \
    -Q "./raw/sfav2_CONUS_24h_"$i"0217"$h".tif" \
    -R "./raw/sfav2_CONUS_24h_"$i"0218"$h".tif" \
    -S "./raw/sfav2_CONUS_24h_"$i"0219"$h".tif" \
    -T "./raw/sfav2_CONUS_24h_"$i"0220"$h".tif" \
    -U "./raw/sfav2_CONUS_24h_"$i"0221"$h".tif" \
    -V "./raw/sfav2_CONUS_24h_"$i"0222"$h".tif" \
    -W "./raw/sfav2_CONUS_24h_"$i"0223"$h".tif" \
    -X "./raw/sfav2_CONUS_24h_"$i"0224"$h".tif" \
    -Y "./raw/sfav2_CONUS_24h_"$i"0225"$h".tif" \
    -Z "./raw/sfav2_CONUS_24h_"$i"0226"$h".tif" \
    --outfile=./tmp/"$i"aggregate.tmp.tif \
    --calc="A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V+W+X+Y+Z" \
    --NoDataValue=0

  if [ -f "./raw/sfav2_CONUS_24h_"$i"0229"$h".tif" ]; then
    gdal_calc.py \
      -A "./tmp/"$i"aggregate.tmp.tif"  \
      -B "./raw/sfav2_CONUS_24h_"$i"0227"$h".tif" \
      -C "./raw/sfav2_CONUS_24h_"$i"0228"$h".tif" \
      -D "./raw/sfav2_CONUS_24h_"$i"0229"$h".tif" \
      --outfile=./tmp/"$i"aggregate.tmp.tif \
      --calc="A+B+C+D" \
      --NoDataValue=0
  else
    gdal_calc.py \
      -A "./tmp/"$i"aggregate.tmp.tif"  \
      -B "./raw/sfav2_CONUS_24h_"$i"0227"$h".tif" \
      -C "./raw/sfav2_CONUS_24h_"$i"0228"$h".tif" \
      --outfile=./tmp/"$i"aggregate.tmp.tif \
      --calc="A+B+C" \
      --NoDataValue=0 
  fi

  gdalwarp -srcnodata "-2819971.75" -dstnodata "0" ./tmp/"$i"aggregate.tmp.tif ./tmp/"$i"aggregate.tmp.tif
done

gdal_calc.py \
  -A "./tmp/2018aggregate.tmp.tif" \
  -B "./tmp/2017aggregate.tmp.tif" \
  -C "./tmp/2016aggregate.tmp.tif" \
  -D "./tmp/2015aggregate.tmp.tif" \
  -E "./tmp/2014aggregate.tmp.tif" \
  --outfile=./tmp/5year_aggregate.tif \
  --calc="(A+B+C+D+E)/5" \
  --NoDataValue=0   

# --calc="median([A,B,C,D,E], 0)" \