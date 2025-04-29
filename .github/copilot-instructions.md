asisaga.github.io is a static html website.
- It uses Jekyll static site generator, so use liquid templating language, wherever possible. However, don't use Jekyll themes.
- The site would be deployed on github pages, so local instalation of Jekyll is not required.
- Use /assets/js folder for JavaScript code.
- Use /assets/css/style.scss for centralized styling of website.
- Define custom classes in style.scss, and use only custom classes, with meaningul names, in html code in all html pages.
- Leverage Bootstrap's utility classes in style.scss to avoid custom CSS wherever possible.
- import Bootstrap css at the end of style.scss, don't use bootstrap.scss
- Define a consistent font family, size, and color scheme in style.scss for use across the website.
- Ensure all pages are mobile-friendly by using Bootstrap's grid system and responsive utilities, by putting relevant code in classes defined in style.scss.
- Use Bootstrap spacing utilities (e.g., mb-4, p-3) in style.scss to maintain consistent margins and padding.
- Use Bootstrap's typography utilities for headings, paragraphs, and text alignment in style.scss for consistent typography.
- Use Bootstrap theme customization options in style.scss for unified color scheme, and apply these colors consistently across buttons, links, and backgrounds in classes defined in style.scss.
- Use Bootstrap cards for code reuse.



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