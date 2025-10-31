// client/public/app.js
Cesium.Ion.defaultAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyMDE1ZjE0Zi03OTlkLTRiMzUtODI5Zi05ODY4OWM2NTAzYmIiLCJpZCI6MzU1NzMzLCJpYXQiOjE3NjE4ODg5OTV9.Fe4BOnDSXDL48UKIzCsv9A7851NF9F5Rx83bqcixoy4';

const viewer = new Cesium.Viewer('cesiumContainer', {
  terrainProvider: Cesium.createWorldTerrain(),
  baseLayerPicker: true,
  infoBox: true,
  selectionIndicator: true
});

const API_URL = 'http://localhost:5000/api';
let addingPole = false;

// Event listeners for buttons
document.getElementById('refresh-btn').addEventListener('click', fetchAndDisplayPoles);
document.getElementById('add-pole-btn').addEventListener('click', () => {
  addingPole = true;
  alert('Click on the globe to place a new pole.');
});

// Fetch poles from backend and display them on the globe
async function fetchAndDisplayPoles() {
  try {
    console.log("🔄 Fetching poles...");
    const res = await fetch(`${API_URL}/poles`);
    if (!res.ok) throw new Error('Failed to fetch poles');
    const poles = await res.json();

    viewer.entities.removeAll();
    console.log(`✅ Loaded ${poles.length} poles`);

    poles.forEach(p => {
      const lon = parseFloat(p.longitude);
      const lat = parseFloat(p.latitude);

      if (isNaN(lon) || isNaN(lat)) return; // skip invalid

      const color =
        p.status === 'Critical'
          ? Cesium.Color.RED
          : p.status === 'Active'
          ? Cesium.Color.GREEN
          : Cesium.Color.ORANGE;

      const entity = viewer.entities.add({
        position: Cesium.Cartesian3.fromDegrees(lon, lat),
        name: `Pole ${p.pole_id}`,
        point: {
          pixelSize: 10,
          color: color,
          outlineColor: Cesium.Color.BLACK,
          outlineWidth: 1
        },
        label: {
          text: `Pole ${p.pole_id}`,
          font: '14px sans-serif',
          style: Cesium.LabelStyle.FILL_AND_OUTLINE,
          verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
          pixelOffset: new Cesium.Cartesian2(0, -20)
        },
        description: `
          <b>Pole ID:</b> ${p.pole_id}<br/>
          <b>Type:</b> ${p.type_name}<br/>
          <b>Height:</b> ${p.height} m<br/>
          <b>Class:</b> ${p.class}<br/>
          <b>Status:</b> ${p.status}<br/>
          <b>Installed:</b> ${new Date(p.installed_at).toDateString()}
        `
      });
    });

    if (viewer.entities.values.length > 0) {
      viewer.flyTo(viewer.entities);
    } else {
      alert("No poles found in database!");
    }
  } catch (e) {
    console.error("❌ Failed to load poles:", e);
    alert('Failed to load poles');
  }
}

// Handle globe clicks for adding poles
const handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);
handler.setInputAction(async function (click) {
  const picked = viewer.scene.pick(click.position);

  // If clicking on a pole
  if (Cesium.defined(picked) && picked.id && picked.id.name) {
    const props = picked.id;
    alert(`You selected: ${props.name}`);
    return;
  }

  // If in "Add Pole" mode
  if (addingPole) {
    const cartesian = viewer.camera.pickEllipsoid(click.position, viewer.scene.globe.ellipsoid);
    if (!cartesian) {
      alert('Invalid place on globe');
      return;
    }

    const carto = Cesium.Cartographic.fromCartesian(cartesian);
    const lon = Cesium.Math.toDegrees(carto.longitude).toFixed(6);
    const lat = Cesium.Math.toDegrees(carto.latitude).toFixed(6);
    const poleNumber = prompt('Enter pole number (e.g., P100):', 'P' + Date.now());
    if (!poleNumber) {
      addingPole = false;
      return;
    }

    const payload = {
      pole_number: poleNumber,
      longitude: lon,
      latitude: lat,
      type_id: 1,
      height: 10,
      class: 'MVP',
      installation_date: new Date().toISOString().split('T')[0],
      manufacturer: 'Auto Added',
      status_id: 1,
      notes: ''
    };

    try {
      const res = await fetch(`${API_URL}/poles`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (res.ok) {
        alert('✅ Pole added successfully');
        fetchAndDisplayPoles();
      } else {
        alert('❌ Failed to add pole');
      }
    } catch (err) {
      console.error('❌ Error adding pole:', err);
      alert('Error adding pole');
    }

    addingPole = false;
  }
}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

// Initial load
fetchAndDisplayPoles();
