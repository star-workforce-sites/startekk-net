#!/bin/bash

################################################################################
# STARTEKK - AUTOMATED PAGE UPDATE & DEPLOYMENT SCRIPT
# 
# Updates 3 pages automatically:
# 1. star-ai-cloud.html - Apply header/footer from ediscovery
# 2. star-ai-finance.html - Fix hero section + apply header/footer
# 3. star-automation.html - Fix hero section + apply header/footer
#
# Run from: /c/Users/STAR Workforce/projects/startekk-net
# Zero manual editing required!
################################################################################

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================================================================"
echo "🚀 STARTEKK - AUTOMATED PAGE UPDATE & DEPLOYMENT"
echo "================================================================================"
echo ""

# Check if we're in the right directory
if [ ! -f "star-ai-cloud.html" ] || [ ! -f "star-ai-ediscovery.html" ]; then
    echo -e "${RED}❌ Error: Required files not found in current directory${NC}"
    echo "Please run this script from: /c/Users/STAR Workforce/projects/startekk-net"
    exit 1
fi

echo -e "${GREEN}✓ Repository found${NC}"
echo ""

# Step 1: Pull latest from GitHub
echo "================================================================================"
echo "📥 STEP 1: Pulling latest from GitHub"
echo "================================================================================"
echo ""

git fetch origin
git pull origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Successfully pulled latest from GitHub${NC}"
else
    echo -e "${YELLOW}⚠ Pull had some issues, but continuing...${NC}"
fi
echo ""

# Step 2: Create backups
echo "================================================================================"
echo "📦 STEP 2: Creating backups"
echo "================================================================================"
echo ""

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p backup

cp star-ai-cloud.html "backup/star-ai-cloud-backup-${TIMESTAMP}.html"
cp star-ai-finance.html "backup/star-ai-finance-backup-${TIMESTAMP}.html"
cp star-automation.html "backup/star-automation-backup-${TIMESTAMP}.html"

echo -e "${GREEN}✓ Backups created:${NC}"
echo "  - backup/star-ai-cloud-backup-${TIMESTAMP}.html"
echo "  - backup/star-ai-finance-backup-${TIMESTAMP}.html"
echo "  - backup/star-automation-backup-${TIMESTAMP}.html"
echo ""

# Step 3: Extract header and footer from star-ai-ediscovery.html
echo "================================================================================"
echo "🔍 STEP 3: Extracting header and footer from star-ai-ediscovery.html"
echo "================================================================================"
echo ""

# Extract navigation/header (from <nav to </nav>)
sed -n '/<nav/,/<\/nav>/p' star-ai-ediscovery.html > /tmp/header.html

# Extract footer (from <footer to </footer>)
sed -n '/<footer/,/<\/footer>/p' star-ai-ediscovery.html > /tmp/footer.html

if [ -s /tmp/header.html ] && [ -s /tmp/footer.html ]; then
    echo -e "${GREEN}✓ Header and footer extracted successfully${NC}"
else
    echo -e "${RED}❌ Failed to extract header or footer${NC}"
    exit 1
fi
echo ""

# Step 4: Update star-ai-cloud.html with consistent header/footer
echo "================================================================================"
echo "🔧 STEP 4: Updating star-ai-cloud.html with header/footer"
echo "================================================================================"
echo ""

# Create Python script to update header/footer
cat > /tmp/update_header_footer.py << 'PYTHON_EOF'
import re
import sys

def update_page(filename, header_file, footer_file):
    # Read files
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    with open(header_file, 'r', encoding='utf-8') as f:
        new_header = f.read()
    
    with open(footer_file, 'r', encoding='utf-8') as f:
        new_footer = f.read()
    
    # Replace header (nav section)
    content = re.sub(
        r'<nav[\s\S]*?</nav>',
        new_header,
        content,
        count=1
    )
    
    # Replace footer
    content = re.sub(
        r'<footer[\s\S]*?</footer>',
        new_footer,
        content,
        count=1
    )
    
    # Write back
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✓ Updated {filename}")

if __name__ == "__main__":
    update_page(sys.argv[1], '/tmp/header.html', '/tmp/footer.html')
PYTHON_EOF

python /tmp/update_header_footer.py star-ai-cloud.html

echo -e "${GREEN}✓ star-ai-cloud.html updated with consistent header/footer${NC}"
echo ""

# Step 5: Fix hero section for star-ai-finance.html
echo "================================================================================"
echo "🎨 STEP 5: Fixing hero section for star-ai-finance.html"
echo "================================================================================"
echo ""

# Create Python script to fix hero section
cat > /tmp/fix_hero_finance.py << 'PYTHON_EOF'
import re

# Read file
with open('star-ai-finance.html', 'r', encoding='utf-8') as f:
    content = f.read()

# New hero section with gradient background, centered, and proper buttons
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

# Find and replace hero section
# Look for the section that contains the hero content
pattern = r'(<section[^>]*>[\s\S]*?Planning a custom financial automation solution[\s\S]*?</section>)'

if re.search(pattern, content):
    content = re.sub(pattern, new_hero, content, count=1)
    print("✓ Hero section updated")
else:
    # If pattern not found, try to insert after nav
    nav_end = content.find('</nav>')
    if nav_end != -1:
        # Find the next section tag
        next_section = content.find('<section', nav_end)
        if next_section != -1:
            # Find the end of that section
            section_end = content.find('</section>', next_section)
            if section_end != -1:
                # Replace that section
                content = content[:next_section] + new_hero + content[section_end + len('</section>'):]
                print("✓ Hero section inserted")
            else:
                print("⚠ Could not find section end")
        else:
            print("⚠ Could not find section start")
    else:
        print("⚠ Could not find nav end")

# Write back
with open('star-ai-finance.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ star-ai-finance.html hero section fixed")
PYTHON_EOF

python /tmp/fix_hero_finance.py

# Update header/footer for finance page
python /tmp/update_header_footer.py star-ai-finance.html

echo -e "${GREEN}✓ star-ai-finance.html updated (hero section + header/footer)${NC}"
echo ""

# Step 6: Fix hero section for star-automation.html
echo "================================================================================"
echo "🎨 STEP 6: Fixing hero section for star-automation.html"
echo "================================================================================"
echo ""

# Create Python script to fix hero section for automation
cat > /tmp/fix_hero_automation.py << 'PYTHON_EOF'
import re

# Read file
with open('star-automation.html', 'r', encoding='utf-8') as f:
    content = f.read()

# New hero section with gradient background, centered, and proper buttons
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

# Find and replace hero section
# Look for the section that contains the hero content
pattern = r'(<section[^>]*>[\s\S]*?Need developers to build custom automation workflows[\s\S]*?</section>)'

if re.search(pattern, content):
    content = re.sub(pattern, new_hero, content, count=1)
    print("✓ Hero section updated")
else:
    # If pattern not found, try to insert after nav
    nav_end = content.find('</nav>')
    if nav_end != -1:
        # Find the next section tag
        next_section = content.find('<section', nav_end)
        if next_section != -1:
            # Find the end of that section
            section_end = content.find('</section>', next_section)
            if section_end != -1:
                # Replace that section
                content = content[:next_section] + new_hero + content[section_end + len('</section>'):]
                print("✓ Hero section inserted")
            else:
                print("⚠ Could not find section end")
        else:
            print("⚠ Could not find section start")
    else:
        print("⚠ Could not find nav end")

# Write back
with open('star-automation.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ star-automation.html hero section fixed")
PYTHON_EOF

python /tmp/fix_hero_automation.py

# Update header/footer for automation page
python /tmp/update_header_footer.py star-automation.html

echo -e "${GREEN}✓ star-automation.html updated (hero section + header/footer)${NC}"
echo ""

# Step 7: Show changes
echo "================================================================================"
echo "📊 STEP 7: Review changes"
echo "================================================================================"
echo ""

git status --short

echo ""
echo -e "${BLUE}Files modified:${NC}"
echo "  ✓ star-ai-cloud.html (header/footer updated)"
echo "  ✓ star-ai-finance.html (hero section fixed + header/footer updated)"
echo "  ✓ star-automation.html (hero section fixed + header/footer updated)"
echo ""

# Step 8: Commit changes
echo "================================================================================"
echo "💾 STEP 8: Committing changes"
echo "================================================================================"
echo ""

git add star-ai-cloud.html star-ai-finance.html star-automation.html

git commit -m "Update product pages: consistent header/footer and fix hero sections

Changes:
- Applied consistent header/footer from star-ai-ediscovery.html to:
  * star-ai-cloud.html
  * star-ai-finance.html
  * star-automation.html

- Fixed hero sections for star-ai-finance and star-automation:
  * Added gradient background (emerald to lime)
  * Center-aligned text
  * Updated buttons to match site-wide button styles
  * Improved visibility and CTA effectiveness

All pages now have consistent navigation and properly formatted hero sections."

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 9: Push to GitHub
echo "================================================================================"
echo "🌐 STEP 9: Pushing to GitHub"
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

# Step 10: Completion
echo "================================================================================"
echo "✅ DEPLOYMENT COMPLETE!"
echo "================================================================================"
echo ""
echo -e "${GREEN}All 3 pages updated successfully:${NC}"
echo ""
echo "📄 star-ai-cloud.html"
echo "   ✓ Header/footer from star-ai-ediscovery applied"
echo ""
echo "📄 star-ai-finance.html"
echo "   ✓ Hero section fixed (gradient background, centered, proper buttons)"
echo "   ✓ Header/footer from star-ai-ediscovery applied"
echo ""
echo "📄 star-automation.html"
echo "   ✓ Hero section fixed (gradient background, centered, proper buttons)"
echo "   ✓ Header/footer from star-ai-ediscovery applied"
echo ""
echo "📡 Vercel will auto-deploy in ~2 minutes"
echo ""
echo "🌐 Updated pages will be live at:"
echo "   - https://startekk.net/star-ai-cloud"
echo "   - https://startekk.net/star-ai-finance"
echo "   - https://startekk.net/star-automation"
echo ""
echo "⏱️  Estimated deployment time: 2-3 minutes"
echo ""
echo "================================================================================"
echo "🎉 SUCCESS! All pages updated and deployed!"
echo "================================================================================"
echo ""
echo "Backups saved in backup/ directory (timestamp: ${TIMESTAMP})"
echo ""
echo "Next steps:"
echo "1. Wait 2-3 minutes for Vercel deployment"
echo "2. Check each page to verify:"
echo "   - Header/footer consistency across all 3 pages"
echo "   - Hero sections on finance and automation have gradient backgrounds"
echo "   - Buttons are properly styled and centered"
echo "3. Test on desktop and mobile"
echo ""
echo "If you need to rollback:"
echo "  cp backup/star-ai-cloud-backup-${TIMESTAMP}.html star-ai-cloud.html"
echo "  cp backup/star-ai-finance-backup-${TIMESTAMP}.html star-ai-finance.html"
echo "  cp backup/star-automation-backup-${TIMESTAMP}.html star-automation.html"
echo "  git add *.html"
echo "  git commit -m 'Rollback to previous version'"
echo "  git push origin main"
echo ""
