// API Endpoint: /api/investor-inquiry.js
// Handles investor inquiry form submissions via Google SMTP
// Matches investor-contact-V3-FINAL.html form fields

import nodemailer from 'nodemailer';

export default async function handler(req, res) {
    // Only allow POST requests
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }
    
    const { name, email, phone, company, interests, message, recaptchaToken } = req.body;
    
    // Validate required fields (only name, email, message are required)
    if (!name || !email || !message) {
        return res.status(400).json({ 
            error: 'Missing required fields',
            required: ['name', 'email', 'message'],
            received: { name, email, message }
        });
    }
    
    // Verify reCAPTCHA v3
    if (recaptchaToken) {
        try {
            const recaptchaVerify = await fetch(
                'https://www.google.com/recaptcha/api/siteverify',
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `secret=${process.env.RECAPTCHA_SECRET_KEY_STARTEKK}&response=${recaptchaToken}`
                }
            );
            
            const recaptchaResult = await recaptchaVerify.json();
            
            if (!recaptchaResult.success || recaptchaResult.score < 0.5) {
                return res.status(400).json({ 
                    error: 'reCAPTCHA verification failed',
                    score: recaptchaResult.score 
                });
            }
        } catch (error) {
            console.error('reCAPTCHA verification error:', error);
            // Continue anyway - don't block legitimate users
        }
    }
    
    // Create email transporter with Google SMTP
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 587,
        secure: false,
        auth: {
            user: process.env.GOOGLE_SMTP_USER_STARTEKK,
            pass: process.env.GOOGLE_SMTP_PASSWORD_STARTEKK
        }
    });
    
    try {
        // Email to investor team
        const investorEmail = {
            from: process.env.GOOGLE_SMTP_USER_STARTEKK,
            to: 'investors@startekk.net',
            replyTo: email,
            subject: `Investor Inquiry from ${name}`,
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%); padding: 30px; text-align: center;">
                        <h1 style="color: white; margin: 0;">New Investor Inquiry</h1>
                    </div>
                    
                    <div style="padding: 30px; background: #f9fafb;">
                        <h2 style="color: #047857; border-bottom: 2px solid #84CC16; padding-bottom: 10px;">Contact Information</h2>
                        <p><strong>Name:</strong> ${name}</p>
                        <p><strong>Email:</strong> <a href="mailto:${email}">${email}</a></p>
                        <p><strong>Phone:</strong> ${phone || 'Not provided'}</p>
                        <p><strong>Company:</strong> ${company || 'Not provided'}</p>
                        <p><strong>Interests:</strong> ${interests || 'General Inquiry'}</p>
                        
                        <h2 style="color: #047857; border-bottom: 2px solid #84CC16; padding-bottom: 10px; margin-top: 30px;">Message</h2>
                        <div style="background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #84CC16;">
                            ${message.replace(/\n/g, '<br>')}
                        </div>
                        
                        <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; color: #6b7280; font-size: 14px;">
                            Submitted: ${new Date().toLocaleString()}<br>
                            From: <a href="https://startekk.net/investor/contact">startekk.net/investor/contact</a>
                        </p>
                    </div>
                </div>
            `
        };
        
        // Confirmation email to user
        const confirmationEmail = {
            from: process.env.GOOGLE_SMTP_USER_STARTEKK,
            to: email,
            subject: 'Thank you for your inquiry - Startekk',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%); padding: 30px; text-align: center;">
                        <h1 style="color: white; margin: 0;">Thank You, ${name}!</h1>
                    </div>
                    
                    <div style="padding: 30px; background: #f9fafb;">
                        <p style="font-size: 18px; color: #047857;">We've received your inquiry.</p>
                        
                        <p>Thank you for your interest in Startekk. Our investor relations team has received your message and will review it carefully.</p>
                        
                        <div style="background: #ecfdf5; border-left: 4px solid #84CC16; padding: 20px; margin: 20px 0; border-radius: 4px;">
                            <h3 style="color: #047857; margin-top: 0;">What happens next?</h3>
                            <ul style="color: #065f46; line-height: 1.8;">
                                <li>Our team will review your inquiry within 24-48 hours</li>
                                <li>If there's a good fit, we'll schedule a call to discuss further</li>
                                <li>We'll reach out to you at <strong>${email}</strong></li>
                            </ul>
                        </div>
                        
                        <p>In the meantime, feel free to explore:</p>
                        <ul style="line-height: 1.8;">
                            <li><a href="https://startekk.net/investor" style="color: #047857;">Investor Overview</a> - Our products, metrics, and vision</li>
                            <li><a href="https://startekk.net/products" style="color: #047857;">Products</a> - Explore our AI-powered solutions</li>
                            <li><a href="https://startekk.net/case-studies" style="color: #047857;">Case Studies</a> - See our impact</li>
                        </ul>
                        
                        <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; color: #6b7280; font-size: 14px;">
                            <strong>Startekk, LLC</strong><br>
                            5465 Legacy Drive Suite 650<br>
                            Plano, TX 75024<br>
                            <a href="tel:+14697133993" style="color: #047857;">(469) 713-3993</a>
                        </p>
                    </div>
                </div>
            `
        };
        
        // Send both emails
        await transporter.sendMail(investorEmail);
        await transporter.sendMail(confirmationEmail);
        
        return res.status(200).json({ 
            success: true,
            message: 'Inquiry submitted successfully' 
        });
        
    } catch (error) {
        console.error('Email sending error:', error);
        return res.status(500).json({ 
            error: 'Failed to send email',
            details: error.message 
        });
    }
}
