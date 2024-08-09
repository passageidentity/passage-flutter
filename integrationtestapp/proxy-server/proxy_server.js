const express = require('express');
const axios = require('axios'); // Import axios
const bodyParser = require('body-parser');
const app = express();
const PORT = 3000; // Proxy server port

// Add CORS headers to allow requests from localhost:4200
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:4200');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const mailosaurAPIKey = process.env.MAILOSAUR_API_KEY || 'default_key';

// Proxy for Mailosaur API
app.get('/api/messages', async (req, res) => {
  const url = 'https://mailosaur.com/api/messages' + req.originalUrl.replace('/api/messages', '');
  console.log(`Proxying request to: ${url}`);
  try {
    const response = await axios.get(url, {
      headers: { 'Authorization': 'Basic ' + Buffer.from('api:' + mailosaurAPIKey).toString('base64') }
    });
    console.log(`Response from Mailosaur: ${response.status}`);
    res.status(response.status).send(response.data);
  } catch (error) {
    console.error(`Error proxying request: ${error}`);
    res.status(500).send(error.toString());
  }
});

app.get('/api/messages/:id', async (req, res) => {
  const url = `https://mailosaur.com/api/messages/${req.params.id}`;
  console.log(`Proxying request to: ${url}`);
  try {
    const response = await axios.get(url, {
      headers: { 'Authorization': 'Basic ' + Buffer.from('api:' + mailosaurAPIKey).toString('base64') }
    });
    console.log(`Response from Mailosaur: ${response.status}`);
    res.status(response.status).send(response.data);
  } catch (error) {
    console.error(`Error proxying request: ${error}`);
    res.status(500).send(error.toString());
  }
});

app.listen(PORT, () => {
  console.log(`Proxy server running on http://localhost:${PORT}`);
});