---
name: "\U0001F525 Hot fix Release"
about: Steps to release a hotfix version
title: ''
labels: ''
assignees: Khaoz-Topsy

---

- [ ] Make sure that `pubspec.yaml` uses github link for the `assistantapps_flutter_common` library
- [ ] Verify that AssistantNMS.Data audits have all passed
- [ ] Regenerate AssistantApps server data from the AssistantNMS.Data tool
- [ ] Make sure content of `release_notes.txt` is ready for production
- [ ] Queue CodeMagic build
