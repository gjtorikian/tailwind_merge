---
name: port-upstream
description: >-
  Check GitHub notifications for upstream dcastil/tailwind-merge pull requests
  and port merged ones into this Ruby gem (branch, translated code, tests,
  commit, PR). Use whenever the user asks to check upstream, check their GitHub
  notifications, sync or catch up with tailwind-merge, port upstream fixes, or
  asks "anything new upstream?" — even if they don't explicitly say "port".
---

# Port upstream tailwind-merge changes

This gem is a Ruby port of [dcastil/tailwind-merge](https://github.com/dcastil/tailwind-merge)
(TypeScript). Upstream fixes — usually to the default config — need to be
re-implemented here by hand. This skill turns the user's GitHub notification
inbox into a triage report, then ports the approved PRs one at a time.

The single source of truth for "already ported" is a commit-message trailer:
every port commit ends with a line like `Ports dcastil/tailwind-merge#705.`
Grep git history for that marker instead of keeping a separate state file —
history can't drift out of sync with itself.

## Phase 1 — Triage

1. Fetch unread notifications for the upstream repo, keeping the thread `id`
   (needed later to mark it read) and the PR number from the subject URL:

   ```bash
   gh api notifications --paginate \
     -q '.[] | select(.repository.full_name == "dcastil/tailwind-merge") | {thread_id: .id, type: .subject.type, title: .subject.title, url: .subject.url}'
   ```

   Ignore non-PullRequest subjects (issues, releases) unless the user asks
   about them. Dedupe if several threads point at the same PR. If the inbox is
   empty, say so and stop — unless the user asked for a **sweep** (see below).

2. For each PR number, fetch its state and metadata:

   ```bash
   gh pr view <N> -R dcastil/tailwind-merge --json state,title,url,mergedAt,body,files
   ```

   Sort the PRs into three buckets:

   - **Not merged yet** (`OPEN`): leave the notification unread and don't
     track it — porting unmerged work is speculative. Mention these in one
     summary line so the user knows why they weren't handled.
   - **Merged, already ported**: check with
     `git log -E --grep 'dcastil/tailwind-merge#<N>([^0-9]|$)'`
     (the character class stops #70 from matching #708). If a commit exists,
     mark the notification read right away — the inbox should reflect
     remaining work:
     `gh api --method PATCH /notifications/threads/<thread_id>`
   - **Merged, not ported**: this is the work queue.

3. Present a triage report for the work queue: upstream title, link, merge
   date, which upstream files it touches, and which Ruby files that maps to
   (see the translation table). Flag PRs that likely have nothing to port —
   changes confined to TypeScript types, docs, bundling, CI, or dependency
   bumps have no Ruby counterpart.

4. Ask the user which PRs to port before writing any code (recommend all the
   applicable ones). PRs the user decides to skip as not applicable also get
   their notification marked read — a conscious "no" is handled work.

## Phase 2 — Port (one upstream PR at a time)

Port approved PRs **oldest merge first** — upstream PRs often touch adjacent
config lines, so applying them in merge order avoids self-inflicted conflicts.
Each port is its own branch off `main`, its own commit, its own PR here.

For each PR:

1. Start clean: `git checkout main && git pull`.
2. Branch using the repo's convention: `fix/<kebab-summary>` (or `feat/` if
   the upstream change adds behavior).
3. Read the full upstream change: `gh pr diff <N> -R dcastil/tailwind-merge`,
   plus the PR body — dcastil's descriptions usually explain the CSS-level
   *why*, which belongs in the commit message here.
4. Translate the diff using the table and idioms below. Port the upstream
   test changes too — a port without its tests isn't verified.
5. Run the suite and linter:

   ```bash
   bundle exec rake test && bundle exec rake rubocop
   ```

   Fix failures before committing. Do **not** touch `version.rb` or
   `CHANGELOG.md` — release-please generates both from conventional commits.
6. Commit with a conventional message modeled on `git show 66d8e2a`:
   `fix(config): <subject>`, a body explaining the CSS behavior being fixed
   (not just "port upstream"), and the trailer as the final line:

   ```
   Ports dcastil/tailwind-merge#<N>.
   ```

   That trailer is the tracking mechanism — omitting it means the PR shows up
   as unported forever.

   Commits are signed through 1Password's SSH agent. If `git commit` fails
   with `1Password: failed to fill whole buffer`, 1Password is locked — ask
   the user to unlock it and retry (the commit may also need to run outside
   the sandbox to reach the agent).
7. Push and open a PR against `main` with `gh pr create`, linking the
   upstream PR in the description.
8. Mark the notification thread read:
   `gh api --method PATCH /notifications/threads/<thread_id>`

Finish with a summary: PRs opened here (with links), PRs skipped and why, and
anything left unread in the inbox (e.g. unmerged upstream PRs).

## Translation table

| Upstream (TypeScript)          | Here (Ruby)                            |
| ------------------------------ | -------------------------------------- |
| `src/lib/default-config.ts`    | `lib/tailwind_merge/config.rb`         |
| `src/lib/validators.ts`        | `lib/tailwind_merge/validators.rb`     |
| `src/lib/parse-class-name.ts`  | `lib/tailwind_merge/parse_class_name.rb` |
| `src/lib/sort-modifiers.ts`    | `lib/tailwind_merge/sort_modifiers.rb` |
| `src/lib/class-group-utils.ts` | `lib/tailwind_merge/class_group_utils.rb` |
| `tests/<kebab-name>.test.ts`   | `test/test_<snake_name>.rb`            |

Idiom mapping — the port is deliberately close to a mechanical rename:

- `scaleFooBar()` helper → `SCALE_FOO_BAR` lambda constant; spread with
  `*SCALE_FOO_BAR.call` where TS uses `...scaleFooBar()`.
- `themeSpacing` / other theme getters → `THEME_SPACING` etc.
- `isNumber` and friends → `IS_NUMBER` lambda constants in `validators.rb`;
  inside `config.rb` they appear bare (the module includes `Validators`) or as
  `Validators::IS_NUMBER` — match whichever the surrounding lines use.
- Object literals → string-keyed hashes: `{ shadow: [...] }` becomes
  `{ "shadow" => [...] }`.
- vitest `expect(twMerge('a b')).toBe('b')` → Minitest
  `assert_equal("b", @merger.merge("a b"))` with `@merger` from `setup`.

When an upstream diff touches a file with no row in the table, check whether
the change is behavior (needs a Ruby home) or TypeScript plumbing (skip it,
and say so in the report). Doc-comment tweaks (like `@see` link fixes) only
apply if the Ruby file carries the same comment.

**Port to the post-PR state.** If the surrounding Ruby code doesn't match
what the upstream diff shows as the "before", the port has drifted — an
earlier upstream change was missed. Don't apply just the PR's delta onto the
stale code; bring the whole expression to upstream's post-PR state and call
out the extra repair in the commit body. (This happened with the `columns`
group, which had drifted to matching only t-shirt sizes while upstream had
long since moved to numbers + the container scale.)

## Sweep mode (optional)

Notifications are ephemeral — if the user dismissed some, merged upstream work
can slip through. When the user asks for a "sweep" or suspects gaps, also
cross-check recent merged upstream PRs against the trailer markers:

```bash
gh pr list -R dcastil/tailwind-merge --state merged --limit 20 --json number,title,mergedAt,url
```

Any PR without a matching `Ports dcastil/tailwind-merge#<N>` commit joins the
triage report (there's no notification thread to mark read for these).
