
const GeoUtils = {
  earthRadius: 6371.0, // Earth radius in kilometers

  degreesToRadians(degrees) {
    return degrees * Math.PI / 180.0;
  },

  haversineDistance([lat1, lon1], [lat2, lon2]) {
    // Convert latitude and longitude from degrees to radians
    lat1 = this.degreesToRadians(lat1);
    lon1 = this.degreesToRadians(lon1);
    lat2 = this.degreesToRadians(lat2);
    lon2 = this.degreesToRadians(lon2);

    const dLat = lat2 - lat1;
    const dLon = lon2 - lon1;

    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(lat1) * Math.cos(lat2) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return this.earthRadius * c;
  },

  closestPoints(center, points, n) {
    return points
      .map(point => ({ point, distance: this.haversineDistance(center, point) }))
      .sort((a, b) => a.distance - b.distance)
      .slice(0, n)
      .map(({ point }) => point);
  }
};

// Example usage:
// const centerPoint = [40.7128, -74.0060]; // New York City (latitude, longitude in degrees)
// const points = [
//   [34.0522, -118.2437], // Los Angeles
//   [41.8781, -87.6298],  // Chicago
//   [51.5074, -0.1278],   // London
//   [35.6895, 139.6917],  // Tokyo
//   [48.8566, 2.3522],    // Paris
//   [55.7558, 37.6176]    // Moscow
// ];

// const n = 3;
// const closestNPoints = Geo.closestPoints(centerPoint, points, n);
// console.log(`The ${n} closest points to the center:`, closestNPoints);
