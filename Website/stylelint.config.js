module.exports = {
  extends: [
    "stylelint-config-recommended-scss"
  ],
  plugins: [
    "stylelint-scss",
    "@double-great/stylelint-a11y"
  ],
  ignoreFiles: [
    "**/bootstrap/**",
    "**/tests/**"
  ],
  rules: {
    // Critical Accessibility Rules (MANDATORY)
    "a11y/no-outline-none": true,               // Prevent outline: none without replacement
    "property-disallowed-list": ["text-shadow"], // Block text-shadow (causes contrast issues)

    // Opacity Rules (WCAG Compliance)
    "declaration-property-value-disallowed-list": {
      "opacity": ["/^0\\.[0-8][0-9]*$/"]         // Prevent opacity < 0.9 for text
    },

    // Jekyll Build Prevention
    "at-rule-disallowed-list": ["extend"],       // Block @extend (breaks Jekyll builds)

    // Layout & Containment Support
    "property-no-unknown": [true, {
      ignoreProperties: ["contain", "isolation"]  // Allow CSS containment properties
    }],

    // Basic Quality Rules
    "no-duplicate-selectors": true,
    "declaration-block-no-redundant-longhand-properties": true,
    "selector-pseudo-class-no-unknown": [true, {
      ignorePseudoClasses: ["focus-visible"]     // Allow focus-visible
    }]

    // Disabled rules (too noisy for existing codebase):
    // "a11y/media-prefers-reduced-motion": null,
    // "a11y/selector-pseudo-class-focus": null,  
    // "unit-disallowed-list": null,
    // "scss/no-global-function-names": null
  }
};