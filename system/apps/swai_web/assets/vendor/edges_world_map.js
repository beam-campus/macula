import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import {GeoUtils} from './geo_utils.js';

const maps_url = 'https://unpkg.com/world-atlas@1/world/50m.json';
const topojson_url = 'https://unpkg.com/topojson@3.0.2/dist/topojson.min.js';
const world_atlas_tsv = 'https://unpkg.com/world-atlas@1.1.4/world/50m.tsv';
const consideredNewNode = 10; // seconds

let g = null;

let atlasData, tjData;

async function preloadData() {
  try {
    const [atlasResponse, tjResponse] = await Promise.all([
      d3.tsv(world_atlas_tsv),
      d3.json(maps_url)
    ]);
    this.atlasData = atlasResponse;
    this.tjData = tjResponse;
  } catch (error) {
    console.error('Error preloading data:', error);
  }
}



export const EdgesChanged = {
  mounted() {
    this.handleEvent("edges_changed", ({ edges }) => {
      this.el.dataset.edges = JSON.stringify(edges);
    });
  },
  updated() {
    this.handleEvent("edges_changed", ({ edges }) => {
      this.el.dataset.edges = JSON.stringify(edges);
    });
  }
};



export const TheMap = {
  mounted() {
    this.nodes = JSON.parse(this.el.dataset.edges);
    preloadData().then(() => {
      // Now you can use the preloaded data to draw the map
      [this.svg, this.projection] = drawWorldMap(this.el, 1200, 600);
      createPoints(this.svg, this.nodes, this.projection);
      // createCurvedLines(this.svg, this.nodes, this.projection);
    });
  },
  updated() {
    this.nodes = JSON.parse(this.el.dataset.edges);
    [this.svg, this.projection] = drawWorldMap(this.el, 1200, 600);
    updatePoints(this.svg, this.nodes, this.projection);    
    // updateCurvedLines(this.svg, this.nodes, this.projection);
  }
};


function createPoints(a_svg, data, projection) {
  const tooltip = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("position", "absolute")
    .style("visibility", "hidden")
    .style("background", "#f9f9f9")
    .style("border", "1px solid #d3d3d3")
    .style("padding", "5px")
    .style("border-radius", "5px");

  const points = a_svg.selectAll("g.node")
    .data(data, d => d.id);

  const enter = points.enter().append("g")
    .attr("class", "node");

  enter.append("circle")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("cx", d => projection([d.lon, d.lat])[0])
    .attr("cy", d => projection([d.lon, d.lat])[1])
    .attr("r", 10)
    .attr("fill", node_color)
    .on("mouseover", function (event, d) {
      tooltip.style("visibility", "visible")
        .text(`Node: ${d.id}`);
    })
    .on("mousemove", function (event) {
      tooltip.style("top", (event.pageY - 10) + "px")
        .style("left", (event.pageX + 10) + "px");
    })
    .on("mouseout", function () {
      tooltip.style("visibility", "hidden");
    });

  enter.append("circle")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("cx", d => projection([d.lon, d.lat])[0])
    .attr("cy", d => projection([d.lon, d.lat])[1])
    .attr("r", 8)
    .attr("fill", "grey");

  enter.append("image")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("xlink:href", d =>  d.is_container ? "/images/docker-mark.svg" : "/images/erlang-mark.svg")
    .attr("width", 10)
    .attr("height", 10)
    .attr("x", d => projection([d.lon, d.lat])[0] - 5)
    .attr("y", d => projection([d.lon, d.lat])[1] - 5);

  points.exit().remove();
}

function updatePoints(a_svg, data, projection) {
  const tooltip = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("position", "absolute")
    .style("visibility", "hidden")
    .style("background", "#f9f9f9")
    .style("border", "1px solid #d3d3d3")
    .style("padding", "5px")
    .style("border-radius", "5px");

  const points = a_svg.selectAll("g.node")
    .data(data, d => d.id);

  const enter = points.enter().append("g")
    .attr("class", "node");

  enter.append("circle")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("cx", d => projection([d.lon, d.lat])[0])
    .attr("cy", d => projection([d.lon, d.lat])[1])
    .attr("r", 9)
    .attr("fill", node_color)
    .on("mouseover", function (event, d) {
      tooltip.style("visibility", "visible")
        .text(`<span>Node: ${d.id} \n Lat: ${d.lat}  </span>`);
    })
    .on("mousemove", function (event) {
      tooltip.style("top", (event.pageY - 10) + "px")
        .style("left", (event.pageX + 10) + "px");
    })
    .on("mouseout", function () {
      tooltip.style("visibility", "hidden");
    });

  enter.append("circle")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("cx", d => projection([d.lon, d.lat])[0])
    .attr("cy", d => projection([d.lon, d.lat])[1])
    .attr("r", 8)
    .attr("fill", "grey");

  enter.append("image")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("xlink:href", d => d.is_container ? "/images/docker-mark.svg" : "/images/erlang-mark.svg")
    .attr("width", 10)
    .attr("height", 10)
    .attr("x", d => projection([d.lon, d.lat])[0] - 5)
    .attr("y", d => projection([d.lon, d.lat])[1] - 5);

  points.select("circle")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("cx", d => projection([d.lon, d.lat])[0])
    .attr("cy", d => projection([d.lon, d.lat])[1])
    .attr("r", 10)
    .attr("fill", node_color);

  points.select("image")
    .classed("blink_offline", d => d.stats && d.stats.nbr_of_agents == 0)
    .classed("blink_online", d => secondsElapsedSince(d.connected_since)<=consideredNewNode && d.stats && d.stats.nbr_of_agents > 0)
    .attr("xlink:href", d => d.is_container ? "/images/docker-mark.svg" : "/images/erlang-mark.svg")
    .attr("x", d => projection([d.lon, d.lat])[0] - 5)
    .attr("y", d => projection([d.lon, d.lat])[1] - 5);

  points.exit().remove();
}



function secondsElapsedSince(utc_in) {
  // Parse the input UTC datetime string to a Date object
  const inputDate = new Date(utc_in);
  // Check if the input date is valid
  if (isNaN(inputDate.getTime())) {
      throw new Error('Invalid UTC datetime string');
  }
  // Get the current date and time in UTC
  const now = new Date();
  // Calculate the difference in milliseconds
  const differenceInMilliseconds = now - inputDate;
  // Convert milliseconds to seconds
  const differenceInSeconds = Math.floor(differenceInMilliseconds / 1000);
  return differenceInSeconds;
}


let node_color = function (d) {
  console.log("connected since", d.connected_since, (secondsElapsedSince(d.connected_since)) );
  if (d.stats.nbr_of_agents > 0) {
    return "green";
  } else {
    return "red";
  }
}

function createCurvedLines(a_svg, data, projection) {
  const links = [];
  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data.length; j++) {
      if (i !== j) {
        links.push({
          source: data[i],
          target: data[j]
        });
      }
    }
  }

  const lineGenerator = d3.linkRadial()
      // .linkHorizontal()
    .x(d => projection([d.lon, d.lat])[0])
    .y(d => projection([d.lon, d.lat])[1]);

  a_svg.selectAll(".curved-lines")
    .data(links)
    .enter()
    .append("path")
    .attr("class", "curved-lines")
    .attr("d", d => lineGenerator({ source: d.source, target: d.target }))
    .attr("fill", "none")
    .attr("stroke", "grey") // Customize stroke color
    .attr("stroke-opacity", 0.2) // Customize stroke opacity
    .attr("stroke-width", 1) // Customize stroke width
    .attr("stroke-dasharray", "5,5"); // Customize stroke dash pattern
}

function updateCurvedLines(a_svg, data, projection) {
  // const links = data.filter(d => d.connected_to).map(d => ({
  //   source: d,
  //   target: data.find(node => node.id === d.connected_to)
  // }));

  const links = [];
  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data.length; j++) {
      if (i !== j) {
        links.push({
          source: data[i],
          target: data[j]
        });
      }
    }
  }

  const lineGenerator = d3.linkHorizontal()
    .x(d => projection([d.lon, d.lat])[0])
    .y(d => projection([d.lon, d.lat])[1]);

  // Select and update the curved lines without affecting country contours
  const curvedLines = a_svg.selectAll(".curved-lines")
    .data(links);

  // Enter new elements
  curvedLines.enter()
    .append("path")
    .attr("class", "curved-lines")
    .attr("d", d => lineGenerator({ source: d.source, target: d.target }))
    .attr("fill", "none")
    .attr("stroke-opacity", 0.2) // Customize stroke opacity
    .attr("stroke", "white") // Customize stroke color
    .attr("stroke-width", 1) // Customize stroke width
    .attr("stroke-dasharray", "5,5"); // Customize stroke dash pattern

  // Update existing elements
  curvedLines
    .attr("d", d => lineGenerator({ source: d.source, target: d.target }))
    .attr("fill", "none")
    .attr("stroke-opacity", 0.2) // Customize stroke opacity
    .attr("stroke", "white") // Customize stroke color
    .attr("stroke-width", 1) // Customize stroke width
    .attr("stroke-dasharray", "5,5"); // Customize stroke dash pattern

  // Remove old elements
  curvedLines.exit().remove();
}


function drawWorldMap(an_el, width, height) {
  if (this.svg != null && this.projection != null) {
    return [this.svg, this.projection];
  }
  const svg = d3.select(an_el)
    .append("svg")
    .attr("width", width)
    .attr("height", height);
  const projection = d3.geoMercator()
    .scale(150)
    .translate([width / 2.5, height / 2]);
  const pathGenerator = d3.geoPath().projection(projection);

  Promise
    .all([
      this.atlasData,
      this.tjData
    ])
    .then(
      ([atlas_data, tj_data]) => {

        const countries = topojson.feature(tj_data, tj_data.objects.countries);

        svg
          .attr("viewBox", "0 0 1000 500")
          .selectAll("path")
          .attr("fill", "transparent")
          .data(countries.features)
          .enter()
          .append("path")
          .attr("class", "map_country")
          .attr("d", pathGenerator);
      }
    );
  return [svg, projection];
}



