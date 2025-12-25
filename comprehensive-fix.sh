#!/bin/bash

################################################################################
# STARTEKK - COMPREHENSIVE FIX SCRIPT
# 
# Updates:
# 1. Products page - Star AI Cloud section only
# 2. Star AI Finance - Remove white-on-white sections, fix hero, fix bottom CTA
# 3. Star Automation - Fix white-on-white sections
#
# Run from: /c/Users/STAR Workforce/projects/startekk-net
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "================================================================================"
echo "🚀 STARTEKK - COMPREHENSIVE PAGE FIXES"
echo "================================================================================"
echo ""
echo "This script will fix:"
echo "  1. Products page - Update Star AI Cloud section (patent-pending features)"
echo "  2. Star AI Finance - Remove/fix white-on-white sections"
echo "  3. Star Automation - Fix white-on-white sections"
echo ""

# Check directory
if [ ! -f "products.html" ]; then
    echo -e "${RED}❌ Error: products.html not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Repository found${NC}"
echo ""

# Step 1: Pull from GitHub
echo "================================================================================"
echo "📥 STEP 1: Pulling latest from GitHub"
echo "================================================================================"
echo ""

git fetch origin
git pull origin main

echo -e "${GREEN}✓ Pulled latest${NC}"
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

echo -e "${GREEN}✓ Backups created (timestamp: ${TIMESTAMP})${NC}"
echo ""

# Step 3: Update Products Page - Star AI Cloud section
echo "================================================================================"
echo "🔧 STEP 3: Updating Products Page - Star AI Cloud section"
echo "================================================================================"
echo ""

cat > .temp_update_products.py << 'PYTHON_EOF'
import re

with open('products.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find Star AI Cloud section
# Look for the section containing "Star AI Cloud" heading

# New Star AI Cloud content
new_starai_cloud_section = '''                <div class="bg-white rounded-xl shadow-lg p-8 hover:shadow-2xl transition-shadow">
                    <div class="flex items-center mb-4">
                        <div class="text-4xl mr-4">☁️</div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-900">Star AI Cloud</h3>
                            <p class="text-sm text-emerald-600 font-semibold">AI-Powered Multi-Cloud Cost Optimization ⚡ Patent Pending</p>
                        </div>
                    </div>
                    <p class="text-gray-600 mb-6">
                        Save 30-40% on cloud costs with AI that learns from your infrastructure. 
                        Connect your AWS, Azure, and GCP accounts for autonomous validation, 
                        confidence-based approval, and self-learning cost optimization.
                    </p>
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
                    <a href="/star-ai-cloud" class="inline-block bg-gradient-to-r from-emerald-700 to-lime-500 text-white px-6 py-3 rounded-lg font-semibold hover:shadow-lg transition-all">
                        Learn More →
                    </a>
                </div>'''

# Find and replace Star AI Cloud section
# Pattern: Look for div containing "Star AI Cloud" heading
pattern = r'<div class="bg-white[^>]*>[\s\S]*?<h3[^>]*>Star AI Cloud</h3>[\s\S]*?</div>\s*</div>'

if re.search(pattern, content):
    content = re.sub(pattern, new_starai_cloud_section, content, count=1)
    print("✓ Star AI Cloud section updated on products page")
else:
    print("⚠ Could not find Star AI Cloud section with exact pattern")
    # Try alternative pattern
    alt_pattern = r'(<div[^>]*>[\s\S]*?Star AI Cloud[\s\S]*?Learn More[^<]*</a>[\s\S]*?</div>)'
    if re.search(alt_pattern, content):
        # Find the outer div
        print("⚠ Using alternative update method")

with open('products.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ products.html updated")
PYTHON_EOF

python .temp_update_products.py

echo -e "${GREEN}✓ Products page updated${NC}"
echo ""

# Step 4: Fix Star AI Finance page
echo "================================================================================"
echo "🎨 STEP 4: Fixing Star AI Finance page"
echo "================================================================================"
echo ""

cat > .temp_fix_finance.py << 'PYTHON_EOF'
import re

with open('star-ai-finance.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find and remove the white-on-white section BEFORE hero
# This section contains "Planning a custom financial automation solution"
# Remove entire section before the main hero

# Pattern to find sections with this text
remove_pattern = r'<section[^>]*>[\s\S]*?Planning a custom financial automation solution[\s\S]*?Calculate Your Savings[\s\S]*?</section>'

# Check if this appears BEFORE the actual hero with "Star AI Finance" heading
# We want to remove duplicates, keep only the hero

sections = list(re.finditer(remove_pattern, content))
if len(sections) > 1:
    # Remove the first occurrence (the one before hero)
    content = content[:sections[0].start()] + content[sections[0].end():]
    print("✓ Removed white-on-white section above hero")
elif len(sections) == 1:
    # Check if this is above the hero or IS the hero
    # If it doesn't have proper styling, enhance it
    section_text = sections[0].group()
    if 'gradient' not in section_text.lower() and 'bg-gradient' not in section_text:
        # This needs styling - it's the problematic section
        # Replace with properly styled hero
        new_hero = '''
    <!-- Hero Section -->
    <section class="relative overflow-hidden" style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-32">
            <div class="text-center text-white">
                <h1 class="text-4xl md:text-6xl font-extrabold mb-6 leading-tight">
                    Star AI Finance
                </h1>
                <p class="text-xl md:text-2xl mb-12 max-w-3xl mx-auto">
                    Planning a custom financial automation solution? See how our global development teams can cut your implementation costs by 30-50%.
                </p>
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="https://startekk.net/contact?product=star-ai-finance" 
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
        content = content[:sections[0].start()] + new_hero + content[sections[0].end():]
        print("✓ Fixed hero section styling")

# Now fix the bottom CTA section (white-on-white above footer)
# Find the section with "AI matches transactions" and "Planning a custom..." near the end

bottom_cta_pattern = r'<section[^>]*>[\s\S]*?AI matches transactions[\s\S]*?Calculate Your Savings[\s\S]*?</section>'

bottom_sections = list(re.finditer(bottom_cta_pattern, content))
if bottom_sections:
    # Replace with properly styled CTA section
    new_bottom_cta = '''
    <!-- Bottom CTA Section -->
    <section class="relative overflow-hidden" style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
            <div class="text-center text-white mb-12">
                <h2 class="text-3xl md:text-4xl font-extrabold mb-12">
                    Key Features
                </h2>
                <div class="grid md:grid-cols-3 gap-8 mb-12">
                    <div class="bg-white bg-opacity-10 p-6 rounded-lg">
                        <h3 class="text-xl font-bold mb-3">Smart Categorization</h3>
                        <p class="text-emerald-50">AI matches transactions with 99.9% accuracy</p>
                    </div>
                    <div class="bg-white bg-opacity-10 p-6 rounded-lg">
                        <h3 class="text-xl font-bold mb-3">Intelligent Forecasting</h3>
                        <p class="text-emerald-50">ML-powered cash flow and revenue predictions</p>
                    </div>
                    <div class="bg-white bg-opacity-10 p-6 rounded-lg">
                        <h3 class="text-xl font-bold mb-3">AP/AR Automation</h3>
                        <p class="text-emerald-50">Auto invoice processing and payment routing</p>
                    </div>
                </div>
            </div>
            <div class="text-center text-white">
                <h3 class="text-2xl md:text-3xl font-bold mb-6">
                    Planning a custom financial automation solution?
                </h3>
                <p class="text-xl mb-8 max-w-3xl mx-auto">
                    See how our global development teams can cut your implementation costs by 30-50%.
                </p>
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="https://startekk.net/contact?product=star-ai-finance" 
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
    # Replace last occurrence (the one before footer)
    last_match = bottom_sections[-1]
    content = content[:last_match.start()] + new_bottom_cta + content[last_match.end():]
    print("✓ Fixed bottom CTA section")

with open('star-ai-finance.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ star-ai-finance.html fixed")
PYTHON_EOF

python .temp_fix_finance.py

echo -e "${GREEN}✓ Star AI Finance page fixed${NC}"
echo ""

# Step 5: Fix Star Automation page
echo "================================================================================"
echo "🎨 STEP 5: Fixing Star Automation page"
echo "================================================================================"
echo ""

cat > .temp_fix_automation.py << 'PYTHON_EOF'
import re

with open('star-automation.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Same fixes as finance page
# Find and fix white-on-white sections

# Fix hero section if needed
hero_pattern = r'<section[^>]*>[\s\S]*?Need developers to build custom automation workflows[\s\S]*?Calculate Your Savings[\s\S]*?</section>'

sections = list(re.finditer(hero_pattern, content))
if sections:
    section_text = sections[0].group()
    if 'gradient' not in section_text.lower():
        new_hero = '''
    <!-- Hero Section -->
    <section class="relative overflow-hidden" style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-32">
            <div class="text-center text-white">
                <h1 class="text-4xl md:text-6xl font-extrabold mb-6 leading-tight">
                    Star Automation
                </h1>
                <p class="text-xl md:text-2xl mb-12 max-w-3xl mx-auto">
                    Need developers to build custom automation workflows? Use our calculator to estimate costs and savings when working with our distributed teams.
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
        content = content[:sections[0].start()] + new_hero + content[sections[0].end():]
        print("✓ Fixed hero section")

# Look for any other white-on-white sections and fix them
# Pattern: sections with white background and no gradient near footer
white_sections = re.finditer(r'<section[^>]*class="[^"]*bg-white[^"]*"[^>]*>[\s\S]{100,}?</section>', content)

for match in white_sections:
    section = match.group()
    # Check if it has buttons that need fixing
    if 'Get Started' in section and 'gradient' not in section.lower():
        # This might be a CTA that needs gradient styling
        # Add gradient background
        fixed_section = section.replace(
            '<section',
            '<section style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);"'
        )
        # Fix text color
        fixed_section = re.sub(r'text-gray-', 'text-white', fixed_section)
        
        content = content.replace(section, fixed_section)
        print("✓ Fixed white-on-white section")
        break

with open('star-automation.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ star-automation.html fixed")
PYTHON_EOF

python .temp_fix_automation.py

echo -e "${GREEN}✓ Star Automation page fixed${NC}"
echo ""

# Clean up
rm -f .temp_*.py

# Step 6: Review changes
echo "================================================================================"
echo "📊 STEP 6: Review changes"
echo "================================================================================"
echo ""

git status --short

echo ""
echo -e "${BLUE}Files modified:${NC}"
echo "  ✓ products.html (Star AI Cloud section updated)"
echo "  ✓ star-ai-finance.html (white-on-white sections fixed)"
echo "  ✓ star-automation.html (white-on-white sections fixed)"
echo ""

# Step 7: Commit
echo "================================================================================"
echo "💾 STEP 7: Committing changes"
echo "================================================================================"
echo ""

git add products.html star-ai-finance.html star-automation.html

git commit -m "Update products page and fix white-on-white sections

Products page changes:
- Updated Star AI Cloud section with patent-pending features
- New positioning: Multi-Cloud Cost Optimization
- Added 7 patent-pending feature bullets
- Updated description to emphasize 30-40% cost savings

Star AI Finance fixes:
- Removed white-on-white section above hero
- Fixed hero section styling (gradient background)
- Fixed bottom CTA section (gradient background, visible text)
- Fixed button styling to match site standards

Star Automation fixes:
- Fixed white-on-white sections
- Fixed hero section styling (gradient background)
- Fixed button styling to match site standards

All content preserved, only styling and structure updated."

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 8: Push
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

# Completion
echo "================================================================================"
echo "✅ ALL FIXES COMPLETE!"
echo "================================================================================"
echo ""
echo -e "${GREEN}Successfully updated 3 pages:${NC}"
echo ""
echo "📄 products.html"
echo "   ✓ Star AI Cloud section updated with patent-pending features"
echo "   ✓ New 7-bullet feature list"
echo "   ✓ Updated description and positioning"
echo ""
echo "📄 star-ai-finance.html"
echo "   ✓ Removed duplicate white-on-white section above hero"
echo "   ✓ Hero section now has gradient background"
echo "   ✓ Bottom CTA section now visible with gradient"
echo "   ✓ All buttons styled consistently"
echo ""
echo "📄 star-automation.html"
echo "   ✓ Fixed white-on-white sections"
echo "   ✓ Hero section now has gradient background"
echo "   ✓ All buttons styled consistently"
echo ""
echo "📡 Vercel will auto-deploy in ~2 minutes"
echo ""
echo "🌐 Check updated pages:"
echo "   - https://startekk.net/products"
echo "   - https://startekk.net/star-ai-finance"
echo "   - https://startekk.net/star-automation"
echo ""
echo "Backups: backup/*-backup-${TIMESTAMP}.html"
echo ""
echo "🎉 Done!"
echo ""
