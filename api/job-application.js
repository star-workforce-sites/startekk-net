// API Endpoint: /api/job-application.js
// Handles job applications: stores in admin + sends email to info@startekk.net

import nodemailer from 'nodemailer';

export default async function handler(req, res) {
    // Only allow POST requests
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }
    
    const { 
        jobTitle, 
        jobId,
        applicantName, 
        applicantEmail, 
        applicantPhone,
        linkedinUrl,
        portfolioUrl,
        resumeFile,
        resumeFilename,
        coverLetter,
        startDate,
        salaryExpectation
    } = req.body;
    
    // Validate required fields
    if (!jobTitle || !applicantName || !applicantEmail || !resumeFile) {
        return res.status(400).json({ 
            error: 'Missing required fields',
            required: ['jobTitle', 'applicantName', 'applicantEmail', 'resumeFile']
        });
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
        // Email to hiring team (info@startekk.net)
        const hiringEmail = {
            from: process.env.GOOGLE_SMTP_USER_STARTEKK,
            to: 'info@startekk.net',
            replyTo: applicantEmail,
            subject: `Job Application: ${applicantName} - ${jobTitle}`,
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%); padding: 30px; text-align: center;">
                        <h1 style="color: white; margin: 0;">New Job Application</h1>
                    </div>
                    
                    <div style="padding: 30px; background: #f9fafb;">
                        <div style="background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                            <h2 style="color: #047857; margin-top: 0;">Position</h2>
                            <p style="font-size: 18px; font-weight: bold; color: #065f46;">${jobTitle}</p>
                        </div>
                        
                        <h2 style="color: #047857; border-bottom: 2px solid #84CC16; padding-bottom: 10px;">Applicant Information</h2>
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 12px 0; font-weight: bold; width: 40%;">Name:</td>
                                <td style="padding: 12px 0;">${applicantName}</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 12px 0; font-weight: bold;">Email:</td>
                                <td style="padding: 12px 0;"><a href="mailto:${applicantEmail}" style="color: #047857;">${applicantEmail}</a></td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 12px 0; font-weight: bold;">Phone:</td>
                                <td style="padding: 12px 0;">${applicantPhone || 'Not provided'}</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 12px 0; font-weight: bold;">LinkedIn:</td>
                                <td style="padding: 12px 0;">${linkedinUrl ? `<a href="${linkedinUrl}" style="color: #047857;">View Profile</a>` : 'Not provided'}</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 12px 0; font-weight: bold;">Portfolio:</td>
                                <td style="padding: 12px 0;">${portfolioUrl ? `<a href="${portfolioUrl}" style="color: #047857;">View Portfolio</a>` : 'Not provided'}</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e5e7eb;">
                                <td style="padding: 12px 0; font-weight: bold;">Start Date:</td>
                                <td style="padding: 12px 0;">${startDate || 'Flexible'}</td>
                            </tr>
                            <tr>
                                <td style="padding: 12px 0; font-weight: bold;">Salary Expectation:</td>
                                <td style="padding: 12px 0;">${salaryExpectation || 'Not specified'}</td>
                            </tr>
                        </table>
                        
                        ${coverLetter ? `
                            <h2 style="color: #047857; border-bottom: 2px solid #84CC16; padding-bottom: 10px; margin-top: 30px;">Cover Letter</h2>
                            <div style="background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #84CC16;">
                                ${coverLetter.replace(/\n/g, '<br>')}
                            </div>
                        ` : ''}
                        
                        <div style="background: #ecfdf5; border: 2px solid #84CC16; padding: 20px; margin-top: 30px; border-radius: 8px;">
                            <h3 style="color: #047857; margin-top: 0;">📎 Resume Attached</h3>
                            <p style="margin: 0; color: #065f46;">Filename: <strong>${resumeFilename}</strong></p>
                            <p style="margin: 8px 0 0 0; color: #6b7280; font-size: 14px;">The resume is attached to this email</p>
                        </div>
                        
                        <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; color: #6b7280; font-size: 14px;">
                            <strong>Application Received:</strong> ${new Date().toLocaleString()}<br>
                            <strong>Source:</strong> <a href="https://startekk.net/pages/jobs.html" style="color: #047857;">startekk.net/pages/jobs.html</a><br>
                            <strong>Job ID:</strong> ${jobId || 'N/A'}
                        </p>
                        
                        <div style="background: #fef3c7; border-left: 4px solid #f59e0b; padding: 16px; margin-top: 20px;">
                            <p style="margin: 0; color: #92400e;"><strong>⚡ Quick Actions:</strong></p>
                            <p style="margin: 8px 0 0 0; color: #92400e;">
                                • Review resume attachment<br>
                                • Check admin panel for full application details<br>
                                • Respond to applicant at ${applicantEmail}
                            </p>
                        </div>
                    </div>
                </div>
            `,
            attachments: [
                {
                    filename: resumeFilename,
                    content: Buffer.from(resumeFile, 'base64'),
                    contentType: resumeFilename.endsWith('.pdf') ? 'application/pdf' : 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                }
            ]
        };
        
        // Confirmation email to applicant
        const confirmationEmail = {
            from: process.env.GOOGLE_SMTP_USER_STARTEKK,
            to: applicantEmail,
            subject: `Application Received - ${jobTitle} at Startekk`,
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #047857 0%, #84CC16 100%); padding: 30px; text-align: center;">
                        <h1 style="color: white; margin: 0;">Application Received!</h1>
                    </div>
                    
                    <div style="padding: 30px; background: #f9fafb;">
                        <p style="font-size: 18px; color: #047857;">Thank you, ${applicantName}!</p>
                        
                        <p>We've successfully received your application for the <strong>${jobTitle}</strong> position.</p>
                        
                        <div style="background: #ecfdf5; border-left: 4px solid #84CC16; padding: 20px; margin: 20px 0; border-radius: 4px;">
                            <h3 style="color: #047857; margin-top: 0;">What happens next?</h3>
                            <ul style="color: #065f46; line-height: 1.8; margin: 0;">
                                <li>Our hiring team will review your application within 3-5 business days</li>
                                <li>If your qualifications match, we'll reach out to schedule an interview</li>
                                <li>You'll hear from us at <strong>${applicantEmail}</strong></li>
                            </ul>
                        </div>
                        
                        <div style="background: white; padding: 20px; border-radius: 8px; border: 1px solid #e5e7eb; margin: 20px 0;">
                            <h3 style="color: #047857; margin-top: 0;">Application Summary</h3>
                            <p style="margin: 8px 0;"><strong>Position:</strong> ${jobTitle}</p>
                            <p style="margin: 8px 0;"><strong>Resume:</strong> ${resumeFilename}</p>
                            <p style="margin: 8px 0;"><strong>Submitted:</strong> ${new Date().toLocaleString()}</p>
                        </div>
                        
                        <p>In the meantime, learn more about life at Startekk:</p>
                        <ul style="line-height: 1.8;">
                            <li><a href="https://startekk.net/about" style="color: #047857;">About Us</a> - Our mission and values</li>
                            <li><a href="https://startekk.net/products" style="color: #047857;">Our Products</a> - See what we build</li>
                            <li><a href="https://startekk.net/pages/jobs.html" style="color: #047857;">Other Openings</a> - Explore more opportunities</li>
                        </ul>
                        
                        <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; color: #6b7280; font-size: 14px;">
                            <strong>Startekk, LLC</strong><br>
                            5465 Legacy Drive Suite 650<br>
                            Plano, TX 75024<br>
                            <a href="tel:+14697133993" style="color: #047857;">(469) 713-3993</a>
                        </p>
                        
                        <p style="color: #6b7280; font-size: 12px; margin-top: 20px;">
                            Questions about your application? Reply to this email or contact us at <a href="mailto:info@startekk.net" style="color: #047857;">info@startekk.net</a>
                        </p>
                    </div>
                </div>
            `
        };
        
        // Send both emails
        await transporter.sendMail(hiringEmail);
        await transporter.sendMail(confirmationEmail);
        
        // Return success with application data for admin panel storage
        return res.status(200).json({ 
            success: true,
            message: 'Application submitted successfully',
            applicationData: {
                id: `APP-${Date.now()}`,
                jobTitle,
                jobId,
                applicantName,
                applicantEmail,
                applicantPhone: applicantPhone || 'Not provided',
                linkedinUrl: linkedinUrl || 'Not provided',
                portfolioUrl: portfolioUrl || 'Not provided',
                resumeFilename,
                coverLetter: coverLetter || 'Not provided',
                startDate: startDate || 'Flexible',
                salaryExpectation: salaryExpectation || 'Not specified',
                submittedAt: new Date().toISOString(),
                status: 'new'
            }
        });
        
    } catch (error) {
        console.error('Application submission error:', error);
        return res.status(500).json({ 
            error: 'Failed to submit application',
            details: error.message 
        });
    }
}
