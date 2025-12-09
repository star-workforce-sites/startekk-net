// API Endpoint: /api/investor-inquiry.js
// Handles investor inquiry form submissions via Google SMTP

import nodemailer from 'nodemailer';

export default async function handler(req, res) {
    // Only allow POST requests
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }
    
    const { name, email, phone, product, investment_amount, investment_type, message, recaptcha } = req.body;
    
    // Validate required fields
    if (!name || !email || !product || !investment_amount || !investment_type || !message) {
        return res.status(400).json({ error: 'Missing required fields' });
    }
    
    // Verify reCAPTCHA
    try {
        const recaptchaVerify = await fetch(
            'https://www.google.com/recaptcha/api/siteverify',
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `secret=${process.env.RECAPTCHA_SECRET_KEY_STARTEKK}&response=${recaptcha}`
            }
        );
        
        const recaptchaResult = await recaptchaVerify.json();
        if (!recaptchaResult.success) {
            return res.status(400).json({ error: 'reCAPTCHA verification failed' });
        }
    } catch (error) {
        console.error('reCAPTCHA verification error:', error);
        return res.status(500).json({ error: 'reCAPTCHA verification error' });
    }
    
    // Create transporter using Google Workspace SMTP (StartTekk workspace)
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 587,
        secure: false, // Use STARTTLS
        auth: {
            user: process.env.GOOGLE_SMTP_USER_STARTEKK, // investors@startekk.net
            pass: process.env.GOOGLE_SMTP_PASSWORD_STARTEKK // App-specific password
        }
    });
    
    // Email content
    const productLabels = {
        'star-ai-cloud': 'Star AI Cloud',
        'star-ai-ediscovery': 'Star AI eDiscovery',
        'star-ai-finance': 'Star AI Finance',
        'qr-feedback': 'QR Feedback',
        'star-workforce': 'Star Workforce',
        'career-accel': 'Career Accel Platform',
        'overall': 'Overall Company Investment'
    };
    
    const amountLabels = {
        'under-100k': 'Under $100K',
        '100k-250k': '$100K - $250K',
        '250k-500k': '$250K - $500K',
        '500k-1m': '$500K - $1M',
        '1m-5m': '$1M - $5M',
        '5m-plus': '$5M+'
    };
    
    const typeLabels = {
        'equity': 'Equity Investment',
        'convertible': 'Convertible Note',
        'debt': 'Debt Financing',
        'strategic': 'Strategic Partnership',
        'other': 'Other'
    };
    
    const htmlContent = `
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #047857 0%, #84CC16 100%); color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border: 1px solid #ddd; border-top: none; border-radius: 0 0 8px 8px; }
        .field { margin-bottom: 15px; }
        .label { font-weight: bold; color: #047857; }
        .value { margin-top: 5px; }
        .footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 style="margin: 0;">🚀 New Investor Inquiry</h1>
            <p style="margin: 5px 0 0 0;">Startekk Investor Relations</p>
        </div>
        <div class="content">
            <div class="field">
                <div class="label">Contact Information:</div>
                <div class="value">
                    <strong>Name:</strong> ${name}<br>
                    <strong>Email:</strong> <a href="mailto:${email}">${email}</a><br>
                    <strong>Phone:</strong> ${phone}
                </div>
            </div>
            
            <div class="field">
                <div class="label">Investment Details:</div>
                <div class="value">
                    <strong>Product Interest:</strong> ${productLabels[product]}<br>
                    <strong>Investment Amount:</strong> ${amountLabels[investment_amount]}<br>
                    <strong>Investment Type:</strong> ${typeLabels[investment_type]}
                </div>
            </div>
            
            <div class="field">
                <div class="label">Message:</div>
                <div class="value" style="white-space: pre-wrap; background: white; padding: 15px; border-radius: 4px; border: 1px solid #ddd;">${message}</div>
            </div>
            
            <div class="field">
                <div class="label">Submission Details:</div>
                <div class="value">
                    <strong>Date:</strong> ${new Date().toLocaleString('en-US', { timeZone: 'America/Chicago' })} CST<br>
                    <strong>Source:</strong> startekk.net/investor/contact.html
                </div>
            </div>
        </div>
        <div class="footer">
            <p>This inquiry was submitted through the Startekk Investor Relations contact form.</p>
            <p>Please respond within 24-48 hours.</p>
        </div>
    </div>
</body>
</html>
    `;
    
    const textContent = `
NEW INVESTOR INQUIRY - Startekk

CONTACT INFORMATION:
Name: ${name}
Email: ${email}
Phone: ${phone}

INVESTMENT DETAILS:
Product Interest: ${productLabels[product]}
Investment Amount: ${amountLabels[investment_amount]}
Investment Type: ${typeLabels[investment_type]}

MESSAGE:
${message}

SUBMISSION DETAILS:
Date: ${new Date().toLocaleString('en-US', { timeZone: 'America/Chicago' })} CST
Source: startekk.net/investor/contact.html

---
Please respond within 24-48 hours.
    `;
    
    try {
        // Send email to investor relations team
        await transporter.sendMail({
            from: `"Startekk Investor Relations" <${process.env.GOOGLE_SMTP_USER_STARTEKK}>`,
            to: 'investors@startekk.net',
            replyTo: email,
            subject: `New Investor Inquiry - ${productLabels[product]} - ${name}`,
            text: textContent,
            html: htmlContent
        });
        
        // Send confirmation email to inquirer
        await transporter.sendMail({
            from: `"Startekk Investor Relations" <${process.env.GOOGLE_SMTP_USER_STARTEKK}>`,
            to: email,
            subject: 'Thank You for Your Investment Inquiry - Startekk',
            html: `
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #047857 0%, #84CC16 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border: 1px solid #ddd; border-top: none; }
        .footer { background: #047857; color: white; padding: 20px; text-align: center; border-radius: 0 0 8px 8px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 style="margin: 0;">Thank You, ${name}!</h1>
        </div>
        <div class="content">
            <p>We've received your investor inquiry for <strong>${productLabels[product]}</strong>.</p>
            
            <p>Our investor relations team will review your information and reach out to you within 24-48 hours with:</p>
            <ul>
                <li>Our investor deck and financial information</li>
                <li>Details about the investment opportunity</li>
                <li>Next steps in the process</li>
            </ul>
            
            <p>In the meantime, if you have any questions, feel free to contact us:</p>
            <p>
                <strong>Phone:</strong> <a href="tel:+14697133993">(469) 713-3993</a><br>
                <strong>Email:</strong> <a href="mailto:investors@startekk.net">investors@startekk.net</a>
            </p>
            
            <p>We look forward to discussing this opportunity with you!</p>
            
            <p style="margin-top: 30px;">
                Best regards,<br>
                <strong>Startekk Investor Relations Team</strong>
            </p>
        </div>
        <div class="footer">
            <p style="margin: 0;">© 2025 Startekk, LLC | 5465 Legacy Drive Suite 650, Plano, TX 75024</p>
        </div>
    </div>
</body>
</html>
            `,
            text: `
Thank You for Your Investment Inquiry!

Dear ${name},

We've received your investor inquiry for ${productLabels[product]}.

Our investor relations team will review your information and reach out to you within 24-48 hours with:
- Our investor deck and financial information
- Details about the investment opportunity
- Next steps in the process

In the meantime, if you have any questions, feel free to contact us:
Phone: (469) 713-3993
Email: investors@startekk.net

We look forward to discussing this opportunity with you!

Best regards,
Startekk Investor Relations Team

© 2025 Startekk, LLC
5465 Legacy Drive Suite 650, Plano, TX 75024
            `
        });
        
        // Log success
        console.log('✅ Investor inquiry email sent:', {
            name,
            email,
            product: productLabels[product],
            timestamp: new Date().toISOString()
        });
        
        return res.status(200).json({ 
            success: true,
            message: 'Inquiry submitted successfully' 
        });
        
    } catch (error) {
        console.error('❌ Email sending error:', error);
        return res.status(500).json({ 
            error: 'Failed to send email. Please try again or contact us directly at investors@startekk.net',
            details: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
}
