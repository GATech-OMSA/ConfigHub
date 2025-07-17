# VS Code Master Guide: Complete Reference

## Table of Contents
1. [VS Code Fundamentals](#vs-code-fundamentals)
2. [Essential Keyboard Shortcuts](#essential-keyboard-shortcuts)
3. [User Interface Mastery](#user-interface-mastery)
4. [Editor Features](#editor-features)
5. [Settings and Configuration](#settings-and-configuration)
6. [Extensions Guide](#extensions-guide)
7. [Integrated Terminal](#integrated-terminal)
8. [Debugging](#debugging)
9. [Git Integration](#git-integration)
10. [Snippets and Productivity](#snippets-and-productivity)
11. [Multi-cursor and Selection](#multi-cursor-and-selection)
12. [Workspace Management](#workspace-management)
13. [Remote Development](#remote-development)
14. [Performance Optimization](#performance-optimization)
15. [Customization and Themes](#customization-and-themes)
16. [Advanced Features](#advanced-features)
17. [Troubleshooting](#troubleshooting)
18. [Quick Reference](#quick-reference)

## VS Code Fundamentals

### Command Palette
The Command Palette is your gateway to all VS Code functionality.

```
# Open Command Palette
Cmd+Shift+P (Mac) / Ctrl+Shift+P (Windows/Linux)

# Quick Open (files)
Cmd+P / Ctrl+P

# Go to Symbol
Cmd+Shift+O / Ctrl+Shift+O

# Go to Line
Ctrl+G

# Show all commands
> (in Command Palette)

# Open settings
Cmd+, / Ctrl+,
```

### Essential Concepts
- **Workspace**: A collection of folders and settings
- **Extension**: Add-on functionality
- **IntelliSense**: Code completion and suggestions
- **Language Server**: Provides language-specific features
- **Tasks**: Automated build/run configurations
- **Snippets**: Code templates

## Essential Keyboard Shortcuts

### macOS Shortcuts

#### Basic Editing
```
Cmd+X                Cut line (empty selection)
Cmd+C                Copy line (empty selection)
Cmd+V                Paste
Cmd+Z                Undo
Cmd+Shift+Z          Redo
Option+Up/Down       Move line up/down
Option+Shift+Up/Down Copy line up/down
Cmd+Shift+K          Delete line
Cmd+Enter            Insert line below
Cmd+Shift+Enter      Insert line above
Cmd+Shift+\          Jump to matching bracket
Cmd+[/]              Indent/outdent line
Cmd+/                Toggle line comment
Option+Shift+A       Toggle block comment
```

#### Multi-cursor and Selection
```
Option+Click         Insert cursor
Cmd+Option+Up/Down   Insert cursor above/below
Cmd+D                Select next occurrence
Cmd+K Cmd+D          Skip occurrence
Cmd+Shift+L          Select all occurrences
Cmd+L                Select current line
Cmd+Shift+Space      Trigger parameter hints
Shift+Option+drag    Column (box) selection
```

#### Navigation
```
Cmd+P                Quick open file
Cmd+Shift+O          Go to symbol in file
Cmd+T                Go to symbol in workspace
Ctrl+G               Go to line
Cmd+Shift+M          Show problems panel
F8 / Shift+F8        Go to next/previous problem
Ctrl+Tab             Navigate editor group history
Cmd+Shift+[/]        Navigate between editor tabs
```

#### Search and Replace
```
Cmd+F                Find
Cmd+H                Replace
Cmd+Shift+F          Find in files
Cmd+Shift+H          Replace in files
F3 / Shift+F3        Find next/previous
Option+Enter         Select all occurrences of find match
```

#### Editor Management
```
Cmd+\                Split editor
Cmd+1/2/3            Focus editor group
Cmd+K Cmd+Left/Right Focus previous/next editor group
Cmd+W                Close editor
Cmd+K W              Close all editors
Cmd+K Cmd+W          Close all editors in group
```

### Windows/Linux Shortcuts
Replace `Cmd` with `Ctrl` and `Option` with `Alt` for most shortcuts.

## User Interface Mastery

### Layout Components
1. **Activity Bar** (left side)
   - Explorer
   - Search
   - Source Control
   - Run and Debug
   - Extensions

2. **Side Bar**
   - File Explorer
   - Search Results
   - Git Changes
   - Debug Variables

3. **Editor Groups**
   - Split vertically/horizontally
   - Drag and drop tabs
   - Grid layout

4. **Panel** (bottom)
   - Terminal
   - Problems
   - Output
   - Debug Console

5. **Status Bar**
   - Language Mode
   - Line/Column
   - Encoding
   - Git Branch

### Customizing Layout
```json
// settings.json
{
  "workbench.sideBar.location": "right",
  "workbench.panel.defaultLocation": "right",
  "workbench.statusBar.visible": true,
  "workbench.activityBar.visible": true,
  "workbench.editor.showTabs": true,
  "workbench.editor.tabSizing": "shrink",
  "workbench.editor.wrapTabs": true
}
```

### Zen Mode
```
# Toggle Zen Mode
Cmd+K Z

// Zen Mode settings
{
  "zenMode.centerLayout": true,
  "zenMode.fullScreen": true,
  "zenMode.hideActivityBar": true,
  "zenMode.hideLineNumbers": false,
  "zenMode.hideStatusBar": true,
  "zenMode.hideTabs": true
}
```

## Editor Features

### IntelliSense
```json
{
  // IntelliSense settings
  "editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": true
  },
  "editor.acceptSuggestionOnCommitCharacter": true,
  "editor.acceptSuggestionOnEnter": "on",
  "editor.quickSuggestionsDelay": 10,
  "editor.suggestOnTriggerCharacters": true,
  "editor.tabCompletion": "on",
  "editor.suggest.localityBonus": true,
  "editor.suggest.snippetsPreventQuickSuggestions": true
}
```

### Code Formatting
```json
{
  // Formatting settings
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.formatOnType": true,
  "editor.defaultFormatter": null, // Set per language
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.python"
  }
}
```

### Code Actions
```
# Trigger code actions
Cmd+. / Ctrl+.

# Quick fixes
- Import missing modules
- Fix linting errors
- Generate getters/setters
- Extract method/variable
- Convert to async/await
```

### Folding
```
# Folding shortcuts
Cmd+Option+[         Fold region
Cmd+Option+]         Unfold region
Cmd+K Cmd+0          Fold all
Cmd+K Cmd+J          Unfold all
Cmd+K Cmd+[          Fold all regions at level
```

## Settings and Configuration

### Settings Hierarchy
1. Default Settings
2. User Settings (`~/Library/Application Support/Code/User/settings.json`)
3. Workspace Settings (`.vscode/settings.json`)
4. Folder Settings

### Essential Settings
```json
{
  // Editor
  "editor.fontSize": 14,
  "editor.fontFamily": "Fira Code, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.lineHeight": 1.6,
  "editor.letterSpacing": 0.5,
  "editor.lineNumbers": "on",
  "editor.renderWhitespace": "selection",
  "editor.rulers": [80, 120],
  "editor.wordWrap": "on",
  "editor.minimap.enabled": true,
  "editor.minimap.maxColumn": 80,
  "editor.minimap.renderCharacters": false,
  
  // Cursor
  "editor.cursorStyle": "line",
  "editor.cursorBlinking": "smooth",
  "editor.cursorSmoothCaretAnimation": true,
  
  // Files
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/*.pyc": true
  },
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  
  // Search
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/*.code-search": true
  },
  
  // Terminal
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.fontFamily": "MesloLGS NF",
  "terminal.integrated.copyOnSelection": true,
  "terminal.integrated.cursorBlinking": true,
  
  // Workbench
  "workbench.colorTheme": "One Dark Pro",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "none",
  "workbench.editor.enablePreview": false,
  "workbench.editor.highlightModifiedTabs": true,
  
  // Other
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "git.autofetch": true,
  "git.confirmSync": false,
  "extensions.ignoreRecommendations": false
}
```

### Language-Specific Settings
```json
{
  "[python]": {
    "editor.rulers": [79, 88],
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": true
    }
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  },
  "[markdown]": {
    "editor.wordWrap": "on",
    "editor.quickSuggestions": {
      "other": true,
      "comments": false,
      "strings": false
    }
  }
}
```

## Extensions Guide

### Essential Extensions

#### General Development
```
# Must-have extensions
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension wayou.vscode-todo-highlight
code --install-extension gruntfuggly.todo-tree
code --install-extension christian-kohler.path-intellisense
code --install-extension formulahendry.auto-rename-tag
code --install-extension naumovs.color-highlight
```

#### Language-Specific
```
# Python
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-python.black-formatter
code --install-extension ms-toolsai.jupyter

# JavaScript/TypeScript
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension xabikos.JavaScriptSnippets
code --install-extension OfHumanBondage.react-proptypes-intellisense

# Web Development
code --install-extension ritwickdey.LiveServer
code --install-extension formulahendry.auto-close-tag
code --install-extension pranaygp.vscode-css-peek

# Docker
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.remote-containers

# Database
code --install-extension mtxr.sqltools
code --install-extension mongodb.mongodb-vscode
```

#### Productivity
```
# Enhanced productivity
code --install-extension alefragnani.project-manager
code --install-extension sleistner.vscode-fileutils
code --install-extension ChakrounAnas.turbo-console-log
code --install-extension aaron-bond.better-comments
code --install-extension wix.vscode-import-cost
code --install-extension kisstkondoros.vscode-gutter-preview
code --install-extension usernamehw.errorlens
```

### Managing Extensions
```bash
# List installed extensions
code --list-extensions

# Install from list
cat extensions.txt | xargs -L 1 code --install-extension

# Export extensions list
code --list-extensions > extensions.txt

# Disable extension
code --disable-extension extension-id

# Uninstall extension
code --uninstall-extension extension-id
```

### Extension Settings Example
```json
{
  // GitLens
  "gitlens.hovers.currentLine.over": "line",
  "gitlens.currentLine.enabled": true,
  "gitlens.codeLens.enabled": false,
  
  // Prettier
  "prettier.singleQuote": true,
  "prettier.trailingComma": "es5",
  "prettier.tabWidth": 2,
  "prettier.semi": true,
  "prettier.printWidth": 80,
  
  // ESLint
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "eslint.autoFixOnSave": true,
  
  // Python
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
  "python.formatting.blackArgs": ["--line-length", "88"],
  
  // Live Server
  "liveServer.settings.donotShowInfoMsg": true,
  "liveServer.settings.donotVerifyTags": true
}
```

## Integrated Terminal

### Terminal Configuration
```json
{
  // Terminal settings
  "terminal.integrated.profiles.osx": {
    "zsh": {
      "path": "/bin/zsh",
      "args": ["-l"]
    },
    "bash": {
      "path": "/bin/bash",
      "args": ["-l"]
    }
  },
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.fontFamily": "MesloLGS NF",
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.cursorStyle": "line",
  "terminal.integrated.scrollback": 10000,
  "terminal.integrated.copyOnSelection": true,
  "terminal.integrated.rightClickBehavior": "paste"
}
```

### Terminal Shortcuts
```
# Terminal management
Ctrl+`               Toggle terminal
Cmd+Shift+`          Create new terminal
Cmd+Shift+[/]        Switch terminals
Cmd+K               Clear terminal
Ctrl+Shift+5         Split terminal

# Terminal navigation
Cmd+Up/Down          Scroll up/down
Cmd+Home/End         Scroll to top/bottom
```

### Multiple Terminals
```json
{
  "terminal.integrated.profiles.osx": {
    "Development": {
      "path": "/bin/zsh",
      "args": ["-l"],
      "env": {
        "NODE_ENV": "development"
      }
    },
    "Production": {
      "path": "/bin/zsh",
      "args": ["-l"],
      "env": {
        "NODE_ENV": "production"
      }
    }
  }
}
```

## Debugging

### Launch Configurations
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      // Node.js
      "type": "node",
      "request": "launch",
      "name": "Launch Program",
      "program": "${workspaceFolder}/index.js",
      "skipFiles": [
        "<node_internals>/**"
      ],
      "env": {
        "NODE_ENV": "development"
      }
    },
    {
      // Node.js with nodemon
      "type": "node",
      "request": "launch",
      "name": "nodemon",
      "runtimeExecutable": "nodemon",
      "program": "${workspaceFolder}/app.js",
      "restart": true,
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    },
    {
      // Python
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal",
      "justMyCode": true
    },
    {
      // Chrome debugging
      "type": "chrome",
      "request": "launch",
      "name": "Launch Chrome",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}/src",
      "sourceMapPathOverrides": {
        "webpack:///src/*": "${webRoot}/*"
      }
    }
  ]
}
```

### Debugging Shortcuts
```
F5                   Start/Continue debugging
F9                   Toggle breakpoint
F10                  Step over
F11                  Step into
Shift+F11            Step out
Shift+F5             Stop debugging
Cmd+K Cmd+I          Show hover

# Breakpoint variations
- Regular breakpoint
- Conditional breakpoint
- Logpoint
- Function breakpoint
```

### Debug Console
```javascript
// Use console methods in debug console
console.log('Debug message');
console.table(data);
console.time('operation');
console.timeEnd('operation');

// Set conditional breakpoints
// Right-click on breakpoint → Edit Breakpoint
// Expression: i === 10
// Hit Count: 5
// Log Message: 'i is {i}'
```

## Git Integration

### Source Control Features
```
# Git commands in VS Code
Cmd+Shift+G          Open Source Control
Cmd+Enter            Commit staged changes

# From Source Control panel:
- Stage/unstage files
- Discard changes
- View diffs
- Create branches
- Push/pull/sync
- Stash changes
- View history
```

### GitLens Features
```
# GitLens capabilities
- Current line blame
- File history
- Compare branches
- View stashes
- Search commits
- Interactive rebase editor
- Repository view
```

### Git Configuration
```json
{
  // Git settings
  "git.enableSmartCommit": true,
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.openRepositoryInParentFolders": "always",
  "git.enableStatusBarSync": true,
  "git.defaultCloneDirectory": "~/dev",
  "git.fetchOnPull": true,
  "git.pruneOnFetch": true,
  "git.autoStash": true,
  
  // GitLens
  "gitlens.hovers.currentLine.over": "line",
  "gitlens.currentLine.enabled": true,
  "gitlens.codeLens.enabled": false,
  "gitlens.blame.avatars": true,
  "gitlens.blame.format": "${author|10} ${date}",
  "gitlens.defaultDateFormat": "MMMM Do, YYYY h:mma"
}
```

## Snippets and Productivity

### Creating Custom Snippets
```json
// File → Preferences → Configure User Snippets
// javascript.json
{
  "Console Log": {
    "prefix": "clg",
    "body": [
      "console.log('$1');",
      "$2"
    ],
    "description": "Console log statement"
  },
  "Arrow Function": {
    "prefix": "af",
    "body": [
      "const ${1:functionName} = (${2:params}) => {",
      "\t$3",
      "};"
    ],
    "description": "Arrow function"
  },
  "Try Catch": {
    "prefix": "tc",
    "body": [
      "try {",
      "\t$1",
      "} catch (error) {",
      "\tconsole.error(error);",
      "\t$2",
      "}"
    ],
    "description": "Try catch block"
  },
  "Async Function": {
    "prefix": "asf",
    "body": [
      "const ${1:functionName} = async (${2:params}) => {",
      "\ttry {",
      "\t\t$3",
      "\t} catch (error) {",
      "\t\tconsole.error(error);",
      "\t\t$4",
      "\t}",
      "};"
    ],
    "description": "Async arrow function with try-catch"
  }
}
```

### Snippet Variables
```json
{
  "React Component": {
    "prefix": "rfc",
    "body": [
      "import React from 'react';",
      "",
      "const ${1:${TM_FILENAME_BASE}} = (${2:props}) => {",
      "\treturn (",
      "\t\t<div>",
      "\t\t\t$3",
      "\t\t</div>",
      "\t);",
      "};",
      "",
      "export default ${1:${TM_FILENAME_BASE}};"
    ],
    "description": "React functional component"
  }
}

// Available variables:
// $TM_FILENAME_BASE - Filename without extension
// $TM_FILENAME - Filename with extension
// $TM_DIRECTORY - Directory path
// $TM_FILEPATH - Full file path
// $CURRENT_YEAR, $CURRENT_MONTH, $CURRENT_DATE
// $CLIPBOARD - Clipboard contents
// $WORKSPACE_NAME - Workspace name
```

### Emmet
```html
<!-- Emmet abbreviations -->
<!-- Type these and press Tab -->

div.container>ul>li*5>a{Item $}
<!-- Expands to: -->
<div class="container">
  <ul>
    <li><a href="">Item 1</a></li>
    <li><a href="">Item 2</a></li>
    <li><a href="">Item 3</a></li>
    <li><a href="">Item 4</a></li>
    <li><a href="">Item 5</a></li>
  </ul>
</div>

<!-- More examples -->
nav>ul>li*4>a[href="#"]{Link $}
form>input:text+input:email+button:submit{Send}
div#header+div.content+div#footer
```

## Multi-cursor and Selection

### Multi-cursor Techniques
```
# Basic multi-cursor
Option+Click         Add cursor
Cmd+Option+Up/Down   Add cursor above/below
Cmd+D                Select next occurrence
Cmd+Shift+L          Select all occurrences

# Advanced selection
Shift+Option+drag    Column selection
Cmd+Shift+Right      Select to end of word
Cmd+Shift+Down       Select to end of file
Option+Shift+Right   Expand selection
Option+Shift+Left    Shrink selection
```

### Practical Examples
```javascript
// Change all occurrences
// 1. Select 'oldName'
// 2. Cmd+D repeatedly or Cmd+Shift+L
// 3. Type 'newName'

const oldName = 'value';
function processOldName() {
  return oldName;
}
console.log(oldName);

// Column editing
// 1. Place cursor at start
// 2. Option+Shift+Down to create column selection
// 3. Type to edit all lines
item1: 'value1',
item2: 'value2',
item3: 'value3',
```

## Workspace Management

### Workspace Settings
```json
// .vscode/settings.json
{
  "folders": [
    {
      "path": "frontend",
      "name": "Frontend"
    },
    {
      "path": "backend",
      "name": "Backend"
    }
  ],
  "settings": {
    "editor.formatOnSave": true,
    "files.exclude": {
      "**/dist": true,
      "**/node_modules": true
    }
  },
  "launch": {
    "configurations": []
  },
  "extensions": {
    "recommendations": [
      "dbaeumer.vscode-eslint",
      "esbenp.prettier-vscode"
    ]
  }
}
```

### Tasks
```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "npm: start",
      "type": "npm",
      "script": "start",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": [],
      "detail": "Start development server"
    },
    {
      "label": "npm: test",
      "type": "npm",
      "script": "test",
      "group": "test",
      "problemMatcher": [],
      "detail": "Run tests"
    },
    {
      "label": "Build All",
      "dependsOn": [
        "Build Frontend",
        "Build Backend"
      ],
      "group": "build",
      "problemMatcher": []
    }
  ]
}
```

### Project Manager Extension
```json
// Project Manager settings
{
  "projectManager.groupList": true,
  "projectManager.sortList": "Name",
  "projectManager.showProjectNameInStatusBar": true,
  "projectManager.openInNewWindowWhenClickingInStatusBar": false,
  "projectManager.git.baseFolders": [
    "~/dev",
    "~/projects"
  ]
}
```

## Remote Development

### Remote SSH
```json
// SSH configuration
{
  "remote.SSH.remotePlatform": {
    "hostname": "linux"
  },
  "remote.SSH.configFile": "~/.ssh/config",
  "remote.SSH.connectTimeout": 30,
  "remote.SSH.defaultExtensions": [
    "ms-python.python",
    "dbaeumer.vscode-eslint"
  ]
}
```

### Dev Containers
```json
// .devcontainer/devcontainer.json
{
  "name": "Node.js Development",
  "image": "mcr.microsoft.com/devcontainers/javascript-node:16",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"
      ],
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh"
      }
    }
  },
  "forwardPorts": [3000],
  "postCreateCommand": "npm install",
  "remoteUser": "node"
}
```

### WSL (Windows Subsystem for Linux)
```json
{
  "remote.WSL.fileWatcher.polling": true,
  "remote.WSL.debug": false,
  "remote.autoForwardPorts": true,
  "remote.autoForwardPortsSource": "process"
}
```

## Performance Optimization

### Performance Settings
```json
{
  // Disable features for better performance
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "none",
  "editor.cursorBlinking": "solid",
  "editor.matchBrackets": "never",
  "editor.renderLineHighlight": "none",
  "workbench.editor.highlightModifiedTabs": false,
  "extensions.autoUpdate": false,
  "search.followSymlinks": false,
  
  // File watching
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/**": true,
    "**/dist/**": true,
    "**/.next/**": true
  },
  
  // Limit file searching
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/bower_components": true,
    "**/dist": true,
    "**/.next": true
  }
}
```

### Large File Handling
```json
{
  // Large file settings
  "editor.largeFileOptimizations": true,
  "files.maxMemoryForLargeFilesMB": 4096,
  "editor.maxTokenizationLineLength": 60000,
  
  // Disable features for large files
  "[largefiles]": {
    "editor.detectIndentation": false,
    "editor.wordWrap": "off",
    "editor.minimap.enabled": false,
    "editor.tokenColorCustomizations": {
      "semanticHighlighting": false
    }
  }
}
```

## Customization and Themes

### Color Theme Customization
```json
{
  "workbench.colorTheme": "One Dark Pro",
  "workbench.colorCustomizations": {
    "[One Dark Pro]": {
      "editor.background": "#282c34",
      "editor.foreground": "#abb2bf",
      "editor.lineHighlightBackground": "#2c323c",
      "editor.selectionBackground": "#3e4451",
      "editorCursor.foreground": "#528bff",
      "editorIndentGuide.background": "#3e4451",
      "editorIndentGuide.activeBackground": "#c678dd",
      "sideBar.background": "#21252b",
      "activityBar.background": "#282c34",
      "statusBar.background": "#21252b"
    }
  },
  
  // Token colors
  "editor.tokenColorCustomizations": {
    "[One Dark Pro]": {
      "comments": "#5c6370",
      "strings": "#98c379",
      "functions": "#61afef",
      "keywords": "#c678dd",
      "numbers": "#d19a66",
      "types": "#e06c75",
      "variables": "#e06c75"
    }
  }
}
```

### Font Configuration
```json
{
  // Font settings
  "editor.fontFamily": "'Fira Code', 'JetBrains Mono', Consolas, 'Courier New', monospace",
  "editor.fontSize": 14,
  "editor.fontWeight": "400",
  "editor.fontLigatures": "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'zero', 'onum'",
  "editor.letterSpacing": 0.5,
  "editor.lineHeight": 1.6,
  
  // Terminal font
  "terminal.integrated.fontFamily": "'MesloLGS NF', 'Hack Nerd Font', monospace",
  "terminal.integrated.fontSize": 14,
  
  // Debug console font
  "debug.console.fontFamily": "default",
  "debug.console.fontSize": 14
}
```

### Icon Themes
```json
{
  "workbench.iconTheme": "material-icon-theme",
  "material-icon-theme.folders.theme": "specific",
  "material-icon-theme.activeIconPack": "react",
  "material-icon-theme.files.associations": {
    "*.service.ts": "nest-service",
    "*.module.ts": "nest-module",
    "*.controller.ts": "nest-controller"
  },
  "material-icon-theme.folders.associations": {
    "ui": "components",
    "guards": "shield",
    "services": "database"
  }
}
```

## Advanced Features

### Code Navigation
```
# Advanced navigation
Cmd+Shift+.          Breadcrumb navigation
Cmd+K Cmd+Q          Go to last edit location
F12                  Go to definition
Option+F12           Peek definition
Shift+F12            Find all references
Cmd+K F12            Open definition to the side
```

### Refactoring
```
# Refactoring shortcuts
F2                   Rename symbol
Cmd+.                Quick fix/refactor menu

# Available refactors:
- Extract method/function
- Extract variable/constant
- Move to new file
- Convert to arrow function
- Generate getters/setters
- Add/remove braces
- Convert import/export
```

### Editor Groups and Layouts
```json
{
  // Editor group settings
  "workbench.editor.openSideBySideDirection": "right",
  "workbench.editor.splitSizing": "distribute",
  "workbench.editor.centeredLayoutAutoResize": true,
  
  // Custom layouts
  "workbench.editor.editorActionsLocation": "titleBar",
  "workbench.editor.showIcons": true,
  "workbench.editor.enablePreview": false,
  "workbench.editor.enablePreviewFromQuickOpen": false
}
```

### Timeline View
```
# Access timeline
- View → Timeline
- Shows Git history
- Shows file saves
- Shows refactorings

# Use for:
- Reviewing changes
- Restoring previous versions
- Understanding file evolution
```

## Troubleshooting

### Common Issues and Solutions

#### 1. High CPU Usage
```json
{
  // Disable expensive features
  "typescript.tsserver.maxTsServerMemory": 3072,
  "typescript.disableAutomaticTypeAcquisition": true,
  "extensions.autoUpdate": false,
  "extensions.autoCheckUpdates": false,
  "git.autorefresh": false,
  "search.followSymlinks": false
}
```

#### 2. Extension Conflicts
```bash
# Start with minimal extensions
code --disable-extensions

# Profile startup
code --prof-startup

# View startup performance
Developer: Startup Performance
```

#### 3. IntelliSense Not Working
```bash
# Restart language servers
> Developer: Reload Window

# Clear cache
rm -rf ~/Library/Application\ Support/Code/Cache/*
rm -rf ~/Library/Application\ Support/Code/CachedData/*

# Reset settings
> Preferences: Open Settings (JSON)
# Remove problematic settings
```

#### 4. Debugging Issues
```json
{
  // Debugging troubleshooting
  "debug.console.closeOnEnd": false,
  "debug.internalConsoleOptions": "openOnSessionStart",
  "debug.showBreakpointsInOverviewRuler": true,
  "debug.showInStatusBar": "always"
}
```

### Performance Profiling
```
# Profile extensions
> Developer: Show Running Extensions

# Start profiler
> Developer: Start Extension Host Profile

# Stop and view results
> Developer: Stop Extension Host Profile
```

## Quick Reference

### Most Used Shortcuts
```
# Navigation
Cmd+P                Quick file open
Cmd+Shift+P          Command palette
Cmd+,                Settings
Cmd+B                Toggle sidebar
Cmd+J                Toggle panel
Cmd+`                Toggle terminal

# Editing
Cmd+D                Select next occurrence
Cmd+/                Toggle comment
Option+Up/Down       Move line
Option+Shift+F       Format document
F2                   Rename symbol

# Multi-cursor
Option+Click         Add cursor
Cmd+Option+Up/Down   Add cursor above/below
Cmd+Shift+L          Select all occurrences

# Search
Cmd+F                Find
Cmd+Shift+F          Find in files
Cmd+H                Replace
Cmd+Shift+H          Replace in files

# Git
Cmd+Shift+G          Source control
Cmd+Enter            Commit

# Debug
F5                   Start/continue
F9                   Toggle breakpoint
F10                  Step over
F11                  Step into
```

### Essential Settings Summary
```json
{
  // Must-have settings
  "editor.formatOnSave": true,
  "editor.minimap.enabled": true,
  "editor.wordWrap": "on",
  "files.autoSave": "afterDelay",
  "workbench.startupEditor": "none",
  "extensions.ignoreRecommendations": false,
  "terminal.integrated.copyOnSelection": true,
  "git.autofetch": true,
  "editor.suggestSelection": "first",
  "editor.snippetSuggestions": "top"
}
```

### Extension Commands
```bash
# Extension management
code --list-extensions
code --install-extension <id>
code --uninstall-extension <id>
code --disable-extension <id>

# Export/import extensions
code --list-extensions > extensions.txt
cat extensions.txt | xargs -L 1 code --install-extension
```

---

Remember: VS Code is highly customizable. Start with defaults, then gradually customize based on your workflow. The key is finding the right balance between features and performance!