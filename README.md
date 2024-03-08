# TechieTubbies---Haul-A-Day

## Contribution Guidelines
To prevent unnecessary or incorrect push to the repository, please follow these steps:
1. Create a new issue to track the progress or activities. Assign the issue to yourself. Then Click Submit New Issue.
    - **Issue Title Format: [Trello Card](SubTask)**
  - Example:
  ```View Profile (Display User Prof Pic)```
3. In that issue, create a corresponding branch. Follow the default branch name format, then Click Create Branch.
4. After cloning the development branch, set the git branch to the branch made in Step 2. Then you can do your tasks.
   git checkout 3-view-profile-display-user-prof-pic
5. After finishing your tasks, commit and push to the branch. This will be reflected in the issue you created in Step 1.
6. On the Github Code Tab, you will see a Compare & Create merge request. Click that to Create the Merge Request.
7. Code Reviewer will review the code and then approve the merge request if nothing needs to be revised. 


## For Git:
Things to do before coding:
1. **git clone url** -> if wala pa ka connect sa git repository
2. **git checkout <branch_name>** -> to enter a specific branch *make sure that you are on the correct branch
3. **git fetch** -> gets recent updates sa code from git repository
4. **git pull** -> fetch + merge -> gets the latest version and merges it with your local changes

Things to do after coding:
1. **git add .** -> logs changes made sa code
2. **git status** -> to check if sakto ang na add sa log
3. **git commit -m "message"** -> message: any phrase that summarizes the things added/changed in the code
4. **git push origin <branch_name>** -> pushes or saves changes to the repository branch
