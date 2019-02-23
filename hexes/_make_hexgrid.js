#! /usr/bin/env node

// https://github.com/Turfjs/turf/tree/master/packages/turf-hex-grid

const Fs = require('fs');
const turf = require("@turf/turf");

let bounds = [-124.7844079, 24.7433195, -66.9513812, 49.3457868];

/********** MAIN **********/

// Set these to be the size of the cells
var cellSide = 5;
var options = {units: 'miles'};

var hexgrid = turf.hexGrid(bounds, cellSide, options);

Fs.writeFile('./us-grid.tmp.json', JSON.stringify(hexgrid), (error) => { if(error) { console.log(error) }});
