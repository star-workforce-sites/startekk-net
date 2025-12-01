#!/bin/bash

# Fix links in all HTML files in root directory
echo "Fixing links in StartTekk..."

for file in *.html; do
    if [ -f "$file" ]; then
        echo "Processing $file..."
        
        # Fix legal links
        sed -i 's|href="privacy-policy\.html"|href="/legal/privacy-policy.html"|g' "$file"
        sed -i 's|href="terms-of-service\.html"|href="/legal/terms-of-service.html"|g' "$file"
        sed -i 's|href="cookie-policy\.html"|href="/legal/cookie-policy.html"|g' "$file"
        sed -i 's|href="do-not-sell\.html"|href="/legal/do-not-sell.html"|g' "$file"
        sed -i 's|href="accessibility\.html"|href="/legal/accessibility.html"|g' "$file"
        sed -i 's|href="fraud-alert\.html"|href="/legal/fraud-alert.html"|g' "$file"
        sed -i 's|href="ai-policy\.html"|href="/legal/ai-policy.html"|g' "$file"
        
        # Fix investor links
        sed -i 's|href="star-ai-cloud\.html"|href="/investor/star-ai-cloud.html"|g' "$file"
        sed -i 's|href="star-ai-ediscovery\.html"|href="/investor/star-ai-ediscovery.html"|g' "$file"
        sed -i 's|href="star-ai-finance\.html"|href="/investor/star-ai-finance.html"|g' "$file"
        sed -i 's|href="star-automation\.html"|href="/investor/star-automation.html"|g' "$file"
        sed -i 's|href="qr-feedback\.html"|href="/investor/qr-feedback.html"|g' "$file"
        
        echo "✅ Fixed $file"
    fi
done

echo ""
echo "✅ All links fixed!"
echo "Now commit and push:"
echo "  git add ."
echo "  git commit -m 'Fix all legal and investor page links'"
echo "  git push origin main"
