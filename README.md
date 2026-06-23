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

Refer to the official documentation at https://docs.useroot.com for details on generating session tokens and verifying your test transactions.

## API Reference

### Initialization

```javascript
const { data: sdk, error } = await RootPay.init(userType, options);
```

**Parameters:**

- `userType` (String): User type - either `"payee"` or `"payer"` to set the correct ID
- `options` (Object):
  - `token` (String): RootPay session token
  - `payee_id` (String): Payee ID (when userType is "payee")
  - `payer_id` (String): Payer ID (when userType is "payer")
  - `apiBaseUrl` (String, optional): Override the API URL
  - `debug` (Boolean, optional): Enable detailed logging (default: false)

**Returns:** `Promise<{ data: SDKInstance | null, error: SDKError }>`

**Example:**

```javascript
const { data: sdk, error } = await window.RootPay.init("payee", {
  token: "your-session-token",
  payee_id: "your-payee-id",
  debug: true,
});

if (error) {
  console.error("Initialization failed:", error);
}
```

### Field Creation

```javascript
const { data, error } = await sdk.field(selector, options);
```

**Parameters:**

- `selector` (String): CSS selector for the container element
- `options` (Object):
  - `type` (String): Field type (`card-number`, `confirm-card-number`, `card-expiry`, `routing-number`, `account-number`, `confirm-account-number`)
  - `name` (String): Field name
  - `style` (Object): Custom CSS properties for styling the field
  - `onStateChange` (Function, optional): Receives the current field state whenever validation or focus state changes

**Returns:** `Promise<{ data: { id: string } | null, error: SDKError }>`

**`onStateChange` shape:**

```typescript
type FieldState = {
  isValid: boolean;
  isFocused: boolean;
  isEmpty: boolean;
  error: {
    errorCode: string;
    message: string;
    details?: Record<string, any> | any[] | null;
  } | null;
};
```

### Payment Method Management

```javascript
const { data, error } = await sdk.submitPaymentMethod(type, options);
```

**Parameters:**

- `type` (String): Payment method type ('card' or 'bank')
- `options` (Object, optional): Additional options
  - `is_default` (Boolean, optional): Whether this payment method should be set as default (default: false)

**Example:**

```javascript
const { data, error } = await sdk.submitPaymentMethod("card", {
  is_default: true,
});

if (error) {
  console.error("Submission failed:", error);
} else {
  console.log("Payment method submitted:", data);
}
```

### Utility Methods

### Payment Methods Management

```javascript
const { data, error } = await sdk.getPaymentMethods(options);
```

**Parameters:**

- `options` (Object, optional): Pagination options
  - `cursor` (String): Cursor for fetching the next page of results

**Returns:** `Promise<{ data: any, error: SDKError }>`

### Teardown

```javascript
const { error } = await sdk.teardown();
```

Use `teardown()` to fully dispose the SDK instance, remove all iframes, clear pending requests, and allow a fresh `RootPay.init(...)` call. This is also the recommended token refresh flow.

```javascript
await sdk.teardown();

const { data: nextSdk, error } = await RootPay.init("payee", {
  token: "new-session-token",
  payee_id: "your-payee-id",
});
```

## Error Codes

All async SDK methods return errors in the form:

```typescript
type SDKError = {
  errorCode: string;
  message: string;
  details?: Record<string, any> | any[] | null;
} | null;
```

For API-backed failures, `details` may include transport metadata such as HTTP `status` and backend-provided `headers`, plus any additional backend error payload.

When the backend includes an `errorCode`, the SDK forwards that `errorCode` directly. `API_ERROR` is used only as a fallback when the backend error payload does not include an `errorCode`.

### Direct SDK Return Error Codes

| Error Code             | Emitted When                                                              | Notes                                                                          |
| ---------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `SDK_INIT_FAILED`      | SDK initialization fails after moderator setup cannot complete            | Returned by `RootPay.init(...)`                                                |
| `SDK_INIT_IN_PROGRESS` | `RootPay.init(...)` is called while a previous init is still running      | Returned by `RootPay.init(...)`                                                |
| `SDK_ALREADY_ACTIVE`   | `RootPay.init(...)` is called while an SDK instance is already active     | Call `sdk.teardown()` before re-initializing                                   |
| `TEARDOWN_FAILED`      | `sdk.teardown()` encounters an unexpected internal error                  | Returned by `sdk.teardown()`                                                   |
| `INVALID_USER_TYPE`    | `RootPay.init(...)` receives a user type other than `payee` or `payer`    | Returned by `RootPay.init(...)`                                                |
| `INVALID_OPTIONS`      | `RootPay.init(...)` options fail schema validation                        | `details` contains validation metadata                                         |
| `FIELD_INIT_FAILED`    | `sdk.field(...)` could not finish creating a secure iframe field          | `details` includes `fieldId` and `fieldType`                                   |
| `CONTAINER_NOT_FOUND`  | `sdk.field(...)` selector does not match any DOM element                  | `details.selector` is provided                                                 |
| `API_TIMEOUT`          | An API-backed call does not resolve before the SDK timeout                | Can be returned by `submitPaymentMethod()` or `getPaymentMethods()`            |
| `API_ERROR`            | The API returned an error payload without an explicit `errorCode`         | Fallback code; `details` may include `status`, `headers`, and backend metadata |
| `TEARDOWN`             | A pending API request was interrupted because `sdk.teardown()` was called | This is emitted to in-flight promises during teardown                          |

### Field Validation And Lifecycle Error Codes

These codes can be emitted by secure fields through `onStateChange(state)`, using `state.error.errorCode`. The same backend-defined codes may also be returned directly by API-backed SDK methods when the backend sends them in an error response.

| Error Code                        | Can Appear On                      | Message                                                       |
| --------------------------------- | ---------------------------------- | ------------------------------------------------------------- |
| `CARD_NUMBER_REQUIRED`            | `onStateChange`, API method errors | Card number is required                                       |
| `CARD_NUMBER_INVALID_LENGTH`      | `onStateChange`, API method errors | Card number must be between 13 and 19 digits                  |
| `CARD_NUMBER_CHECKSUM_FAILED`     | `onStateChange`, API method errors | Card number is invalid                                        |
| `CARD_NUMBER_MISMATCH`            | `onStateChange`, API method errors | Card numbers do not match                                     |
| `CARD_EXPIRY_INVALID_FORMAT`      | `onStateChange`, API method errors | Expiry must be in MMYY or MM/YY format                        |
| `CARD_EXPIRY_INVALID_MONTH`       | `onStateChange`, API method errors | Expiry month must be between 01 and 12                        |
| `CARD_EXPIRED`                    | `onStateChange`, API method errors | Card has expired                                              |
| `ACCOUNT_NUMBER_REQUIRED`         | `onStateChange`, API method errors | Account number is required                                    |
| `ACCOUNT_NUMBER_TOO_SHORT`        | `onStateChange`, API method errors | Account number must be at least 4 digits                      |
| `ACCOUNT_NUMBER_INVALID`          | `onStateChange`, API method errors | Account number is invalid                                     |
| `ACCOUNT_NUMBER_MISMATCH`         | `onStateChange`, API method errors | Account numbers do not match                                  |
| `ROUTING_NUMBER_REQUIRED`         | `onStateChange`, API method errors | Routing number is required                                    |
| `ROUTING_NUMBER_INVALID_LENGTH`   | `onStateChange`, API method errors | ABA routing number must be 9 digits                           |
| `ROUTING_NUMBER_CHECKSUM_FAILED`  | `onStateChange`, API method errors | Routing number checksum is invalid                            |
| `ROUTING_NUMBER_INVALID_PREFIX`   | `onStateChange`, API method errors | Routing number has an invalid Federal Reserve district prefix |
| `BIC_INVALID_LENGTH`              | `onStateChange`, API method errors | BIC must be 8 or 11 characters                                |
| `BIC_INVALID_BANK_CODE`           | `onStateChange`, API method errors | BIC bank code (first 4 characters) must be letters            |
| `BIC_INVALID_COUNTRY_CODE`        | `onStateChange`, API method errors | BIC country code (characters 5-6) must be letters             |
| `BIC_INVALID_FORMAT`              | `onStateChange`, API method errors | BIC location or branch code is invalid                        |
| `ROUTING_NUMBER_UNSUPPORTED_TYPE` | `onStateChange`, API method errors | Routing number type is not supported                          |

> **Note — BIC/SWIFT is not currently supported.** The `BIC_INVALID_*` error codes above (and the corresponding backend validation logic) exist in the platform but are **not reachable through this SDK**. No field type accepts a BIC/SWIFT code at this time. These codes are documented for completeness and to reflect the underlying validation layer, but you will not encounter them in a standard integration.

| `FIELD_NOT_READY` | `onStateChange`, API method errors | Field is not ready |
| `FIELD_TYPE_UNKNOWN` | `onStateChange`, API method errors | Unknown field type |
| `VALIDATION_ERROR` | `onStateChange`, API method errors | Validation failed |

### API-Only Backend Error Codes

These backend-originated errors are specific to API request validation and are returned directly by API-backed SDK methods.

| Backend Error Code      | Typical Source         | Message                    |
| ----------------------- | ---------------------- | -------------------------- |
| `TOKEN_NOT_PROVIDED`    | API request validation | Session token not provided |
| `PAYER_ID_NOT_PROVIDED` | API request validation | Payer Id not provided      |
| `PAYEE_ID_NOT_PROVIDED` | API request validation | Payee Id not provided      |

### Which SDK Function Can Emit Which Errors?

| SDK Function                             | Possible Error Codes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `RootPay.init(userType, options)`        | `SDK_INIT_IN_PROGRESS`, `SDK_ALREADY_ACTIVE`, `INVALID_USER_TYPE`, `INVALID_OPTIONS`, `SDK_INIT_FAILED`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `sdk.field(selector, options)`           | `CONTAINER_NOT_FOUND`, `FIELD_INIT_FAILED`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `field.onStateChange(state)`             | `CARD_NUMBER_REQUIRED`, `CARD_NUMBER_INVALID_LENGTH`, `CARD_NUMBER_CHECKSUM_FAILED`, `CARD_NUMBER_MISMATCH`, `CARD_EXPIRY_INVALID_FORMAT`, `CARD_EXPIRY_INVALID_MONTH`, `CARD_EXPIRED`, `ACCOUNT_NUMBER_REQUIRED`, `ACCOUNT_NUMBER_TOO_SHORT`, `ACCOUNT_NUMBER_INVALID`, `ACCOUNT_NUMBER_MISMATCH`, `ROUTING_NUMBER_REQUIRED`, `ROUTING_NUMBER_INVALID_LENGTH`, `ROUTING_NUMBER_CHECKSUM_FAILED`, `ROUTING_NUMBER_INVALID_PREFIX`, `BIC_INVALID_LENGTH`, `BIC_INVALID_BANK_CODE`, `BIC_INVALID_COUNTRY_CODE`, `BIC_INVALID_FORMAT`, `ROUTING_NUMBER_UNSUPPORTED_TYPE`, `FIELD_NOT_READY`, `FIELD_TYPE_UNKNOWN`, `VALIDATION_ERROR` |
| `sdk.submitPaymentMethod(type, options)` | `API_TIMEOUT`, `TEARDOWN`, `TOKEN_NOT_PROVIDED`, `PAYER_ID_NOT_PROVIDED`, `PAYEE_ID_NOT_PROVIDED`, all backend-forwarded validation/lifecycle codes listed above, and `API_ERROR` only as a fallback when the backend omits `errorCode`                                                                                                                                                                                                                                                                                                                                                                                            |
| `sdk.getPaymentMethods(options)`         | `API_TIMEOUT`, `TEARDOWN`, `TOKEN_NOT_PROVIDED`, `PAYER_ID_NOT_PROVIDED`, `PAYEE_ID_NOT_PROVIDED`, all backend-forwarded validation/lifecycle codes listed above, and `API_ERROR` only as a fallback when the backend omits `errorCode`                                                                                                                                                                                                                                                                                                                                                                                            |
| `sdk.teardown()`                         | `TEARDOWN_FAILED`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

### API Error Details Shape

When an API-backed method returns a backend error, the error typically looks like this:

```typescript
type ApiErrorDetails = {
  status?: number;
  headers?: Record<string, string>;
  details?: Record<string, any> | any[] | null;
};
```

### API Error Handling Example

```javascript
const { data, error } = await sdk.submitPaymentMethod("card");

if (error) {
  switch (error.errorCode) {
    case "API_TIMEOUT":
      console.error("Request timed out");
      break;
    case "TOKEN_NOT_PROVIDED":
    case "PAYER_ID_NOT_PROVIDED":
    case "PAYEE_ID_NOT_PROVIDED":
      console.error("Request validation failed:", error.message);
      console.log("details:", error.details);
      break;
    case "API_ERROR":
      console.error(
        "API failed without explicit backend errorCode:",
        error.message,
      );
      console.log("status:", error.details?.status);
      console.log("headers:", error.details?.headers);
      console.log("backend details:", error.details?.details);
      break;
    default:
      console.error("Backend forwarded error:", error.errorCode, error.message);
      console.log("details:", error.details);
  }
}
```
