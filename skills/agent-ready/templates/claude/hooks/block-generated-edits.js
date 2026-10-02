#!/usr/bin/env node
// PreToolUse hook: refuses edits to files AGENTS.md marks as generated/do-not-edit.
// Patterns match both / and \ so the hook works on Windows, macOS and Linux.
const PROTECTED = [
  // {{PROTECTED_PATTERNS}} e.g. /src[\\/]generated[\\/]/, /api[\\/]types[\\/].*\.ts$/
];
const REGENERATE_HINT = "{{REGENERATE_HINT}}"; // e.g. 'Edit the source schema and run "npm run codegen".'

let input = "";
process.stdin.on("data", (chunk) => (input += chunk));
process.stdin.on("end", () => {
  let payload;
  try {
    payload = JSON.parse(input);
  } catch {
    process.exit(0);
  }

  const path = payload?.tool_input?.file_path || "";
  const hit = PROTECTED.some((re) => re.test(path));

  if (hit) {
    process.stderr.write(`${path} is generated (see AGENTS.md "Common Gotchas"). ${REGENERATE_HINT}`);
    process.exit(2); // exit code 2 = block the tool call; stderr is fed back to the agent
  }

  process.exit(0);
});
