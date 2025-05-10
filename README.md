# RootPay JavaScript SDK

A secure JavaScript SDK for managing payment methods that helps maintain PCI compliance by keeping sensitive data off your servers.

## Installation

```bash
npm install rootpay-js
```

## Basic Usage

```javascript
// Initialize with a session token
const rootpay = RootPay.init({
  token: 'your_session_token',
  environment: 'production'
});

// Create payment fields
const cardField = rootpay.field('#card-container', {
  type: 'card-number',
  name: 'card-number'
});

// Submit payment method
rootpay.submitPaymentMethod(function(status, response) {
  // Handle response
});
```

For detailed documentation, please refer to internal company resources.