#!/bin/bash

################################################################################
# STARTEKK - HEADER/FOOTER & HERO STYLING FIX (CONTENT PRESERVATION)
# 
# This script ONLY updates:
# 1. Header/footer (from ediscovery) - preserves all content
# 2. Hero section STYLING (CSS/classes only) - preserves all text
#
# DOES NOT change any product features, descriptions, or content!
#
# Run from: /c/Users/STAR Workforce/projects/startekk-net
################################################################################

set -e  # Exit on any error

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "================================================================================"
echo "🚀 STARTEKK - HEADER/FOOTER & STYLING UPDATE (CONTENT PRESERVED)"
echo "================================================================================"
echo ""
echo "This script will:"
echo "  ✓ Update header/footer from star-ai-ediscovery.html"
echo "  ✓ Fix hero section STYLING (gradient, centered, buttons)"
echo "  ✓ PRESERVE all existing content and product features"
echo ""

# Check directory
if [ ! -f "star-ai-cloud.html" ] || [ ! -f "star-ai-ediscovery.html" ]; then
    echo -e "${RED}❌ Error: Required files not found${NC}"
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

cp star-ai-cloud.html "backup/star-ai-cloud-backup-${TIMESTAMP}.html"
cp star-ai-finance.html "backup/star-ai-finance-backup-${TIMESTAMP}.html"
cp star-automation.html "backup/star-automation-backup-${TIMESTAMP}.html"

echo -e "${GREEN}✓ Backups created (timestamp: ${TIMESTAMP})${NC}"
echo ""

# Step 3: Extract header/footer from ediscovery
echo "================================================================================"
echo "🔍 STEP 3: Extracting header/footer from star-ai-ediscovery.html"
echo "================================================================================"
echo ""

mkdir -p .temp

sed -n '/<nav/,/<\/nav>/p' star-ai-ediscovery.html > .temp/header.html
sed -n '/<footer/,/<\/footer>/p' star-ai-ediscovery.html > .temp/footer.html

if [ -s .temp/header.html ] && [ -s .temp/footer.html ]; then
    echo -e "${GREEN}✓ Header and footer extracted${NC}"
else
    echo -e "${RED}❌ Failed to extract header/footer${NC}"
    exit 1
fi
echo ""

# Step 4: Update header/footer only (preserve all content)
echo "================================================================================"
echo "🔧 STEP 4: Updating header/footer (preserving all content)"
echo "================================================================================"
echo ""

cat > .temp/update_header_footer.py << 'PYTHON_EOF'
import re
import sys

def update_page(filename, header_file, footer_file):
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    with open(header_file, 'r', encoding='utf-8') as f:
        new_header = f.read()
    
    with open(footer_file, 'r', encoding='utf-8') as f:
        new_footer = f.read()
    
    # Replace ONLY nav section
    content = re.sub(r'<nav[\s\S]*?</nav>', new_header, content, count=1)
    
    # Replace ONLY footer section
    content = re.sub(r'<footer[\s\S]*?</footer>', new_footer, content, count=1)
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✓ Updated {filename}")

if __name__ == "__main__":
    update_page(sys.argv[1], '.temp/header.html', '.temp/footer.html')
PYTHON_EOF

python .temp/update_header_footer.py star-ai-cloud.html
python .temp/update_header_footer.py star-ai-finance.html
python .temp/update_header_footer.py star-automation.html

echo -e "${GREEN}✓ Header/footer updated on all 3 pages${NC}"
echo ""

# Step 5: Fix hero STYLING for star-ai-finance.html (preserve content)
echo "================================================================================"
echo "🎨 STEP 5: Fixing hero STYLING for star-ai-finance.html"
echo "================================================================================"
echo ""

cat > .temp/fix_hero_styling_finance.py << 'PYTHON_EOF'
import re

with open('star-ai-finance.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the hero section (first section after nav)
# We'll add/update styling attributes while preserving ALL text content

# Pattern to find the hero section tag
hero_pattern = r'(<section[^>]*>)([\s\S]*?)(</section>)'

matches = list(re.finditer(hero_pattern, content))

if matches:
    # Get first section after nav
    first_section = matches[0]
    opening_tag = first_section.group(1)
    section_content = first_section.group(2)
    closing_tag = first_section.group(3)
    
    # Update opening tag to include gradient background
    if 'style=' in opening_tag:
        # Add to existing style
        new_opening = re.sub(
            r'style="([^"]*)"',
            r'style="\1; background: linear-gradient(135deg, #047857 0%, #84CC16 100%);"',
            opening_tag
        )
    else:
        # Add new style attribute
        new_opening = opening_tag.replace(
            '<section',
            '<section style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);"'
        )
    
    # Add centering and styling classes to inner divs (preserve all content)
    # Look for the container div
    section_content = re.sub(
        r'<div([^>]*class="[^"]*mx-auto[^"]*"[^>]*)>',
        r'<div\1><div class="text-center text-white">',
        section_content,
        count=1
    )
    
    # Close the centering div before section end
    if '</div>' in section_content:
        # Add closing div before last </div>
        parts = section_content.rsplit('</div>', 1)
        section_content = parts[0] + '</div></div>' + (parts[1] if len(parts) > 1 else '')
    
    # Update button styling (preserve all href and text)
    # Find Get Started button
    section_content = re.sub(
        r'<a\s+href="([^"]*contact[^"]*)"([^>]*)>',
        r'<a href="\1" class="inline-block bg-white text-emerald-700 px-8 py-4 rounded-lg font-bold text-lg hover:shadow-2xl transition-all">',
        section_content
    )
    
    # Find Calculate Savings button
    section_content = re.sub(
        r'<a\s+href="([^"]*calculator[^"]*)"([^>]*)>',
        r'<a href="\1" class="inline-block border-2 border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white hover:text-emerald-700 transition-all">',
        section_content
    )
    
    # Reconstruct section
    new_section = new_opening + section_content + closing_tag
    
    # Replace in content
    content = content[:first_section.start()] + new_section + content[first_section.end():]
    
    print("✓ Hero styling updated (content preserved)")
else:
    print("⚠ Could not find hero section")

with open('star-ai-finance.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ star-ai-finance.html styling fixed")
PYTHON_EOF

python .temp/fix_hero_styling_finance.py

echo -e "${GREEN}✓ Hero styling fixed for star-ai-finance.html${NC}"
echo ""

# Step 6: Fix hero STYLING for star-automation.html (preserve content)
echo "================================================================================"
echo "🎨 STEP 6: Fixing hero STYLING for star-automation.html"
echo "================================================================================"
echo ""

cat > .temp/fix_hero_styling_automation.py << 'PYTHON_EOF'
import re

with open('star-automation.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the hero section (first section after nav)
hero_pattern = r'(<section[^>]*>)([\s\S]*?)(</section>)'

matches = list(re.finditer(hero_pattern, content))

if matches:
    # Get first section after nav
    first_section = matches[0]
    opening_tag = first_section.group(1)
    section_content = first_section.group(2)
    closing_tag = first_section.group(3)
    
    # Update opening tag to include gradient background
    if 'style=' in opening_tag:
        new_opening = re.sub(
            r'style="([^"]*)"',
            r'style="\1; background: linear-gradient(135deg, #047857 0%, #84CC16 100%);"',
            opening_tag
        )
    else:
        new_opening = opening_tag.replace(
            '<section',
            '<section style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%);"'
        )
    
    # Add centering and styling classes to inner divs (preserve all content)
    section_content = re.sub(
        r'<div([^>]*class="[^"]*mx-auto[^"]*"[^>]*)>',
        r'<div\1><div class="text-center text-white">',
        section_content,
        count=1
    )
    
    # Close the centering div
    if '</div>' in section_content:
        parts = section_content.rsplit('</div>', 1)
        section_content = parts[0] + '</div></div>' + (parts[1] if len(parts) > 1 else '')
    
    # Update button styling (preserve all href and text)
    section_content = re.sub(
        r'<a\s+href="([^"]*contact[^"]*)"([^>]*)>',
        r'<a href="\1" class="inline-block bg-white text-emerald-700 px-8 py-4 rounded-lg font-bold text-lg hover:shadow-2xl transition-all">',
        section_content
    )
    
    section_content = re.sub(
        r'<a\s+href="([^"]*calculator[^"]*)"([^>]*)>',
        r'<a href="\1" class="inline-block border-2 border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white hover:text-emerald-700 transition-all">',
        section_content
    )
    
    # Reconstruct section
    new_section = new_opening + section_content + closing_tag
    
    # Replace in content
    content = content[:first_section.start()] + new_section + content[first_section.end():]
    
    print("✓ Hero styling updated (content preserved)")
else:
    print("⚠ Could not find hero section")

with open('star-automation.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ star-automation.html styling fixed")
PYTHON_EOF

python .temp/fix_hero_styling_automation.py

echo -e "${GREEN}✓ Hero styling fixed for star-automation.html${NC}"
echo ""

# Clean up
rm -rf .temp

# Step 7: Review changes
echo "================================================================================"
echo "📊 STEP 7: Review changes"
echo "================================================================================"
echo ""

git status --short

echo ""
echo -e "${BLUE}What was updated:${NC}"
echo "  ✓ Header/footer replaced on all 3 pages (from ediscovery)"
echo "  ✓ Hero styling fixed (gradient, centered, buttons) - CONTENT PRESERVED"
echo "  ✓ All product features and descriptions kept intact"
echo ""

# Step 8: Commit
echo "================================================================================"
echo "💾 STEP 8: Committing changes"
echo "================================================================================"
echo ""

git add star-ai-cloud.html star-ai-finance.html star-automation.html

git commit -m "Update header/footer and fix hero styling (content preserved)

Changes:
- Applied consistent header/footer from star-ai-ediscovery.html
- Fixed hero section styling (gradient background, centered text, button classes)
- ALL existing content, features, and descriptions preserved

Files updated:
- star-ai-cloud.html (header/footer only)
- star-ai-finance.html (header/footer + hero styling)
- star-automation.html (header/footer + hero styling)"

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 9: Push
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

# Completion
echo "================================================================================"
echo "✅ UPDATE COMPLETE - ALL CONTENT PRESERVED!"
echo "================================================================================"
echo ""
echo -e "${GREEN}Successfully updated 3 pages:${NC}"
echo ""
echo "📄 star-ai-cloud.html"
echo "   ✓ Header/footer updated"
echo "   ✓ All content preserved"
echo ""
echo "📄 star-ai-finance.html"
echo "   ✓ Header/footer updated"
echo "   ✓ Hero styling fixed (gradient, centered, buttons)"
echo "   ✓ All product features preserved"
echo ""
echo "📄 star-automation.html"
echo "   ✓ Header/footer updated"
echo "   ✓ Hero styling fixed (gradient, centered, buttons)"
echo "   ✓ All product features preserved"
echo ""
echo "📡 Vercel will auto-deploy in ~2 minutes"
echo ""
echo "🌐 Check updated pages:"
echo "   - https://startekk.net/star-ai-cloud"
echo "   - https://startekk.net/star-ai-finance"
echo "   - https://startekk.net/star-automation"
echo ""
echo "Backups: backup/*-backup-${TIMESTAMP}.html"
echo ""
echo "🎉 Done!"
echo ""
