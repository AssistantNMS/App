---
name: "\U0001F4E6 New Release"
about: Steps to release a new version
title: Release 2.xx
labels: pre-release
assignees: Khaoz-Topsy

---

### Prepare:
- [ ] Make sure that `pubspec.yaml` uses github link for the `assistantapps_flutter_common` library
- [ ] Regenerate AssistantApps server data from the AssistantNMS.Data tool
- [ ] Verify that AssistantNMS.Data audits have all passed
- [ ] Make sure content of `release_notes.txt` is ready for production
- [ ] Create new item in Admin tool
  - [ ] Copy content of `release_notes.txt` to Markdown
  - [ ] Future date release date
  - [ ] Copy guid, paste into `assistantAppsSettings.dart`
- [ ] [Queue](https://codemagic.io/app/5d9da9057a0a9500105180bf/workflow/5ef3374ec0adbfe0fdee431d/settings) CodeMagic build 

---

### Much later:
- [ ] Go through manual iOS steps
  - [ ] Copy content of `release_notes.txt` into Apple webpage
  - [ ] Submit for Apple review
- [ ] Create Github release ([New Release](https://github.com/AssistantNMS/App/releases/new))
  - [ ] Merge Pull Request
  - [ ] Tag main branch
  - [ ] Attach `.aab`
  - [ ] Attach `.apk`
  - [ ] Attach `.ipa`
  - [ ] Use appropriate tag
