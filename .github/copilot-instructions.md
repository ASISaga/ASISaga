### Static html website coding preferences
asisaga.com is a static Jekyll website on GitHub Pages, located in the `Website` folder of this workspace.

#### Website Structure
- asisaga.com has three subdomains: `www`, `realmofagents`, and `businessinfinity`. Each subdomain is implemented as its own submodule within the `Website` folder:
  - `www.asisaga.com`
  - `realmofagents.asisaga.com`
  - `businessinfinity.asisaga.com`
- The Jekyll theme is located in the `common.asisaga.com` submodule. This theme is applied to all subdomains by GitHub Pages at compile time.
- The structure of the website is documented in `website_structure.json`. Keep this file updated for any structural changes made in the website.


#### Jekyll Structure & Components
- Use Jekyll with Liquid templating (no themes required)
- Create reusable UI components in `_includes` folder
- Use {% include %} tag with parameterization: `{% include component.html param="value" %}`
- Use semantic HTML5 elements (header, nav, main, section, etc.) for accessibility and SEO
- Follow component-based architecture: isolated, reusable, maintainable elements
- Break complex UI patterns into smaller, reusable partials
- Preserve required Jekyll Markdown header in style.scss
- JavaScript: Place in `/assets/js` folder
- Each Jekyll UI component in `_includes` must have a matching SCSS partial in `/assets/css/components/`
- Each HTML page must have a matching SCSS file in `/assets/css/pages/` directory
- Each HTML element in a Jekyll UI component or HTML page must have exactly one SCSS class in its respective SCSS file
- **Subdomain site JavaScript loading:** Each subdomain site (`www`, `realmofagents`, `businessinfinity`) includes a `script.js` in its `<head>`, which imports `common.js` from the theme site (`common.asisaga.com/assets/js`). All shared JS (including Bootstrap logic) must be imported via `common.js` for consistency and maintainability across subdomains.
- **Theme merging:** The `_layouts`, `_includes`, `_sass`, and `assets` directories from the `common.asisaga.com` theme are automatically merged into each subdomain site during the Jekyll site build by GitHub Pages. Do not manually copy these folders into subdomains; update or add components, layouts, styles, or assets in the theme and all subdomains will inherit them on the next build.


#### SCSS Structure & Components
- Bootstrap v5.3.5 with dependencies in `assets/css/bootstrap`
- Naming: Use kebab-case for single, descriptive custom classes per element
- Central styling: `/assets/css/style.scss` (imports only, no direct code)
- Preserve required Jekyll Markdown header in style.scss
**Theme SCSS organization:**
  - Common SCSS for the theme is kept in the theme's `_sass` directory, with `_common.scss` as the entry point for shared styles.
  - Each subdomain maintains its own SCSS in its respective `_sass` directory, with `_main.scss` as the entry point for subdomain-specific styles.
  - The theme provides a `style.scss` file in `assets/css`, which is included in the HTML `<head>`.
  - `style.scss` imports `_common.scss` from the theme and `_main.scss` from the respective subdomain, ensuring both shared and subdomain-specific styles are applied.
  - **All SCSS updates must be made in the appropriate `_sass` directory for the theme or subdomain. Do not edit or add SCSS directly in `assets/css` except for the `style.scss` import file.**

##### Organization & Hierarchy
- Name partials with underscore prefix: `_partial-name.scss`
- Organize partials in logical folder hierarchy:
  - `/assets/css/base/`: Core styling (variables, typography, utilities)
  - `/assets/css/components/`: Reusable UI component styles
  - `/assets/css/pages/`: Page-specific layouts
- Required base partials:
  - `_variables.scss`: Define colors, breakpoints, spacing values
  - `_typography.scss`: Font families, sizes, weights, styles
  - `_mixins.scss`: Reusable style patterns and functions
  - `_utilities.scss`: Helper classes that apply single-purpose styling
- Import all partials into `style.scss` in order of dependency
- Group imports by type (base, components, pages) with clear comments
- Import base styles first, then components, then page-specific styles

##### Bootstrap Integration
- Prioritize Bootstrap utilities and components over custom CSS
- Mobile-first: Utilize Bootstrap's responsive grid and utility classes
- Encapsulate Bootstrap inside custom classes in SCSS files
- Customize Bootstrap via SCSS variables rather than overriding styles directly
- Maintain consistent typography and color schemes site-wide
- Follow accessibility guidelines (alt text, ARIA labels, color contrast, etc.)

##### Component & Page Styling
- Each Jekyll UI component must have a matching SCSS partial in `/assets/css/components/`
- Each HTML page must have a matching SCSS file in `/assets/css/pages/` directory
- Nest SCSS classes to match HTML structure hierarchy (applies specifically to page and component SCSS files)
- Use the SCSS parent selector (`&`) appropriately for pseudo-classes and modifier classes
- Limit nesting depth to 3-4 levels to avoid overly specific selectors
- Structure component and page-specific SCSS files to visually represent the DOM hierarchy
- Page-specific and component-specific SCSS should only include or extend Bootstrap code or custom partials, not contain direct CSS property definitions
- Use `@extend`, `@include`, or Bootstrap utility classes within component and page SCSS files rather than writing custom property declarations

##### Best Practices
- Keep partials focused on a single concern or component
- Add descriptive comments in SCSS and HTML
- Update Static Website section of 'copiot-instructions.md' file w.r.t. improvements to these instructions after each run of copilot agent.





### Python Coding Preferences
- Generate detailed comments.
- Use PascalCase for class names.
- Use CamelCase for class methods.
- Use snake_case for variables.
- Use SCREAMING_SNAKE_CASE for constants.

GitHubAgent is a python project.
It uses https://github.com/PyGithub/PyGithub for iteration with GitHub
Documentation of PyGithub https://pygithub.readthedocs.io/en/stable/reference.html

- @azure Rule - Use Azure Best Practices: When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `azure_development-get_best_practices` tool if available.