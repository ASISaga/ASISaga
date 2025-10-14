# Chatroom & Boardroom Refactoring - Migration Guide

## Overview
This document outlines the refactoring of chatroom and boardroom components to create a modular, extensible architecture where boardroom builds on top of chatroom.

## Architecture

### Theme Repository (theme.asisaga.com)
**Generic Chatroom Component** - Reusable base for any chat interface

#### Files Created/Modified:
1. **Web Component**: `assets/js/chatroom-app.js`
   - Custom element: `<chatroom-app>`
   - Features: messaging, typing indicators, connection status, auto-refresh
   - Extensible API for subclassing

2. **Styles**: `_sass/components/_chatroom.scss`
   - Base chatroom styles
   - Header, messages, input areas
   - Responsive design
   - Accessibility features

3. **Layout**: `_layouts/chatroom.html`
   - Integrates with `layout: fixed-height`
   - Uses web component with Jekyll liquid attributes

4. **Includes** (refactored to accept parameters):
   - `_includes/chatroom/header.html` - Parameterized header
   - `_includes/chatroom/messages.html` - Message area
   - `_includes/chatroom/input.html` - Parameterized input with toolbar support
   - `_includes/chatroom/template.html` - Complete template structure

5. **SCSS Integration**: Added to `_sass/_common.scss`

### Business Infinity Repository (businessinfinity.asisaga.com)
**Boardroom Component** - Extends chatroom for business features

#### Files Created:
1. **Web Component**: `assets/js/boardroom-app-new.js`
   - Custom element: `<boardroom-app>`
   - Extends `ChatroomApp` class
   - Features: agent profiles, screen share, video call, file attachments

2. **Styles**: `_sass/components/_boardroom-new.scss`
   - Imports chatroom styles
   - Adds boardroom-specific features
   - Agent list, profiles, loading overlays, toasts

3. **Layout**: `boardroom/index-new.html`
   - Uses `<boardroom-app>` web component
   - Integrates chatroom includes with boardroom features
   - Multi-pane layout (toggle strip, members sidebar, chat area)

4. **SCSS Integration**: Added to `_sass/_main.scss`

## Key Features

### Chatroom (Generic Base)
- ✅ Message sending/receiving
- ✅ Connection status indicator
- ✅ Typing indicator
- ✅ Character count
- ✅ Auto-refresh messages
- ✅ Customizable header
- ✅ Toolbar support
- ✅ Avatar display
- ✅ Responsive design
- ✅ Accessibility (ARIA labels)

### Boardroom (Business Extension)
- ✅ All chatroom features
- ✅ Agent list and profiles
- ✅ Toggle strip for view switching
- ✅ Members sidebar with search
- ✅ Screen share button
- ✅ Video call button
- ✅ File attachment
- ✅ Text formatting toolbar
- ✅ Loading overlays
- ✅ Toast notifications
- ✅ Emoji picker
- ✅ Voice messages

## Integration Points

### Chatroom → Boardroom Extension
```javascript
// Boardroom extends Chatroom
import ChatroomApp from '../../../theme.asisaga.com/assets/js/chatroom-app.js';

class BoardroomApp extends ChatroomApp {
  constructor() {
    super(); // Inherits all chatroom functionality
    // Add boardroom-specific config
  }
}
```

### SCSS Extension
```scss
// Boardroom imports and extends chatroom styles
@import '../../theme.asisaga.com/sass/components/chatroom';

.boardroom-chat-area {
  // Extends .chatroom-layout
}
```

### Layout Integration
Both integrate with the theme's layout hierarchy:
```
layout: default
  └─ layout: fixed-height
      └─ layout: chatroom (theme)
          └─ <chatroom-app> web component

layout: app (businessinfinity)
  └─ boardroom/index-new.html
      └─ <boardroom-app> web component (extends chatroom)
```

## Web Component Attributes

### Chatroom Attributes
```html
<chatroom-app
  title="Chat Title"
  participants="5"
  show-avatar
  avatar-url="/path/to/avatar.png"
  placeholder="Type a message..."
  max-length="1000"
  show-toolbar
  show-typing-indicator
  show-connection-status
  api-endpoint="/api/chat"
  auto-refresh
  refresh-interval="3000"
>
```

### Boardroom Attributes (includes all chatroom attributes)
```html
<boardroom-app
  show-toggle-strip
  show-members-sidebar
  show-agent-profiles
  enable-screen-share
  enable-video-call
  enable-file-attach
  enable-formatting
  api-base="/api/boardroom"
>
```

## Events API

### Chatroom Events
- `chatroom-ready` - Component initialized
- `chatroom-send-message` - Message sent
- `chatroom-status-change` - Connection status changed
- `chatroom-typing` - User typing
- `chatroom-error` - Error occurred
- `chatroom-disconnected` - Component disconnected

### Boardroom Events (includes all chatroom events)
- `boardroom-ready` - Boardroom initialized
- `boardroom-agent-selected` - Agent selected
- `boardroom-view-change` - View toggled
- `boardroom-screen-share` - Screen share initiated
- `boardroom-video-call` - Video call initiated
- `boardroom-disconnected` - Boardroom disconnected

## Migration Path

### Current State
- Multiple boardroom implementations:
  - `boardroom/index.html` (Jekyll includes)
  - `boardroom2/index.html` (minimal web component)
  - `assets/js/boardroom/BoardroomApp.js` (old implementation)
  - `assets/js/boardroom-app.js` (another implementation)

### New State
- Single unified implementation:
  - `boardroom/index-new.html` (unified layout)
  - `assets/js/boardroom-app-new.js` (extends chatroom)

### Deprecation Plan
After successful deployment and testing:
1. Rename `boardroom/index-new.html` → `boardroom/index.html`
2. Rename `assets/js/boardroom-app-new.js` → `assets/js/boardroom-app.js`
3. Delete old implementations:
   - `boardroom2/` directory
   - `assets/js/boardroom/BoardroomApp.js` (if not used elsewhere)
   - Old SCSS files in `_sass/components/boardroom/` (keep only necessary ones)

## Testing Checklist

### Before Deployment
- [ ] Verify chatroom SCSS compiles without errors
- [ ] Verify boardroom SCSS compiles without errors
- [ ] Check Jekyll liquid syntax in includes
- [ ] Validate web component HTML structure
- [ ] Review JavaScript for syntax errors

### After Deployment
- [ ] Test chatroom layout on ASI Saga website
- [ ] Test boardroom on businessinfinity.asisaga.com
- [ ] Verify responsive design on mobile
- [ ] Test all interactive features (send message, attach file, etc.)
- [ ] Check accessibility with screen readers
- [ ] Verify events fire correctly
- [ ] Test agent selection and profile loading
- [ ] Verify API integration (if backend is ready)

## Deployment Steps

1. **Commit Changes**
   ```bash
   git add .
   git commit -m "Refactor: Create chatroom base component and extend for boardroom"
   ```

2. **Push to Repository**
   ```bash
   git push origin main
   ```

3. **GitHub Pages Build**
   - GitHub Pages will automatically build both sites
   - Monitor build status in repository Actions tab
   - Check for any Jekyll build errors

4. **Verification**
   - Visit theme.asisaga.com (if using chatroom layout)
   - Visit businessinfinity.asisaga.com/boardroom/index-new.html
   - Test all features

5. **Playwright Testing** (after deployment confirmation)
   - Run automated tests on deployed sites
   - Fix any issues found
   - Re-deploy if necessary

## Rollback Plan
If issues are encountered:
1. Revert to previous commit: `git revert HEAD`
2. Push revert: `git push origin main`
3. GitHub Pages will rebuild with previous version
4. Investigate and fix issues offline
5. Re-attempt deployment

## Benefits of New Architecture

1. **DRY (Don't Repeat Yourself)**
   - Chatroom code is written once, reused everywhere
   - Boardroom only contains business-specific logic

2. **Maintainability**
   - Updates to base chatroom features propagate automatically
   - Clear separation of concerns

3. **Extensibility**
   - Easy to create new chat variants (support chat, team chat, etc.)
   - Inheritance model makes customization straightforward

4. **Performance**
   - Single JavaScript file for chatroom
   - Boardroom adds minimal overhead

5. **Consistency**
   - Same UX patterns across all chat interfaces
   - Unified styling from theme

## Notes
- The import path in boardroom-app-new.js assumes a relative path structure
- May need adjustment based on actual deployment structure
- Consider using a module bundler if import paths become complex
- API endpoints are placeholders - update with actual backend URLs

## Next Steps
1. ✅ Get deployment confirmation from user
2. Deploy to GitHub Pages
3. Test with Playwright
4. Monitor for errors
5. Clean up deprecated files
6. Update documentation

---
Created: 2025-10-14
Last Updated: 2025-10-14
Status: Ready for Deployment Review
