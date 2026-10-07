# Skill library procedures

- The reviewed skill sources live in src/skills; they are not automatically installed by editing that directory.
- your-library declares .ailibrary/notebook and .ailibrary/historybook. Its initializer now defaults to .ailibrary and accepts an explicit target directory. Scratch files are separately placed in .aitmp by scratch-on-disk.
- Filename retrieval must inspect files within notebook/ and historybook/, rather than listing only .ailibrary's immediate directories.
- On 2026-10-07, disposable-directory execution verified default and custom initialization, existing-note preservation on repeated initialization, and retrieval of a topic filename. Metadata checks do not establish skill selection reliability or behavioral effectiveness.
- This record uses the currently active agent-memory path .aiassistant; it does not change the storage contract of the source skill being edited.
