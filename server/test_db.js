const mysql = require('mysql2/promise');
(async () => {
  try {
    const conn = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: '',
      database: 'electric_pole_gis',
      port: 3307     // change to the port you verified above
    });
    console.log('✅ Node connected to MariaDB!');
    await conn.end();
  } catch (err) {
    console.error('❌ Test connection failed:');
    console.error(err);
  }
})();
