# Comprehensive Git Workflow Guide: Commands and Scenarios

## Table of Contents
1. [Essential Git Commands](#essential-git-commands)
2. [Basic Workflow](#basic-workflow)
3. [Working with Branches](#working-with-branches)
4. [Collaboration Strategies](#collaboration-strategies)
5. [Using Git Worktree](#using-git-worktree)
6. [Mastering Git Stash](#mastering-git-stash)
7. [Managing Multiple Commits](#managing-multiple-commits)
8. [Advanced Scenarios](#advanced-scenarios)
9. [Git Configuration](#git-configuration)
10. [Git Aliases](#git-aliases)
11. [Advanced Git Topics](#advanced-git-topics)
      - [Git Hooks](#git-hooks)
      - [Git Bisect](#git-bisect)
      - [Git Submodules](#git-submodules)
      - [Git Large File Storage (LFS)](#git-large-file-storage-lfs)
      - [Git Flow](#git-flow)
      - [Advanced Merge Conflict Resolution](#advanced-merge-conflict-resolution)
      - [Git Reflog](#git-reflog)
      - [Advanced Git Log](#advanced-git-log)


## Essential Git Commands

Here are some essential Git commands, their explanations, and scenarios where they are commonly used. We'll consider the standard branches: feature/sbx, release, and master.

1. `git clone <repository-url>`
   - Explanation: Creates a copy of a remote repository on your local machine.
   - Scenario: When you're starting to work on a new project or joining a team.
   ```
   git clone https://github.com/company/project.git
   ```

2. `git branch`
   - Explanation: Lists all local branches in the current repository.
   - Scenario: When you want to see what branches exist locally.
   ```
   git branch
   ```

3. `git checkout -b feature/sbx/<feature-name>`
   - Explanation: Creates and switches to a new feature branch based on the current branch.
   - Scenario: When you're starting work on a new feature.
   ```
   git checkout -b feature/sbx/user-authentication
   ```

4. `git add <file>` or `git add .`
   - Explanation: Stages changes for commit. `.` stages all changes.
   - Scenario: After making changes and before committing.
   ```
   git add src/auth/login.js
   ```

5. `git commit -m "<message>"`
   - Explanation: Records the staged changes with a descriptive message.
   - Scenario: After staging changes, to create a commit.
   ```
   git commit -m "Implement user login functionality"
   ```

6. `git push origin feature/sbx/<feature-name>`
   - Explanation: Uploads local branch commits to the remote repository.
   - Scenario: When you want to share your changes with the team.
   ```
   git push origin feature/sbx/user-authentication
   ```

7. `git pull origin master`
   - Explanation: Fetches changes from the remote master branch and merges them into the current branch.
   - Scenario: To update your local branch with the latest changes from master.
   ```
   git pull origin master
   ```

8. `git merge feature/sbx/<feature-name>`
   - Explanation: Combines the specified branch into the current branch.
   - Scenario: When merging a completed feature into the release branch.
   ```
   git checkout release
   git merge feature/sbx/user-authentication
   ```

9. `git rebase master`
   - Explanation: Reapplies commits from the current branch on top of the master branch.
   - Scenario: To incorporate the latest changes from master and maintain a linear history.
   ```
   git checkout feature/sbx/user-authentication
   git rebase master
   ```

10. `git cherry-pick <commit-hash>`
    - Explanation: Applies the changes from a specific commit to the current branch.
    - Scenario: When you want to bring a specific fix from one branch to another.
    ```
    git cherry-pick abc1234
    ```

11. `git reset --hard <commit-hash>`
    - Explanation: Moves the current branch to a specific commit, discarding all changes after that commit.
    - Scenario: When you want to completely undo commits and start over from a specific point.
    ```
    git reset --hard HEAD~3
    ```

12. `git revert <commit-hash>`
    - Explanation: Creates a new commit that undoes the changes made in a specific commit.
    - Scenario: When you want to undo a commit but keep the undo action in the history.
    ```
    git revert abc1234
    ```

13. `git tag -a v1.0 -m "Version 1.0 release"`
    - Explanation: Creates an annotated tag at the current commit.
    - Scenario: When marking a specific point in history, usually for a release.
    ```
    git tag -a v1.0 -m "Version 1.0 release"
    git push origin v1.0
    ```

14. `git log --oneline --graph --all`
    - Explanation: Displays a compact log of all commits with a graph of branches.
    - Scenario: When you want to visualize the project history and branch structure.
    ```
    git log --oneline --graph --all
    ```

15. `git diff feature/sbx/<feature-name> master`
    - Explanation: Shows the differences between two branches.
    - Scenario: When you want to see what changes your feature branch will introduce to master.
    ```
    git diff feature/sbx/user-authentication master
    ```

## Basic Workflow

### Scenario: Daily development routine

1. Update your local main branch:
   ```
   git checkout main
   git pull origin main
   ```

2. Create a new feature branch:
   ```
   git checkout -b feature/new-feature
   ```

3. Make changes, stage, and commit:
   ```
   git add .
   git commit -m "Implement new feature"
   ```

4. Push your branch to remote:
   ```
   git push -u origin feature/new-feature
   ```

5. Create a pull request on your Git hosting platform (e.g., GitHub, GitLab)

## Working with Branches

### Scenario: Switching between multiple features

1. List all branches:
   ```
   git branch -a
   ```

2. Switch to another branch:
   ```
   git checkout feature/another-feature
   ```

3. Create and switch to a new branch based on main:
   ```
   git checkout -b feature/new-idea main
   ```

### Scenario: Cleaning up old branches

1. Delete a local branch:
   ```
   git branch -d feature/old-feature
   ```

2. Delete a remote branch:
   ```
   git push origin --delete feature/old-feature
   ```

3. Prune deleted remote branches:
   ```
   git fetch --prune
   ```

## Collaboration Strategies

### Scenario: Merge conflicts

1. Update your feature branch with the latest changes from main:
   ```
   git checkout feature/your-feature
   git merge main
   ```

2. If conflicts occur, resolve them manually in your code editor

3. Stage the resolved files:
   ```
   git add .
   ```

4. Complete the merge:
   ```
   git commit
   ```

### Scenario: Rebasing your branch

1. Update your local main branch:
   ```
   git checkout main
   git pull origin main
   ```

2. Rebase your feature branch:
   ```
   git checkout feature/your-feature
   git rebase main
   ```

3. Resolve any conflicts that arise during rebasing

4. Force push your rebased branch (use with caution):
   ```
   git push --force-with-lease origin feature/your-feature
   ```

## Using Git Worktree

### Scenario: Working on multiple features simultaneously

1. Create a new worktree for a feature:
   ```
   git worktree add ../path/to/new-worktree feature/new-feature
   ```

2. Navigate to the new worktree:
   ```
   cd ../path/to/new-worktree
   ```

3. Work on your feature, commit changes as usual

4. Return to the main worktree:
   ```
   cd /path/to/main/worktree
   ```

5. List all worktrees:
   ```
   git worktree list
   ```

6. Remove a worktree when done:
   ```
   git worktree remove ../path/to/new-worktree
   ```

## Mastering Git Stash

### Scenario: Quickly switching tasks

1. Stash your current changes:
   ```
   git stash save "WIP: Description of your changes"
   ```

2. Switch to another branch or task

3. Return to your original task and apply the stash:
   ```
   git stash apply
   ```

4. Or pop the stash (apply and remove from stash list):
   ```
   git stash pop
   ```

5. List all stashes:
   ```
   git stash list
   ```

6. Apply a specific stash:
   ```
   git stash apply stash@{n}
   ```

7. Create a branch from a stash:
   ```
   git stash branch new-branch stash@{n}
   ```

## Managing Multiple Commits

### Scenario: Cleaning up commits before pushing

1. Make your changes and create multiple commits:
   ```
   git commit -m "WIP: Implement feature part 1"
   git commit -m "WIP: Implement feature part 2"
   git commit -m "WIP: Fix bug in part 1"
   ```

2. Start an interactive rebase:
   ```
   git rebase -i HEAD~3
   ```

3. In the interactive rebase editor:
   - Change "pick" to "squash" or "s" for commits you want to combine
   - Reorder commits if necessary
   - Edit commit messages as needed

4. After the rebase, force push your branch (if it's already pushed):
   ```
   git push --force-with-lease origin feature/your-feature
   ```

### Scenario: Keeping your branch up-to-date while working

1. Commit your current changes:
   ```
   git commit -m "WIP: Current progress"
   ```

2. Fetch the latest changes from the remote:
   ```
   git fetch origin
   ```

3. Rebase your branch onto the updated main:
   ```
   git rebase origin/main
   ```

4. Continue working and creating commits

5. When ready to push, squash your WIP commits:
   ```
   git rebase -i origin/main
   ```

6. Push your cleaned-up branch:
   ```
   git push origin feature/your-feature
   ```

## Advanced Scenarios

### Scenario 1: Handling a Hotfix

Imagine you're working on a long-term feature branch, and a critical bug is reported in the production version.

1. Stash your current work:
   ```
   git stash save "WIP: Long-term feature"
   ```

2. Create a hotfix branch from the production branch:
   ```
   git checkout -b hotfix/critical-bug production
   ```

3. Fix the bug and commit:
   ```
   git commit -m "Fix critical bug in login process"
   ```

4. Merge the hotfix into both production and development branches:
   ```
   git checkout production
   git merge hotfix/critical-bug
   git push origin production

   git checkout development
   git merge hotfix/critical-bug
   git push origin development
   ```

5. Delete the hotfix branch:
   ```
   git branch -d hotfix/critical-bug
   ```

6. Return to your feature branch and reapply your work:
   ```
   git checkout feature/long-term
   git stash pop
   ```

7. Rebase your feature branch to include the hotfix:
   ```
   git rebase development
   ```

### Scenario 2: Feature Flags for Parallel Development

When working on a large feature that needs to be merged but not immediately activated:

1. Implement your feature with a feature flag:
   ```python
   if FEATURE_FLAG_ENABLED:
       # New feature code
   else:
       # Old functionality
   ```

2. Commit your changes:
   ```
   git commit -m "Implement new search algorithm behind feature flag"
   ```

3. Create a pull request to merge your feature into the main branch

4. After merging, the feature can be enabled or disabled via configuration

### Scenario 3: Cleaning Up a Messy Feature Branch

Suppose you've been working on a feature branch and have made many small, incremental commits. Now you want to clean it up before merging:

1. Ensure you're on your feature branch:
   ```
   git checkout feature/messy-feature
   ```

2. Start an interactive rebase:
   ```
   git rebase -i main
   ```

3. In the interactive rebase editor, you might see something like:
   ```
   pick abc1234 Initial implementation of feature
   pick def5678 Fix typo in function name
   pick ghi9101 Implement secondary functionality
   pick jkl1121 Add error handling
   pick mno3141 Refactor for performance
   pick pqr5161 Update tests
   ```

4. Modify the file to combine related commits:
   ```
   pick abc1234 Initial implementation of feature
   squash def5678 Fix typo in function name
   pick ghi9101 Implement secondary functionality
   pick jkl1121 Add error handling
   squash mno3141 Refactor for performance
   squash pqr5161 Update tests
   ```

5. Save and close the editor. Git will then prompt you to edit the commit messages for the squashed commits.

6. Force push your cleaned-up branch:
   ```
   git push --force-with-lease origin feature/messy-feature
   ```

### Scenario 4: Collaborative Feature Development

When multiple developers are working on the same feature:

1. Create a feature branch:
   ```
   git checkout -b feature/collaborative-feature main
   ```

2. Developer A makes changes and pushes:
   ```
   git commit -m "Implement user authentication"
   git push origin feature/collaborative-feature
   ```

3. Developer B pulls the latest changes before starting work:
   ```
   git checkout feature/collaborative-feature
   git pull origin feature/collaborative-feature
   ```

4. Developer B makes changes and pushes:
   ```
   git commit -m "Add password reset functionality"
   git push origin feature/collaborative-feature
   ```

5. If conflicts arise, resolve them locally:
   ```
   git pull origin feature/collaborative-feature
   # Resolve conflicts in your editor
   git add .
   git commit -m "Merge and resolve conflicts in user management"
   git push origin feature/collaborative-feature
   ```

6. Once the feature is complete, create a pull request to merge into main

### Scenario 5: Experimenting with Git Worktree

When you need to work on multiple branches simultaneously:

1. Create a new worktree for a feature:
   ```
   git worktree add ../feature-login feature/login
   ```

2. Create another worktree for a different feature:
   ```
   git worktree add ../feature-dashboard feature/dashboard
   ```

3. Navigate between worktrees to work on different features:
   ```
   cd ../feature-login
   # Work on login feature
   git commit -m "Implement login UI"

   cd ../feature-dashboard
   # Work on dashboard feature
   git commit -m "Add user statistics to dashboard"
   ```

4. When finished, remove the worktrees:
   ```
   git worktree remove ../feature-login
   git worktree remove ../feature-dashboard
   ```

### Scenario 6: Using Git Stash for Quick Context Switching

When you need to switch contexts quickly without committing half-done work:

1. Stash your current changes with a descriptive message:
   ```
   git stash save "WIP: Refactoring user model"
   ```

2. Switch to a different branch to work on a urgent task:
   ```
   git checkout -b hotfix/urgent-api-fix main
   # Work on the hotfix
   git commit -m "Fix API response format"
   git push origin hotfix/urgent-api-fix
   ```

3. Return to your original branch:
   ```
   git checkout feature/user-refactor
   ```

4. Reapply your stashed changes:
   ```
   git stash pop
   ```

5. If you have multiple stashes, you can list them:
   ```
   git stash list
   ```

   And apply a specific stash:
   ```
   git stash apply stash@{1}
   ```


## Git Configuration

Setting up Git with your personal information is crucial for proper attribution of your commits. Here are some essential configuration commands:

```bash
# Set your name
git config --global user.name "Your Name"

# Set your email
git config --global user.email "your.email@example.com"

# Set your preferred text editor
git config --global core.editor "vim"  # or "nano", "emacs", etc.

# View your current Git configuration
git config --list
```

You can also create or edit a `.gitconfig` file in your home directory to store these settings. Here's an example of what your `.gitconfig` file might look like:

```ini
[user]
    name = Your Name
    email = your.email@example.com
[core]
    editor = code --wait
```


## Git Aliases

In addition to the aliases you've already defined, here are some more useful Git aliases to consider adding to your `.gitconfig` file:

```ini
[alias]
    # Status
    s = status -s # short status
    st = status # full status
    
    # Commit
    ci = commit -m # commit with message
    cm = commit # commit (opens editor)
    cam = commit -am # add all changes and commit with message
    amend = commit --amend # modify the last commit
    
    # Checkout
    co = checkout
    cod = checkout . --
    
    # Reset
    rh = reset HEAD # unstage files
    unstage = reset HEAD -- # alternative to unstage files
    undo = reset HEAD~1 --mixed # undo last commit, keeping changes
    undo-commit = reset --soft HEAD^ # undo last commit, keep changes staged
    
    # Add
    a = add # stage changes
    aa = add -A # stage all changes
    ap = add -p # add changes in patches
    
    # Clean
    cdf = clean -df # remove untracked files and directories
    
    # Branch
    b = branch # list, create, or delete branches
    ba = branch -a # list all branches (local and remote)
    
    # Pull and Push
    pl = pull
    pr = pull --rebase
    ps = push
    
    # Log
    l = log # show commit logs
    last = log -1 HEAD # show last commit
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit # pretty log graph
    lo = log --oneline --graph --decorate # compact, graphical log
    ls = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate # custom formatted log
    ll = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat # detailed log
    
    # Diff
    d = diff # show changes
    ds = diff --staged # show staged changes
    
    # Stash
    save = stash save # save changes to a new stash
    pop = stash pop # apply the most recent stash and remove it
    st = stash # stash changes
    stp = stash pop # pop stashed changes
    
    # Miscellaneous
    changes = log -p --follow -- # show changes in a file, including past renames
    blame = blame -c # show who changed what in a file
    fp = fetch --all --prune # fetch updates and prune
    remotes = remote -v # show remote repository URLs
    aliases = config --get-regexp alias # list all aliases
    m = merge --no-ff # merge creating a new commit object
    rb = rebase # reapply commits
    rbi = rebase -i # interactive rebase
    cp = cherry-pick # apply changes from specific commits
    wip = commit -am "WIP" # quickly save work in progress
    
    # Find commands
    fb = "!f() { git branch -a --contains $1; }; f" # find branches containing a commit
    ft = "!f() { git describe --always --contains $1; }; f" # find tags containing a commit
    fc = "!f() { git log --pretty=format:'%C(yellow)%h %Cblue%ad %Creset%s%Cgreen [%cn] %Cred%d' --decorate --date=short -S$1; }; f" # find commits by source code
    fm = "!f() { git log --pretty=format:'%C(yellow)%h %Cblue%ad %Creset%s%Cgreen [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f" # find commits by commit message
```

You can add these aliases to your `.gitconfig` file or set them using the `git config` command. Here's how you would use some of these new aliases:

```bash
git s                        # Short status
git st                       # Full status
git ci "Commit message"      # Commit with message
git cm                       # Commit (opens editor)
git cam "Add and commit"     # Add all changes and commit with message
git co main                  # Checkout main branch
git cod                      # Checkout all changes in current directory
git rh                       # Reset HEAD (unstage files)
git unstage                  # Alternative to unstage files
git undo                     # Undo the last commit, keeping changes
git undo-commit              # Undo the last commit, keep changes staged
git a file.txt               # Stage changes in file.txt
git aa                       # Stage all changes
git ap                       # Add changes in patches
git cdf                      # Clean and force remove untracked files and directories
git b                        # List branches
git ba                       # List all branches (including remote)
git pl                       # Pull changes
git pr                       # Pull with rebase
git ps                       # Push changes
git l                        # Show commit logs
git last                     # Show last commit
git lg                       # Show pretty log graph
git lo                       # Show compact, graphical log
git ls                       # List commits with short stats
git ll                       # List commits with detailed stats
git d                        # Show unstaged changes
git ds                       # Show staged changes
git save "WIP: In progress"  # Stash changes with a message
git pop                      # Pop the latest stash
git st                       # Stash changes
git stp                      # Pop stashed changes
git changes file.txt         # Show changes in file.txt over time
git blame file.txt           # Show who changed what in file.txt
git fp                       # Fetch all remotes and prune
git remotes                  # Show all remote URLs
git aliases                  # List all defined aliases
git m feature-branch         # Merge feature-branch with a merge commit
git rb main                  # Rebase current branch on main
git rbi HEAD~3               # Interactive rebase of last 3 commits
git cp abc123                # Cherry-pick commit abc123
git wip                      # Quickly commit work in progress
git fb abc123                # Find branches containing commit abc123
git ft abc123                # Find tags containing commit abc123
git fc "function name"       # Find commits that add or remove the specified function
git fm "commit message"      # Find commits with the specified message
```

## Advanced Git Topics

### Git Hooks

Git hooks are scripts that Git executes before or after events such as commit, push, and receive. They reside in the `.git/hooks` directory of your Git repository.

Here's an example of a pre-commit hook that runs linting before allowing a commit:

```bash
#!/bin/sh
# .git/hooks/pre-commit

# Run linter
npm run lint

# If linting fails, prevent the commit
if [ $? -ne 0 ]; then
  echo "Linting failed. Please fix the errors before committing."
  exit 1
fi
```

Make sure to make the hook executable:

```bash
chmod +x .git/hooks/pre-commit
```

Other useful hooks include:
- `pre-push`: Run tests before pushing
- `post-merge`: Update dependencies after merging
- `prepare-commit-msg`: Automatically add issue numbers to commit messages

### Git Bisect

Git bisect is a powerful debugging tool that uses binary search to find the commit that introduced a bug.

```bash
# Start the bisect process
git bisect start

# Mark the current version as bad
git bisect bad

# Mark a known good version
git bisect good v1.0

# Git will checkout a commit halfway between good and bad
# Test your code and mark the commit
git bisect good  # or git bisect bad

# Repeat until Git identifies the first bad commit

# When done, reset your repository
git bisect reset
```

You can also run Git bisect automatically if you have a test script:

```bash
git bisect start HEAD v1.0
git bisect run ./test_script.sh
```

### Git Submodules

Git submodules allow you to keep a Git repository as a subdirectory of another Git repository. This is useful for including libraries or shared components in your project.

```bash
# Add a submodule
git submodule add https://github.com/example/repo.git path/to/submodule

# Initialize submodules after cloning a repository
git submodule init

# Update submodules
git submodule update --init --recursive

# Pull all changes in the submodules
git submodule update --remote

# Remove a submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
git commit -m "Removed submodule"
rm -rf .git/modules/path/to/submodule
```

### Git Large File Storage (LFS)

Git LFS is an extension that replaces large files with text pointers inside Git, while storing the file contents on a remote server.

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.psd"
git lfs track "*.iso"

# Ensure .gitattributes is tracked
git add .gitattributes

# Add, commit and push as usual
git add file.psd
git commit -m "Add large file"
git push origin main

# Clone a repository with LFS files
git lfs clone https://github.com/example/repo.git

# Pull LFS files
git lfs pull
```

### Git Flow

Git Flow is a branching model that defines a strict branching structure designed around project releases.

```bash
# Initialize Git Flow
git flow init

# Start a new feature
git flow feature start my-feature

# Finish a feature
git flow feature finish my-feature

# Start a release
git flow release start 1.0.0

# Finish a release
git flow release finish 1.0.0

# Start a hotfix
git flow hotfix start bug-fix

# Finish a hotfix
git flow hotfix finish bug-fix
```

### Advanced Merge Conflict Resolution

Resolving merge conflicts can be complex. Here are some advanced techniques:

```bash
# Use a visual merge tool
git mergetool

# Use specific merge strategy
git merge --strategy-option theirs  # or ours

# Abort a merge
git merge --abort

# After resolving conflicts
git add .
git commit -m "Resolve merge conflicts"

# Use Git's diff3 format for better context
git config --global merge.conflictstyle diff3
```

### Git Reflog

Git reflog is a mechanism to record when the tip of branches are updated. It's useful for recovering lost commits.

```bash
# View the reflog
git reflog

# Restore to a specific reflog entry
git reset --hard HEAD@{2}

# Recover a dropped stash
git stash apply $(git stash list | grep 'stash@{0}' | cut -d: -f1)
```

### Advanced Git Log

Git log has many powerful options for viewing commit history:

```bash
# Show commits by author
git log --author="John Doe"

# Show commits in a date range
git log --since="1 week ago" --until="yesterday"

# Show a pretty graph of commits
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

# Show changed files in each commit
git log --name-status

# Show a summary of changes
git log --stat

# Search for commits with specific content
git log -S"function_name"

# Show commits that changed a specific file
git log -- path/to/file

# Show a range of commits
git log master..feature
```



