# SkillBank — Selenium test suite

40 automated test cases that drive [SkillBank](https://github.com/abedinm/skillbank) in a
real Chrome browser, screenshot every step, verify results in MySQL, and generate a
Word report from the run.

**Latest run: 40/40 passed, 107 screenshots, 68-page report.**

| Module | Cases | What it covers |
|---|---|---|
| Registration | 10 | Valid signup, blank fields, duplicate email, malformed email, password boundary at 5 and 6 characters, starting credit balance |
| Login and session | 8 | Member and admin login, wrong password, unknown email, blank fields, logout, guest hitting a protected URL |
| Skill offer CRUD | 8 | Create, validation errors, edit, deactivate, delete via confirm dialog, editing another member's offer |
| Session booking and credits | 7 | Request, self-booking guard, accept, complete with the 1-credit transfer, review, double-review guard, cancel |
| Admin panel | 7 | Admin dashboard, member and guest blocked, user list, add skill, blank skill name, delete skill |

## Files

```
selenium_suite.py   the 40 test cases and the harness that runs them
reset_db.py         reloads schema.sql and re-seeds, so every run starts identical
build_report.py     turns results.json + screenshots into the Word report
capture_window.ps1  captures a named window (used for the IDE/terminal figures)
results.json        machine-readable result of the last run
run_log.txt         console output of the last run
screenshots/        107 step screenshots, one per c.shot() call
setup_shots/        environment evidence: IDE, pip install, browser under automation, MySQL
MAC_SETUP.md        full macOS setup guide, plus a prompt that does it for you
```

## Running it

Prerequisites: Python 3.10+, Chrome, and SkillBank running on `http://localhost:8003`
with MySQL up.

```bash
pip install selenium pillow python-docx
python reset_db.py
python selenium_suite.py
python build_report.py
```

ChromeDriver is not a separate download — Selenium Manager fetches the matching driver
automatically on first run.

To watch the browser instead of running headless:

```bash
SB_HEADED=1 python selenium_suite.py
```

**On a Mac:** see [MAC_SETUP.md](MAC_SETUP.md). Three hardcoded Windows paths need
changing; nothing else is platform specific.

## How a test case is written

Each case is a function with its documentation in the decorator, so the report and the
code cannot drift apart:

```python
@case("TC_reg-04", "Registration",
      "Verify registration with a password shorter than 6 characters",
      "Verify that the minimum password length rule is enforced.",
      "The registration page is reachable.",
      "Registration module, Chrome browser",
      "Registration fails and the message \"Password must be at least 6 characters.\" "
      "is displayed.")
def reg04(c):
    c.step("Open the Registration page.")
    goto("register")
    c.shot("Registration page opened")
    ...
    errs = errors()
    assert "Password must be at least 6 characters." in errs, "errors were %r" % errs
    c.actual = "Registration blocked. Error message displayed: ..."
```

`c.step()` records a step, `c.datum()` records test data, `c.shot()` captures the whole
page through the Chrome DevTools Protocol, and `c.actual` is what appears in the Actual
Results column. A failing assertion marks the case Fail and screenshots the failure
state.

## Design notes

**Database verification.** Twenty cases read MySQL directly rather than trusting the
page. The credit-transfer test reads both balances before and after, then checks the
`transactions` table — a success message on screen cannot make it pass.

**Explicit waits, no sleeps.** Every click that navigates waits for the old document to
go stale and for `document.readyState` to reach `complete`. An earlier version used
fixed 0.35s sleeps and produced a false failure on a slow load.

**Chrome's password manager is disabled.** With default settings the "save password"
bubble appears after the first successful login and swallows the keystrokes sent to the
next login form — five login tests failed for a reason that had nothing to do with the
application.

**Deterministic data.** `reset_db.py` drops and reloads the schema before every run, so
the tests always see the same three demo accounts and two demo offers.

## How the suite was validated

- Executed three times in a row from a fresh database — 40/40 each time.
- Mutation test: the app's validation message was changed from `Name is required.` to
  `Name missing.`; TC_reg-02 correctly failed and the other 39 still passed. The app was
  then restored. A suite that cannot fail is not testing anything.

## Findings

All 40 pass, but the run surfaced three things worth noting about the app:

1. Login and registration forms have no HTML5 `required` attribute, so empty fields are
   rejected server-side rather than by the browser (TC_log-05, TC_log-06).
2. Adding a skill with a blank name is silently ignored — nothing is created, but no
   message is shown either (TC_adm-05).
3. The credit transfer is correct and atomic: learner 3 → 2, teacher 3 → 4, one row in
   `transactions` (TC_ses-04).
