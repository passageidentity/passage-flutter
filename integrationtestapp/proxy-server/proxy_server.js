const express = require('express');
const request = require('request');
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

const mailosaurAPIKey = 'udoOEVY0FNE11tTh';

// Proxy for Mailosaur API
app.get('/api/messages', (req, res) => {
  const url = 'https://mailosaur.com/api/messages' + req.originalUrl.replace('/api/messages', '');
  console.log(`Proxying request to: ${url}`);
  request({
    url: url,
    headers: { 'Authorization': 'Basic ' + Buffer.from('api:' + mailosaurAPIKey).toString('base64') }
  }, (error, response, body) => {
    if (error) {
      console.error(`Error proxying request: ${error}`);
      res.status(500).send(error);
    } else {
      console.log(`Response from Mailosaur: ${response.statusCode}`);
      res.status(response.statusCode).send(body);
    }
  });
});

app.get('/api/messages/:id', (req, res) => {
  const url = `https://mailosaur.com/api/messages/${req.params.id}`;
  console.log(`Proxying request to: ${url}`);
  request({
    url: url,
    headers: { 'Authorization': 'Basic ' + Buffer.from('api:' + mailosaurAPIKey).toString('base64') }
  }, (error, response, body) => {
    if (error) {
      console.error(`Error proxying request: ${error}`);
      res.status(500).send(error);
    } else {
      console.log(`Response from Mailosaur: ${response.statusCode}`);
      res.status(response.statusCode).send(body);
    }
  });
});

app.listen(PORT, () => {
  console.log(`Proxy server running on http://localhost:${PORT}`);
});
