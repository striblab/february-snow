'''
Downloads 24-hour accumulation files from the National Snowfall Analysis,
given a date range. More here:

https://www.nohrsc.noaa.gov/snowfall/
'''

import urllib, urlparse, os
from datetime import date, timedelta

START_DATE = date(2019, 2, 1)
END_DATE = date(2019, 3, 1) # Non-inclusive

def delta_generator(start, end, delta):
    '''
    Generator concept taken from here:
    https://stackoverflow.com/questions/10688006/generate-a-list-of-datetimes-between-an-interval
    '''
    curr = start
    while curr < end:
        yield curr
        curr += delta

if __name__ == '__main__':
    base_url = 'https://www.nohrsc.noaa.gov/snowfall/data'

    for d in delta_generator(START_DATE, END_DATE, timedelta(days=1)):
        # Mke the URL
        month_year_str = d.strftime('%Y%m')
        filename_str = 'sfav2_CONUS_24h_%s.tif' % d.strftime('%Y%m%d00')
        full_url = base_url + '/' + month_year_str + '/' + filename_str
        outfile = "./raw/%s" % filename_str

        # Download the file
        if os.path.isfile(outfile) == False:
            try:
                print 'Downloading %s ...' % full_url
                downloader = urllib.URLopener()
                downloader.retrieve(full_url, outfile)
            except:
                print 'File not found!'
        else:
            print 'File %s exists' % outfile

    print 'Done!'
