# 🛡️ Accessibility-First Development Guide

## Overview
This guide implements a comprehensive proactive quality assurance system that prevents accessibility, layout, and responsiveness issues during development rather than discovering them in tests.

## 🚫 FORBIDDEN PATTERNS (Will Break Builds/Accessibility)

### Jekyll/SCSS Issues
- ❌ `@extend` in SCSS files (causes Jekyll build errors)
- ❌ `text-shadow` property (causes contrast violations)
- ❌ `opacity < 0.9` for text (WCAG violation)
- ❌ `outline: none` without replacement focus indicator

### HTML Structure Issues
- ❌ Nested landmark elements (`<header>` inside `<header>`)
- ❌ Multiple `main`, `banner`, or `contentinfo` landmarks
- ❌ Interactive elements smaller than 44px
- ❌ Images without `alt` attributes
- ❌ Form inputs without labels

### Color/Contrast Issues
- ❌ `rgba()` with alpha < 0.9 for text
- ❌ Light text on light backgrounds
- ❌ Dark text on dark backgrounds

## ✅ REQUIRED PATTERNS

### Every HTML Page Must Have:
```html
<!-- Skip navigation (first element) -->
<a href="#skip-target" class="sr-only focus-visible">Skip to main content</a>

<!-- Single landmark structure -->
<header role="banner" aria-label="Site header">...</header>
<main id="skip-target" role="main">...</main>
<footer role="contentinfo" aria-label="Site footer">...</footer>
```

### Every SCSS Component Must Have:
```scss
.component-name {
  // Mandatory containment for layout stability
  contain: layout style;
  isolation: isolate;
  
  // Interactive elements need minimum touch targets
  min-height: 44px;
  min-width: 44px;
  
  // Focus indicators required
  &:focus {
    outline: 3px solid #0066cc;
    outline-offset: 2px;
  }
}
```

### Every Interactive Element Must Have:
- Minimum 44px touch targets
- Focus indicators
- Proper ARIA labels
- High contrast colors (4.5:1 ratio minimum)

## 🔧 Development Tools Setup

### 1. Install Dependencies
```bash
cd /path/to/ASISaga/Website
npm install
```

### 2. Enable Pre-commit Hooks
```bash
chmod +x .pre-commit-accessibility.sh
```

### 3. Run Validation During Development
```bash
# Check CSS/SCSS
npm run lint:css

# Check HTML
npm run lint:html

# Full accessibility check
npm run test:accessibility
```

## 🎯 Real-time Validation

### VS Code Extensions (Auto-installed)
- **Axe Accessibility Linter** - Real-time accessibility scanning
- **Stylelint** - SCSS/CSS validation with accessibility rules
- **HTMLHint** - HTML validation with accessibility checks
- **Color Info** - Color contrast checking

### Live Validation Rules
- Stylelint prevents forbidden CSS patterns
- HTMLHint catches missing alt attributes and labels
- Axe-core identifies accessibility violations
- Custom rules block dangerous opacity values

## 📋 Development Checklist

### Before Writing Code:
- [ ] Review `.accessibility-templates.html` for patterns
- [ ] Check `.scss-guidelines.scss` for SCSS patterns
- [ ] Enable Stylelint and HTMLHint in VS Code

### Before Committing:
- [ ] Run `npm run dev:validate`
- [ ] Check no forbidden patterns exist
- [ ] Verify all interactive elements have focus indicators
- [ ] Confirm color contrast meets WCAG AA (4.5:1)

### Before Deploying:
- [ ] Run full test suite
- [ ] Check Lighthouse accessibility score (95%+)
- [ ] Verify responsive behavior at 375px, 768px, 1440px

## 🚨 Common Issues & Solutions

### Issue: Jekyll Build Fails with "@extend not found"
**Solution:** Replace `@extend .class-name` with actual CSS properties:
```scss
// ❌ Wrong
.my-class {
  @extend .layout-container;
}

// ✅ Correct
.my-class {
  contain: layout style;
  isolation: isolate;
}
```

### Issue: Color Contrast Failures
**Solution:** Use high-contrast color variables:
```scss
// ❌ Wrong
color: rgba(255, 255, 255, 0.7);

// ✅ Correct
color: rgba(255, 255, 255, 0.95);
```

### Issue: Element Overlap
**Solution:** Add CSS containment:
```scss
.container {
  contain: layout style;
  isolation: isolate;
}
```

### Issue: Touch Targets Too Small
**Solution:** Ensure minimum sizes:
```scss
.button {
  min-height: 44px;
  min-width: 44px;
  padding: 0.75rem 1.5rem;
}
```

## 🎨 Color System

Use only these WCAG AA compliant colors:
```scss
$text-primary: #212529;        // Dark text on light backgrounds
$text-light: #ffffff;          // Light text on dark backgrounds
$text-secondary: #495057;      // Medium contrast (4.5:1+)
$text-muted: rgba(33, 37, 41, 0.95); // Accessible muted text
```

## 📱 Responsive Requirements

Test all breakpoints:
- **Mobile:** 375px width minimum
- **Tablet:** 768px width minimum  
- **Desktop:** 1440px width minimum

Ensure:
- No horizontal scrolling
- Touch targets remain 44px+
- Text remains readable (16px+ font size)
- Interactive elements remain accessible

## 🏗️ Architecture Patterns

### Layout Containers
```scss
.layout-container {
  contain: layout style;
  isolation: isolate;
}
```

### Grid Systems
```scss
.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  contain: layout style;
  isolation: isolate;
}
```

### Interactive Elements
```scss
.interactive-element {
  min-height: 44px;
  min-width: 44px;
  
  &:focus {
    outline: 3px solid #0066cc;
    outline-offset: 2px;
  }
  
  &:hover {
    transform: translateY(-1px);
  }
}
```

This system ensures that accessibility, layout, and responsiveness issues are caught and prevented during development, not discovered during testing. 🎯