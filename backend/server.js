const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('Hello from Effective Mobile!!! Если вы это читаете deploy прошёл успешно');
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Backend app listening at http://localhost:${port}`);
});
