---
name: New Release
about: Steps to release a new version
title: 'Release '
labels: pre-release
assignees: Khaoz-Topsy

---

- [ ] Make sure that `pubspec.yaml` uses github link for the `assistantapps_flutter_common` library
- [ ] Verify that AssistantNMS.Data audits have all passed
- [ ] Regenerate AssistantApps server data from the AssistantNMS.Data tool
- [ ] Make sure content of `release_notes.txt` is ready for production
- [ ] Create new item in Admin tool
  - [ ] Copy content of `release_notes.txt` 
  - [ ] Future date release date
  - [ ] Copy guid, paste into `prod.dart`
- [ ] Queue CodeMagic build

Much later:
- [ ] Go through manual iOS steps
  - [ ] Copy content of `release_notes.txt` into Apple webpage
  - [ ] Submit for Apple review
- [ ] Create Github release
  - [ ] Tag main branch
  - [ ] Attach `.apk`
  - [ ] Use appropriate tag
