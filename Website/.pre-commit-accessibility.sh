#!/bin/bash

# Pre-commit hook for Accessibility-First Development
# This script runs before each commit to catch accessibility and layout issues

echo "🛡️  Running Accessibility-First Pre-commit Checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if any checks fail
FAILED=0

# 1. Check for common accessibility violations in HTML
echo "🔍 Checking HTML for accessibility violations..."
if grep -r "text-shadow" . --include="*.scss" --include="*.css" --exclude-dir=node_modules --exclude-dir=.git; then
    echo -e "${RED}❌ FORBIDDEN: text-shadow found (causes contrast issues)${NC}"
    FAILED=1
fi

if grep -r "@extend" . --include="*.scss" --exclude-dir=node_modules --exclude-dir=.git; then
    echo -e "${RED}❌ FORBIDDEN: @extend found (causes Jekyll build errors)${NC}"
    FAILED=1
fi

if grep -r "outline: none" . --include="*.scss" --include="*.css" --exclude-dir=node_modules --exclude-dir=.git; then
    echo -e "${RED}❌ FORBIDDEN: outline: none found (accessibility violation)${NC}"
    FAILED=1
fi

# 2. Check for missing alt attributes
echo "🖼️  Checking for missing alt attributes..."
if grep -r "<img" . --include="*.html" --exclude-dir=node_modules --exclude-dir=.git | grep -v "alt="; then
    echo -e "${RED}❌ MISSING: Images without alt attributes found${NC}"
    FAILED=1
fi

# 3. Check for nested landmarks
echo "🏗️  Checking for nested landmark elements..."
if grep -r "<header.*<header\|<footer.*<footer\|<main.*<main\|<nav.*<nav" . --include="*.html" --exclude-dir=node_modules --exclude-dir=.git; then
    echo -e "${RED}❌ FORBIDDEN: Nested landmark elements found${NC}"
    FAILED=1
fi

# 4. Check for missing ARIA labels on duplicate landmarks
echo "🏷️  Checking for ARIA labels on landmarks..."
if grep -r '<header\|<footer' . --include="*.html" --exclude-dir=node_modules --exclude-dir=.git | grep -v 'aria-label='; then
    echo -e "${YELLOW}⚠️  WARNING: Landmark elements should have aria-label attributes${NC}"
fi

# 5. Check for low opacity text (accessibility issue)
echo "🎨 Checking for low opacity text..."
if grep -r "opacity: 0\.[0-8]" . --include="*.scss" --include="*.css" --exclude-dir=node_modules --exclude-dir=.git; then
    echo -e "${RED}❌ FORBIDDEN: Text with opacity < 0.9 found (contrast violation)${NC}"
    FAILED=1
fi

# 6. Run Stylelint
echo "🎨 Running Stylelint..."
if ! npm run lint:css; then
    echo -e "${RED}❌ Stylelint found issues${NC}"
    FAILED=1
fi

# 7. Run HTMLHint if available
if command -v htmlhint &> /dev/null; then
    echo "📝 Running HTMLHint..."
    if ! npm run lint:html; then
        echo -e "${RED}❌ HTMLHint found issues${NC}"
        FAILED=1
    fi
fi

# 8. Check for minimum button/touch target sizes
echo "👆 Checking for minimum touch target sizes..."
if grep -r "height:.*[1-3][0-9]px\|width:.*[1-3][0-9]px" . --include="*.scss" --include="*.css" --exclude-dir=node_modules --exclude-dir=.git; then
    echo -e "${YELLOW}⚠️  WARNING: Small elements found (may not meet 44px touch target minimum)${NC}"
fi

# Results
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All accessibility checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Accessibility checks failed. Please fix the issues above before committing.${NC}"
    echo -e "${YELLOW}💡 Tip: Use the templates in .accessibility-templates.html${NC}"
    exit 1
fi