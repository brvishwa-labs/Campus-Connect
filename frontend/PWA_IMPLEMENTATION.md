# Progressive Web App (PWA) Implementation

This document describes the PWA implementation for Campus Connect.

## Features

- **Standalone Mode**: When installed on mobile devices, the app opens in fullscreen mode without the browser URL bar
- **Install Prompt**: Users can install the app directly from the browser
- **Offline Support**: Service worker caches key resources for offline functionality
- **Native-like Experience**: Configured as a standalone app with custom theme colors

## Files Modified/Created

### Created Files:
1. **`public/manifest.json`**: PWA manifest configuration
   - Defines app name, icons, and display mode (standalone)
   - Sets theme colors and orientation

2. **`public/sw.js`**: Service worker for caching and offline support
   - Caches essential resources on install
   - Serves cached content when offline
   - Cleans up old caches on activation

3. **`src/components/PWAInstallPrompt.jsx`**: Install prompt component
   - Shows install button when app is installable
   - Handles install prompt logic
   - Can be dismissed by user

### Modified Files:
1. **`index.html`**: Added PWA meta tags and manifest link
   - Theme color meta tag
   - Apple mobile web app tags
   - Manifest link reference

2. **`src/main.jsx`**: Service worker registration
   - Registers service worker on app load
   - Logs registration status

3. **`src/App.jsx`**: Added PWA install prompt component
   - Renders install prompt at app root level

## How It Works

### Installation Flow:
1. User visits the app in a supported browser
2. Browser detects PWA capability (manifest + service worker)
3. Install prompt appears at bottom of screen
4. User clicks "Install" to add app to home screen
5. App opens in standalone mode (fullscreen, no URL bar)

### Mobile Experience:
- **Before Install**: Opens in browser with URL bar
- **After Install**: Opens as standalone app, fullscreen without browser chrome
- **Works like**: A native mobile application

### Desktop Experience:
- Can also be installed on desktop browsers (Chrome, Edge, etc.)
- Opens in its own window
- Appears in app launcher/dock

## Testing

### Mobile (Android/iOS):
1. Open the app in Chrome/Safari
2. Wait for install prompt to appear
3. Click "Install" button
4. Find app icon on home screen
5. Open app - should launch in fullscreen mode

### Desktop:
1. Open the app in Chrome/Edge
2. Look for install icon in address bar
3. Click to install
4. App opens in standalone window

## Browser Support

- ✅ Chrome (Android/Desktop)
- ✅ Edge (Desktop)
- ✅ Safari (iOS 11.3+)
- ✅ Firefox (Android)
- ⚠️ Safari (Desktop) - Limited support

## Configuration

### Manifest (`public/manifest.json`)
- `display: "standalone"` - Opens without browser UI
- `theme_color` - Sets status bar color on mobile
- `background_color` - Splash screen background
- `orientation: "portrait"` - Locks to portrait mode on mobile

### Service Worker (`public/sw.js`)
- Caches specified URLs on install
- Serves from cache first, then network
- Updates cache on new service worker activation

## Future Enhancements

- Push notifications
- Background sync
- More comprehensive offline functionality
- Custom splash screen images
- App shortcuts

## Notes

- Service worker only works over HTTPS (or localhost)
- Manifest must be served with correct MIME type
- Icons should be provided in multiple sizes for best experience
- Users can uninstall PWA like any native app
