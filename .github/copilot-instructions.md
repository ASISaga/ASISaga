asisaga.github.io is a static html website.
It is built using bootstrap, so avoid raw css as much as possible. Use cards for code reuse.
It uses Jekyll static site generator, so use liquid templating language, wherever possible. However, don't use Jekyll themes.
The site would be deployed on github pages, so local instalation of Jekyll is not required.
Use /assets/js folder for JavaScript code.



GitHubAgent is a python project.
It uses https://github.com/PyGithub/PyGithub for iteration with GitHub
Documentation of PyGithub https://pygithub.readthedocs.io/en/stable/reference.html
Generate detailed comments.
Use PascalCase for class names.
Use CamelCase for class methods.
Use snake_case for variables.
Use SCREAMING_SNAKE_CASE for constants.

- @azure Rule - Use Azure Best Practices: When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `get_azure_best_practices` tool if available.