---
name: "\U0001F4E6 New Release"
about: Steps to release a new version
title: Release 2.x.x
labels: pre-release
assignees: Khaoz-Topsy

---

### Prepare:
- [ ] Make sure that `pubspec.yaml` uses github link for the `assistantapps_flutter_common` library
- [ ] Regenerate AssistantApps server data from the AssistantNMS.Data tool
- [ ] Verify that AssistantNMS.Data audits have all passed
- [ ] Make sure content of `release_notes.txt` is ready for production
- [ ] Run the versionNumberScript `dart scripts\version_num_script.dart`
- [ ] Create new item in Admin tool
  - [ ] Copy content of `release_notes.txt` to Markdown
  - [ ] Future date release date
  - [ ] Copy guid, paste into `assistant_apps_settings.dart`
- [ ] Create Pull Request
- [ ] [Queue](https://codemagic.io/app/5d9da9057a0a9500105180bf/workflow/5ef3374ec0adbfe0fdee431d/settings) CodeMagic build 

---

### Later:
- [ ] Merge Pull Request on successful build and deploy
- [ ] Create Github release ([New Release](https://github.com/AssistantNMS/App/releases/new))
  - [ ] Tag develop branch (2.x.x)
  - [ ] Use appropriate tag (2.x.x)
  - [ ] Attach `.aab`
  - [ ] Attach `.apk`
  - [ ] Attach `.ipa`
  - [ ] Attach `.exe`
- [ ] Go through manual iOS steps
  - [ ] Copy content of `release_notes.txt` into Apple webpage
  - [ ] Submit for Apple review
- [ ] Go through manual WindowsStore steps
  - [ ] Copy content of `release_notes.txt` into store webpage
  - [ ] Submit for Microsoft review

