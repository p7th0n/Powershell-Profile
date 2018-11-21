# Module: Send-ToDrafts

## Summary

* Send text from Windows to [Drafts](https://getdrafts.com/) app. Drafts is an iOS app.

> Drafts. Where Text Starts.
>
> Drafts lets you turn text into action – it’s a quick notebook, handy editor, and writing automation tool, all in one.
>
> -- from the website

### Features

* Sends Windows clipboard text to Drafts by way of Dropbox.
* Sends PowerShell command line output to Drafts.

## Setup

* Download or clone this repo to your _~/Documents/WindowsPowerShell/Modules_ folder.
* Add _import-module Send-ToDrafts_ in your _$PROFILE_.
* Create the Drafts folder at _~/Dropbox/Drafts_.
* From the Drafts Action Directory install [Dropbox to Drafts](https://actions.getdrafts.com/a/1Qq).

## Usage

### Send-DosToDrafts cmdlet

* This cmdlet works with PowerShell commands entered as command line arguments or other PowerShell commands piped to Send-DosToDrafts.
* Running as a command line argument:

```powershell

# Outputs the command results to the current window and creates a text file with the output in ~/Dropbox/Drafts
Send-DosToDrafts Get-ChildItem

```

* Running as piped commands:

```powershell

# Outputs the command results to the current window and creates a text file with the output in ~/Dropbox/Drafts
Get-ChildItem | Send-DosToDrafts

```

### Send-ClipboardToDrafts cmdlet

* Copy text to clipboard & run Send-ClipboardToDrafts.
* I made a Windows shortcut that runs _Send-ClipboardToDrafts_ in a minimized PowerShell window.  That provides a quick icon to click.  In the future I may develop a C# app for the system tray.

## Notes

* [WindowsToDrafts on GitHub](https://github.com/p7th0n/WindowsToDrafts). This repo has the source for the Drafts app Action.
* Other notes and references for the module.

Author: Dave Kurman ::
![octocat](https://github.com/favicon.ico) [Github](https://github.com/p7th0n) ::
![linkedin](https://www.linkedin.com//favicon.ico) [LinkedIn](https://www.linkedin.com/in/davekurman/)

Copyright (c) 2018 Dave Kurman. All rights reserved.
