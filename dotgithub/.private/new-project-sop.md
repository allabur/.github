# New Project SOP

Copyright © Alberto Lacort All rights reserved.

Last Updated: 2025-08-26 at 1:49 pm

Follow these steps whenever you start a new development project. This will allow you to have a consistent workflow for all the projects you work on, saving you lots of time in the long run.

## Workflow

1. Create main project folder based on template `project-template` → `1_projects/client-project-description`
2. Clone the repository to your local repository folder
3. Open it in your IDE of choice and save it into a project (e.g., VS Code workspace file)
4. Add all the relevant information to the repository (e.g., data, API keys, docs)
5.  Create a new environment with Conda and install dependencies (optional)
6.  Create a new project in project management tool (e.g., ClickUp, Linear, Jira, Trello)
7.  Configure your project and add any automations and/or GitHub integrations
8.  Fill the board with your initial features and add clarification where needed
9.  Add team members to the repositories and kanban boards (optional)
10. Create a Slack communication channel for collaboration (optional). Channel name: `client-project-name`
11. To start working on features:
    - Copy the branch name from your Kanban board (e.g. Linear)
    - Check out the new branch
    - Complete the feature
    - Push all the changes to your main branch
    - Create a PR (Pull Request) to your main branch to merge everything
    - Ensure there are no conflicts and merge the request, completing the feature. 
    - Finally, delete both the local and remote branch to clean everything up. 
    - Now you can continue with the next feature, following a similar workflow.
