# RootPay JavaScript SDK

A secure JavaScript SDK for managing payment methods that helps maintain PCI compliance by keeping sensitive data off your servers.

## Features

- Securely collect payment information (card details, bank account details)
- Manage payment methods (list, add, set default, remove)
- Token-based authentication
- PCI-compliant through secure iframes
- Cross-platform compatibility



## Installation

### CDN

You can include RootPay directly from our CDN:

```html
<script src="https://cdn.rootpay.com/v1/rootpay.min.js"></script>
```

## Integration Guide



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
  - `environment` (String): 'sandbox' or 'production'
  - `onTokenExpired` (Function): Callback when token expires
  - `onStateChange` (Function): Callback for form state changes

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
  - `placeholder` (String): Placeholder text
  - `validations` (Array): Validation rules
  - `css` (Object): Custom CSS properties

**Returns:** Field controller object


### Payment Method Management

```javascript
rootpay.getPaymentMethods(callback)
rootpay.setDefaultPaymentMethod(paymentMethodId, callback)
rootpay.removePaymentMethod(paymentMethodId, callback)
rootpay.submitPaymentMethod(callback)
```

**Parameters:**
- `paymentMethodId` (String): ID of the payment method
- `callback` (Function): Callback function with parameters:
  - `status` (Number): HTTP status code
  - `response` (Object): Response data


### Utility Methods

```javascript
rootpay.getFormState()
rootpay.getTokenMetadata()
```

**Returns:**
- `getFormState()`: Current form state object
- `getTokenMetadata()`: Token metadata including expiration and scopes

## Distribution Notes

This library is intended for internal use only. The public distribution package only includes the compiled JavaScript file without documentation, examples, or test files.

When publishing to npm, the README and other sensitive files will be automatically excluded by the .npmignore configuration. Use the release script which verifies no sensitive information is included in the build output.

## Security Practices

- Never store payment information on your servers
- Always use HTTPS for production
- Keep API keys and secrets in environment variables
- Request tokens with the minimum necessary scopes
- Set appropriate token TTL values
- Never hardcode credentials in client-side code

## Browser Compatibility

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- IE11+ (with polyfills)

## Support

For internal support, please contact the payments infrastructure team at payments-infra@root-financial.internal

## Getting Started



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