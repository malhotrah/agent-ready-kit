#!/usr/bin/env node
// PostToolUse hook: formats a file right after the agent edits it, so formatting
// never costs the agent a turn. Best-effort: a missing formatter never blocks.
const { spawnSync } = require("child_process");

// Extension -> formatter command (the file path is appended as the last argument).
const FORMATTERS = {
  // {{FORMATTERS}} e.g. ".py": ["uv", "run", "ruff", "format"], ".ts": ["npx", "prettier", "--write"]
};

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
  const ext = Object.keys(FORMATTERS).find((e) => path.endsWith(e));
  if (!ext) process.exit(0);

  const [cmd, ...args] = FORMATTERS[ext];
  const isWin = process.platform === "win32";
  // On Windows, npx/pnpm etc. are .cmd shims and need a shell; quote the path for it.
  spawnSync(cmd, [...args, isWin ? `"${path}"` : path], { stdio: "ignore", shell: isWin });
  process.exit(0);
});
