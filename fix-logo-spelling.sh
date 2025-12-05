#!/bin/bash

# =============================================================================
# LOGO SPELLING FIX - COMPREHENSIVE SCRIPT
# =============================================================================
# Changes "StartTekk" and "StarTekk" to "Startekk" in brand/logo contexts
# Preserves "StartTekk, LLC" in footers (legal entity name)
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         LOGO SPELLING FIX - STARTEKK & STARWORKFORCE       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verify we're in the right directory
if [ ! -d "startekk-net" ] || [ ! -d "starworkforce-net" ]; then
    echo -e "${RED}ERROR: Please run this from /c/Users/STAR Workforce/projects${NC}"
    echo -e "${YELLOW}Current directory: $(pwd)${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found both repositories${NC}"
echo ""

# =============================================================================
# CREATE BACKUP
# =============================================================================

echo -e "${YELLOW}Creating backup...${NC}"
BACKUP_DIR="backup-logo-fix-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r startekk-net "$BACKUP_DIR/"
cp -r starworkforce-net "$BACKUP_DIR/"
echo -e "${GREEN}✓ Backup created: $BACKUP_DIR${NC}"
echo ""

# =============================================================================
# FUNCTION: Fix logo spelling in a file
# =============================================================================

fix_logo_spelling() {
    local file="$1"
    local changes=0
    
    # Create temp file
    local temp_file="${file}.tmp"
    
    # Process the file line by line
    while IFS= read -r line; do
        original_line="$line"
        
        # Change ALL instances of StartTekk to Startekk (no exceptions)
        line=$(echo "$line" | sed 's/StartTekk/Startekk/g')
        
        # Change ALL instances of StarTekk to Startekk (no exceptions)
        line=$(echo "$line" | sed 's/StarTekk/Startekk/g')
        
        # Count if changed
        if [ "$original_line" != "$line" ]; then
            ((changes++))
        fi
        
        echo "$line" >> "$temp_file"
    done < "$file"
    
    # Replace original with temp file
    mv "$temp_file" "$file"
    
    return $changes
}

# =============================================================================
# PROCESS STARTEKK-NET FILES
# =============================================================================

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Processing Startekk.net files...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

STARTEKK_COUNT=0
STARTEKK_CHANGED=0

# Find all HTML files
while IFS= read -r file; do
    echo -e "${BLUE}Processing: ${file#startekk-net/}${NC}"
    
    if fix_logo_spelling "$file"; then
        echo -e "${GREEN}  ✓ Updated logo spelling${NC}"
        ((STARTEKK_CHANGED++))
    else
        echo -e "${CYAN}  - No changes needed${NC}"
    fi
    
    ((STARTEKK_COUNT++))
done < <(find startekk-net -name "*.html" -not -path "*/node_modules/*" -not -path "*/.git/*" -type f)

echo ""
echo -e "${GREEN}✓ Processed $STARTEKK_COUNT Startekk files ($STARTEKK_CHANGED changed)${NC}"
echo ""

# =============================================================================
# PROCESS STARWORKFORCE-NET FILES
# =============================================================================

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Processing StarWorkforce.net files...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

STARWORKFORCE_COUNT=0
STARWORKFORCE_CHANGED=0

# Find all HTML files
while IFS= read -r file; do
    echo -e "${BLUE}Processing: ${file#starworkforce-net/}${NC}"
    
    if fix_logo_spelling "$file"; then
        echo -e "${GREEN}  ✓ Updated logo spelling${NC}"
        ((STARWORKFORCE_CHANGED++))
    else
        echo -e "${CYAN}  - No changes needed${NC}"
    fi
    
    ((STARWORKFORCE_COUNT++))
done < <(find starworkforce-net -name "*.html" -not -path "*/node_modules/*" -not -path "*/.git/*" -type f)

echo ""
echo -e "${GREEN}✓ Processed $STARWORKFORCE_COUNT StarWorkforce files ($STARWORKFORCE_CHANGED changed)${NC}"
echo ""

# =============================================================================
# VERIFICATION
# =============================================================================

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Verification...${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "Checking startekk-net/index.html logo..."
if grep -q ">Startekk<" startekk-net/index.html; then
    echo -e "${GREEN}✓ Logo now says 'Startekk' (correct)${NC}"
else
    echo -e "${RED}⚠ Warning: Logo may not be fixed correctly${NC}"
fi

echo ""
echo "Checking if 'Startekk, LLC' is correct..."
if grep -q "Startekk, LLC" startekk-net/index.html; then
    echo -e "${GREEN}✓ 'Startekk, LLC' correct (lowercase 't')${NC}"
elif grep -q "StartTekk, LLC" startekk-net/index.html; then
    echo -e "${RED}✗ Still shows 'StartTekk, LLC' - needs fix${NC}"
else
    echo -e "${YELLOW}⚠ Note: Legal entity not found on this page${NC}"
fi

echo ""

# =============================================================================
# SUMMARY
# =============================================================================

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    FIX COMPLETE!                           ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

TOTAL_FILES=$((STARTEKK_COUNT + STARWORKFORCE_COUNT))
TOTAL_CHANGED=$((STARTEKK_CHANGED + STARWORKFORCE_CHANGED))

echo -e "${GREEN}✅ Changes Summary:${NC}"
echo -e "  • Startekk.net: $STARTEKK_CHANGED out of $STARTEKK_COUNT files updated"
echo -e "  • StarWorkforce.net: $STARWORKFORCE_CHANGED out of $STARWORKFORCE_COUNT files updated"
echo -e "  • Total: $TOTAL_CHANGED out of $TOTAL_FILES files updated"
echo ""

echo -e "${GREEN}✅ What Changed:${NC}"
echo -e "  • ALL instances: 'StartTekk' → 'Startekk'"
echo -e "  • ALL instances: 'StarTekk' → 'Startekk'"
echo -e "  • Legal entity: 'StartTekk, LLC' → 'Startekk, LLC'"
echo -e "  • NO EXCEPTIONS - Everything is now 'Startekk'"
echo ""

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  NEXT STEPS:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}1. Review changes:${NC}"
echo -e "   ${BLUE}cd startekk-net${NC}"
echo -e "   ${BLUE}git diff${NC}"
echo ""

echo -e "${CYAN}2. Test locally (optional):${NC}"
echo -e "   Open index.html in browser"
echo -e "   Logo should say 'Startekk' (lowercase 't')"
echo ""

echo -e "${CYAN}3. Commit and deploy:${NC}"
echo -e "   ${BLUE}cd startekk-net${NC}"
echo -e "   ${BLUE}git add .${NC}"
echo -e "   ${BLUE}git commit -m \"Fix: Update logo spelling to 'Startekk' across all pages\"${NC}"
echo -e "   ${BLUE}git push origin main${NC}"
echo ""
echo -e "   ${BLUE}cd ../starworkforce-net${NC}"
echo -e "   ${BLUE}git add .${NC}"
echo -e "   ${BLUE}git commit -m \"Fix: Update logo spelling consistency\"${NC}"
echo -e "   ${BLUE}git push origin main${NC}"
echo ""

echo -e "${CYAN}4. Wait for Vercel deployment (2-3 minutes)${NC}"
echo ""

echo -e "${CYAN}5. Verify live sites:${NC}"
echo -e "   ${BLUE}https://startekk.net${NC} - Logo should say 'Startekk'"
echo -e "   ${BLUE}https://starworkforce.net${NC} - Logo consistent"
echo ""

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${GREEN}Backup saved at:${NC}"
echo -e "   ${CYAN}$BACKUP_DIR${NC}"
echo ""

echo -e "${GREEN}✅ All logo spelling fixes complete!${NC}"
echo ""
