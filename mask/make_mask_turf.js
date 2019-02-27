#! /usr/bin/env node

const Fs = require('fs');
const turf = require("@turf/turf");
const topojson = require("topojson");
const us_shp = require('./us.json');

let bounds = [-129.848974, 20.396308, -60.885444, 55.384358];

/********** HELPER FUNCTIONS **********/

function polyMask(mask, bounds) {
  let bboxPoly = turf.bboxPolygon(bounds);
  return turf.difference(bboxPoly, mask);
}

/********** MAIN **********/

let us = turf.polygon(
  topojson.feature(us_shp, us_shp.objects.country).features[0].geometry.coordinates[0]
);

let mask = polyMask(us, bounds);

Fs.writeFile('./us-mask.json', JSON.stringify(mask), (error) => { if(error) { console.log(error) }});
