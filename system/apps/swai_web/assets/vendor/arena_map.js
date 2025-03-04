import * as d3 from 'd3';
import * as d3_hex from 'd3-hexbin';


const consideredNewNode = 10; // seconds
const hexagon_size = 5;
const particle_size = 2;
const size_factor = 1.8;
const horizontal_scale = 3/2;
const vertical_scale = Math.sqrt(3);

const ringConfig = {
  'iceServers': [
    {
      'urls': 'stun:stun.l.google.com:19302'
    },
  ]
};

const proto = window.location.protocol === "https:" ? "wss:" : "ws:";
const get_offer = async (scape_id) => {
  offer_url = `${window.location.protocol}//${window.location.host}/api/rings/${scape_id}`;
  const response = await fetch(offer_url);
  offer = await response.json();
  console.log(`found SDP offer for scape ${scape_id} :`, offer);
  return offer;
};

const start_connection = async (ringSocket, scape_id) => {
  offer = await get_offer(scape_id);
  
  const pc = new RTCPeerConnection(ringConfig);

  pc.setRemoteDescription(offer);

  pc.onicecandidate = event => {
    if (event.candidate === null) return;
    console.log("Sent ICE candidate:", event.candidate);
    ringSocket.send(JSON.stringify({ 
      type: "ice", 
      data: event.candidate,
      scape_id: scape_id
    }));
  };

  const dataChannel = pc.createDataChannel(scape_id);
  dataChannel.onopen = _ => { console.log("Data channel is open"); }
  dataChannel.onclose = _ => { console.log("Data channel is closed"); }
  dataChannel.onmessage = event => {
   console.log("Received message:", event.data);
  }

  pc.ondatachannel = event => {
    const dataChannel = event.channel;
    dataChannel.onmessage = event => {
      console.log("OnDataChannel Received message:", event.data);
    }
  }

  ringSocket.onmessage = async event => {
    const { type, data } = JSON.parse(event.data);

    switch (type) {
      case "answer":
        console.log("Received SDP answer:", data);
        await pc.setRemoteDescription(data);
        break;
      case "ice":
        console.log("Received ICE candidate:", data);
        await pc.addIceCandidate(data);
    }
  };

  let offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  console.log("Sent SDP offer:", offer);
  ringSocket.send(JSON.stringify({ type: "offer", data: offer }));
};


let g = null;


export const HivesChanged = {
  mounted() {
    this.handleEvent("hives_changed", ({ hives }) => {
      this.el.dataset.hives = JSON.stringify(hives);
    });
  },
  updated() {
    this.handleEvent("hives_changed", ({ hives }) => {
      this.el.dataset.hives = JSON.stringify(hives);
    });
  }
};

export const ParticlesChanged = {
  mounted() {
    this.handleEvent("particles_changed", ({ particles }) => {
      this.el.dataset.particles = JSON.stringify(particles);
    });
  },
  updated() {
    this.handleEvent("particles_changed", ({ particles }) => {
      this.el.dataset.particles = JSON.stringify(particles);
    });
  }
};


export const ArenaMapChanged = {
  mounted() {
    this.handleEvent("arena_map_changed", ({ arena_map }) => {
      this.el.dataset.arena_map = JSON.stringify(arena_map);
    });
  },
  updated() {
    this.handleEvent("arena_map_changed", ({ arena_map }) => {
      this.el.dataset.arena_map = JSON.stringify(arena_map);
    });
  }
};

// Function to draw particles
function drawParticles(svg, particles) {
  const particleSelection = svg.selectAll('circle')
    .data(particles, d => d.particle_id);

  particleSelection.enter()
    .append('circle')
    .attr('r', particle_size)
    .attr('fill', d => d.hive_color)
    .merge(particleSelection)
    .attr('cx', d => d.position.x)
    .attr('cy', d => d.position.y);



  particleSelection.exit().remove();
}

// Usage in TheArena component
export const TheArena = {
  mounted() {    

    // this.ringSocket = new WebSocket(`${proto}//${window.location.host}/ring_socket/websocket`);
    // this.ringSocket.onopen = _ => start_connection(ringSocket, this.el.dataset.scape_id);
    // this.ringSocket.onclose = event => console.log("Ring connection was terminated:", event);
     

    this.scape_id = this.el.dataset.scape_id;
    connect_to_ring(this.scape_id);
    this.arena_map = JSON.parse(this.el.dataset.arena_map);
    this.particles = JSON.parse(this.el.dataset.particles);
    this.hives = JSON.parse(this.el.dataset.hives);
    this.svg = drawArena(this.el, 800, 600, 5, this.hives);

//    this.particles = generateParticles([], this.hives);
    this.particles = JSON.parse(this.el.dataset.particles);
    // Call updateParticles with the appropriate parameters
//    updateParticles(this.svg, this.hives, 800, 600, 5);
    drawParticles(this.svg, this.particles);
  },
  updated() {
    this.arena_map = JSON.parse(this.el.dataset.arena_map);
    this.particles = JSON.parse(this.el.dataset.particles);
    this.hives = JSON.parse(this.el.dataset.hives);
    this.svg = drawArena(this.el, 800, 600, 5, this.hives);
    // this.particles = generateParticles(this.particles, this.hives);
    this.particles = JSON.parse(this.el.dataset.particles);
    // Call updateParticles with the appropriate parameters
//    updateParticles(this.svg, this.hives, 800, 600, 5);
    drawParticles(this.svg, this.particles);
  }
};

function drawArena(an_el, width, height, hexa_size, hives) {
  const svg = prepareArena(an_el, width, height, hexa_size, hives);
//  drawArenaRaster(svg, width, height, hexa_size);
  overlayHives(svg, 7, hexa_size, hives);
  return svg;
}

function prepareArena(an_el, width, height, hexa_size, hives) {
  d3.select(an_el)
    .selectAll("svg")
    .remove();

  const svg = d3.select(an_el)
    .append("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("viewBox", `0 0 ${width} ${height}`)
    .attr("preserveAspectRatio", "xMidYMid meet");
  return svg;
}


function drawArenaRaster(svg, width, height, hexa_size) {

  const margin = { top: 10, right: 10, bottom: 10, left: 10 };
  const innerWidth = vertical_scale * (width - margin.left - margin.right);
  const innerHeight = horizontal_scale * (height - margin.top - margin.bottom);

  const g = svg.append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

  // Create a hexbin generator
  const hexbin = d3_hex.hexbin()
    .radius(hexa_size)
    .extent([[0, 0], [innerWidth, innerHeight]]);

  // Calculate hexagons
  // const hexagons = hexbin(
  //   d3.range(innerWidth * innerHeight / (hexa_size * hexa_size * 1.5))
  //     .map((d, i) => [
  //       (i % Math.ceil(innerWidth / (hexa_size * Math.sqrt(3)))) * hexa_size * Math.sqrt(3),
  //       Math.floor(i / Math.ceil(innerWidth / (hexa_size * Math.sqrt(3)))) * hexa_size * 1.5
  //     ])
  // );

   const hexagons = hexbin(
     d3.range(innerWidth * innerHeight / (hexa_size * hexa_size))
       .map((d, i) => [i % innerWidth, Math.floor(i / innerWidth)])
   );
  g.append("g")
    .selectAll("path")
    .data(hexagons)
    .enter().append("path")
    .attr("d", hexbin.hexagon())
    .attr("transform", d => `translate(${d.x},${d.y})`)
    .attr("fill", "transparent")
    .attr("stroke", "gray");

  return svg;
}

function overlayHives(svg, hive_size, hexa_size, hives) {
  const g = svg.append("g");

  hives.forEach(hive => {
    hive.hive_image = "https://api.dicebear.com/8.x/bottts/svg?seed=" + hive.user_alias;
    if (hive.user_alias == null || hive.user_alias == "FREE") {
      hive.user_alias = "FREE";
      hive.hive_image = "https://api.dicebear.com/8.x/bottts/svg?seed=guest00000000000000";
      hive.hive_color = "gray"
    }
    console.log("Overlaying Hive.hexa: ", hive.hexa);
    const { q, r } = hive.hexa;
    console.log("Overlaying Hive.q: ${q}, r: ${r}");

    // Calculate the center position of the octagon
    const x = q * hexa_size * horizontal_scale;
    const y = r * hexa_size * vertical_scale;

    // Adjust the octagon size
    const adjustedSize = hive_size * size_factor; // Increase the size by 20%

    console.log("Overlaying Hive: ", hive);

    // Append the Hive Area as an octagon
    g.append("polygon")
      .attr("points", [
        [x - (adjustedSize / 2) * hexa_size, y - (adjustedSize / 2) * hexa_size * 0.5],
        [x, y - adjustedSize * hexa_size * 0.5],
        [x + (adjustedSize / 2) * hexa_size, y - (adjustedSize / 2) * hexa_size * 0.5],
        [x + adjustedSize * hexa_size * 0.5, y],
        [x + (adjustedSize / 2) * hexa_size, y + (adjustedSize / 2) * hexa_size * 0.5],
        [x, y + adjustedSize * hexa_size * 0.5],
        [x - (adjustedSize / 2) * hexa_size, y + (adjustedSize / 2) * hexa_size * 0.5],
        [x - adjustedSize * hexa_size * 0.5, y]
      ].join(" "))
      .attr("fill", hive.hive_color)
      .attr("stroke", "gray")
      .attr("stroke-width", 3);

    // Append the image
    g.append("image")
      .attr("xlink:href", getHiveImage(hive.user_alias))
      .attr("x", x - (hive_size / 2) * hexa_size)
      .attr("y", y - (hive_size / 2) * hexa_size - 6)
      .attr("width", hive_size * hexa_size)
      .attr("height", hive_size * hexa_size);

    // Append the user alias below the image
    g.append("text")
      .attr("font-size", "10px")
      .attr("x", x)
      .attr("y", y - 8 + (Math.round(hive_size / 2) + 1) * hexa_size)
      .attr("text-anchor", "middle")
      .attr("fill", "black")
      .text(hive.user_alias);
  });
  return svg;
}

function getHiveImage(user_alias) {
  if (user_alias == null || user_alias == "FREE") {
    return "https://api.dicebear.com/8.x/bottts/svg?seed=guest00000000000000";
  }
  return "https://api.dicebear.com/8.x/bottts/svg?seed=" + user_alias;
}





