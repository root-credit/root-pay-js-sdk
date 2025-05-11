# RootPay JavaScript SDK

A secure JavaScript SDK for collecting payment information that helps maintain PCI compliance by keeping sensitive data off your servers.

## Features

- Securely collect payment information (card details, bank account details)
- Cross-origin communication via iframes
- Token-based authentication
- PCI-compliant architecture
- Cross-browser compatibility

## Installation

For production use, include RootPay directly from our CDN:

```html
<script src="https://cdn.rootpay.com/v1/rootpay.min.js"></script>
```

## Integration Guide

To use RootPay in your application:

1. Initialize the SDK with your session token
2. Create payment input fields
3. Submit payment method information

See API Reference for detailed usage instructions.

## Token-Based Authentication Flow

For security reasons, RootPay uses a token-based authentication system:

1. Your backend server requests a session token from the RootPay API
2. The token is passed to your frontend
3. Your frontend initializes the RootPay SDK with this token
4. The SDK uses the token for all operations

## API Reference

### Initialization

```javascript
RootPay.init(options)
```

**Parameters:**
- `options` (Object):
  - `token` (String): RootPay session token
  - `payee_id` (String): Payee ID
  - `environment` (String): 'sandbox' or 'production'
  - `apiBaseUrl` (String, optional): Override the API URL
  - `onSuccess` (Function): Callback for successful payment method creation
  - `onError` (Function): Callback for payment method creation errors

**Returns:** RootPay instance

### Field Creation

```javascript
rootpay.field(selector, options)
```

**Parameters:**
- `selector` (String): CSS selector for the container element
- `options` (Object):
  - `type` (String): Field type ('card-number', 'card-expiry', 'routing-number', 'account-number')
  - `name` (String): Field name
  - `style` (Object): Custom CSS properties for styling the field

**Returns:** Field controller object with `update()` method

### Payment Method Management

```javascript
rootpay.submitPaymentMethod(callback, type)
```

**Parameters:**
- `callback` (Function): Callback function with parameters:
  - `status` (Number): HTTP status code
  - `response` (Object): Response data
- `type` (String): Payment method type ('card' or 'bank')

### Utility Methods

```javascript
rootpay.getFormState()
```

**Returns:**
- `getFormState()`: Current form state object including field validity and values

## Browser Compatibility

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- IE11+ (with polyfills)

## Security Practices

- Never store payment information on your servers
- Always use HTTPS for production
- Keep API keys and secrets in environment variables
- Request tokens with the minimum necessary scopes
- Set appropriate token TTL values
- Never hardcode credentials in client-side code

## License

MIT