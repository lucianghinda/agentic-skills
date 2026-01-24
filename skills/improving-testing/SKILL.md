---
name: improving-testing
description: Produces practical, risk-based testing guidance and minimal test plans for features or changes. Use when user asks what to test, how to pick test cases (boundaries, permissions, state machines), how to improve weak tests, or to review existing tests. Covers equivalence partitions, boundary values, decision tables, and state transitions.
---

# Improving Testing

## When to Use
Use when user asks:
- "What should I test for this feature?"
- "How do I test edge cases?"
- "Review my tests"
- "What cases am I missing?"
- "Help me pick test cases"
- "How to test validation/permissions/state machines?"

## Do NOT Use When
- User wants to run existing tests (use terminal)
- User wants test code generation without design planning
- User asks about test framework setup or tooling
- User asks about CI/CD pipeline configuration

## Inputs (ask if missing)
- Feature in one sentence
- Biggest risks (user harm, money, trust, security)
- Inputs and constraints (types, ranges, formats)
- Roles and permissions
- States and transitions

If unknown, assume and state assumptions.

## Workflow

### Step 1: Define the goal
Pick the primary goal:
- Verify requirement
- Document behavior
- Prevent regressions in risky areas

### Step 2: Identify risks
List 3 to 7 risks. Prefer:
- Permissions, security, privacy
- Money and data integrity
- Complex branching logic
- Stateful behavior
- Boundary and validation failures

### Step 3: Design cases before writing tests
Pick the technique that matches the problem:
- **Equivalence classes**: representative per group
- **Boundary values**: min, max, just below, just above
- **Decision table**: combinations of conditions
- **State transitions**: allowed and forbidden transitions

For each rule, include:
- One positive case
- One negative case
- One edge case (boundary, empty, null, max length, weird chars)

Write each test idea as:
- Preconditions
- Inputs
- Action
- Expected result (oracle)

### Step 4: Plan test data
For each case, define representative data:
- One value per equivalence class
- Boundary values for ranges and lengths
- Clearly named examples (avoid random data)

### Step 5: Review and harden the tests
Check each test for:
- **Correctness**: matches requirement and risk
- **Strength**: fails for the right reason
- **Relevance**: covers risky paths, not only happy path
- **Determinism**: no time, randomness, network, ordering leaks
- **Maintainability**: clear setup, focused assertions, minimal noise
- **Gaps**: which risks have zero tests?
- **Redundancy**: which tests repeat the same behavior?

Never weaken assertions just to make the test pass. Fix the code or redesign the test.

### Step 6: Coverage guidance
- Line coverage is a baseline
- Prefer decision or branch coverage for branching logic
- Raise coverage mainly in high risk areas

## Output Format
1. Rules applied
2. Mini test plan
3. Smallest useful set of cases
4. Review notes (only if tests provided)
5. Bug report (only if failure reported)

## Rules Checklist

1. **Start with risk.** Test what could hurt users, money, or trust.

2. **Write the test idea before the test code.** A sentence like: "If X, then Y, because Z risk."

3. **Always include: positive, negative, edge.** Do not stop at happy path.

4. **Use partitions and boundaries.** Pick one representative per group, then test edges.

5. **When conditions combine, use a decision table.** Map the combinations, then pick the smallest set that covers the rules.

6. **When behavior changes by state, test transitions.** Test one allowed and one forbidden transition.

7. **One test, one point.** Split mixed tests.

8. **Name tests by behavior.** Use "when ... it ..." naming.

9. **Assert outcomes, not steps.** Prefer results and side effects over internal calls.

10. **Keep tests deterministic.** Avoid time, randomness, network calls, and order dependence.

11. **Regularly check gaps and redundancy.** Add missing tests for risky rules. Remove duplicates that prove the same thing.

## Examples

### Example 1: Validation with boundaries

**Rules applied:**
- Always include: positive, negative, edge
- Test the edges first

**Mini test plan:**
- Feature: User age must be 18+
- Risks: underage access, off-by-one bug
- Technique: Boundary values

**Smallest useful set of cases:**
| Input | Expected | Type |
|-------|----------|------|
| age 18 | accepted | positive |
| age 17 | rejected | negative |
| age missing | rejected | edge |

**Review notes:**
Assert the validation error, not a generic success response.

---

### Example 2: Permissions with roles

**Rules applied:**
- Test risky actions (delete, refund, export)
- Use a small decision table

**Mini test plan:**
- Feature: Only admins can delete posts
- Risks: unauthorized data loss
- Technique: Decision table (role x action)

**Smallest useful set of cases:**
| Actor | Action | Expected | Type |
|-------|--------|----------|------|
| admin | delete | allowed | positive |
| non-admin | delete | forbidden | negative |
| unauthenticated | delete | forbidden | edge |

**Review notes:**
Assert status and side effect (record removed), not internal method calls.

---

### Example 3: Combined conditions (decision table)

**Rules applied:**
- Map combinations, do not guess
- Assert the final outcome

**Mini test plan:**
- Feature: Discount applies when (member AND cart >= 100) OR promo_code valid
- Risks: wrong price charged
- Technique: Decision table

**Smallest useful set of cases:**
| Member | Cart | Promo | Expected | Type |
|--------|------|-------|----------|------|
| yes | 100 | - | discount | positive |
| yes | 99 | - | no discount | edge |
| no | 20 | valid | discount | positive |
| no | 200 | invalid | no discount | negative |

**Review notes:**
Assert final price, not intermediate flags.

---

### Example 4: State transitions

**Rules applied:**
- Test one allowed and one forbidden transition
- State bugs are common regressions

**Mini test plan:**
- Feature: Invoice can be paid only if issued
- Risks: invalid financial state
- Technique: State transitions

**Smallest useful set of cases:**
| From State | Action | Expected | Type |
|------------|--------|----------|------|
| issued | pay | allowed | positive |
| draft | pay | forbidden | negative |
| paid | pay again | forbidden | edge |

**Review notes:**
Assert final state and single payment record.

---

### Example 5: Bug report format

When user reports a failure, produce a bug report:

```
Title: [Brief description]
Environment: [OS, browser, version]
Preconditions: [Required state before reproducing]
Steps to reproduce:
  1. ...
  2. ...
Expected result: [What should happen]
Actual result: [What actually happened]
Severity: [Critical/High/Medium/Low]
Notes / logs: [Relevant error messages or logs]
```
