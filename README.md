# RootPay JavaScript SDK

A secure JavaScript SDK for collecting payment information without sensitive data touching the client's servers. This SDK enables easy integration with the RootPay platform for securely collecting card and bank account details.

## Features

- Securely collect payment information (card details, bank account details)
- Cross-origin communication via iframes
- Token-based authentication
- PCI-compliant architecture
- Manage saved payment methods (view, fetch, and submit new payment methods)

## Installation

### Production Use (CDN)
For production use, include RootPay directly from the jsDelivr CDN:

```html
<!-- Latest version -->
<script src="https://cdn.jsdelivr.net/gh/root-credit/root-pay-js-sdk@latest/rootpay.min.js"></script>

<!-- Specific version -->
<script src="https://cdn.jsdelivr.net/gh/root-credit/root-pay-js-sdk@VERSION/rootpay.min.js"></script>
```

## Testing Demo

We provide sample integration demos that you can use to test the SDK with your RootPay account.

### Prerequisites for Testing

1. You must have a RootPay account to use the demos
2. You need a valid session token from your backend
3. You need your payee ID or payer ID from the RootPay platform (depending on your use case)

### Web Demo

1. Download the files from the `web` directory
2. The files are `styles.css` and `index.html`.
3. Open `index.html` in a web browser (the script loads automatically from CDN)
4. Enter your session token, user type (payee or payer), and corresponding ID in the form
5. Click "Initialize Payment Form" to test the SDK
6. You can test both card and bank account payment methods

### iOS Demo

1. Open the Xcode project in the `ios-example` directory
2. Build and run the project on a simulator or device
3. Tap "Collect Payment Info" to open the payment form
4. The demo includes a WebView that loads the SDK and connects to RootPay

### Test Values

For test card transactions, you can use the number `4111 1111 1111 1111` with any future expiry date.

Refer to the official documentation at https://docs.root.credit for details on generating session tokens and verifying your test transactions.

## API Reference

### Initialization

```javascript
RootPay.init(userType, options);
```

**Parameters:**
- `userType` (String): User type - either `"payee"` or `"payer"` to set the correct ID
- `options` (Object):
  - `token` (String): RootPay session token
  - `payee_id` (String): Payee ID (when userType is "payee")
  - `payer_id` (String): Payer ID (when userType is "payer")
  - `apiBaseUrl` (String, optional): Override the API URL
  - `debug` (Boolean, optional): Enable detailed logging (default: false)

**Returns:** RootPay instance

**Example:**
```javascript
const sdk = window.RootPay.init("payee", {
  token: "your-session-token",
  payee_id: "your-payee-id",
  debug: true,
});
```

### Field Creation

```javascript
rootpay.field(selector, options);
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
rootpay.submitPaymentMethod(callback, type, options);
```

**Parameters:**
- `callback` (Function): Callback function with parameters:
  - `error` (Object|null): Error object if submission fails, null on success
  - `response` (Object): Response data
- `type` (String): Payment method type ('card' or 'bank')
- `options` (Object, optional): Additional options
  - `isDefault` (Boolean, optional): Whether this payment method should be set as default (default: true)

**Example:**
```javascript
sdk.submitPaymentMethod(
  (error, response) => {
    if (error) {
      console.error("Submission failed:", error);
    } else {
      console.log("Payment method submitted:", response);
    }
  },
  "card",
  { isDefault: true }
);
```

### Utility Methods

### Payment Methods Management

```javascript
rootpay.getPaymentMethods(callback, options);
```

**Parameters:**
- `callback` (Function, optional): Callback function with parameters:
  - `error` (Object|null): Error object if the fetch fails, null on success
  - `paymentMethods` (Array): Array of payment method objects
  - `paginationInfo` (Object): Pagination details including:
    - `hasMore` (Boolean): Whether there are more payment methods to fetch
    - `nextCursor` (String|null): Cursor to use for fetching the next page, null if no more pages
- `options` (Object, optional): Pagination options
  - `cursor` (String): Cursor for fetching the next page of results

**Returns:**
- When called without a callback: Array of current payment methods (synchronous use)
- When called with a callback: Fetches latest payment methods from server (asynchronous use)
