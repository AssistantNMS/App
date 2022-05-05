# Contributing to AssistantNMS

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

### TLDR
> **Note:** Please don't file an issue to ask a question. You'll get faster results by asking your question in our [Discord server](https://assistantapps.com/discord) or by using the resources below.

## Table Of Contents

* [What should I know before I get started?](#what-should-i-know-before-i-get-started)
  * [Project History](#project-history)
  * [Design Decisions](#design-decisions)

* [How Can I Contribute?](#how-can-i-contribute)
  * [I found a 🐛Bug🐛 and I want to report it](#i-found-a-bug-and-want-to-report-it)
  * [Suggesting a Feature](#suggesting-a-feature)

<br />

## What should I know before I get started?

### Project History

The Assistant for No Man's Sky app was started by 1 person and maintained by the same person for over 2 years at the time of writing this. A lot of the code will be opinionated and a lot of the code is old and/or outdated and/or needs refactoring.

The project has gone through multiple major refactorings and still needs to go through a few more. For example, the Dart linter is throwing a lot of warnings at the moment. These will need to be solved eventually, but with nearly 2000 warnings it is a lot easier to only [boyscout](https://www.stepsize.com/blog/how-to-be-an-effective-boy-girl-scout-engineer) these issues instead of spending too long fixing these small issues.

### Design Decisions
This project was started long before Dart 2 and null safety was added. There are a lot of files that are not compliant with best practices due to this. They will slowly be fixed, over time 😅

#### File naming
Unfortunately almost all of the files in the project are pascal case `appShell.dart` instead of what Dart recommends `app_shell.dart`. There are just too many files to change along with their corresponding imports, so we will just continue naming the files in pascal case until someone can come up with an easy solution that doesn't break everything 😅

<br />

## How Can I Contribute?

### I found a bug and want to report it

First of all thank you for taking the time to check our guidelines before creating a Github issue 💪

To help keep the issues manageable, please double check that the issue you have, has not been reported already in the issues list. Secondly please ensure that you fill in as much information as possible on the issue. The issue template should help you through the process, sometimes small details help us find the bug quickly.

### Suggesting a Feature

_**Please note:** Just because a feature ticket exists, does not mean that we will or can build the feature._ 

- Ensure that there is no existing feature request on the [issues page](https://github.com/AssistantNMS/App/issues)
- Research is required
  - Typically when a feature is built, there is a lot of time spent gathering the data, figuring out how we are going to make use of and store the data within the apps, figuring out how to localise (translate) the data displayed.
- Some things may not be possible or will take too much time.

You can create a feature request from [here](https://github.com/AssistantNMS/App/issues/new?assignees=&labels=idea&template=---feature-request.md)


