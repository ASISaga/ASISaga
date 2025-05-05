asisaga.github.io is a static html website.
- It uses Jekyll static site generator, so use liquid templating language, wherever possible. However, don't use Jekyll themes.
- The site would be deployed on github pages, so local instalation of Jekyll is not required.
- Use /assets/js folder for JavaScript code.
- Use /assets/css/style.scss for centralized styling of website, and create specific scss per page of website.
- Markdown code is required at the begining of style.scss for Jekyll. Don't delete it.
- Define custom classes in page specific scss, and use only one custom class, with meaningul name, in any html element.
- The website uses bootstrap version 5.3.5.
- bootstrap.scss dependencies are in assets/css/bootstrap folder
- Enacapsulate all bootstrap code inside the custom classes in style.scss.
- Define a consistent font family, size, and color scheme in style.scss for use across the website.
- Ensure all pages are mobile-friendly by using Bootstrap's grid system and responsive utilities, by putting relevant code in classes defined in style.scss.
- Use Bootstrap spacing utilities (e.g., mb-4, p-3) in style.scss to maintain consistent margins and padding.
- Use Bootstrap's typography utilities for headings, paragraphs, and text alignment in style.scss for consistent typography.
- Use presuilt Bootstrap css classes, utility classes, spacing utilities, components like buttons, cards, modals, and navigation bars for code reuse. Avoid custom CSS wherever possible.
- Use Bootstrap theme customization options in style.scss, only if required, for unified color scheme, and apply these colors consistently across buttons, links, and backgrounds in classes defined in style.scss.


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