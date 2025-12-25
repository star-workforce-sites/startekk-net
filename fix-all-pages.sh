#!/bin/bash

################################################################################
# STARTEKK - AUTOMATED PAGE FIXES
# 
# Updates:
# 1. Products page - Update Star AI Cloud section with patent-pending features
# 2. Star AI Finance - Remove white-on-white sections, enhance content
# 3. Star Automation - Remove white-on-white sections, add proper hero and features
#
# Windows Git Bash Compatible
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "================================================================================"
echo "🚀 STARTEKK - AUTOMATED PAGE FIXES"
echo "================================================================================"
echo ""

# Check if we're in the right directory
if [ ! -f "products.html" ] || [ ! -f "star-ai-finance.html" ] || [ ! -f "star-automation.html" ]; then
    echo -e "${RED}❌ Error: Required files not found${NC}"
    echo "Current directory: $(pwd)"
    echo "Please run from: ~/projects/startekk-net"
    exit 1
fi

echo -e "${GREEN}✓ All files found${NC}"
echo ""

# Step 1: Pull from GitHub
echo "================================================================================"
echo "📥 STEP 1: Pulling latest from GitHub"
echo "================================================================================"
echo ""

git fetch origin
git pull origin main

echo -e "${GREEN}✓ Pulled latest from GitHub${NC}"
echo ""

# Step 2: Create backups
echo "================================================================================"
echo "📦 STEP 2: Creating backups"
echo "================================================================================"
echo ""

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p backup

cp products.html "backup/products-backup-${TIMESTAMP}.html"
cp star-ai-finance.html "backup/star-ai-finance-backup-${TIMESTAMP}.html"
cp star-automation.html "backup/star-automation-backup-${TIMESTAMP}.html"

echo -e "${GREEN}✓ Backups created in backup/ directory${NC}"
echo "  - products-backup-${TIMESTAMP}.html"
echo "  - star-ai-finance-backup-${TIMESTAMP}.html"
echo "  - star-automation-backup-${TIMESTAMP}.html"
echo ""

# Step 3: Fix Products Page - Update Star AI Cloud section
echo "================================================================================"
echo "🔧 STEP 3: Updating Products Page - Star AI Cloud Section"
echo "================================================================================"
echo ""

cat > fix_products.py << 'PYTHON_EOF'
import re

with open('products.html', 'r', encoding='utf-8') as f:
    content = f.read()

# New Star AI Cloud section with patent-pending features
new_section = '''            <!-- Star AI Cloud -->
            <div class="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
                <div class="flex items-center mb-4">
                    <div class="text-3xl mr-3">☁️</div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900">Star AI Cloud</h2>
                        <p class="text-sm text-emerald-600 font-semibold">AI-Powered Multi-Cloud Cost Optimization ⚡ Patent Pending</p>
                    </div>
                </div>
                <p class="text-gray-600 mb-6">Save 30-40% on cloud costs with AI that learns from your infrastructure. Connect your AWS, Azure, and GCP accounts for autonomous validation, confidence-based approval, and self-learning cost optimization.</p>
                <ul class="space-y-2 mb-6">
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Live data access to actual cloud accounts</span>
                    </li>
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Confidence-based approval (auto-implements ≥90%)</span>
                    </li>
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Predictive cost forecasting (30-day predictions)</span>
                    </li>
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Collective intelligence from 1,000+ companies</span>
                    </li>
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Real-time event detection (60-second response)</span>
                    </li>
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Infrastructure drift detection & auto-remediation</span>
                    </li>
                    <li class="flex items-start">
                        <svg class="w-5 h-5 text-emerald-600 mr-2 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                        <span class="text-gray-700">Multi-model AI orchestration (Claude + GPT-4)</span>
                    </li>
                </ul>
                <a href="/star-ai-cloud.html" class="inline-block bg-gradient-to-r from-emerald-600 to-lime-500 text-white px-6 py-3 rounded-lg font-semibold hover:shadow-lg transition-all">
                    Learn More →
                </a>
            </div>'''

# Find and replace the Star AI Cloud section (lines 73-99)
pattern = r'<!-- Star AI Cloud -->.*?</div>\s*(?=<!-- Star AI eDiscovery -->)'
content = re.sub(pattern, new_section + '\n\n            ', content, flags=re.DOTALL)

with open('products.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ Products page updated - Star AI Cloud section with 7 patent-pending features")
PYTHON_EOF

python fix_products.py
rm fix_products.py

echo -e "${GREEN}✓ Products page updated${NC}"
echo ""

# Step 4: Fix Star AI Finance Page
echo "================================================================================"
echo "🎨 STEP 4: Fixing Star AI Finance Page"
echo "================================================================================"
echo ""

cat > fix_finance.py << 'PYTHON_EOF'
import re

with open('star-ai-finance.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove the white-on-white div after nav (lines 64-71)
# This section starts with <div class="mt-8"> and contains "Planning a custom financial automation"
pattern1 = r'</script>\s*<div class="mt-8">.*?</div>\s*</div>\s*(?=<!-- Bottom CTA Section -->)'
content = re.sub(pattern1, '</script>\n\n    <!-- Hero Section -->\n    <section class="relative overflow-hidden" style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);">\n        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-32">\n            <div class="text-center text-white">\n                <h1 class="text-4xl md:text-6xl font-extrabold mb-6 leading-tight">\n                    Star AI Finance\n                </h1>\n                <p class="text-xl md:text-2xl mb-8 max-w-3xl mx-auto">\n                    Automate your financial operations with AI-powered reconciliation, forecasting, and AP/AR automation. Save 40+ hours per month while improving accuracy to 99.9%.\n                </p>\n                <div class="grid md:grid-cols-3 gap-6 mb-12 max-w-4xl mx-auto">\n                    <div class="bg-white bg-opacity-10 p-4 rounded-lg backdrop-blur-sm">\n                        <div class="text-3xl font-bold mb-1">99.9%</div>\n                        <div class="text-sm text-emerald-50">Transaction Matching Accuracy</div>\n                    </div>\n                    <div class="bg-white bg-opacity-10 p-4 rounded-lg backdrop-blur-sm">\n                        <div class="text-3xl font-bold mb-1">40+</div>\n                        <div class="text-sm text-emerald-50">Hours Saved Per Month</div>\n                    </div>\n                    <div class="bg-white bg-opacity-10 p-4 rounded-lg backdrop-blur-sm">\n                        <div class="text-3xl font-bold mb-1">24/7</div>\n                        <div class="text-sm text-emerald-50">Automated Processing</div>\n                    </div>\n                </div>\n                <div class="flex flex-col sm:flex-row gap-4 justify-center">\n                    <a href="https://startekk.net/contact?product=star-ai-finance" \n                       class="inline-block bg-white text-emerald-700 px-8 py-4 rounded-lg font-bold text-lg hover:shadow-2xl transition-all">\n                        Get Started\n                    </a>\n                    <a href="https://startekk.net/cost-calculator" \n                       class="inline-block border-2 border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white hover:text-emerald-700 transition-all">\n                        Calculate Your Savings\n                    </a>\n                </div>\n            </div>\n        </div>\n    </section>\n\n    <!-- Features Section -->\n    <section class="py-20 bg-white">\n        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">\n            <h2 class="text-4xl font-bold text-center mb-12 text-gray-900">Comprehensive Financial Automation</h2>\n            <div class="grid md:grid-cols-3 gap-8">\n                <div class="bg-gray-50 p-6 rounded-lg">\n                    <div class="text-3xl mb-4">🧾</div>\n                    <h3 class="text-xl font-bold mb-3 text-gray-900">Invoice Processing</h3>\n                    <p class="text-gray-600">AI extracts data from invoices, matches to POs, and routes for approval automatically.</p>\n                </div>\n                <div class="bg-gray-50 p-6 rounded-lg">\n                    <div class="text-3xl mb-4">💰</div>\n                    <h3 class="text-xl font-bold mb-3 text-gray-900">Cash Flow Forecasting</h3>\n                    <p class="text-gray-600">ML-powered predictions help you plan ahead with 95% accuracy on 30-day forecasts.</p>\n                </div>\n                <div class="bg-gray-50 p-6 rounded-lg">\n                    <div class="text-3xl mb-4">🔄</div>\n                    <h3 class="text-xl font-bold mb-3 text-gray-900">Reconciliation</h3>\n                    <p class="text-gray-600">Automatically match transactions across accounts with 99.9% accuracy.</p>\n                </div>\n                <div class="bg-gray-50 p-6 rounded-lg">\n                    <div class="text-3xl mb-4">📊</div>\n                    <h3 class="text-xl font-bold mb-3 text-gray-900">Financial Reporting</h3>\n                    <p class="text-gray-600">Generate real-time reports and dashboards with customizable metrics.</p>\n                </div>\n                <div class="bg-gray-50 p-6 rounded-lg">\n                    <div class="text-3xl mb-4">⚠️</div>\n                    <h3 class="text-xl font-bold mb-3 text-gray-900">Fraud Detection</h3>\n                    <p class="text-gray-600">AI identifies suspicious patterns and anomalies in real-time.</p>\n                </div>\n                <div class="bg-gray-50 p-6 rounded-lg">\n                    <div class="text-3xl mb-4">🔗</div>\n                    <h3 class="text-xl font-bold mb-3 text-gray-900">System Integration</h3>\n                    <p class="text-gray-600">Connects with QuickBooks, Xero, NetSuite, and major ERPs.</p>\n                </div>\n            </div>\n        </div>\n    </section>\n\n    ', content, flags=re.DOTALL)

with open('star-ai-finance.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ Star AI Finance page updated")
print("  - Removed white-on-white section")
print("  - Added enhanced hero with stats")
print("  - Added 6 feature cards")
PYTHON_EOF

python fix_finance.py
rm fix_finance.py

echo -e "${GREEN}✓ Star AI Finance page updated${NC}"
echo ""

# Step 5: Fix Star Automation Page
echo "================================================================================"
echo "🎨 STEP 5: Fixing Star Automation Page"
echo "================================================================================"
echo ""

cat > fix_automation.py << 'PYTHON_EOF'
import re

with open('star-automation.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove ALL problematic sections and replace with proper structure
# Find from end of nav script to before footer
pattern = r'</script>\s*<div class="mt-8">.*?(?=<!-- Footer -->)'

replacement = '''</script>

    <!-- Hero Section -->
    <section class="relative overflow-hidden" style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-32">
            <div class="text-center text-white">
                <h1 class="text-4xl md:text-6xl font-extrabold mb-6 leading-tight">
                    Star Automation
                </h1>
                <p class="text-xl md:text-2xl mb-8 max-w-3xl mx-auto">
                    Eliminate 80% of manual work with AI-powered business process automation. Connect 500+ apps, build intelligent workflows, and deploy RPA bots that work 24/7 with 99.9% accuracy.
                </p>
                <div class="grid md:grid-cols-3 gap-6 mb-12 max-w-4xl mx-auto">
                    <div class="bg-white bg-opacity-10 p-4 rounded-lg backdrop-blur-sm">
                        <div class="text-3xl font-bold mb-1">80%</div>
                        <div class="text-sm text-emerald-50">Reduction in Manual Tasks</div>
                    </div>
                    <div class="bg-white bg-opacity-10 p-4 rounded-lg backdrop-blur-sm">
                        <div class="text-3xl font-bold mb-1">500+</div>
                        <div class="text-sm text-emerald-50">App Integrations</div>
                    </div>
                    <div class="bg-white bg-opacity-10 p-4 rounded-lg backdrop-blur-sm">
                        <div class="text-3xl font-bold mb-1">99.9%</div>
                        <div class="text-sm text-emerald-50">Automation Accuracy</div>
                    </div>
                </div>
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="https://startekk.net/contact?product=star-automation" 
                       class="inline-block bg-white text-emerald-700 px-8 py-4 rounded-lg font-bold text-lg hover:shadow-2xl transition-all">
                        Get Started
                    </a>
                    <a href="https://startekk.net/cost-calculator" 
                       class="inline-block border-2 border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white hover:text-emerald-700 transition-all">
                        Calculate Your Savings
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Key Features Section -->
    <section class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 class="text-4xl font-bold text-center mb-12 text-gray-900">Powerful Automation Capabilities</h2>
            <div class="grid md:grid-cols-3 gap-8">
                <div class="bg-gray-50 p-6 rounded-lg">
                    <div class="text-3xl mb-4">🔧</div>
                    <h3 class="text-xl font-bold mb-3 text-gray-900">No-Code Workflow Builder</h3>
                    <p class="text-gray-600">Drag-and-drop interface to build complex automations without writing code. Visual workflow designer with pre-built templates.</p>
                </div>
                <div class="bg-gray-50 p-6 rounded-lg">
                    <div class="text-3xl mb-4">🤖</div>
                    <h3 class="text-xl font-bold mb-3 text-gray-900">RPA Bots</h3>
                    <p class="text-gray-600">Software robots that handle data entry, form filling, email processing, and repetitive tasks across applications.</p>
                </div>
                <div class="bg-gray-50 p-6 rounded-lg">
                    <div class="text-3xl mb-4">🔗</div>
                    <h3 class="text-xl font-bold mb-3 text-gray-900">500+ Integrations</h3>
                    <p class="text-gray-600">Connect Salesforce, Microsoft 365, Google Workspace, Slack, SAP, Oracle, and hundreds more platforms seamlessly.</p>
                </div>
                <div class="bg-gray-50 p-6 rounded-lg">
                    <div class="text-3xl mb-4">🧠</div>
                    <h3 class="text-xl font-bold mb-3 text-gray-900">AI Decision Engine</h3>
                    <p class="text-gray-600">Machine learning models make intelligent decisions based on rules, patterns, and historical data.</p>
                </div>
                <div class="bg-gray-50 p-6 rounded-lg">
                    <div class="text-3xl mb-4">📊</div>
                    <h3 class="text-xl font-bold mb-3 text-gray-900">Analytics Dashboard</h3>
                    <p class="text-gray-600">Real-time visibility into automation performance, bottlenecks, and ROI with comprehensive reporting.</p>
                </div>
                <div class="bg-gray-50 p-6 rounded-lg">
                    <div class="text-3xl mb-4">⏰</div>
                    <h3 class="text-xl font-bold mb-3 text-gray-900">24/7 Execution</h3>
                    <p class="text-gray-600">Automations run continuously with scheduled triggers, webhooks, and event-based activation.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Use Cases Section -->
    <section class="py-20 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 class="text-4xl font-bold text-center mb-12 text-gray-900">Common Use Cases</h2>
            <div class="grid md:grid-cols-2 gap-8">
                <div class="bg-white p-6 rounded-lg shadow">
                    <h3 class="text-xl font-bold mb-3 text-emerald-700">Sales & CRM Automation</h3>
                    <p class="text-gray-600 mb-3">Automatically update Salesforce records, send follow-up emails, generate quotes, and sync data across systems.</p>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• Lead routing and assignment</li>
                        <li>• Automated email sequences</li>
                        <li>• Quote generation and approval</li>
                    </ul>
                </div>
                <div class="bg-white p-6 rounded-lg shadow">
                    <h3 class="text-xl font-bold mb-3 text-emerald-700">HR & Onboarding</h3>
                    <p class="text-gray-600 mb-3">Streamline employee onboarding, payroll processing, leave requests, and performance reviews.</p>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• New hire provisioning</li>
                        <li>• Time-off approval workflows</li>
                        <li>• Benefits enrollment automation</li>
                    </ul>
                </div>
                <div class="bg-white p-6 rounded-lg shadow">
                    <h3 class="text-xl font-bold mb-3 text-emerald-700">IT Operations</h3>
                    <p class="text-gray-600 mb-3">Automate ticket routing, system monitoring, backup scheduling, and incident response.</p>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• Automated ticket triage</li>
                        <li>• System health monitoring</li>
                        <li>• Password reset workflows</li>
                    </ul>
                </div>
                <div class="bg-white p-6 rounded-lg shadow">
                    <h3 class="text-xl font-bold mb-3 text-emerald-700">Customer Service</h3>
                    <p class="text-gray-600 mb-3">Route support tickets, send automated responses, update knowledge bases, and track SLAs.</p>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• Smart ticket routing</li>
                        <li>• Automated status updates</li>
                        <li>• Customer feedback collection</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Bottom CTA -->
    <section class="relative overflow-hidden" style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
            <div class="text-center text-white">
                <h2 class="text-3xl md:text-4xl font-extrabold mb-6">
                    Need developers to build custom automation workflows?
                </h2>
                <p class="text-xl mb-8 max-w-3xl mx-auto">
                    Use our calculator to estimate costs and savings when working with our distributed teams. Save 30-50% on development costs.
                </p>
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="https://startekk.net/contact?product=star-automation" 
                       class="inline-block bg-white text-emerald-700 px-8 py-4 rounded-lg font-bold text-lg hover:shadow-2xl transition-all">
                        Get Started
                    </a>
                    <a href="https://startekk.net/cost-calculator" 
                       class="inline-block border-2 border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white hover:text-emerald-700 transition-all">
                        Calculate Your Savings
                    </a>
                </div>
            </div>
        </div>
    </section>

    '''

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('star-automation.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ Star Automation page updated")
print("  - Removed all white-on-white sections")
print("  - Added proper gradient hero with stats")
print("  - Added 6 feature cards")
print("  - Added 4 use case examples")
print("  - Added bottom CTA section")
PYTHON_EOF

python fix_automation.py
rm fix_automation.py

echo -e "${GREEN}✓ Star Automation page updated${NC}"
echo ""

# Step 6: Review changes
echo "================================================================================"
echo "📊 STEP 6: Review Changes"
echo "================================================================================"
echo ""

git status --short

echo ""
echo -e "${BLUE}Files modified:${NC}"
echo "  ✓ products.html"
echo "  ✓ star-ai-finance.html"
echo "  ✓ star-automation.html"
echo ""

# Step 7: Commit
echo "================================================================================"
echo "💾 STEP 7: Committing Changes"
echo "================================================================================"
echo ""

git add products.html star-ai-finance.html star-automation.html

git commit -m "Update products page and enhance finance/automation pages

Products page:
- Updated Star AI Cloud section with 7 patent-pending features
- New positioning: AI-Powered Multi-Cloud Cost Optimization
- Added specific feature bullets with checkmark icons
- Updated description emphasizing 30-40% cost savings

Star AI Finance:
- Removed white-on-white section after navigation
- Added enhanced hero with stats (99.9% accuracy, 40+ hours saved)
- Added 6 comprehensive feature cards
- Improved SEO with better descriptions

Star Automation:
- Removed all white-on-white sections
- Added proper gradient hero with stats (80% reduction, 500+ integrations)
- Added 6 feature cards (no-code builder, RPA bots, integrations, etc.)
- Added 4 use case examples (Sales, HR, IT, Customer Service)
- Added bottom CTA section

All pages now have consistent styling, proper gradient backgrounds, and enhanced content."

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 8: Push to GitHub
echo "================================================================================"
echo "🌐 STEP 8: Pushing to GitHub"
echo "================================================================================"
echo ""

git push origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}"
else
    echo -e "${RED}❌ Push failed${NC}"
    exit 1
fi

echo ""
echo "================================================================================"
echo "✅ ALL UPDATES COMPLETE!"
echo "================================================================================"
echo ""
echo -e "${GREEN}Successfully updated 3 pages:${NC}"
echo ""
echo "📄 products.html"
echo "   ✓ Star AI Cloud - 7 patent-pending features"
echo "   ✓ New subtitle: AI-Powered Multi-Cloud Cost Optimization"
echo ""
echo "📄 star-ai-finance.html"
echo "   ✓ Removed white-on-white section"
echo "   ✓ Enhanced hero with performance stats"
echo "   ✓ Added 6 feature cards"
echo ""
echo "📄 star-automation.html"
echo "   ✓ Removed all white-on-white sections"
echo "   ✓ Enhanced hero with automation stats"
echo "   ✓ Added 6 feature cards"
echo "   ✓ Added 4 use case examples"
echo "   ✓ Added bottom CTA"
echo ""
echo "📡 Vercel will auto-deploy in ~2 minutes"
echo ""
echo "🌐 Check updated pages:"
echo "   - https://startekk.net/products"
echo "   - https://startekk.net/star-ai-finance"
echo "   - https://startekk.net/star-automation"
echo ""
echo "📦 Backups saved: backup/*-backup-${TIMESTAMP}.html"
echo ""
echo "🎉 Done!"
echo ""
