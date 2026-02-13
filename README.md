"# Security Scanning Demo 🔒

A comprehensive demonstration of automated security scanning in CI/CD pipelines using GitHub Actions. This project showcases how to detect vulnerabilities using multiple security scanning tools including SCA (Software Composition Analysis), DAST (Dynamic Application Security Testing), and container image scanning.

## 🎯 Demo Overview

This demo demonstrates enterprise-grade security scanning capabilities integrated into a GitHub Actions workflow. Each security scanning tool detects different types of vulnerabilities in your application stack.

## 🛡️ Security Scanning Types

### 1. **SCA (Software Composition Analysis) Scan** 🔍
**Purpose:** Detects vulnerabilities in third-party dependencies and open source libraries.

**Tool Used:** GitHub Dependency Review Action  
**Triggers on:** Dependencies with known CVEs

**Demo Scenario - Create PR with vulnerable dependencies:**
```gradle
dependencies {
    // Add these vulnerable JavaScript dependencies to package.json
    implementation('minimist:1.2.5')        // Critical: Prototype Pollution
    implementation('underscore:1.12.0')     // Critical: Arbitrary Code Execution  
    implementation('lodash:4.17.20')        // High: Command Injection + Multiple moderate issues
    implementation('express:4.17.1')       // Moderate: Open Redirect vulnerability
}
```

### 2. **DAST (Dynamic Application Security Testing) Scan** 🌐
**Purpose:** Tests running web applications for security vulnerabilities like XSS, SQL injection, and insecure configurations.

**Tool Used:** OWASP ZAP Baseline Scanner  
**Triggers on:** Insecure web application configurations

**Demo Scenario - Add insecure cookie handling:**

In your request handler, add this vulnerable code:
```java
// INSECURE: Cookie without SameSite attribute - ZAP will detect this
exchange.getResponseHeaders().add("Set-Cookie", "landingVisit=true; Path=/; Max-Age=3600");
```

**Expected DAST Findings:**
- Missing SameSite cookie attribute
- Potentially other web security misconfigurations

### 3. **Container Image Vulnerability Scan (Trivy)** 📦
**Purpose:** Scans container images and source code for OS vulnerabilities, library issues, and misconfigurations.

**Tool Used:** Trivy Scanner  
**Triggers on:** Vulnerable OS packages, outdated libraries, container misconfigurations

**Demo Scenario - Use vulnerable library:**
```gradle
dependencies {
    // This version from 2013 has known vulnerabilities
    implementation("commons-collections:commons-collections:3.2.1")
}
```

### 4. **Secret Detection** 🔐
**Purpose:** Prevents hardcoded secrets, API keys, and credentials from being committed to version control.

**Tool Used:** GitHub Secret Scanning (built-in)  
**Triggers on:** Hardcoded API keys, database passwords, certificates

## 🚀 Getting Started

### Prerequisites
- JDK 25+ installed
- Docker installed  
- GitHub account with Actions enabled

### Local Development
```bash
# Build the application
./gradlew build

# Run locally
./gradlew run

# Access the app
curl http://localhost:7070
```

### Docker Usage
```bash
# Build image
docker build -t security-demo .

# Run container
docker run -p 7070:7070 security-demo

# Test application
curl http://localhost:7070
```

## 🔄 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/on-pull-request.yml`) automatically triggers on:
- Pull requests to `main` branch
- Direct pushes to `main` branch

### Pipeline Stages:
1. **Build & Package** - Builds application and creates Docker image
2. **SCA Scan** - Reviews dependencies for vulnerabilities
3. **Container Scan** - Analyzes Docker image with Trivy
4. **DAST Scan** - Tests running application with ZAP

## 📊 Security Scan Results

### SCA Scan Results
- ✅ **PASS**: All dependencies are secure
- ❌ **FAIL**: Critical/High vulnerabilities detected in dependencies

### DAST Scan Results  
- ✅ **PASS**: No web application vulnerabilities found
- ❌ **FAIL**: XSS, injection, or configuration issues detected

### Container Scan Results
- ✅ **PASS**: Container image is secure
- ❌ **FAIL**: OS vulnerabilities or risky configurations found

## 🔧 Configuration

### Customizing Security Scans

**SCA Scan Configuration:**
```yaml
# .github/workflows/on-pull-request.yml
- name: Dependency Review
  with:
    fail-on-severity: moderate  # Set threshold
    deny-licenses: GPL-2.0, LGPL-2.0  # Block specific licenses
```

**DAST Scan Configuration:**
```yaml
# ZAP Baseline Scan options
cmd_options: '-a'  # Include additional tests
rules_file_name: '.zap/rules.tsv'  # Custom rules
```

**Trivy Scan Configuration:**
```yaml
# Container vulnerability scanning
severity: "CRITICAL,HIGH,MEDIUM"  # Set severity threshold
vuln-type: 'os,library'  # Scan types
```

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Source Code   │───▶│  GitHub Actions  │───▶│  Security Scans │
│                 │    │                  │    │                 │
│ • Java App      │    │ • Build          │    │ • SCA           │
│ • Dependencies  │    │ • Test           │    │ • DAST          │
│ • Dockerfile    │    │ • Package        │    │ • Container     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 📈 Demo Scenarios

### Scenario 1: Clean Build (All Scans Pass)
- Fresh repository with secure dependencies
- All security scans should pass ✅

### Scenario 2: SCA Failure  
- Add vulnerable JavaScript dependencies 
- SCA scan fails with dependency vulnerabilities ❌

### Scenario 3: DAST Failure
- Add insecure cookie configuration
- DAST scan fails with web security issues ❌

### Scenario 4: Container Scan Failure
- Use outdated, vulnerable libraries
- Trivy scan fails with container vulnerabilities ❌

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Ensure all security scans pass (or intentionally fail for demo)
5. Submit a pull request

## 📝 License

This project is used for educational and demonstration purposes.

---

**⚡ Pro Tip:** This demo is designed for security training. In production environments, always address security findings immediately and never intentionally introduce vulnerabilities." 
