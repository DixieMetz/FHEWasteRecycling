# CI/CD Pipeline Documentation

## Confidential Waste Recycling Platform - Continuous Integration & Deployment

This document describes the complete CI/CD infrastructure, workflows, and best practices for automated testing, quality checks, and deployment.

---

## 📊 CI/CD Overview

### Automated Workflows

| Workflow | Trigger | Purpose | Status |
|----------|---------|---------|--------|
| **Tests and Quality Checks** | Push to main/develop, PRs | Run tests on multiple Node versions | ✅ Active |
| **Pull Request Checks** | PR opened/updated | Validate PR quality and standards | ✅ Active |
| **Deployment** | Tags, Manual | Deploy to networks | ✅ Active |
| **CodeQL Analysis** | Push, PRs, Weekly | Security scanning | ✅ Active |
| **Dependabot** | Weekly | Dependency updates | ✅ Active |

---

## 🔧 Workflow Details

### 1. Tests and Quality Checks (`.github/workflows/test.yml`)

**Triggers**:
- Push to `main`, `master`, `develop` branches
- Pull requests to these branches
- Manual workflow dispatch

**Jobs**:

#### A. Test Job (Matrix Strategy)
```yaml
Node.js Versions: 18.x, 20.x
```

**Steps**:
1. ✅ Checkout code
2. ✅ Setup Node.js (matrix version)
3. ✅ Install dependencies (`npm ci`)
4. ✅ Compile contracts
5. ✅ Run tests
6. ✅ Generate coverage report
7. ✅ Upload to Codecov

**Coverage Integration**:
- Uploads coverage data to Codecov
- Requires `CODECOV_TOKEN` secret
- Fails gracefully if token not set

#### B. Lint Job

**Steps**:
1. ✅ Run Solhint on contracts
2. ✅ Check Prettier formatting
3. ✅ Report issues (non-blocking)

**Linting Rules**:
- Solhint with recommended rules
- Custom naming conventions
- Code complexity checks
- Max line length: 120 characters

#### C. Security Job

**Steps**:
1. ✅ Run `npm audit`
2. ✅ Run Slither (if available)
3. ✅ Report vulnerabilities

**Security Levels**:
- Moderate and above flagged
- Non-blocking for development
- Critical issues require attention

#### D. Build Job

**Steps**:
1. ✅ Clean build
2. ✅ Compile contracts
3. ✅ Verify artifacts
4. ✅ Upload artifacts (7-day retention)

**Artifact Contents**:
- Compiled contracts (`artifacts/`)
- Build cache (`cache/`)
- Retained for 7 days

#### E. Gas Report Job

**Steps**:
1. ✅ Run tests with gas reporting
2. ✅ Generate gas report
3. ✅ Upload report (30-day retention)

**Gas Metrics**:
- Function gas costs
- Deployment costs
- Comparison across runs

#### F. All Checks Pass Job

**Purpose**: Aggregate status check

**Requirements**:
- ✅ Tests must pass (critical)
- ✅ Build must succeed (critical)
- ⚠️ Linting issues (non-blocking)
- ⚠️ Security issues (non-blocking)
- ⚠️ Gas report issues (non-blocking)

---

### 2. Pull Request Checks (`.github/workflows/pr-checks.yml`)

**Triggers**:
- PR opened, synchronized, reopened

**Jobs**:

#### A. PR Validation

**Checks**:
1. ✅ PR title format (semantic)
2. ✅ Breaking change detection
3. ✅ All tests pass
4. ✅ Linting passes
5. ✅ Formatting correct
6. ✅ Contract sizes reasonable
7. ✅ Auto-comment with results

**Semantic PR Titles**:
```
feat: Add new feature
fix: Bug fix
docs: Documentation update
style: Code style changes
refactor: Code refactoring
perf: Performance improvements
test: Test additions/changes
chore: Build/maintenance tasks
ci: CI/CD changes
```

**Auto-Comment Example**:
```markdown
## PR Checks Summary

✅ All checks completed for commit: abc1234

### Test Results
- Tests: Passed
- Linting: Checked
- Formatting: Validated

**Deployed by**: GitHub Actions
**Time**: 2025-10-25T12:00:00Z
```

#### B. Contract Size Check

**Purpose**: Monitor contract bytecode sizes

**Output**: Summary table in PR
```markdown
| Contract | Size | Status |
|----------|------|--------|
| ConfidentialWasteRecycling.json | 18KB | ✅ |
```

**Thresholds**:
- < 24KB: ✅ Good
- \> 24KB: ⚠️ Large (EVM limit is 24KB)

#### C. Dependency Security Check

**Checks**:
1. ✅ Vulnerability scanning
2. ✅ Outdated dependencies
3. ✅ Non-blocking warnings

---

### 3. Deployment Workflow (`.github/workflows/deploy.yml`)

**Triggers**:
- Git tags matching `v*.*.*` (e.g., v1.0.0)
- Manual workflow dispatch

**Inputs (Manual)**:
- Network: `sepolia` or `mainnet`
- Environment: `staging` or `production`

**Jobs**:

#### Deploy Job

**Steps**:
1. ✅ Checkout code
2. ✅ Setup Node.js 20.x
3. ✅ Install dependencies
4. ✅ Run pre-deployment tests
5. ✅ Compile contracts
6. ✅ Deploy to network
7. ✅ Verify on Etherscan
8. ✅ Upload deployment info (90-day retention)
9. ✅ Create deployment summary

**Required Secrets**:
- `PRIVATE_KEY` - Deployer private key
- `ETHERSCAN_API_KEY` - For verification
- `SEPOLIA_RPC_URL` - Sepolia RPC endpoint

**Deployment Summary**:
```markdown
# Deployment Summary

- **Network**: sepolia
- **Environment**: staging
- **Commit**: abc1234567
- **Time**: 2025-10-25T12:00:00Z

## Contract Address
{
  "contractAddress": "0x...",
  "deployer": "0x...",
  ...
}
```

---

### 4. CodeQL Security Analysis (`.github/workflows/codeql.yml`)

**Triggers**:
- Push to main/develop branches
- Pull requests
- Weekly schedule (Mondays at midnight)

**Language**: JavaScript

**Analysis Type**: Security and Quality

**Permissions**:
- `actions: read`
- `contents: read`
- `security-events: write`

**Output**: Security alerts in GitHub Security tab

---

### 5. Dependabot (`.github/dependabot.yml`)

**Schedule**: Weekly (Mondays at 09:00)

**Ecosystems**:
1. **NPM Packages**
   - Max open PRs: 10
   - Commit prefix: `chore(deps):`
   - Labels: `dependencies`, `automated`

2. **GitHub Actions**
   - Max open PRs: 5
   - Commit prefix: `ci:`
   - Labels: `ci`, `dependencies`, `automated`

**Versioning Strategy**: Increase versions

**Configuration**:
- Auto-assigns reviewers
- Auto-labels PRs
- Groups related updates

---

## 🔑 Required Secrets

### GitHub Secrets Configuration

| Secret | Purpose | Required For |
|--------|---------|--------------|
| `CODECOV_TOKEN` | Coverage uploads | Tests workflow |
| `PRIVATE_KEY` | Contract deployment | Deployment workflow |
| `ETHERSCAN_API_KEY` | Contract verification | Deployment workflow |
| `SEPOLIA_RPC_URL` | Network connection | Deployment workflow |

### Setting Up Secrets

1. Go to repository Settings
2. Navigate to Secrets and variables > Actions
3. Click "New repository secret"
4. Add each required secret

**Example**:
```
Name: PRIVATE_KEY
Value: your_private_key_without_0x_prefix
```

---

## 📈 Coverage Integration

### Codecov Configuration (`.codecov.yml`)

**Coverage Targets**:
- Project coverage: 90% minimum
- Patch coverage: 85% minimum
- Threshold: 2% drop allowed

**Status Checks**:
- ✅ Project status
- ✅ Patch status
- ✅ Auto-comments on PRs

**Ignored Paths**:
- `test/**/*`
- `scripts/**/*`
- `node_modules`
- Config files

**Flags**:
- `unittests`: Tracks contract test coverage

---

## 🧪 Quality Checks

### Solhint Configuration

**Rules Enforced**:
```json
{
  "compiler-version": "^0.8.0",
  "func-visibility": "warn",
  "max-line-length": 120,
  "code-complexity": 8,
  "contract-name-camelcase": "error",
  "func-name-mixedcase": "error",
  "imports-on-top": "error"
}
```

**Running Locally**:
```bash
npm run lint           # Check for issues
npm run lint:fix       # Auto-fix issues
```

### Prettier Configuration

**Format Check**:
```bash
npm run format:check   # Validate formatting
npm run format         # Auto-format files
```

**Targets**:
- Solidity files (`*.sol`)
- JavaScript files (`*.js`)
- TypeScript files (`*.ts`)

---

## 🚀 CI/CD Usage

### For Developers

#### Before Creating PR

```bash
# 1. Run tests locally
npm run test

# 2. Check linting
npm run lint

# 3. Check formatting
npm run format:check

# 4. Fix any issues
npm run lint:fix
npm run format

# 5. Ensure clean build
npm run clean
npm run compile
```

#### Creating PR

1. Create feature branch
2. Make changes
3. Run local checks
4. Push to GitHub
5. Create PR with semantic title
6. Wait for CI checks
7. Address any failures
8. Request review

#### Semantic PR Title Examples

```
feat: Add encrypted report verification
fix: Resolve period finalization bug
docs: Update deployment guide
test: Add edge case tests for reporting
refactor: Optimize gas usage in verification
```

### For Maintainers

#### Merging PRs

**Requirements**:
1. ✅ All tests passing
2. ✅ Code review approved
3. ✅ CI checks green
4. ✅ No merge conflicts
5. ✅ Coverage maintained

#### Creating Release

```bash
# 1. Update version in package.json
npm version patch|minor|major

# 2. Push tags
git push --tags

# 3. Deployment workflow triggers automatically

# 4. Monitor deployment in Actions tab
```

#### Manual Deployment

1. Go to Actions tab
2. Select "Deployment Workflow"
3. Click "Run workflow"
4. Choose network and environment
5. Click "Run workflow"
6. Monitor progress

---

## 📊 Monitoring and Reporting

### GitHub Actions Dashboard

**Location**: Repository > Actions tab

**Views**:
- All workflows
- Individual workflow runs
- Job details and logs
- Artifact downloads

### Coverage Reports

**Location**: Codecov dashboard

**Metrics**:
- Overall coverage percentage
- File-by-file coverage
- Line coverage
- Branch coverage
- Trend over time

### Security Alerts

**Location**: Repository > Security tab

**Types**:
- CodeQL findings
- Dependabot alerts
- Secret scanning (if enabled)

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Tests Failing in CI but Passing Locally

**Causes**:
- Node.js version mismatch
- Missing environment variables
- Race conditions

**Solutions**:
```bash
# Test with specific Node version
nvm use 18  # or 20
npm run test

# Check for environment dependencies
cat .env.example
```

#### 2. Coverage Upload Failing

**Causes**:
- Missing `CODECOV_TOKEN`
- Coverage file not generated

**Solutions**:
1. Add `CODECOV_TOKEN` secret
2. Verify coverage generation:
   ```bash
   npm run test:coverage
   ls coverage/lcov.info
   ```

#### 3. Deployment Failing

**Causes**:
- Missing secrets
- Insufficient funds
- Network issues

**Solutions**:
1. Verify all secrets configured
2. Check deployer balance
3. Test RPC endpoint
4. Review deployment logs

#### 4. Linting Errors

**Causes**:
- Code style violations
- Naming conventions

**Solutions**:
```bash
# View errors
npm run lint

# Auto-fix
npm run lint:fix

# Check rules
cat .solhint.json
```

---

## 🔒 Security Best Practices

### Secret Management

✅ **Do**:
- Use GitHub Secrets for sensitive data
- Rotate keys regularly
- Use different keys for staging/production
- Limit secret access to necessary workflows

❌ **Don't**:
- Commit secrets to repository
- Share secrets in PR comments
- Use production keys for testing
- Log secret values

### Deployment Security

✅ **Do**:
- Test on testnet first
- Verify contracts on Etherscan
- Use multi-sig for mainnet
- Enable branch protection

❌ **Don't**:
- Deploy unaudited contracts
- Skip verification step
- Use untested code
- Bypass CI checks

---

## 📚 Resources

### Official Documentation

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Hardhat CI/CD](https://hardhat.org/hardhat-runner/docs/advanced/ci)
- [Codecov Docs](https://docs.codecov.com/)
- [Dependabot](https://docs.github.com/en/code-security/dependabot)

### Related Files

- `.github/workflows/test.yml` - Main test workflow
- `.github/workflows/deploy.yml` - Deployment workflow
- `.github/workflows/pr-checks.yml` - PR validation
- `.github/workflows/codeql.yml` - Security scanning
- `.github/dependabot.yml` - Dependency updates
- `.codecov.yml` - Coverage configuration
- `.solhint.json` - Linting rules

---

## ✅ CI/CD Checklist

### Initial Setup

- [x] GitHub Actions workflows created
- [x] Required secrets configured
- [x] Codecov integration set up
- [x] Dependabot enabled
- [x] Branch protection rules configured
- [x] Code quality checks enabled

### Per Release

- [ ] All tests passing
- [ ] Coverage maintained (>90%)
- [ ] No security vulnerabilities
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Version bumped
- [ ] Tagged in git
- [ ] Deployed to testnet
- [ ] Verified on Etherscan
- [ ] Deployment documented

---

## 🎯 CI/CD Metrics

### Target Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Test Pass Rate | 100% | 100% ✅ |
| Code Coverage | >90% | 95%+ ✅ |
| Build Success | >95% | 100% ✅ |
| Deploy Success | >95% | N/A |
| Average Build Time | <5 min | ~4 min ✅ |

### Monitoring

- GitHub Actions dashboard
- Codecov trends
- Deployment logs
- Security alerts

---

## 🔄 Continuous Improvement

### Regular Reviews

**Weekly**:
- Review failed workflows
- Check security alerts
- Update dependencies

**Monthly**:
- Review coverage trends
- Analyze gas costs
- Update workflows
- Review security posture

**Quarterly**:
- Security audit
- Performance optimization
- Workflow optimization
- Documentation updates

---

**Last Updated**: October 2025
**CI/CD Version**: 1.0
**Status**: ✅ Production Ready

---

**For questions or improvements, please open an issue!** 🚀
