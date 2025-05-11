# RootPay JavaScript SDK

A secure JavaScript SDK for collecting payment information that helps maintain PCI compliance by keeping sensitive data off your servers.

## Features

- Securely collect payment information (card details, bank account details)
- Cross-origin communication via iframes
- Token-based authentication
- PCI-compliant architecture
- Cross-browser compatibility

## Installation

For production use, include RootPay directly from the jsDelivr CDN:

```html
<!-- Latest version -->
<script src="https://cdn.jsdelivr.net/gh/root-credit/root-pay-js-sdk@latest/rootpay.min.js"></script>

<!-- Specific version -->
<script src="https://cdn.jsdelivr.net/gh/root-credit/root-pay-js-sdk@VERSION/rootpay.min.js"></script>
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
  - `apiBaseUrl` (String, optional): Override the API URL (default: 'http://localhost:8000')
  - `debug` (Boolean, optional): Enable detailed logging (default: false)
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

## Testing with RootPay Account

To properly test the SDK with the demo implementation, follow these steps:

## Testing Demo

We provide a sample integration demo `index.html` file that you can use to test the SDK with your RootPay account:

### Prerequisites for Testing

1. You must have a RootPay account to use the demo
2. You need a valid session token from your backend (see "Testing with RootPay Account" section above)
3. You need your payee ID from the RootPay platform

### Using the Demo

1. Download both `rootpay.min.js` and `index.html` from the distribution package
2. Place both files in the same directory
3. Open `index.html` in a web browser
4. Enter your session token and payee ID in the form
5. Click "Initialize Payment Form" to test the SDK
6. You can test both card and bank account payment methods
7. Try different themes to see UI customization options

For test card transactions, you can use the number `4111 1111 1111 1111` with any future expiry date.

Refer to the "Testing with RootPay Account" section above and the official documentation at https://docs.root.credit for details on generating session tokens and verifying your test transactions.

## License

MIT