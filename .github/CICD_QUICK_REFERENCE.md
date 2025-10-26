# CI/CD Quick Reference

## ⚡ Quick Start Guide

### What's Automated?

Every time you **push to main/develop** or **create a PR**, these workflows run automatically:

```
✅ Tests (Node 18.x & 20.x)
✅ Code Quality Checks
✅ Security Scans
✅ Coverage Upload
✅ Gas Reporting
```

---

## 📁 Workflow Files

| File | Purpose | Triggers |
|------|---------|----------|
| `test.yml` | Main tests & quality | Push, PR |
| `pr-checks.yml` | PR validation | PRs only |
| `deploy.yml` | Deployment | Tags, Manual |
| `codeql.yml` | Security scan | Push, PR, Weekly |

---

## 🚀 Common Commands

### Run Locally (Before Push)
```bash
npm run test              # Run tests
npm run test:coverage     # Generate coverage
npm run lint              # Check linting
npm run lint:fix          # Fix linting
npm run format:check      # Check formatting
npm run format            # Fix formatting
```

### Check CI Status
```bash
# View workflows
gh workflow list

# View recent runs
gh run list

# Watch latest run
gh run watch
```

---

## 🎯 CI/CD Features

### ✅ Automated Testing
- Runs on **every push** to main/develop
- Runs on **all pull requests**
- Tests on **Node 18.x & 20.x**
- Uploads coverage to **Codecov**

### ✅ Code Quality
- **Solhint** linting (20+ rules)
- **Prettier** formatting
- **Auto-formatting** available locally

### ✅ Security
- **NPM audit** on every PR
- **CodeQL** weekly scans
- **Dependency** updates via Dependabot

### ✅ Deployment
- **Tag-based** automatic deployment
- **Manual** deployment option
- **Etherscan** auto-verification

---

## 🔑 Required Secrets (Optional)

Only needed if you want to:

| Secret | For | Required? |
|--------|-----|-----------|
| `CODECOV_TOKEN` | Coverage tracking | Optional |
| `PRIVATE_KEY` | Deployment | Only for deploy |
| `ETHERSCAN_API_KEY` | Verification | Only for deploy |
| `SEPOLIA_RPC_URL` | Network | Only for deploy |

**Add secrets**: Settings → Secrets and variables → Actions

---

## 📊 What Each Workflow Does

### `test.yml` - Main Test Workflow

**6 Jobs**:
1. **Test** (Node 18.x & 20.x) - Run all tests
2. **Lint** - Code quality checks
3. **Security** - Vulnerability scans
4. **Build** - Verify compilation
5. **Gas Report** - Track gas usage
6. **All Checks** - Aggregate status

**Runtime**: ~8 minutes

### `pr-checks.yml` - PR Validation

**3 Jobs**:
1. **PR Validation** - Title, tests, quality
2. **Size Check** - Monitor contract sizes
3. **Dependency Check** - Security audit

**Runtime**: ~5 minutes

### `deploy.yml` - Deployment

**1 Job**:
- Compile, deploy, verify, archive

**Runtime**: ~10 minutes

### `codeql.yml` - Security

**1 Job**:
- JavaScript security analysis

**Runtime**: ~3 minutes

---

## ✅ Status Checks

### On Every PR

You'll see these checks:
- ✅ Tests (Node 18.x)
- ✅ Tests (Node 20.x)
- ✅ Code Quality Checks
- ✅ Security Audit
- ✅ Build Verification

**All must pass** to merge (if branch protection enabled)

---

## 🐛 Troubleshooting

### Tests Failing?
```bash
# Run locally with same Node version
nvm use 18  # or 20
npm run test
```

### Linting Errors?
```bash
npm run lint        # See errors
npm run lint:fix    # Auto-fix
```

### Formatting Issues?
```bash
npm run format:check  # See issues
npm run format        # Auto-fix
```

### Coverage Upload Failed?
- Add `CODECOV_TOKEN` secret (optional)
- Or ignore - it's non-blocking

---

## 📚 Full Documentation

- **Complete Guide**: `CI_CD.md` (3000+ lines)
- **Summary**: `CI_CD_SUMMARY.md`
- **Verification**: `CICD_VERIFICATION.md`
- **This Card**: `CICD_QUICK_REFERENCE.md`

---

## 🎓 Best Practices

### Before Creating PR
1. ✅ Run `npm run test`
2. ✅ Run `npm run lint`
3. ✅ Run `npm run format:check`
4. ✅ Fix any issues
5. ✅ Create PR with semantic title

### Semantic PR Titles
```
feat: Add new feature
fix: Bug fix
docs: Documentation
test: Add tests
refactor: Code refactoring
perf: Performance improvement
chore: Maintenance
ci: CI/CD changes
```

### During Review
- ✅ Wait for all CI checks
- ✅ Address any failures
- ✅ Respond to feedback
- ✅ Re-run checks after changes

---

## 💡 Tips

### Speed Up CI
- Use `npm ci` instead of `npm install`
- Cache dependencies (already configured)
- Run linting locally first

### Debug Failures
- Check workflow logs in Actions tab
- Look for red X marks
- Click on failed job for details
- Run same command locally

### Coverage
- Aim for >90% coverage
- Check Codecov comments on PRs
- Improve tests for red files

---

## 🚀 Quick Actions

### View Workflows
```
Repository → Actions tab
```

### Trigger Manual Deploy
```
Actions → Deploy → Run workflow
```

### Check Coverage
```
codecov.io/gh/your-org/repo
```

### View Security Alerts
```
Repository → Security tab
```

---

## 📞 Need Help?

1. Check `CI_CD.md` for detailed docs
2. Review workflow logs in Actions tab
3. Run commands locally to debug
4. Check configuration files

---

**CI/CD Status**: ✅ Active and Running

**Workflows**: 4
**Jobs**: 11
**Node Versions**: 18.x, 20.x
**Documentation**: Complete

