const express = require('express');
const app = express();
const port = process.env.PORT || APP_PORT;

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Ready check endpoint
app.get('/ready', (req, res) => {
  res.status(200).json({ status: 'ready', timestamp: new Date().toISOString() });
});

// Main endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to APP_NAME',
    version: '1.0.0',
    environment: process.env.ENVIRONMENT || 'development'
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`APP_NAME listening on port ${port}`);
  console.log(`Environment: ${process.env.ENVIRONMENT || 'development'}`);
});
