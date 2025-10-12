# SCSS Utility Refactoring Guide

## Overview
This guide outlines the systematic approach to replace custom CSS with utility mixins across all SCSS files in the Website directory.

## Utility Mixins Available

### Spacing Utilities
```scss
@include pad($size);        // padding: map.get($spacers, $size)
@include pad-x($size);      // padding-left + padding-right
@include pad-y($size);      // padding-top + padding-bottom
@include mar($size);        // margin: map.get($spacers, $size)
@include mar-x($size);      // margin-left + margin-right
@include mar-y($size);      // margin-top + margin-bottom
@include mar-t($size);      // margin-top
@include mar-b($size);      // margin-bottom
```

### Layout Utilities
```scss
@include d-flex;            // display: flex
@include d-block;           // display: block
@include d-inline-block;    // display: inline-block
@include d-inline-flex;     // display: inline-flex
@include align-items($value);       // align-items: $value
@include justify-content($value);   // justify-content: $value
@include flex-direction($value);    // flex-direction: $value
@include flex-wrap($value);         // flex-wrap: $value
@include flex($value);              // flex: $value
```

### Text Alignment Utilities
```scss
@include text-center;       // text-align: center
@include text-left;         // text-align: left
@include text-right;        // text-align: right
```

### Background Utilities
```scss
@include bg-primary;        // background-color: $primary
@include bg-secondary;      // background-color: $secondary
@include bg-light;          // background-color: $gray-100
@include bg-white;          // background-color: #fff
```

### Position Utilities
```scss
@include position-relative; // position: relative
@include position-absolute; // position: absolute
@include position-fixed;    // position: fixed
```

### Size Utilities
```scss
@include w-100;             // width: 100%
@include h-100;             // height: 100%
```

## Refactoring Pattern

### Before (Custom CSS)
```scss
.my-component {
  padding: 2rem 1rem;
  text-align: center;
  display: flex;
  justify-content: center;
  background-color: $light;
  margin-bottom: 1.5rem;
}
```

### After (Utility Mixins)
```scss
.my-component {
  @include pad-y(4);
  @include pad-x(3);
  @include text-center;
  @include d-flex;
  @include justify-content(center);
  @include bg-light;
  @include mar-b(4);
}
```

## Bootstrap Integration Strategy

1. **Use Bootstrap mixins where available**:
   - `@include make-container()` instead of custom container styles
   - Bootstrap spacing functions for complex spacing
   - Bootstrap breakpoint mixins for responsive design

2. **Create utility mixins for non-available Bootstrap utilities**:
   - Text alignment, flexbox properties, basic layout
   - Simple spacing patterns

3. **Use Bootstrap classes in HTML for complex components**:
   - Navigation components (`.nav`, `.nav-pills`, `.nav-item`)
   - Button components (`.btn`, `.btn-primary`, `.btn-outline-*`)
   - Form components and complex interactive elements

## Files Refactored So Far

✅ `theme.asisaga.com/_sass/base/_utilities.scss` - Added comprehensive utility mixins
✅ `businessinfinity.asisaga.com/_sass/pages/_business-infinity.scss` - Partial refactoring
✅ `www.asisaga.com/_sass/pages/_home.scss` - Partial refactoring  
✅ `www.asisaga.com/_sass/pages/_about.scss` - Comprehensive refactoring
✅ `www.asisaga.com/_sass/pages/_index.scss` - Partial refactoring

## Systematic Refactoring Approach

### Phase 1: Key Page Files (Priority)
- All `pages/*.scss` files in major sites
- Focus on common patterns: padding, margin, text-align, display, flexbox

### Phase 2: Component Files
- All `components/*.scss` files
- More complex layout patterns

### Phase 3: Base and Utility Files
- Ensure all base files use consistent patterns
- Clean up any remaining custom CSS

## Common Patterns to Replace

1. **Spacing**: `padding: X` → `@include pad(size)`
2. **Layout**: `display: flex` → `@include d-flex`
3. **Alignment**: `text-align: center` → `@include text-center`
4. **Flexbox**: `justify-content: center` → `@include justify-content(center)`
5. **Positioning**: `position: relative` → `@include position-relative`
6. **Backgrounds**: `background-color: $light` → `@include bg-light`

## Benefits Achieved

1. **Consistency**: All spacing and layout follows Bootstrap's system
2. **Maintainability**: Changes to spacing/layout system require updating only mixins
3. **Readability**: Intent is clearer with semantic mixin names
4. **Performance**: No CSS bloat from repeated custom properties
5. **Framework Integration**: Better alignment with Bootstrap's philosophy

## Next Steps

1. Continue refactoring remaining page files systematically
2. Update component files using the same patterns
3. Create additional utility mixins as needed for common patterns
4. Remove unused custom CSS properties
5. Validate that all changes maintain visual consistency

## Important Notes

- Always test visual output after refactoring
- Keep Bootstrap variables and mixins available via proper imports
- Maintain responsive design patterns using Bootstrap breakpoint mixins
- Document any custom mixins that don't have Bootstrap equivalents