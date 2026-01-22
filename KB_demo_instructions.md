# GitHub DevSecOps POC - Demo Instructions 

**Client:** KarnatakaBank  
**Objective:** Demonstrate GitHub as a consolidated DevSecOps platform  

---

## Executive Summary

This POC demonstrates how GitHub can serve as a **unified DevSecOps platform** consolidating:
- CI/CD pipelines for applications and infrastructure
- Comprehensive security scanning (SAST, DAST, IAST, SCA)
- Artifact & package management (Java, containers, NPM, DLLs)
- Infrastructure as Code automation (Terraform, Ansible)
- Enterprise security controls and governance

---

## Demo Structure

### Phase 1: Platform Consolidation Overview 
### Phase 2: Infrastructure DevSecOps
### Phase 3: Application DevSecOps & Security
### Phase 4: Artifact & Package Management
### Phase 5: Security Controls & Governance

---

## PHASE 1: Platform Consolidation Overview

### What to Show:

1. **GitHub's Unified Platform Benefits**
   ```
   ✅ Single platform for: Code → Build → Test → Security → Deploy
   ✅ Native integrations (no middleware required)
   ✅ Reduced tool sprawl & licensing complexity
   ✅ Single pane of glass for all DevSecOps activities
   ```

2. **Open Repository Structure**
   - Show the current project structure
   - Navigate to: https://github.com/[org]/KarnatakaBank
   - Highlight the integrated workflows

3. **Key Message:**
   > "Instead of managing separate tools for Git, CI/CD, security scanning, artifact storage, and IaC automation, GitHub provides all of these natively or with seamless integrations."

---

## PHASE 2: Infrastructure DevSecOps (Terraform & Ansible)

### Objective: Address requirement #2 - Infrastructure automation

### Demo Steps:

1. **Show Terraform Integration**
   
   Navigate to: `.github/workflows/terraform-deploy.yml`
   
   **Key Points:**
   - Automated Terraform plan/apply workflows
   - State management with remote backend
   - Multi-environment deployments (dev/staging/prod)
   - Cost estimation before apply
   - Security scanning of infrastructure code

2. **Show Ansible Integration**
   
   Navigate to: `.github/workflows/ansible-deploy.yml`
   
   **Key Points:**
   - Automated playbook execution
   - Inventory management per environment
   - Secrets management via GitHub Secrets/Vault
   - Idempotency checks and dry-run capabilities

3. **Infrastructure Security Scanning**
   
   Point to: `.github/workflows/security-sast-sca.yml`
   
   **Explain:**
   - Trivy scans Terraform/Ansible for misconfigurations
   - Checkov/tfsec for IaC security (can be added)
   - SARIF results uploaded to Security tab

### Live Demo Action:

```bash
# In terminal, show workflow trigger
cd $HOME/Demos/KarnatakaBank

# Show Terraform workflow
cat .github/workflows/terraform-*.yml 2>/dev/null || echo "Create Terraform workflow during demo"

# Trigger workflow (if configured)
gh workflow run infrastructure-deploy.yml --field environment=staging
```

### Talking Points:
- ✅ **Single pipeline** for infrastructure changes
- ✅ **Automated compliance checks** before deployment
- ✅ **Audit trail** of all infrastructure changes
- ✅ **No separate Jenkins/GitLab CI** required

---

## PHASE 3: Application DevSecOps & Security Scanning

### Objective: Address requirement #3 & #4 - Comprehensive security scanning

### 3A. Show SAST (Static Application Security Testing)

Navigate to: `.github/workflows/security-sast-sca.yml`

**Demonstrate:**
1. **GitHub CodeQL** (Native - FREE for public repos)
   - Show line: `uses: github/codeql-action/init@v3`
   - Open: Security tab → Code scanning alerts
   - **Key:** "This is GitHub's native SAST - no third-party cost"

2. **Multiple SAST Engines Running in Parallel**
   ```yaml
   Jobs:
   - codeql-analysis (GitHub Native)
   - semgrep-sast (Optional)
   - sonarqube-sast (Optional)
   - snyk-sca (Comprehensive)
   ```

3. **Show SARIF Results**
   - Navigate to: Security → Code scanning
   - Show vulnerability findings
   - Demonstrate how to dismiss false positives

### 3B. Show SCA (Software Composition Analysis)

**Demonstrate:**
1. **Dependabot** (Native - FREE)
   - Navigate to: `.github/dependabot.yml`
   - Show: Security → Dependabot alerts
   - **Key:** "Automatic dependency updates with security fixes"

2. **Dependency Review** (Native)
   - Show in workflow: `dependency-review-action`
   - **Key:** "Blocks PRs with vulnerable dependencies"


### 3C. Show DAST (Dynamic Application Security Testing)

Navigate to: `.github/workflows/security-dast.yml`

**Demonstrate:**
1. **OWASP ZAP Integration**
   - Baseline, Full, and API scanning
   - Scheduled weekly scans
   - Manual trigger capability

2. **Live Demo:**
   ```bash
   # Trigger DAST scan
   gh workflow run security-dast.yml \
     --field target_url=https://staging.karnataka-bank.com
   ```

3. **Show Results:**
   - Actions → Download artifacts → ZAP reports
   - HTML, JSON, and Markdown reports

### 3D. Show IAST (Interactive Application Security Testing)

Navigate to: `.github/workflows/security-iast.yml`

**Demonstrate:**
1. **Runtime Security Analysis**
   - Contrast Security integration
   - Seeker integration
   - Falco for container runtime security

2. **Key Differentiator:**
   > "IAST runs during functional testing, catching issues that SAST/DAST miss by analyzing actual runtime behavior"

### 3E. Consolidated Security Dashboard

Navigate to: `.github/workflows/security-dashboard.yml`

**Demonstrate:**
1. **Trigger all scans with one click**
2. **Consolidated HTML dashboard**
3. **GitHub Security Overview tab** - single pane of glass

### Live Demo:

```bash
# Show all security workflows
ls -la .github/workflows/security-*.yml

# Trigger comprehensive scan
gh workflow run security-dashboard.yml

# Show dashboard location
echo "Dashboard will be available at:"
echo "https://[org].github.io/KarnatakaBank/security/security-dashboard.html"
```

---

## PHASE 4: Artifact & Package Management

### Objective: Address requirement #3 & #5 

### 4A. Address the Object Storage Concern

**client's Blocker:** "Need for object storage for artifact management"

**Solution Explanation:**

```
GitHub provides THREE artifact management solutions:

1. GitHub Actions Artifacts (Short-term, 90 days max)
   └─ For CI/CD build outputs, test results, reports
   └─ FREE within Actions minutes quota
   └─ No separate object storage needed

2. GitHub Packages (Long-term, unlimited)
   └─ For versioned packages meant for distribution
   └─ Supports: Maven, NPM, Docker, NuGet, RubyGems
   └─ 500MB FREE, then paid storage
   └─ No separate object storage infrastructure needed

3. GitHub Releases (Permanent)
   └─ For production binaries and release assets
   └─ Attached to Git tags
   └─ Unlimited storage for releases
```

### 4B. Demonstrate Each Type

#### Demo 4B-1: GitHub Actions Artifacts (Short-term)

Navigate to: `.github/workflows/deploy.yml` (lines 44-51)

```yaml
- name: Upload build artifacts
  uses: actions/upload-artifact@v4
  with:
    name: build-artifacts
    path: artifacts/
    retention-days: 30  # ← Short-term storage
```

**Show in UI:**
- Actions → Any workflow run → Artifacts section
- Download artifacts directly from UI

**Explain:**
> "These are automatically stored by GitHub - no S3 bucket setup required. Perfect for temporary CI/CD outputs."

#### Demo 4B-2: GitHub Packages (Long-term)

**Create live examples for each package type:**

##### Java Artifacts (Maven/Gradle)

Create file to demonstrate: `pom.xml` or `build.gradle`

```bash
# Show Maven publishing to GitHub Packages
cat <<'EOF' > publish-java-demo.txt
<distributionManagement>
  <repository>
    <id>github</id>
    <url>https://maven.pkg.github.com/[ORG]/KarnatakaBank</url>
  </repository>
</distributionManagement>

# Publish command:
mvn deploy

# Result: Java artifacts stored in GitHub Packages
# Access: https://github.com/[ORG]/KarnatakaBank/packages
EOF
```

##### NPM Packages

Show in: `.github/workflows/npm-publish.yml` (create if needed)

```yaml
- name: Publish to GitHub Packages
  run: npm publish
  env:
    NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

##### Container Registry (Docker)

Navigate to: `.github/workflows/docker-deploy.yml` (lines 31-43)

```yaml
- name: Log in to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io  # ← GitHub Container Registry
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

**Show in UI:**
- Navigate to: Packages tab in GitHub
- Show published containers at `ghcr.io/[org]/karnataka-bank-app`

##### .NET NuGet Packages

Create example:

```bash
cat <<'EOF' > nuget-publish-example.txt
# NuGet publish to GitHub Packages

- name: Publish NuGet package
  run: |
    dotnet nuget add source \
      --username [ORG] \
      --password ${{ secrets.GITHUB_TOKEN }} \
      --store-password-in-clear-text \
      --name github "https://nuget.pkg.github.com/[ORG]/index.json"
    
    dotnet nuget push "**/*.nupkg" \
      --source github \
      --api-key ${{ secrets.GITHUB_TOKEN }}
EOF
```

#### Demo 4B-3: GitHub Releases (Permanent)

Navigate to: `.github/workflows/deploy.yml` (lines 104-125)

**Show:**
- Releases tab in GitHub UI
- Attached release assets (binaries, JARs, DLLs, etc.)
- Git tag association

### 4C. Comparison Table for client

Create visual:

```
┌────────────────────────┬─────────────────┬──────────────────┬────────────────┐
│ Artifact Type          │ Storage         │ Retention        │ Use Case       │
├────────────────────────┼─────────────────┼──────────────────┼────────────────┤
│ CI/CD Build Outputs    │ Actions         │ 90 days max      │ Temp builds    │
│ Test Results/Reports   │ Artifacts       │ Configurable     │ CI/CD pipeline │
├────────────────────────┼─────────────────┼──────────────────┼────────────────┤
│ Maven/Gradle JARs      │ GitHub Packages │ Unlimited        │ Dependencies   │
│ NPM Modules            │ GitHub Packages │ Unlimited        │ Libraries      │
│ Docker Images          │ GitHub Packages │ Unlimited        │ Containers     │
│ NuGet DLLs             │ GitHub Packages │ Unlimited        │ .NET libs      │
├────────────────────────┼─────────────────┼──────────────────┼────────────────┤
│ Production Binaries    │ Releases        │ Permanent        │ Deployments    │
│ Release Assets         │ Releases        │ Permanent        │ Downloads      │
└────────────────────────┴─────────────────┴──────────────────┴────────────────┘

NO SEPARATE OBJECT STORAGE (S3/Blob) REQUIRED ✅
```

### 4D. Live Demo Commands

```bash
# Show all artifact/package management workflows
grep -r "upload-artifact\|packages\|release" .github/workflows/

# Show package publishing examples
cat .github/workflows/docker-deploy.yml | grep -A 10 "ghcr.io"

# List all artifacts from recent runs
gh run list --limit 5
gh run view [RUN_ID] --log
```

### Key Messages for client:

✅ **No external object storage needed** - GitHub provides all storage natively  
✅ **Support for all required formats** - Java, NPM, Docker, NuGet, binaries  
✅ **Clear separation** - Short-term (Artifacts) vs Long-term (Packages/Releases)  
✅ **Free tier available** - 500MB packages, 2GB artifacts  
✅ **Seamless authentication** - Uses same GitHub credentials  

### 5D. Security Controls Dashboard

**Demonstrate:**

1. **Security Overview**
   - Navigate to: Security → Overview
   - Show: Dependabot alerts, Code scanning, Secret scanning

2. **Security Policies**
   - Show: `SECURITY.md` file (created earlier)
   - Explain: Coordinated disclosure process

3. **Secret Scanning**
   - Navigate to: Settings → Code security
   - Enable: Secret scanning
   - Show: Push protection (prevents secrets in commits)

4. **Audit Logs**
   - Navigate to: Organization → Settings → Audit log
   - Show: All access, changes, deployments logged

## Technical Setup Instructions

### 1. Verify All Workflows Exist

```bash
cd $HOME/Demo/KarnatakaBank

# List all workflows
ls -la .github/workflows/

# Expected files:
# - deploy.yml
# - docker-deploy.yml
# - aws-deploy.yml
# - security-sast-sca.yml
# - security-dast.yml
# - security-iast.yml
# - security-dashboard.yml
```

### 2. Create Infrastructure Workflows (If Needed)

If Terraform/Ansible workflows don't exist, create them during demo prep:

```bash
# These will be created in the next step if client specifically asks
# For now, explain the concept using existing workflows as templates
```

### 3. Set Up GitHub UI for Demo

Open these tabs before demo:
1. Repository home page
2. Actions tab
3. Security tab → Code scanning
4. Security tab → Dependabot
5. Packages tab
6. Settings → Branches
7. Organization settings (if admin)

### 4. Prepare Demo Data

```bash
# Trigger some workflows to have artifacts
gh workflow run security-sast-sca.yml
gh workflow run deploy.yml

# Wait for completion
gh run list --limit 5

# Verify artifacts exist
gh run view [RUN_ID]
```

---

## Success Criteria

By the end of the demo, client should:

✅ Understand GitHub can consolidate multiple DevSecOps tools  
✅ See live examples of SAST, DAST, IAST, and SCA  
✅ Know that object storage is NOT required (GitHub provides native storage)  
✅ Understand artifact vs package management differences  
✅ See branch protection and security controls in action   
✅ Be ready to move forward with GitHub evaluation/POC  

---
