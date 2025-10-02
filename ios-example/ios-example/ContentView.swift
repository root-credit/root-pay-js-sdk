import SwiftUI
import WebKit

// MARK: - Main Content View
struct ContentView: View {
    @State private var showWebView = false
    
    var body: some View {
        if showWebView {
            // Show WebView when button is clicked
            RootPayWebView(showWebView: $showWebView)
                .edgesIgnoringSafeArea(.all)
        } else {
            // Initial screen with just a button
            VStack {
                Spacer()
                Text("RootPay iOS Example")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                Button(action: {
                    showWebView = true
                }) {
                    Text("Collect Payment Info")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - WebView Implementation
struct RootPayWebView: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showWebView: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Set up configuration
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        configuration.userContentController = contentController
        
        // Enable JavaScript
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        
        // Set up message handlers
        contentController.add(context.coordinator, name: "returnToApp")
        contentController.add(context.coordinator, name: "consoleLog")
        
        // Create WebView
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        // Load HTML content
        webView.loadHTMLString(paymentFormHTML, baseURL: nil)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // No updates needed
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: RootPayWebView
        
        init(_ parent: RootPayWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ WebView loaded - JavaScript will handle SDK loading")
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "returnToApp" {
                // Return to main app
                DispatchQueue.main.async {
                    self.parent.showWebView = false
                }
            } else if message.name == "consoleLog" {
                print("JS Console: \(message.body)")
            }
        }
    }
    
    // MARK: - HTML Content
    var paymentFormHTML: String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <title>RootPay Integration</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    margin: 0;
                    padding: 20px;
                    background-color: #f5f5f7;
                    color: #333;
                    line-height: 1.5;
                }
                
                .container {
                    max-width: 600px;
                    margin: 0 auto;
                    background-color: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                    padding: 24px;
                }
                
                h1 {
                    text-align: center;
                    font-size: 24px;
                    margin-bottom: 24px;
                    color: #333;
                }
                
                h2 {
                    font-size: 20px;
                    margin-bottom: 20px;
                    color: #333;
                }
                
                .hidden {
                    display: none;
                }
                
                .form-group {
                    margin-bottom: 16px;
                }
                
                label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 500;
                }
                
                input[type="text"] {
                    width: 100%;
                    padding: 12px;
                    font-size: 16px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    box-sizing: border-box;
                }
                
                .payment-type {
                    display: flex;
                    gap: 16px;
                    margin-bottom: 20px;
                }
                
                .payment-type label {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }
                
                button {
                    background-color: #007AFF;
                    color: white;
                    border: none;
                    padding: 14px 20px;
                    font-size: 16px;
                    font-weight: 500;
                    border-radius: 8px;
                    cursor: pointer;
                    width: 100%;
                    margin-bottom: 12px;
                }
                
                button:disabled {
                    background-color: #cccccc;
                    cursor: not-allowed;
                }
                
                .return-button {
                    background-color: #6c757d;
                    margin-top: 30px;
                }
                
                .secure-field {
                    height: 50px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    margin-bottom: 16px;
                    background-color: #fff;
                }
                
                .status {
                    padding: 12px;
                    border-radius: 8px;
                    margin: 16px 0;
                    display: none;
                }
                
                .error {
                    background-color: #f8d7da;
                    border: 1px solid #f5c6cb;
                    color: #721c24;
                    display: block;
                }
                
                .success {
                    background-color: #d4edda;
                    border: 1px solid #c3e6cb;
                    color: #155724;
                    display: block;
                }
                
                .info {
                    background-color: #e8f4fd;
                    border: 1px solid #b8daff;
                    color: #004085;
                    display: block;
                }
                
                .loading {
                    background-color: #fff3cd;
                    border: 1px solid #ffeaa7;
                    color: #856404;
                    display: block;
                }
                
                .payment-method {
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    padding: 16px;
                    margin-bottom: 16px;
                    background-color: #f9f9f9;
                }
                
                .sdk-loading {
                    text-align: center;
                    padding: 20px;
                    color: #666;
                }
                
                .test-values {
                    background-color: #f8f9fa;
                    border-radius: 8px;
                    padding: 16px;
                    margin-top: 30px;
                    font-size: 14px;
                }
                
                .test-values h3 {
                    margin-top: 0;
                    font-size: 16px;
                }
                
                .checkbox-label {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-bottom: 20px;
                }
                
                .get-methods-button {
                    background-color: #28a745;
                    margin-bottom: 20px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>RootPay Integration</h1>
                
                <!-- SDK Loading Status -->
                <div id="sdk-loading" class="sdk-loading">
                    <p>Loading payment system...</p>
                </div>
                
                <!-- Setup Form -->
                <div id="setup-form" class="hidden">
                    <div class="form-group">
                        <label>User Type:</label>
                        <div class="payment-type">
                            <label>
                                <input type="radio" name="user-type" value="payee" checked> Payee
                            </label>
                            <label>
                                <input type="radio" name="user-type" value="payer"> Payer
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="token">RootPay Token:</label>
                        <input type="text" id="token" placeholder="Enter your RootPay session token" value="test_token_12345">
                    </div>
                    
                    <div class="form-group">
                        <label for="party-id">Party ID:</label>
                        <input type="text" id="party-id" placeholder="Enter Payee ID" value="test_party_id">
                    </div>
                    
                    <button id="initialize-btn">Initialize Payment Form</button>
                </div>
                
                <!-- Payment Form (initially hidden) -->
                <div id="payment-form" class="hidden">
                    <h2>Enter Payment Information</h2>
                    
                    <div class="payment-type">
                        <label>
                            <input type="radio" name="payment-type" value="card" checked> Debit Card
                        </label>
                        <label>
                            <input type="radio" name="payment-type" value="bank"> Bank Account
                        </label>
                    </div>
                    
                    <!-- Card Fields -->
                    <div id="card-fields">
                        <div class="form-group">
                            <label for="card-number-container">Card Number</label>
                            <div id="card-number-container" class="secure-field"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirm-card-number-container">Confirm Card Number</label>
                            <div id="confirm-card-number-container" class="secure-field"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="card-expiry-container">Expiry Date (MM/YY)</label>
                            <div id="card-expiry-container" class="secure-field"></div>
                        </div>
                    </div>
                    
                    <!-- Bank Fields -->
                    <div id="bank-fields" class="hidden">
                        <div class="form-group">
                            <label for="account-number-container">Account Number</label>
                            <div id="account-number-container" class="secure-field"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirm-account-number-container">Confirm Account Number</label>
                            <div id="confirm-account-number-container" class="secure-field"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="routing-number-container">Routing Number</label>
                            <div id="routing-number-container" class="secure-field"></div>
                        </div>
                    </div>
                    

                    <button id="submit-btn" disabled style="opacity: 0.5; cursor: not-allowed;">Submit Payment Information</button>
                    
                    <div id="status-message" class="status"></div>
                    
                    <!-- Payment Methods -->
                    <div id="payment-methods">
                        <h2>Saved Payment Methods</h2>
                        <button id="get-methods-btn" class="get-methods-button">Get Payment Methods</button>
                        <div id="payment-methods-list"></div>
                    </div>
                </div>
                
                <!-- Return to App Button -->
                <button id="return-btn" class="return-button">Return to App</button>
                
                <!-- Test Values -->
                <div class="test-values">
                    <h3>Test Values & Features</h3>
                    <p><strong>Confirmation Fields:</strong> Both card number and account number have confirmation fields to prevent typos</p>
                    <p><strong>Test Card:</strong> 4111 1111 1111 1111 with any future expiry date</p>
                    <p><strong>Test Account Number:</strong> 1234567890</p>
                    <p><strong>Test Routing Number:</strong> 111000025</p>
                </div>
            </div>
            
            <!-- 🎯 Load RootPay SDK directly in JavaScript -->
            <script>
                // Load SDK dynamically and set up API debugging
                (function() {
                    console.log('📦 Starting RootPay SDK loading process...');
                    
                    // Override console methods to send to Swift
                    const originalConsoleLog = console.log;
                    const originalConsoleError = console.error;
                    const originalConsoleWarn = console.warn;
                    
                    console.log = function() {
                        const args = Array.from(arguments);
                        const message = args.map(arg => {
                            if (typeof arg === 'object' && arg !== null) {
                                try {
                                    return JSON.stringify(arg, null, 2);
                                } catch (e) {
                                    return '[Complex Object]';
                                }
                            }
                            return String(arg);
                        }).join(' ');
                        
                        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.consoleLog) {
                            window.webkit.messageHandlers.consoleLog.postMessage('LOG: ' + message);
                        }
                        originalConsoleLog.apply(console, args);
                    };
                    
                    console.error = function() {
                        const message = Array.from(arguments).join(' ');
                        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.consoleLog) {
                            window.webkit.messageHandlers.consoleLog.postMessage('ERROR: ' + message);
                        }
                        originalConsoleError.apply(console, arguments);
                    };
                    
                    console.warn = function() {
                        const message = Array.from(arguments).join(' ');
                        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.consoleLog) {
                            window.webkit.messageHandlers.consoleLog.postMessage('WARN: ' + message);
                        }
                        originalConsoleWarn.apply(console, arguments);
                    };
                    
                    // Set up API debugging BEFORE loading SDK
                    const originalFetch = window.fetch;
                    window.fetch = function(url, options = {}) {
                        console.log('🌐 FETCH REQUEST:', {
                            url: url,
                            method: options.method || 'GET',
                            headers: options.headers,
                            body: options.body ? 'Present' : 'None'
                        });
                        
                        return originalFetch.apply(this, arguments)
                            .then(response => {
                                console.log('✅ FETCH RESPONSE:', {
                                    url: url,
                                    status: response.status,
                                    statusText: response.statusText
                                });
                                return response;
                            })
                            .catch(error => {
                                console.error('❌ FETCH ERROR:', {
                                    url: url,
                                    error: error.message
                                });
                                throw error;
                            });
                    };
                    
                    // Override XMLHttpRequest 
                    const OriginalXHR = window.XMLHttpRequest;
                    window.XMLHttpRequest = function() {
                        const xhr = new OriginalXHR();
                        const originalOpen = xhr.open;
                        const originalSend = xhr.send;
                        
                        xhr.open = function(method, url, async, user, password) {
                            console.log('🔗 XHR REQUEST:', {
                                method: method,
                                url: url
                            });
                            return originalOpen.apply(this, arguments);
                        };
                        
                        xhr.send = function(data) {
                            console.log('📤 XHR SEND:', {
                                data: data ? 'Present' : 'None'
                            });
                            return originalSend.apply(this, arguments);
                        };
                        
                        return xhr;
                    };
                    
                    // Monitor iframe creation
                    const originalCreateElement = document.createElement;
                    document.createElement = function(tagName) {
                        const element = originalCreateElement.apply(this, arguments);
                        if (tagName.toLowerCase() === 'iframe') {
                            const originalSetAttribute = element.setAttribute;
                            element.setAttribute = function(name, value) {
                                if (name === 'src') {
                                    console.log('🖼️ IFRAME CREATED:', {
                                        src: value
                                    });
                                }
                                return originalSetAttribute.apply(this, arguments);
                            };
                        }
                        return element;
                    };
                    
                    console.log('🔧 API debugging setup complete');
                    
                    // Now load the SDK
                    const script = document.createElement('script');
                    script.src = 'https://cdn.jsdelivr.net/gh/root-credit/root-pay-js-sdk@latest/rootpay.min.js';
                    script.onload = function() {
                        console.log('✅ RootPay SDK loaded successfully!');
                        initializeApp();
                    };
                    script.onerror = function() {
                        console.error('❌ Failed to load RootPay SDK');
                        document.getElementById('sdk-loading').innerHTML = '<p style="color: red;">Failed to load payment system</p>';
                    };
                    document.head.appendChild(script);
                })();
                
                // Application state
                const state = {
                    rootpay: null,
                    sdkReady: false,
                    userType: 'payee',
                    fields: {
                        cardNumber: null,
                        cardExpiry: null,
                        confirmCardNumber: null,
                        accountNumber: null,
                        routingNumber: null,
                        confirmAccountNumber: null
                    },
                    paymentType: 'card',
                    validation: {
                        cardNumber: false,
                        cardExpiry: false,
                        confirmCardNumber: false,
                        accountNumber: false,
                        routingNumber: false,
                        confirmAccountNumber: false
                    },
                    submitInProgress: false,
                    validationTimeout: null
                };
                
                // Initialize app after SDK loads
                function initializeApp() {
                    console.log('🚀 Initializing application...');
                    console.log('SDK availability:', typeof RootPay !== 'undefined' ? 'Available' : 'Not Available');
                    
                    state.sdkReady = true;
                    
                    // Hide loading and show setup form
                    document.getElementById('sdk-loading').classList.add('hidden');
                    document.getElementById('setup-form').classList.remove('hidden');

                    // Ensure button is initially disabled
                    updateSubmitButtonState();
                    
                    // Set up event listeners
                    document.getElementById('initialize-btn').addEventListener('click', initializeRootPay);
                    document.getElementById('submit-btn').addEventListener('click', submitPaymentInfo);
                    document.getElementById('get-methods-btn').addEventListener('click', loadPaymentMethods);
                    document.getElementById('return-btn').addEventListener('click', function() {
                        window.webkit.messageHandlers.returnToApp.postMessage('return');
                    });
                    
                    // Payment type selection
                    document.querySelectorAll('input[name="payment-type"]').forEach(radio => {
                        radio.addEventListener('change', function(e) {
                            state.paymentType = e.target.value;
                            
                            if (state.paymentType === 'card') {
                                document.getElementById('card-fields').classList.remove('hidden');
                                document.getElementById('bank-fields').classList.add('hidden');
                                createCardFields();
                            } else {
                                document.getElementById('card-fields').classList.add('hidden');
                                document.getElementById('bank-fields').classList.remove('hidden');
                                createBankFields();
                            }
                            
                            updateSubmitButtonState();
                        });
                    });
                    
                    // User type selection
                    document.querySelectorAll('input[name="user-type"]').forEach(radio => {
                        radio.addEventListener('change', function(e) {
                            state.userType = e.target.value;
                            const partyIdInput = document.getElementById('party-id');
                            if (state.userType === 'payee') {
                                partyIdInput.placeholder = 'Enter Payee ID';
                            } else {
                                partyIdInput.placeholder = 'Enter Payer ID';
                            }
                        });
                    });
                    
                    console.log('✅ Application initialized');
                }
                
                // Initialize RootPay with explicit localhost:8000 configuration
                function initializeRootPay() {
                    console.log('🎯 Initializing RootPay...');
                    
                    const token = document.getElementById('token').value.trim();
                    const partyId = document.getElementById('party-id').value.trim();
                    
                    if (!token || !partyId) {
                        showStatus('Please enter valid token and party ID', 'error');
                        return;
                    }
                    
                    const initConfig = {
                        token: token,
                        debug: true
                    };
                    
                    // Set either payee_id or payer_id based on user type
                    if (state.userType === 'payee') {
                        initConfig.payee_id = partyId;
                    } else {
                        initConfig.payer_id = partyId;
                    }
                    
                    initConfig.onSuccess = function(response) {
                        if (state.submitInProgress) {
                            showStatus('Payment method added successfully!', 'success');
                        }
                        console.log('🎉 RootPay success:', response);
                    };
                    
                    initConfig.onError = function(errorMessage, errorDetails) {
                        showStatus('Error: ' + errorMessage, 'error');
                        console.error('❌ RootPay error:', errorMessage, errorDetails);
                    };
                    
                    initConfig.onPaymentMethodsUpdate = function(paymentMethods) {
                        console.log('💳 Payment methods updated:', paymentMethods);
                        displayPaymentMethods(paymentMethods);
                    };
                    
                    console.log('🔧 Configuration:', JSON.stringify(initConfig, null, 2));
                    
                    try {
                        // Initialize with userType as first parameter (v2.0.0)
                        state.rootpay = RootPay.init(state.userType, initConfig);
                        
                        console.log('✅ RootPay initialized with userType:', state.userType);
                        
                        // Create fields and show form
                        createCardFields();
                        document.getElementById('setup-form').classList.add('hidden');
                        document.getElementById('payment-form').classList.remove('hidden');
                        
                    } catch (error) {
                        console.error('💥 RootPay initialization error:', error);
                        showStatus('Failed to initialize: ' + error.message, 'error');
                    }
                }
                
                // Create secure fields
                function createCardFields() {
                    if (!state.rootpay) return;
                    
                    console.log('🔒 Creating secure card fields...');
                    
                    if (!state.fields.cardNumber) {
                        state.fields.cardNumber = state.rootpay.field('#card-number-container', {
                            type: 'card-number',
                            name: 'card-number',
                            style: { fontSize: '18px', fontWeight: '500', color: '#333' },
                            onValidChange: function(isValid) {
                                console.log('🔢 Card number validation changed:', isValid);
                                state.validation.cardNumber = isValid;
                                updateSubmitButtonState();
                            }
                        });
                    }
                    
                    if (!state.fields.confirmCardNumber) {
                        state.fields.confirmCardNumber = state.rootpay.field('#confirm-card-number-container', {
                            type: 'confirm-card-number',
                            name: 'confirm-card-number',
                            style: { fontSize: '18px', fontWeight: '500', color: '#333' },
                            placeholder: 'Re-enter card number',
                            onValidChange: function(isValid) {
                                console.log('✅ Confirm card number validation changed:', isValid);
                                state.validation.confirmCardNumber = isValid;
                                updateSubmitButtonState();
                            }
                        });
                    }
                    
                    if (!state.fields.cardExpiry) {
                        state.fields.cardExpiry = state.rootpay.field('#card-expiry-container', {
                            type: 'card-expiry',
                            name: 'card-expiry',
                            style: { fontSize: '18px', fontWeight: '500', color: '#333' },
                            onValidChange: function(isValid) {
                                console.log('📅 Card expiry validation changed:', isValid);
                                state.validation.cardExpiry = isValid;
                                updateSubmitButtonState();
                            }
                        });
                    }
                }
                
                function createBankFields() {
                    if (!state.rootpay) return;
                    
                    console.log('🏦 Creating secure bank fields...');
                    
                    if (!state.fields.accountNumber) {
                        state.fields.accountNumber = state.rootpay.field('#account-number-container', {
                            type: 'account-number',
                            name: 'account-number',
                            style: { fontSize: '18px', fontWeight: '500', color: '#333' },
                            onValidChange: function(isValid) {
                                console.log('🏦 Account number validation changed:', isValid);
                                state.validation.accountNumber = isValid;
                                updateSubmitButtonState();
                            }
                        });
                    }
                    
                    if (!state.fields.confirmAccountNumber) {
                        state.fields.confirmAccountNumber = state.rootpay.field('#confirm-account-number-container', {
                            type: 'confirm-account-number',
                            name: 'confirm-account-number',
                            style: { fontSize: '18px', fontWeight: '500', color: '#333' },
                            placeholder: 'Re-enter account number',
                            onValidChange: function(isValid) {
                                console.log('✅ Confirm account number validation changed:', isValid);
                                state.validation.confirmAccountNumber = isValid;
                                updateSubmitButtonState();
                            }
                        });
                    }
                    
                    if (!state.fields.routingNumber) {
                        state.fields.routingNumber = state.rootpay.field('#routing-number-container', {
                            type: 'routing-number',
                            name: 'routing-number',
                            style: { fontSize: '18px', fontWeight: '500', color: '#333' },
                            onValidChange: function(isValid) {
                                console.log('🏛️ Routing number validation changed:', isValid);
                                state.validation.routingNumber = isValid;
                                updateSubmitButtonState();
                            }
                        });
                    }
                }
                
                // Submit payment info
                function submitPaymentInfo() {
                    console.log('💳 Submitting payment method...');
                    
                    if (!state.rootpay) {
                        showStatus('RootPay not initialized', 'error');
                        return;
                    }
                    
                    showStatus('Processing...', 'info');
                    state.submitInProgress = true;
                    
                    // Updated callback signature: (error, response) - v2.0.0
                    state.rootpay.submitPaymentMethod(function(error, response) {
                        console.log('📤 Submission result - error:', error, 'response:', response);
                        
                        if (error) {
                            const errorMessage = error.message || 'Unknown error';
                            const statusCode = error.status || 'N/A';
                            showStatus(`Error ${statusCode}: ${errorMessage}`, 'error');
                        } else {
                            showStatus('Payment method added successfully!', 'success');
                            loadPaymentMethods();
                        }
                        
                        state.submitInProgress = false;
                    }, state.paymentType);
                }
                
                // Load payment methods using getPaymentMethods
                function loadPaymentMethods() {
                    console.log('📋 Loading payment methods...');
                    
                    if (!state.rootpay) return;
                    
                    document.getElementById('payment-methods-list').innerHTML = '<p>Loading payment methods...</p>';
                    
                    state.rootpay.getPaymentMethods(function(error, paymentMethods, paginationInfo) {
                        if (error) {
                            showStatus('Error loading payment methods: ' + error, 'error');
                            document.getElementById('payment-methods-list').innerHTML = '<p>Failed to load payment methods.</p>';
                        } else {
                            console.log('✅ Loaded payment methods:', paymentMethods);
                            if (paginationInfo) {
                                console.log('📄 Pagination info:', paginationInfo);
                            }
                            displayPaymentMethods(paymentMethods);
                        }
                    });
                }
                
                // Display payment methods
                function displayPaymentMethods(paymentMethods) {
                    const container = document.getElementById('payment-methods-list');
                    
                    // Handle both array and object with data property
                    let methodsArray = paymentMethods;
                    if (paymentMethods && paymentMethods.data) {
                        methodsArray = paymentMethods.data;
                    }
                    
                    if (!methodsArray || methodsArray.length === 0) {
                        container.innerHTML = '<p>No payment methods available.</p>';
                        return;
                    }
                    
                    let html = '';
                    methodsArray.forEach(method => {
                        let methodDetails = '';
                        let verificationBadge = '';
                        
                        if (method.card_last_four) {
                            const expiry = method.card_expiry_date || '';
                            const expiryMonth = expiry.substring(0, 2);
                            const expiryYear = expiry.substring(2);
                            methodDetails = `<div class="payment-method">
                                <strong>Debit Card</strong> •••• ${method.card_last_four}
                                <br><small>Expires: ${expiryMonth}/${expiryYear}</small>
                            `;
                        } else if (method.account_last_four) {
                            methodDetails = `<div class="payment-method">
                                <strong>Bank Account</strong> •••• ${method.account_last_four}
                                <br><small>Routing: ${method.routing_number}</small>
                            `;
                        }
                        
                        if (method.verification_status) {
                            const statusColor = method.verification_status === 'verified' ? 'green' : 
                                              method.verification_status === 'failed' ? 'red' : 'orange';
                            verificationBadge = `<br><small style="color: ${statusColor}">Status: ${method.verification_status}</small>`;
                        }
                        
                        if (method.is_default) {
                            verificationBadge += '<br><small style="color: blue; font-weight: bold;">Default</small>';
                        }
                        
                        html += methodDetails + verificationBadge + '</div>';
                    });
                    
                    container.innerHTML = html;
                }
                
                // Update submit button state with debouncing and validation stability check
                function updateSubmitButtonState() {
                    // Clear any existing timeout
                    if (state.validationTimeout) {
                        clearTimeout(state.validationTimeout);
                    }
                    
                    // Add a longer delay to handle SDK's internal validation changes
                    state.validationTimeout = setTimeout(function() {
                        let isValid = false;
                        
                        if (state.paymentType === 'card') {
                            isValid = state.validation.cardNumber && state.validation.cardExpiry && state.validation.confirmCardNumber;
                        } else {
                            isValid = state.validation.accountNumber && state.validation.routingNumber && state.validation.confirmAccountNumber;
                        }
                        
                        const submitButton = document.getElementById('submit-btn');
                        
                        // Only change button state if it's different from current state
                        const currentlyDisabled = submitButton.disabled;
                        const shouldBeDisabled = !isValid;
                        
                        if (currentlyDisabled !== shouldBeDisabled) {
                            submitButton.disabled = shouldBeDisabled;
                            submitButton.style.opacity = isValid ? '1' : '0.5';
                            submitButton.style.cursor = isValid ? 'pointer' : 'not-allowed';
                            
                            console.log('Form validation (debounced):', isValid ? 'Valid' : 'Invalid', state.validation);
                            console.log('Button state changed:', currentlyDisabled ? 'was disabled' : 'was enabled', '→', shouldBeDisabled ? 'now disabled' : 'now enabled');
                        }
                        
                        // Add a stability check - verify the state again after a short delay
                        setTimeout(function() {
                            let finalIsValid = false;
                            
                            if (state.paymentType === 'card') {
                                finalIsValid = state.validation.cardNumber && state.validation.cardExpiry && state.validation.confirmCardNumber;
                            } else {
                                finalIsValid = state.validation.accountNumber && state.validation.routingNumber && state.validation.confirmAccountNumber;
                            }
                            
                            if (finalIsValid !== isValid) {
                                console.log('⚠️ Validation state changed during stability check, re-evaluating...');
                                updateSubmitButtonState();
                            }
                        }, 200); // Stability check after 200ms
                        
                    }, 150); // Increased debounce delay to 150ms
                }
                
                // Show status messages
                function showStatus(message, type) {
                    const statusEl = document.getElementById('status-message');
                    statusEl.textContent = message;
                    statusEl.className = `status ${type}`;
                }
            </script>
        </body>
        </html>
        """
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
