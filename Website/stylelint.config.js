module.exports = {
  extends: ["stylelint-config-recommended-scss"],
  plugins: ["stylelint-scss"],
  rules: {
    "scss/at-rule-no-unknown": true,              // catch mistyped mixins, functions
    "scss/dollar-variable-colon-space-after": "always",
    "no-empty-source": true
  }
};